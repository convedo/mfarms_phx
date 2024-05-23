defmodule Mfarms.Marketplace.Farmer do
  use Ecto.Schema

  schema "farmers" do
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :location, :string
    field :chat_id, :string
    field :contact_type, Ecto.Enum, values: [:telegram, :internal]

    timestamps()
    has_many(:listings, Mfarms.Marketplace.Listing)
  end

  def changeset(farmer, attrs) do
    farmer
    |> Ecto.Changeset.cast(attrs, [
      :first_name,
      :last_name,
      :phone_number,
      :location,
      :chat_id,
      :contact_type
    ])
    |> Ecto.Changeset.validate_required([
      :first_name,
      :last_name,
      :phone_number,
      :location,
      :chat_id,
      :contact_type
    ])
  end
end
