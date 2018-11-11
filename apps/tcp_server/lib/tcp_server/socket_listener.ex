defmodule TcpServer.SocketListener do
  @moduledoc false
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(_) do
    opts = [port: 8005]
    {:ok, _} = :ranch.start_listener(:AsyncAck, 10, :ranch_tcp, opts, TcpServer.SocketHandler, [])
  end
end
