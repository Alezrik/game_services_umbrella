defmodule TcpServerTest do
  use ExUnit.Case
  doctest TcpServer

  @tag :wip
  test "sometthing" do
    {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
    id = 0
    m = <<"hello">>
    sz = byte_size(m)
    id_sz = 8 * 8
    sz_sz = 32 * 8
    :gen_tcp.send(conn, [<<id::size(id_sz)>>, <<sz::size(sz_sz)>>] ++ m)

    case :gen_tcp.recv(conn, 0, 5000) do
      {:ok, _data} ->
        :gen_tcp.close(conn)

      {:error, reason} ->
        :gen_tcp.close(conn)
        assert(false, "Error on TCP Receive: #{inspect(reason)}")
    end
  end
end
