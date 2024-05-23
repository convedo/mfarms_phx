defmodule Mfarms.Chat.ChatServer do
  use GenServer
  require Logger

  defmodule State do
    defstruct chat_id: nil, messages: [], contact_type: nil, farmer: nil
  end

  def start_link({chat_id, contact_type}) do
    GenServer.start_link(
      __MODULE__,
      %State{chat_id: chat_id, contact_type: contact_type},
      name: via_tuple(chat_id)
    )
  end

  def new_message(chat_id, message_text) do
    GenServer.cast(via_tuple(chat_id), {:new_message, message_text})
  end

  # Server callbacks
  @spec init(%{:chat_id => any(), optional(any()) => any()}) ::
          {:ok, %{:chat_id => any(), :farmer => any(), optional(any()) => any()}}
  def init(state) do
    case Mfarms.Marketplace.get_farmer_by_chat_id(state.chat_id) do
      nil -> {:ok, Map.put(state, :farmer, nil)}
      farmer -> {:ok, Map.put(state, :farmer, farmer)}
    end
  end

  def handle_cast({:new_message, message_text}, state) do
    state =
      state
      |> add_user_message(message_text)
      |> respond()

    {:noreply, state}
  end

  defp via_tuple(chat_id) do
    {:via, Registry, {ChatRegistry, chat_id}}
  end

  defp add_user_message(state, message_text) do
    Map.update!(state, :messages, &[%{role: "user", content: message_text} | &1])
  end

  defp add_assistant_message(state, text) do
    Map.update!(state, :messages, &[%{role: "assistant", content: text} | &1])
  end

  defp respond(%{farmer: nil} = state) do
    if Enum.count(state.messages) == 1 do
      message = """
        Hello, this is M'Farms Plus. Please register first by providing
        your first name, last name, phone number, and location."
      """

      send_message(state, message)
    else
      instruction = """
        You are a chat bot. Please ensure that the user has provided all information, to register as a farmer.
      """

      gpt_response =
        instruct_chat_gpt(
          instruction,
          state.messages,
          Mfarms.Chat.PromptModel.Farmer
        )

      IO.inspect(gpt_response, label: "Farmer")

      case gpt_response do
        {:ok, _} ->
          response_success = """
            Thank you for registration. You can now use the chat bot to
             - create listings on the marketplace
             - get marketprice information
             - get weather information
             - get the latest subsidy information
          """

          send_message(state, response_success)

        {:error, _} ->
          send_message(
            state,
            "Please provide the necessary information"
          )
      end
    end
  end

  defp send_message(state, message) do
    if(state.contact_type == :telegram) do
      Telegex.send_message(state.chat_id, message)
    else
      Logger.error("Unsupported contact type: #{state.contact_type}")
    end

    add_assistant_message(state, message)
  end

  defp instruct_chat_gpt(instruction, messages, response_model) do
    messages =
      Enum.concat(
        [
          %{
            role: "system",
            content: instruction
          }
        ],
        Enum.reverse(messages)
      )

    Instructor.chat_completion(
      model: "gpt-3.5-turbo",
      response_model: response_model,
      messages: messages
    )
  end
end
