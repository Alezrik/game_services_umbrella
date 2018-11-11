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
    bitsize = bit_size(params)
    packet = <<id::binary-size(8), bitsize::little-size(32)>> <> params

    with {:ok, resp} <-
           TcpServer.CommandDeserializer.deserialize(:binary.decode_unsigned(id), params) do
      Logger.error(fn -> "Deserializer: #{inspect resp}" end)
    else
      {:error, reason} -> Logger.error(fn -> "Deserialize Error: #{inspect(reason)}" end)
      err -> Logger.error(fn -> "Deserialize Error: #{inspect(err)}" end)
    end

    {:noreply, state}
  end
end
