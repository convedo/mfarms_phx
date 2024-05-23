defmodule MfarmsWeb.AppLive do
  alias Phoenix.PubSub
  use MfarmsWeb, :live_view

  alias Mfarms.Marketplace

  @impl true
  def mount(_params, _session, socket) do
    listings = Marketplace.list_listings()
    PubSub.subscribe(Mfarms.PubSub, "listings")
    {:ok, stream(socket, :listings, listings)}
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
      </.table>
    </div>
    """
  end

  @impl true
  def handle_info({:new_listing, listing_id}, socket) do
    listing = Marketplace.get_listing(listing_id)
    {:noreply, stream(socket, :listings, [listing], at: 0)}
  end
end
