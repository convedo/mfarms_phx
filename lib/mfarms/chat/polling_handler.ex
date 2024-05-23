defmodule Mfarms.PollingHandler do
  use Telegex.Polling.GenHandler

  @impl true
  def on_boot do
    # delete any potential webhook
    {:ok, true} = Telegex.delete_webhook()
    # create configuration (can be empty, because there are default values)
    %Telegex.Polling.Config{}
    # you must return the `Telegex.Polling.Config` struct ↑
  end

  @impl true
  def on_update(update) do
    %{
      message: %{
        message_id: id,
        text: text,
        chat: %{
          id: chat_id
        }
      }
    } = update

    message = %{
      id: id,
      text: text,
      chat_id: chat_id
    }

    handle_incoming_message(chat_id, message)
    :ok
  end

  defp handle_incoming_message(chat_id, message) do
    IO.inspect(message)

    case Mfarms.Chat.ChatSupervisor.start_chat_server(chat_id, :telegram) do
      {:ok, _pid} ->
        IO.inspect("Chat server already started")
        Mfarms.Chat.ChatServer.new_message(chat_id, message.text)

      {:error, reason} ->
        IO.inspect(reason)
    end
  end
end
