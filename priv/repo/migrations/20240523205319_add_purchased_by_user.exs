defmodule Mfarms.Repo.Migrations.AddPurchasedByUser do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :purchased_by_user_id, references(:users, on_delete: :nilify_all)
    end
  end
end
