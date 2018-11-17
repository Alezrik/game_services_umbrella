defmodule TcpServer.Workflows.CmsgAuthenticate do
  @moduledoc false
  require Logger

  def process_msg(%{type: "CMSG_AUTHENTICATE"} = params, opts \\ []) do
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
  end

  defp execute(params, opts) do
    client_token = Map.get(params, :client_rand)
    server_token = Map.get(params, :server_rand)
    salt = Map.get(params, :salt)

    case GameServices.Authentication.get_ticket(client_token, server_token, salt) do
      {:ok, ticket} ->
        Logger.debug("Ticket found", client_token: client_token, server_token: server_token)

        with password <- Map.get(params, :password),
             {:ok, user} <- Authentication.get_user_by_credential(ticket.username, password),
             {:ok, token} <- Authentication.get_user_token(user),
             message <- %{type: "SMSG_AUTHENTICATE", success: true, token: token},
             {:ok, message_len, message} <- TcpServer.CommandSerializer.serialize(message) do
          Logger.info("Authentication Success", user: user)

          GenServer.cast(
            ClusterManager.get_tcp_client(),
            {:send_msg, 5, message_len, message, opts}
          )
        else
          other ->
            Logger.warn(fn -> "Error on Authentication" end, error: other)
            other
        end
    end
  end
end
