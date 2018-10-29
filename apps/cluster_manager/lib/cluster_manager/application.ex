defmodule ClusterManager.Application do
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
      # Starts a worker by calling: ClusterManager.Worker.start_link(arg)
      # {ClusterManager.Worker, arg},
      {Cluster.Supervisor, [topologies, [name: ClusterManager.ClusterSupervisor]]},

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusterManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
