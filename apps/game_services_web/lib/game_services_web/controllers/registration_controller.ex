defmodule GameServicesWeb.RegistrationController do
  use GameServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end


  def register(conn, _params) do
    render(conn, "index.html")
  end

end
