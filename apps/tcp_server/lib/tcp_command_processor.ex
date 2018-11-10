defmodule TcpServer.TcpCommandProcessor do
  use GenServer
  require Logger
  def start_link(_) do
    ClusterManager.start_cluster_worker(__MODULE__, :tcp_command_processor)
  end

  @impl true
  def init(_) do
    {:ok, :ok}
  end

  @impl true
  def handle_cast({:process, id, params, socket, transport}, state) do
    bitsize = bit_size(params)
    packet = <<id::binary-size(8), bitsize::little-size(32)>> <> params
    transport.send(socket, packet)
    {:noreply, state}
  end
end
