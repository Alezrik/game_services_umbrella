defmodule TcpServer.CommandDeserializer do
  @moduledoc false
  require Logger

  # CMSG_AUTHENTICATE_CHALLENGE msg
  def deserialize(1, params) do
    sz = byte_size(params) - 1
    Logger.error(fn -> "size is #{inspect(sz)}" end)
    Logger.error(fn -> "received params: '#{inspect(params)}'" end)
    <<name_len::size(8), remain::binary>> = params
    <<name::binary-size(name_len), left::binary>> = remain
    client_rnd = :binary.decode_unsigned(left)
    Logger.info("CMSG_AUTHENTICATE_CHALLENGE received", name: name, client_rnd: client_rnd)
    {:ok, %{name: name, client_rnd: client_rnd, type: "CMSG_AUTHENTICATE_CHALLENGE", type_id: 1}}
  end

  def deserialize(4, params) do
    sz = byte_size(params) - 1
    <<s::binary-size(sz), remain>> = params
    true = String.valid?(s)
    Logger.error(fn -> "size is #{inspect(sz)}" end)
    bin_sz = sz - 1
    Logger.error(fn -> "received params: #{inspect(s)}" end)
    str = Base.decode64!(s, padding: true)
    parameters = String.split(str, "+")
    Logger.error(fn -> "msg received: #{inspect(parameters)}" end)

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

  def deserialize(id, params) do
    Logger.error("Invalid Deserialize id", message_id: id, parameters: params)
    {:error, "invalid_id: #{inspect(id)}"}
  end
end
