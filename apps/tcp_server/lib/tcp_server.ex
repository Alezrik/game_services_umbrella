defmodule TcpServer do
  # server process thanks to http://dbeck.github.io/Wrapping-up-my-Elixir-TCP-experiments/
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      {TcpServer.TcpCommandProcessor, []},
      {TcpServer.SocketListener, []}
    ]

    opts = [strategy: :one_for_one, name: TcpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
