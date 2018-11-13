defmodule TcpServer.Workflows.CmsgAuthenticateChallenge do
  @moduledoc false
  require Logger

  # for random string gen
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  ## Process CMSG_AUTHENTICATE_CHALLENGE Msg from Client
  def process_msg(%{type: "CMSG_AUTHENTICATE_CHALLENGE"} = params, opts \\ []) do
    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn -> execute(params, opts) end)
  end

  defp execute(params, opts) do
    server_rnd = :random.uniform(99_999_999_999)
    salt = string_of_length(40)
    msg = %{type: "SMSG_AUTHENTICATE_CHALLENGE", server_rnd: server_rnd, salt: salt}
    Logger.info(fn -> "Create Response: SMSG_AUTHENTICATE_CHALLENGE" end, message: msg)

    with {:ok, message_len, message} <- TcpServer.CommandSerializer.serialize(msg) do
      transport = Keyword.get(opts, :response_pid, nil)
      socket = Keyword.get(opts, :response_socket, nil)
      id = 2
      id_sz = 8 * 8
      sz_sz = 32
      message_bytes = <<id::size(id_sz), message_len::little-size(sz_sz)>> <> message
      transport.send(socket, message_bytes)
      #      {:ok}
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
