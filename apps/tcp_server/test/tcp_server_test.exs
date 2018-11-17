defmodule TcpServerTest do
  use ExUnit.Case
  doctest TcpServer
  require Logger

  use ExUnitProperties

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  end
  property "sometthing" do
    check all name <- string(:alphanumeric, min_length: 5, max_length: 20),
              email <- string(:alphanumeric, min_length: 5, max_length: 20),
              password <- string(:alphanumeric, min_length: 5, max_length: 20) do


      UserManager.register_new_user(name, email, password)
      {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
      id = 1
      username = name
      password = password
      username_len = byte_size(username)
      password_len = byte_size(password)
      id_sz = 8 * 8
      sz_sz = 32

      client_id = :rand.uniform(999_999)

      message = <<username_len::size(8)>> <> username <> <<client_id::size(32)>>
      sz = byte_size(message)

      packet = <<id::size(id_sz), sz::little-size(sz_sz)>> <> message
      :gen_tcp.send(conn, packet)

      case :gen_tcp.recv(conn, 0, 5000) do
        {:ok, data} ->
          <<id::size(64), msg_size::little-size(32), remain::binary>> = data
          <<server_rnd::size(32), pw_salt_len::size(8), salt::binary>> = remain
          #        :gen_tcp.close(conn)
          id = 4

          message_str = "#{client_id}+#{server_rnd}+#{password}+#{salt}"
          message_enc = Base.encode64(message_str)
          message_sz = byte_size(message_enc)
          packet = <<id::size(64), message_sz::little-size(sz_sz)>> <> message_enc
          #        {:ok, conn} = :gen_tcp.connect('localhost', 8005, [:binary, active: false])
          :gen_tcp.send(conn, packet)

          case :gen_tcp.recv(conn, 0, 5000) do
            {:ok, data} ->
              <<id::size(64), msg_size::little-size(32), remain::binary>> = data
              <<success::size(8), token_len::size(32), token::binary>> = remain
              :gen_tcp.close(conn)
              assert(success == 1)
              assert(token_len > 0)

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
end
