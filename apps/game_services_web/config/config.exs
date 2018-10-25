# Since configuration is shared in umbrella projects, this file
# should only configure the :game_services_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :game_services_web,
  ecto_repos: [GameServices.Repo],
  generators: [context_app: :game_services]

# Configures the endpoint
config :game_services_web, GameServicesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "toozqKQAntupgNTwPVAqZmWsaMxbz/fZasj+vHxr/IfPTbQXqSoBGhsftuEtB4ij",
  render_errors: [view: GameServicesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GameServicesWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
