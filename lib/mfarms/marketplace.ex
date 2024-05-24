defmodule Mfarms.Marketplace do
  alias Mfarms.Repo
  alias Mfarms.Marketplace.Listing
  import Ecto.Query, warn: false

  def list_farmers do
    Repo.all(Mfarms.Marketplace.Farmer)
  end

  def list_listings do
    Listing
    |> order_by([l], desc: l.id)
    |> preload(:farmer)
    |> Repo.all()
  end

  def list_listings_on_offer() do
    Listing
    |> order_by([l], desc: l.id)
    |> where([l], is_nil(l.purchased_by_user_id))
    |> preload(:farmer)
    |> Repo.all()
  end

  def list_listings_on_offer(term) do
    Listing
    |> order_by([l], desc: l.id)
    |> where([l], is_nil(l.purchased_by_user_id) and ilike(l.name, ^"%#{term}%"))
    |> preload(:farmer)
    |> Repo.all()
  end

  def list_purchased_listings_by_user_id(user_id, term) do
    Listing
    |> where([l], l.purchased_by_user_id == ^user_id and ilike(l.name, ^"%#{term}%"))
    |> preload(:farmer)
    |> Repo.all()
  end

  def get_farmer_by_chat_id(chat_id) when is_integer(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: Integer.to_string(chat_id))
  end

  def get_farmer_by_chat_id(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: chat_id)
  end

  def create_farmer(attrs) do
    %Mfarms.Marketplace.Farmer{}
    |> Mfarms.Marketplace.Farmer.changeset(attrs)
    |> Repo.insert()
  end

  def create_listing(attrs) do
    %Listing{}
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end

  def get_listing(id) do
    Listing
    |> preload(:farmer)
    |> Repo.get(id)
  end

  def purchase_listing(listing_id, user_id) do
    listing = get_listing(listing_id)
    listing = Ecto.Changeset.change(listing, purchased_by_user_id: user_id)
    Repo.update(listing)
  end
end
