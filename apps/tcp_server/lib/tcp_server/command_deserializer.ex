defmodule TcpServer.CommandDeserializer do
  @moduledoc false
  require Logger

  def deserialize(1, params) do
    Logger.metadata(msg_id: 1)
    <<name_len::size(8), remain::binary>> = params
    <<name::binary-size(name_len), left::binary>> = remain
    client_rnd = :binary.decode_unsigned(left)
    Logger.info("CMSG_AUTHENTICATE_CHALLENGE received", [name: name, client_rnd: client_rnd])
    {:ok, %{name: name, client_rnd: client_rnd}}

end

  def deserialize(id, params) do
    Logger.error("Invalid Deserialize id", message_id: id, parameters: params)
    {:error, "invalid_id: #{inspect(id)}"}
  end
end
