defmodule TcpServer.Workflows.CmsgAuthenticate do
  require Logger

  def process_msg(%{type: "CMSG_AUTHENTICATE"} = params, opts \\ []) do
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
  end

  defp execute(params, opts) do
 #x`   with {:ok, ticket} <- GameServices.Authentication.create_ticket()
  end
end
