defmodule Mfarms.Marketplace.Farmer do
  use Ecto.Schema

  schema "farmers" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)
    field(:location, :string)
    field(:chat_id, :string)
    field :contact_type, Ecto.Enum, values: [:telegram, :internal]

    timestamps()
    has_many(:listings, Mfarms.Marketplace.Listing)
  end
end
