defmodule Mfarms.Marketplace.Listing do
  use Ecto.Schema

  schema "listings" do
    field(:name, :string)
    field(:price, :float)
    field(:currency, :string)
    field(:quantity, :integer)
    field(:unit, :string)

    timestamps()
    belongs_to(:farmer, Mfarms.Marketplace.Farmer)
  end
end
