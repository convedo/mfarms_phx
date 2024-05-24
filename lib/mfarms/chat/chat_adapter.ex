defmodule Mfarms.Chat.ChatAdapter do
  require Logger

  def send_message(chat_id, :telegram, message) do
    chat_id =
      if is_binary(chat_id) do
        String.to_integer(chat_id)
      else
        chat_id
      end

    Telegex.send_message(chat_id, message)
  end

  def send_message(chat_id, :internal, message) do
    Phoenix.PubSub.broadcast(Mfarms.PubSub, "chat:#{chat_id}", {:new_message, message})
  end

  def send_message(_chat_id, contact_type, _message) do
    Logger.error("Unsupported contact type: #{contact_type}")
  end
end
