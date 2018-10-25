# Since configuration is shared in umbrella projects, this file
# should only configure the :game_services application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :game_services,
  ecto_repos: [GameServices.Repo]

import_config "#{Mix.env()}.exs"
