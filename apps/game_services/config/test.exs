# Since configuration is shared in umbrella projects, this file
# should only configure the :game_services application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :game_services, GameServices.Repo,
  username: "postgres",
  password: "postgres",
  database: "game_services_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
