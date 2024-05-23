defmodule Mfarms.Marketplace.Listing do
  use Ecto.Schema

  schema "listings" do
    field(:name, :string)
    field(:price, :float)
    field(:currency, :string)
    field(:quantity, :integer)
    field(:unit, :string, default: "pcs")

    timestamps()
    belongs_to(:farmer, Mfarms.Marketplace.Farmer)
    belongs_to(:purchased_by_user, Mfarms.Accounts.User)
  end

  def changeset(listing, attrs) do
    listing
    |> Ecto.Changeset.cast(attrs, [:name, :price, :currency, :quantity, :unit, :farmer_id])
    |> Ecto.Changeset.validate_required([:name, :price, :currency, :quantity, :farmer_id])
  end
end
