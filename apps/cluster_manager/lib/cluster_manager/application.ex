defmodule ClusterManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @cluster_active Application.get_env(:cluster_manager, :cluster_status, false)

  def start(_type, _args) do
    # List all child processes to be supervised
    topologies = get_topology(@cluster_active)
    children = get_children(@cluster_active, topologies)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusterManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  #
  #  defp get_topology(:true) do
  #    [
  #      example: [
  #        strategy: Cluster.Strategy.Kubernetes.DNS,
  #        config: [
  #          service: "game-services-umbrella-headless",
  #          application_name: "game-services-umbrella",
  #          polling_interval: 10_000
  #        ]
  #      ]
  #    ]
  #  end
  #  defp get_topology(:false), do: []
  @spec get_topology(true | false) :: list()
  defp get_topology(other) when is_boolean(other) do
    if other == true do
      [
        example: [
          strategy: Cluster.Strategy.Kubernetes.DNS,
          config: [
            service: "game-services-umbrella-headless",
            application_name: "game-services-umbrella",
            polling_interval: 10_000
          ]
        ]
      ]
    else
      []
    end
  end

  #  defp get_topology(z), do: []

  # @spec get_children(boolean(), list()) :: [{module(), list()}]
  defp get_children(false, _topology) do
    []
  end

  defp get_children(true, topologies) do
    [
      # Starts a worker by calling: ClusterManager.Worker.start_link(arg)
      # {ClusterManager.Worker, arg},
      {Cluster.Supervisor, [topologies, [name: ClusterManager.ClusterSupervisor]]}
    ]
  end
end
