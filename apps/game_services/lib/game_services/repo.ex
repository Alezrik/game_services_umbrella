defmodule GameServices.Repo do
  use Ecto.Repo,
    otp_app: :game_services,
    adapter: Ecto.Adapters.Postgres
end
