defmodule TcpServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :tcp_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ranch],
      mod: {TcpServer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:game_services, in_umbrella: true},
      {:logger_backend, in_umbrella: true},
      {:authentication, in_umbrella: true},
      {:user_manager, in_umbrella: true, only: :test},
      {:cluster_manager, in_umbrella: true},
      {:cowboy, "~> 2.5"},
      {:maru, "~> 0.13.2"},
      {:stream_data, "~> 0.1", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},
    ]
  end
end
