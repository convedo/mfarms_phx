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

  def get_farmer_by_chat_id(chat_id) when is_integer(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: Integer.to_string(chat_id))
  end

  def get_farmer_by_chat_id(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: chat_id)
  end
end
