defmodule TcpServerTest do
  use ExUnit.Case
  doctest TcpServer
  require Logger

  @tag :wip
  test "sometthing" do
    {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
    id = 1
    username = <<"tester123">>
    password = "tester123"
    username_len = byte_size(username)
    password_len = byte_size(password)
    id_sz = 8 * 8
    sz_sz = 32

    random_id = :rand.uniform(999_999)

    message = <<username_len::size(8)>> <> username <> <<random_id::size(32)>>
    sz = byte_size(message)

    packet = <<id::size(id_sz), sz::little-size(sz_sz)>> <> message
    Logger.error(fn -> "sending msg : #{message}" end)
    Logger.error(fn -> "sending sz: #{sz}" end)
    :gen_tcp.send(conn, packet)

    case :gen_tcp.recv(conn, 0, 5000) do
      {:ok, data} ->
        Logger.error(fn -> "data is #{inspect(data)}" end)
        <<id::size(64), msg_size::little-size(32), remain::binary>> = data
        <<server_rnd::size(32), pw_salt_len::size(8), salt::binary>> = remain
        #        <<msg_size::little-size(32), remain::binary>> = data
        Logger.error(fn -> "id is #{id}" end)
        Logger.error(fn -> "msg_size is #{msg_size}" end)
        Logger.error(fn -> "salt is #{salt}" end)
        Logger.error(fn -> "server_rnd is #{server_rnd}" end)
        :gen_tcp.close(conn)
        id = 4

        message_str = "#{random_id}+#{server_rnd}+#{password}+#{salt}"
        message_enc = Base.encode64(message_str)
        message_sz = byte_size(message_enc)
        Logger.error(fn -> "sending msg : #{message_enc}" end)
        Logger.error(fn -> "sending sz: #{message_sz}" end)
        packet = <<id::size(64), message_sz::little-size(sz_sz)>> <> message_enc
        {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
        :gen_tcp.send(conn, packet)

        case :gen_tcp.recv(conn, 0, 5000) do
          {:ok, data} ->
            Logger.error(fn -> "I got this stuff: #{inspect(data)}" end)
            :gen_tcp.close(conn)

          {:error, reason} ->
            :gen_tcp.close(conn)
            assert(false, "Error on TCP Receive: #{inspect(reason)}")
        end

      {:error, reason} ->
        :gen_tcp.close(conn)
        assert(false, "Error on TCP Receive: #{inspect(reason)}")
    end
  end
end
