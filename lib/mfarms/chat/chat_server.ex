defmodule Mfarms.Chat.ChatServer do
  alias Phoenix.PubSub
  use GenServer
  require Logger

  defmodule State do
    defstruct chat_id: nil, messages: [], contact_type: nil, farmer: nil
  end

  def start_link({chat_id, contact_type}) do
    IO.inspect(chat_id, label: "Chat ID")

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

    tenMinutes = 1000 * 60 * 10
    {:noreply, state, tenMinutes}
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

      IO.inspect(gpt_response)

      case gpt_response do
        {:ok, farmer} ->
          chat_id =
            if is_integer(state.chat_id),
              do: Integer.to_string(state.chat_id),
              else: state.chat_id

          {:ok, farmer} =
            Mfarms.Marketplace.create_farmer(%{
              chat_id: chat_id,
              contact_type: state.contact_type,
              first_name: farmer.first_name,
              last_name: farmer.last_name,
              phone_number: farmer.phone_number,
              location: farmer.location
            })

          response_success = """
          Thank you for registration. You can now use the chat bot to
            - create listings on the marketplace
            - get marketprice information
            - get weather information
            - get the latest subsidy information
          """

          state
          |> Map.put(:farmer, farmer)
          |> send_message(response_success)

        {:error, _} ->
          send_message(
            state,
            "Please provide the necessary information"
          )
      end
    end
  end

  defp respond(state) do
    intention = get_intention_of_message(state)

    state =
      if intention.new_conversation do
        # only keep the most recent one
        Map.put(state, :messages, [Enum.at(state.messages, 0)])
      else
        state
      end

    respond(intention.topic, state)
  end

  defp respond(:place_listing, state) do
    gpt_response =
      instruct_chat_gpt(
        "Ensure that the user has provided all information to create a listing and extract the details of the listing.",
        state.messages,
        Mfarms.Chat.PromptModel.Listing
      )

    case gpt_response do
      {:ok, listing} ->
        {:ok, listing} =
          Mfarms.Marketplace.create_listing(%{
            name: listing.name,
            price: listing.price,
            quantity: listing.quantity,
            currency: listing.currency,
            unit: listing.unit,
            farmer_id: state.farmer.id
          })

        PubSub.broadcast(Mfarms.PubSub, "listings", {:new_listing, listing.id})
        send_message(state, "Listing created successfully")

      {:error, _} ->
        send_message(state, "Please provide the details of the listing")
    end
  end

  defp respond(:weather, state) do
    send_message(state, "It will be sunny today")
  end

  defp respond(:view_marketprices, state) do
    send_message(
      state,
      """
      The market prices are as follows:
      - Tomatoes: $1.50
      - Cucumbers: $0.75
      - Potatoes: $0.50
      """
    )
  end

  defp respond(_, state) do
    send_message(state, "I'm sorry, I don't understand")
  end

  defp get_intention_of_message(state) do
    {:ok, intention} =
      instruct_chat_gpt(
        "What is the intention of the user?",
        state.messages,
        Mfarms.Chat.PromptModel.Intention
      )

    intention
  end

  defp send_message(state, message) do
    case state.contact_type do
      :telegram ->
        Telegex.send_message(state.chat_id, message)

      :internal ->
        Phoenix.PubSub.broadcast(Mfarms.PubSub, "chat:#{state.chat_id}", {:new_message, message})

      _ ->
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
