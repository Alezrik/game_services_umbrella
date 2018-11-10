defmodule Authentication.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    body = Poison.encode!(%{message: to_string(type) <> " : " <> to_string(reason)})
    send_resp(conn, 401, body)
  end
end
