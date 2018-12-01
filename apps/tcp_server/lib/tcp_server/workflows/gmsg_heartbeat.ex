defmodule TcpServer.Workflows.GmsgHeartbeat do
  @moduledoc false
  require Logger

  def process_msg(%{type: "GMSG_HEARTBEAT"} = params, opts \\ []) do
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
  end

  defp execute(params, opts) do
    Logger.info(fn -> "Processing Heartbeat request" end)
    response_message = %{type: "SMSG_HEARTBEAT", type_id: 101}
    {:ok, message_len, message} = TcpServer.CommandSerializer.serialize(response_message)

    GenServer.cast(
      ClusterManager.get_tcp_client(),
      {:send_msg, 101, message_len, message, opts}
    )
  end
end
