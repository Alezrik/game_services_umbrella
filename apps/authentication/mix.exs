defmodule Authentication.MixProject do
  use Mix.Project

  def project do
    [
      app: :authentication,
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
      extra_applications: [:logger],
      mod: {Authentication.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},

      {:libcluster, "~> 3.0"},
      {:swarm, "~> 3.0"},
      {:game_services, in_umbrella: true},
      {:junit_formatter, ">= 0.0.0", only: :test},
      {:guardian, "~> 1.1.2", github: "Alezrik/guardian"},
      {:stream_data, "~> 0.1", only: :test}
    ]
  end
end
