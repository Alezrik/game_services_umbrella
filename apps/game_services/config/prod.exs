# Since configuration is shared in umbrella projects, this file
# should only configure the :game_services application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :game_services, GameServices.Repo,
  hostname: "${DB_HOSTNAME}",
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  pool_size: 20

#  for running migration in console
# config :game_services, GameServices.Repo,
#       hostname: "localhost",
#       username: "postgres",
#       password: "postgres",
#       database: "game_services_prod",
#       pool_size: 20
