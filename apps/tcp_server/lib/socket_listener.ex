defmodule TcpServer.SocketListener do
  use GenServer

  def start_link(_) do
    opts = [port: 8005]
    {:ok, _} = :ranch.start_listener(:AsyncAck, 10, :ranch_tcp, opts, AsyncAck.Handler, [])
  end
end
