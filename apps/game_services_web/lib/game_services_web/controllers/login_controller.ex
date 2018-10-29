defmodule GameServicesWeb.LoginController do
  @moduledoc false
  use GameServicesWeb, :controller

  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec login(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def login(conn, %{"login" => login}) do
    Logger.info(fn -> "process login request: #{inspect(login)}" end)

    case Authentication.get_user_by_credential(
           Map.get(login, "username"),
           Map.get(login, "password")
         ) do
      {:ok, user} ->
        Logger.info(fn -> "login success: #{inspect(user)}" end)

        conn
        |> Authentication.login_connection(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {error, reason} ->
        Logger.info(fn -> "login fail: #{inspect(reason)}" end)
        Logger.debug(fn -> inspect(GameServices.Identity.list_credentials()) end)

        conn
        |> put_flash(:login_err, "Invalid Login Credentials")
        |> render("index.html")
    end
  end
end
