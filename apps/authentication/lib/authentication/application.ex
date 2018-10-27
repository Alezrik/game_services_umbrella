defmodule Authentication.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Authentication.Worker.start_link(arg)
      # {Authentication.Worker, arg},

      {Authentication.AuthenticationWorker, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Authentication.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
