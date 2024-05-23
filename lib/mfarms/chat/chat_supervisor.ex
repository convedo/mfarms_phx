defmodule Mfarms.Chat.ChatSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_chat_server(chat_id, contact_type) do
    case Registry.lookup(ChatRegistry, chat_id) do
      [] ->
        DynamicSupervisor.start_child(
          __MODULE__,
          {Mfarms.Chat.ChatServer, {chat_id, contact_type}}
        )

      [{pid, _}] ->
        {:ok, pid}
    end
  end
end
