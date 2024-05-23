defmodule MfarmsWeb.AppLive do
  use MfarmsWeb, :live_view

  alias Mfarms.Marketplace

  @impl true
  def mount(_params, _session, socket) do
    listings = Marketplace.list_listings()

    {:ok, stream(socket, :listings, listings)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>Marketplace Listings</.header>
    <.table id="listings" rows={@streams.listings}>
      <:col :let={{_id, listing}} label="Id"><%= listing.id %></:col>
      <:col :let={{_id, listing}} label="Name"><%= listing.name %></:col>
      <:col :let={{_id, listing}} label="Seller">
        <%= "#{listing.farmer.first_name} #{listing.farmer.last_name}" %>
      </:col>
      <:col :let={{_id, listing}} label="Quantity"><%= "#{listing.quantity} #{listing.unit}" %></:col>
      <:col :let={{_id, listing}} label="Price"><%= "#{listing.price} #{listing.currency}" %></:col>
      <:col :let={{_id, listing}} label="Listed Since"><%= "#{listing.inserted_at}" %></:col>
    </.table>
    """
  end
end
