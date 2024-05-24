defmodule MfarmsWeb.AppLive do
  alias Phoenix.PubSub
  use MfarmsWeb, :live_view

  alias Mfarms.Marketplace

  @impl true
  def mount(_params, _session, socket) do
    listings = Marketplace.list_listings_on_offer()

    if(connected?(socket)) do
      PubSub.subscribe(Mfarms.PubSub, "listings")
    end

    filters = %{
      "term" => nil
    }

    socket =
      socket
      |> assign(:show_basket, false)
      |> assign(:search_term, "")
      |> assign(:filters_form, to_form(filters))
      |> stream(:listings, listings)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="text-wrap mb-4 max-w-2xl">
      <h1 class="text-5xl font-bold tracking-tighter mb-4">
        We connect farmers with international markets
      </h1>
      <p class="text-lg text-slate-950 mb-4">
        We provide a platform for farmers to easily connect with larger markets. Use our chat feature to list your produce or register as a buyer and have access to a huge market of locally grown produce.
        <.link class="font-medium" href={~p"/learn-more"}>Learn more</.link>
      </p>
      <div>
        <a href="https://t.me/mfarms_plus_bot" target="_blank">
          <.button>
            <div class="flex items-center gap-2">
              <.icon name="hero-paper-airplane-solid" class="w-4 h-4" />Telegram
            </div>
          </.button>
        </a>
        <a href={~p"/chat"}>
          <.button>
            <div class="flex items-center gap-2">
              <.icon name="hero-chat-bubble-left-solid" class="w-4 h-4" />Browser Chat
            </div>
          </.button>
        </a>
      </div>
    </section>
    <div class="py-4 px-8 bg-white rounded shadow-sm">
      <.header>Marketplace Listings</.header>
      <.form for={@filters_form} phx-change="search">
        <div :if={@current_user} class="flex items-center gap-4">
          <div class="flex-grow" phx-keydown="search">
            <.input
              class="w-64"
              phx-debounce="500"
              type="text"
              placeholder="Search listings..."
              field={@filters_form[:term]}
            />
          </div>
          <div class="flex-none" phx-click="toggle-basket">
            <%= if @show_basket do %>
              <.icon name="hero-shopping-cart-solid" class="w-8 h-8 mt-2 bg-green-500" />
            <% else %>
              <.icon name="hero-shopping-cart-solid" class="w-8 h-8 mt-2" />
            <% end %>
          </div>
        </div>
      </.form>
      <.table id="listings" rows={@streams.listings}>
        <:col :let={{_id, listing}} label="Id"><%= listing.id %></:col>
        <:col :let={{_id, listing}} label="Name"><%= listing.name %></:col>
        <:col :let={{_id, listing}} label="Seller">
          <%= "#{listing.farmer.first_name} #{listing.farmer.last_name}" %>
        </:col>
        <:col :let={{_id, listing}} label="Quantity">
          <%= "#{listing.quantity} #{listing.unit}" %>
        </:col>
        <:col :let={{_id, listing}} label="Price"><%= "#{listing.price} #{listing.currency}" %></:col>
        <:col :let={{_id, listing}} label="Listed Since"><%= "#{listing.inserted_at}" %></:col>
        <:action :let={{_id, listing}} :if={@current_user}>
          <%= if listing.purchased_by_user_id == @current_user.id do %>
            <.button disabled class="bg-green-400">Purchased</.button>
          <% else %>
            <.button phx-click="purchase" phx-value-id={listing.id}>Purchase</.button>
          <% end %>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def handle_event("purchase", %{"id" => listing_id}, socket) do
    {:ok, listing} = Marketplace.purchase_listing(listing_id, socket.assigns.current_user.id)

    PubSub.broadcast(
      Mfarms.PubSub,
      "listings",
      {:listing_purchased, listing.id, listing.purchased_by_user_id}
    )

    Mfarms.Chat.ChatAdapter.send_message(
      listing.farmer.chat_id,
      listing.farmer.contact_type,
      "Your listing ##{listing.id} has been purchased: #{listing.quantity}#{listing.unit} #{listing.name} for #{listing.price} #{listing.currency}. The buyer will contact you shortly."
    )

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"term" => term}, socket) do
    socket =
      socket
      |> assign(:search_term, term)
      |> assign_listings

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle-basket", _, socket) do
    socket =
      socket
      |> assign(:show_basket, !socket.assigns.show_basket)
      |> assign_listings

    {:noreply, socket}
  end

  defp assign_listings(socket) do
    listings =
      if socket.assigns.show_basket do
        Marketplace.list_purchased_listings_by_user_id(
          socket.assigns.current_user.id,
          socket.assigns.search_term
        )
      else
        Marketplace.list_listings_on_offer(socket.assigns.search_term)
      end

    stream(socket, :listings, listings, reset: true)
  end

  @impl true
  def handle_info({:new_listing, listing_id}, socket) do
    listing = Marketplace.get_listing(listing_id)
    {:noreply, stream(socket, :listings, [listing], at: 0)}
  end

  @impl true
  def handle_info({:listing_purchased, listing_id, user_id}, socket) do
    if !is_nil(socket.assigns.current_user) && user_id == socket.assigns.current_user.id do
      listing = Marketplace.get_listing(listing_id)

      socket =
        socket
        |> stream_insert(:listings, listing)

      {:noreply, socket}
    else
      {:noreply, stream_delete_by_dom_id(socket, :listings, "listings-#{listing_id}")}
    end
  end
end
