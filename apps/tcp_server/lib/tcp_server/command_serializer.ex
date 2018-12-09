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
        pw_salt_len =byte_size(pw_salt)
        message = <<server_rnd::size(32), pw_salt_len::size(32)>> <> pw_salt
        message_len = byte_size(message)

        Logger.error(fn -> "Serialize SMSG_AUTHENTICATE_CHALLENGE to binary" end,
          message_len: message_len, salt: pw_salt, salt_len: pw_salt_len
        )

        {:ok, message_len, message}
    end
  end

  def serialize(%{type: "SMSG_AUTHENTICATE"} = params) do
    case Map.get(params, :success, false) do
      true ->
        token = Map.get(params, :token)
        Logger.debug(fn -> "token" end, token: token)
        token_len = byte_size(token)
        success = 1
        message = <<1::size(8), token_len::size(32)>> <> token
        message_len = byte_size(message)
        Logger.info(fn -> "Serialize SMSG_AUTHENTICATE to binary" end, message_len: message_len)
        {:ok, message_len, message}

      false ->
        message = <<0::size(8), 0::size(8)>>
        message_len = byte_size(message)
        Logger.info(fn -> "Serialize SMSG_AUTHENTICATE to binary" end, message_len: message_len)
        {:ok, message_len, message}
    end
  end

  def serialize(%{type: "SMSG_HEARTBEAT"} = params) do
    message = <<1>>
    message_len = byte_size(message)
    Logger.info(fn -> "Serialize SMSG_HEARTBEAT to binary" end, message_len: message_len)
    {:ok, message_len, message}
  end
end
