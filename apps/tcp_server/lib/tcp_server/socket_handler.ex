defmodule TcpServer.SocketHandler do
  @moduledoc false

  require Logger

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _opts \\ []) do
    Logger.debug(fn -> "New Socket Connection" end, transport: transport)
    :ok = :ranch.accept_ack(ref)
    transport.setopts(socket, nodelay: true)
    responder_pid = spawn_link(__MODULE__, :responder, [socket, transport, <<>>, [], 0])
    Process.flag(:trap_exit, true)
    loop(socket, transport, responder_pid)
    Logger.debug(fn -> "Socket Connection Closed" end, transport: transport)
  end

  def calc_skipped([]) do
    0
  end

  def calc_skipped([{_, skipped}]) do
    skipped
  end

  def calc_skipped([{_, skipped} | rest]) do
    1 + skipped + calc_skipped(rest)
  end

  def flush(_, _, []) do
  end

  def flush(_socket, _transport, _ack_list) do
    #    Logger.warn "ack_list: #{inspect ack_list}"
    #    [{id, _} | _] = ack_list
    #    skipped = calc_skipped(ack_list)
    #    GenServer.cast(ClusterManager.get_tcp_command_processor(), {:process, id, ack_list, socket, transport})
  end

  def responder(socket, transport, yet_to_parse, ack_list, packet_count) do
    #    Logger.warn "top yet_to_parse: #{inspect yet_to_parse}"
    ##    Logger.warn "top ack_list: #{inspect ack_list}"
    ##    Logger.warn "packet_count: #{inspect packet_count}"
    receive do
      {:message, packet} ->
        case parse(yet_to_parse <> packet, <<>>, 0, transport, socket) do
          {not_yet_parsed, {id, skipped}} ->
            new_ack_list = [{id, skipped} | ack_list]

            if packet_count > 20 do
              flush(socket, transport, new_ack_list)
              responder(socket, transport, not_yet_parsed, [], 0)
            else
              responder(socket, transport, not_yet_parsed, new_ack_list, packet_count + 1)
            end

          {not_yet_parsed, {}} ->
            responder(socket, transport, not_yet_parsed, ack_list, packet_count + 1)
        end

      {:stop} ->
        :stop
    after
      5 ->
        flush(socket, transport, ack_list)
        responder(socket, transport, yet_to_parse, [], 0)
    end
  end

  def loop(socket, transport, responder_pid) do
    case transport.recv(socket, 0, 15_000) do
      {:ok, packet} ->
        {:message_queue_len, length} = :erlang.process_info(responder_pid, :message_queue_len)

        if length > 100 do
          :timer.sleep(div(length, 100))
        end

        send(responder_pid, {:message, packet})
        loop(socket, transport, responder_pid)

      {:error, :timeout} ->
        shutdown(socket, transport, responder_pid)

      _ ->
        shutdown(socket, transport, responder_pid)
    end
  end

  defp shutdown(socket, transport, responder_pid) do
    send(responder_pid, {:stop})

    receive do
      {:EXIT, responder_pid, :normal} -> :ok
    end

    :ok = transport.close(socket)
  end

  defp parse(<<>>, <<>>, _skipped, _transport, _socket) do
    {<<>>, {}}
  end

  defp parse(<<>>, last_id, skipped, _transport, _socket) do
    {<<>>, {last_id, skipped}}
  end

  defp parse(packet, <<>>, 0, transport, socket) do
    Logger.debug(fn -> "parse packet #{inspect(packet)}" end)

    case packet do
      <<id::binary-size(8), sz::little-size(32), data::binary-size(sz)>> when sz < 1_000_000 ->
        GenServer.cast(
          ClusterManager.get_tcp_command_processor(),
          {:process, id, data <> <<0>>, socket, transport}
        )

        {<<>>, {id, 0}}

      <<id::binary-size(8), sz::little-size(32), data::binary-size(sz), rest::binary>>
      when sz < 100 ->
        GenServer.cast(
          ClusterManager.get_tcp_command_processor(),
          {:process, id, data <> <<0>>, socket, transport}
        )

        parse(rest, id, 0, transport, socket)

      unparsed ->
        Logger.error(fn -> "no parser match: #{inspect(unparsed)}" end)
        {unparsed, {}}
    end
  end

  defp parse(packet, last_id, skipped, transport, socket) do
    case packet do
      <<id::binary-size(8), sz::little-size(32), _data::binary-size(sz)>> when sz < 1_000_000 ->
        {<<>>, {id, skipped + 1}}

      <<id::binary-size(8), sz::little-size(32), _data::binary-size(sz), rest::binary>>
      when sz < 100 ->
        parse(rest, id, skipped + 1, transport, socket)

      unparsed ->
        {unparsed, {last_id, skipped}}
    end
  end
end
