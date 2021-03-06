defmodule GameServices.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.3.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:dialyzer, :elixir, :kernel, :mix, :stdlib],
        plt_add_deps: :transitive,
        ignore_warnings: ".dialyzer-ignore"
      ],
      # better name pending
      name: "GameServicesUmbrella",
      source_url: "https://github.com/Alezrik/game_services_umbrella",
      docs: [
        main: "readme",
        extras: ["README.md", "TCP_PACKET.md"]
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
