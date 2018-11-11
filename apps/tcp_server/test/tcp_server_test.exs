defmodule TcpServerTest do
  use ExUnit.Case
  doctest TcpServer
  require Logger

  @tag :wip
  test "sometthing" do
    {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
    id = 1
    username = <<"tester123">>
    username_len = byte_size(username)
    id_sz = 8 * 8
    sz_sz = 32

    random_id = :rand.uniform(999_999)

    message = <<username_len::size(8)>> <> username <> <<random_id::size(32)>>
    sz = byte_size(message)

    packet = <<id::size(id_sz), sz::little-size(sz_sz)>> <> message
    :gen_tcp.send(conn, packet)

    case :gen_tcp.recv(conn, 0, 5000) do
      {:ok, _data} ->
        :gen_tcp.close(conn)

      {:error, reason} ->
        :gen_tcp.close(conn)
        assert(false, "Error on TCP Receive: #{inspect(reason)}")
    end
  end
end
