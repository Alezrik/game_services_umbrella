defmodule GameServicesWeb.LoginController do
  @moduledoc false
  use GameServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render(conn, "index.html")
  end
end
