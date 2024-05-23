defmodule MfarmsWeb.ChatLive do
  use MfarmsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    chat_id = Ecto.UUID.generate()

    if(connected?(socket)) do
      Phoenix.PubSub.subscribe(Mfarms.PubSub, "chat:#{chat_id}")
      Mfarms.Chat.ChatSupervisor.start_chat_server(chat_id, :internal)
    end

    messages = []

    chat_message = %{
      "text" => "",
      "role" => "user"
    }

    socket =
      socket
      |> stream(:messages, messages)
      |> assign(:chat_id, chat_id)
      |> assign(:message_form, to_form(chat_message))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Chat
      <:subtitle>Only for demo purposes</:subtitle>
    </.header>
    <div id="messages" phx-update="stream">
      <div :for={{_id, message} <- @streams.messages}>
        <div class="grid grid-cols-1 gap-4">
          <div :if={message.role == "user"} class="flex justify-end mb">
            <div class="bg-slate-100 rounded-lg p-3 max-w-xs">
              <%= message.text %>
            </div>
          </div>
          <div :if={message.role == "system"} class="flex justify-start mb-2">
            <div class="bg-blue-100 rounded-lg p-3 max-w-xs">
              <%= message.text %>
            </div>
          </div>
        </div>
      </div>
    </div>
    <.form for={@message_form} phx-submit="submit" phx-change="change">
      <.input field={@message_form[:text]} name="text" type="textarea" placeholder="Type a message" />
      <.button class="mt-2" type="submit">Send</.button>
    </.form>
    """
  end

  @impl true
  def handle_event("submit", message, socket) do
    chat_message = %{
      "text" => ""
    }

    socket =
      socket
      |> assign(:message_form, to_form(chat_message))
      |> add_message(message)

    {:noreply, socket}
  end

  @impl true
  def handle_event("change", params, socket) do
    socket = assign(socket, :message_form, to_form(params))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    message = %{
      id: Ecto.UUID.generate(),
      role: "system",
      text: message
    }

    {:noreply, stream_insert(socket, :messages, message)}
  end

  def add_message(socket, message) do
    text = String.trim(message["text"])

    case text do
      "" ->
        socket

      _ ->
        Mfarms.Chat.ChatServer.new_message(socket.assigns.chat_id, text)

        message = %{
          id: Ecto.UUID.generate(),
          role: "user",
          text: text
        }

        stream_insert(socket, :messages, message)
    end
  end
end
