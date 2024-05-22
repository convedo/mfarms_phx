defmodule Mfarms.Repo do
  use Ecto.Repo,
    otp_app: :mfarms,
    adapter: Ecto.Adapters.Postgres
end
