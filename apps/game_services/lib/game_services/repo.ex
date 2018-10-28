defmodule GameServices.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :game_services,
    adapter: Ecto.Adapters.Postgres
end
