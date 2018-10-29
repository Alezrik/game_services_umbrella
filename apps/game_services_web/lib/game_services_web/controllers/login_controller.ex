defmodule GameServicesWeb.LoginController do
  @moduledoc false
  use GameServicesWeb, :controller

  require Logger
  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, %{"login" => login}) do
    case Authentication.get_user_by_credential(Map.get(login, "username"), Map.get(login, "password")) do
      {:ok, user} ->
        Logger.debug("login success: #{inspect user}")
        redirect(conn, to: Routes.page_path(conn, :index))
       {error, reason} ->
         Logger.debug "login fail: #{inspect reason}"
         render(conn, "index.html")
    end

  end
end
