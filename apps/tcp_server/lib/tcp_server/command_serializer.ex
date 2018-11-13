defmodule TcpServer.CommandSerializer do
  @moduledoc false
  require Logger

  def serialize(%{type: "SMSG_AUTHENTICATE_CHALLENGE"} = params) do
    id_sz = 8 * 8
    sz_sz = 32
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
        pw_salt_len = byte_size(pw_salt)
        message = <<server_rnd::size(32), pw_salt_len::size(8)>> <> pw_salt
        message_len = byte_size(message)
        {:ok, message_len, message}
    end
  end
end
