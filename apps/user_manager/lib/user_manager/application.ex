defmodule UserManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: UserManager.Worker.start_link(arg)
      # {UserManager.Worker, arg},
    {Task.Supervisor, name: UserManager.TaskSupervisor},
      {UserManager.RegisterWorker, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UserManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
