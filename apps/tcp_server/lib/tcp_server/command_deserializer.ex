defmodule TcpServer.CommandDeserializer do
  @moduledoc false
  require Logger

  # CMSG_AUTHENTICATE_CHALLENGE msg
  def deserialize(1, params) do
    sz = byte_size(params) - 1
    <<name_len::size(8), remain::binary>> = params
    <<name::binary-size(name_len), client_rnd::size(32), remain::binary>> = remain
    #    client_rnd = :binary.decode_unsigned(left)

    Logger.info(fn -> "CMSG_AUTHENTICATE_CHALLENGE received" end,
      name: name,
      client_rnd: client_rnd
    )

    {:ok, %{name: name, client_rnd: client_rnd, type: "CMSG_AUTHENTICATE_CHALLENGE", type_id: 1}}
  end

  def deserialize(4, params) do
    sz = byte_size(params) - 1
    <<s::binary-size(sz), remain>> = params
    true = String.valid?(s)
    bin_sz = sz - 1
    str = Base.decode64!(s, padding: true)
    parameters = String.split(str, "+")

    Logger.info(fn -> "CMSG_AUTHENTICATE received" end,
      client_rand: Enum.at(parameters, 0),
      server_rand: Enum.at(parameters, 1),
      password: Enum.at(parameters, 2),
      salt: Enum.at(parameters, 4)
    )

    {:ok,
     %{
       client_rand: Enum.at(parameters, 0),
       server_rand: Enum.at(parameters, 1),
       password: Enum.at(parameters, 2),
       salt: Enum.at(parameters, 3),
       type: "CMSG_AUTHENTICATE",
       type_id: 4
     }}
  end

  def deserialize(100, params) do
    Logger.info(fn -> "CMSG_HEARTBEAT received" end)
    {:ok, %{type: "CMSG_HEARTBEAT", type_id: 100}}
  end

  def deserialize(id, params) do
    Logger.error("Invalid Deserialize id", message_id: id, parameters: params)
    {:error, "invalid_id: #{inspect(id)}"}
  end
end
