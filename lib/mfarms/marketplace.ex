defmodule Mfarms.Marketplace do
  alias Mfarms.Repo

  def list_farmers do
    Repo.all(Mfarms.Marketplace.Farmer)
  end

  def list_listings do
    Repo.all(Mfarms.Marketplace.Listing)
  end

  def get_farmer_by_chat_id(chat_id) when is_integer(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: Integer.to_string(chat_id))
  end

  def get_farmer_by_chat_id(chat_id) do
    Repo.get_by(Mfarms.Marketplace.Farmer, chat_id: chat_id)
  end
end
