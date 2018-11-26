defmodule TcpServer.TcpClient do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(_) do
    ClusterManager.start_cluster_worker(__MODULE__, :tcp_client)
  end

  @impl true
  def init(_) do
    {:ok, :ok}
  end

  @impl true
  def handle_cast({:send_msg, message_id, message_len, message, transport_options}, state) do
    Logger.info(fn -> "got message to send" end,
      message_id: message_id,
      message_len: message_len,
      message: message
    )

    transport = Keyword.get(transport_options, :response_pid, nil)
    socket = Keyword.get(transport_options, :response_socket, nil)
    id_sz = 8 * 8
    sz_sz = 32

    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn ->
      a = <<message_len::little-size(sz_sz)>>
      message_bytes = <<message_id::size(id_sz), message_len::little-size(sz_sz)>> <> message
      transport.send(socket, message_bytes)
    end)

    {:noreply, state}
  end
end
