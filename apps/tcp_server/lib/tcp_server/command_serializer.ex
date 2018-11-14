defmodule TcpServer.CommandSerializer do
  @moduledoc false
  require Logger

  def serialize(%{type: "SMSG_AUTHENTICATE_CHALLENGE"} = params) do
    server_rnd = Map.get(params, :server_rnd, -1)
    pw_salt = Map.get(params, :salt, "")

    case server_rnd == -1 or pw_salt == "" do
      true ->
        Logger.error(
          fn -> "failed to get required parameters for SMSG_AUTHENTICATE_CHALLENGE" end,
          parameters: params
        )

        {:error, "invalid server random"}

      false ->
        #        Logger.error(fn -> "pw_salt: #{pw_salt}" end)
        #        Logger.error(fn -> "server rnd: #{server_rnd}" end)
        pw_salt_len = byte_size(pw_salt)
        message = <<server_rnd::size(32), pw_salt_len::size(8)>> <> pw_salt
        message_len = byte_size(message)

        Logger.info(fn -> "Serialize SMSG_AUTHENTICATE_CHALLENGE to binary" end,
          message_len: message_len
        )

        {:ok, message_len, message}
    end
  end
end
