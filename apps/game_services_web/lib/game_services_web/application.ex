defmodule GameServicesWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "game-services-umbrella-headless",
          application_name: "game-services-umbrella",
          polling_interval: 10_000
        ]
      ]
    ]

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      {Cluster.Supervisor, [topologies, [name: GameServicesWeb.ClusterSupervisor]]},
      GameServicesWeb.Endpoint
      # Starts a worker by calling: GameServicesWeb.Worker.start_link(arg)
      # {GameServicesWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameServicesWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameServicesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
