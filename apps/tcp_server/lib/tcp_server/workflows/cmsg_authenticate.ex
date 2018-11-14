defmodule TcpServer.Workflows.CmsgAuthenticate do
  require Logger

  def process_msg(%{type: "CMSG_AUTHENTICATE"} = params, opts \\ []) do
    Logger.error(fn -> "got params: #{inspect(params)}" end)
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
  end

  defp execute(params, opts) do
  end
end
