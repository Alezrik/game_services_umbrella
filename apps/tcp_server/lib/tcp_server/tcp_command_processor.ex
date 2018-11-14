defmodule TcpServer.TcpCommandProcessor do
  @moduledoc false

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
  def handle_cast({:process, id, params, socket, transport}, state) when is_binary(id) do
    Logger.debug(fn -> "processing message" end, message_id: id)

    Task.Supervisor.async_nolink(TcpServer.TaskSupervisor, fn ->
      bitsize = bit_size(params)
      packet = <<id::binary-size(8), bitsize::little-size(32)>> <> params

      with {:ok, resp} <-
             TcpServer.CommandDeserializer.deserialize(:binary.decode_unsigned(id), params) do
        process_msg(resp, socket, transport)
      else
        {:error, reason} -> Logger.error(fn -> "Deserialize Error: #{inspect(reason)}" end)
        err -> Logger.error(fn -> "Deserialize Error: #{inspect(err)}" end)
      end
    end)

    {:noreply, state}
  end

  def process_msg(msg, socket, transport) when is_map(msg) do
    t = Map.get(msg, :type, "INVALID")

    case t do
      "CMSG_AUTHENTICATE_CHALLENGE" ->
        Logger.info(fn -> "Process Client Msg: CMSG_AUTHENTICATE_CHALLENGE" end, message: msg)

        TcpServer.Workflows.CmsgAuthenticateChallenge.process_msg(msg,
          response_pid: transport,
          response_socket: socket
        )

      "CMSG_AUTHENTICATE" ->
        Logger.info(fn -> "Process Client Msg: CMSG_AUTHENTICATE" end, message: msg)

        TcpServer.Workflows.CmsgAuthenticate.process_msg(msg,
          response_pid: transport,
          response_socket: socket
        )
    end
  end
end
