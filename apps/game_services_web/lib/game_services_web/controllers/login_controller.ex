defmodule GameServicesWeb.LoginController do
  @moduledoc false
  use GameServicesWeb, :controller

  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec login(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def login(conn, %{"login" => login}) do
    username = Map.get(login, "username")
    password = Map.get(login, "password")
    Logger.metadata(username: username)
    Logger.metadata(password: password)

    case Authentication.get_user_by_credential(
           username,
           password
         ) do
      {:ok, user} ->
        Logger.info(fn -> "login success" end, user_id: user.id)

        conn
        |> Authentication.login_connection(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {_error, reason} ->
        Logger.warn(fn -> "login fail: #{inspect(reason)}" end,
          username: Map.get(login, "username", "")
        )

        conn
        |> put_flash(:login_err, "Invalid Login Credentials")
        |> render("index.html")
    end
  end

  def logout(conn, _params) do
    Logger.info(fn -> "Logout Connection" end)

    conn
    |> Authentication.logout_connection()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
