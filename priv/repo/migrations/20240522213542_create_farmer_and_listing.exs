defmodule :"Elixir.Mfarms.Repo.Migrations.Create farmer and listing" do
  use Ecto.Migration

  def change do
    create table(:farmers) do
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :location, :string
      add :chat_id, :string
      add :contact_type, :string

      timestamps()
    end

    create table(:listings) do
      add :name, :string
      add :price, :float
      add :currency, :string
      add :quantity, :integer
      add :unit, :string
      add :farmer_id, references(:farmers, on_delete: :delete_all)

      timestamps()
    end
  end
end
