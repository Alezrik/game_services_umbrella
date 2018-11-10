defmodule TcpServerTest do
  use ExUnit.Case
  doctest TcpServer
  require Logger

  @tag :wip
  test "sometthing" do
    {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
    id = 47
    m = <<"hello">>
    sz = byte_size(m)
    id_sz = 8 * 8
    sz_sz = 32
    packet =  <<id::size(id_sz), sz::little-size(sz_sz)>> <> m
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
