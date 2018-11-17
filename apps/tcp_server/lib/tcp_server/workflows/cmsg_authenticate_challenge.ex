defmodule TcpServer.Workflows.CmsgAuthenticateChallenge do
  @moduledoc false
  require Logger

  # for random string gen
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  ## Process CMSG_AUTHENTICATE_CHALLENGE Msg from Client
  def process_msg(%{type: "CMSG_AUTHENTICATE_CHALLENGE"} = params, opts \\ []) do
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
    {:ok}
  end

  defp execute(params, opts) do
    server_rnd = :rand.uniform(99_999_999)
    salt = string_of_length(40)
    msg = %{type: "SMSG_AUTHENTICATE_CHALLENGE", server_rnd: server_rnd, salt: salt}

    Logger.info(fn -> "Create Response: SMSG_AUTHENTICATE_CHALLENGE" end,
      server_rnd: server_rnd,
      salt: salt
    )

    with {:ok, ticket} <-
           GameServices.Authentication.create_ticket(%{
             client_token: "#{Map.get(params, :client_rnd)}",
             server_token: "#{server_rnd}",
             username: Map.get(params, :name),
             salt: salt
           }),
          {:ok, message_len, message} <- TcpServer.CommandSerializer.serialize(msg),
         transport <- Keyword.get(opts, :response_pid, nil),
         socket <- Keyword.get(opts, :response_socket, nil) do
      id = 2
      id_sz = 8 * 8
      sz_sz = 32
      message_bytes = <<id::size(id_sz), message_len::little-size(sz_sz)>> <> message
      Logger.error(fn -> "sending tcp reply" end)

      transport.send(socket, message_bytes)
      else
      err -> Logger.error "Got error: #{inspect err}"
    end
  end

  def string_of_length(length) do
    1..length
    |> Enum.reduce([], fn _i, acc ->
      [Enum.random(@chars) | acc]
    end)
    |> Enum.join("")
  end
end
