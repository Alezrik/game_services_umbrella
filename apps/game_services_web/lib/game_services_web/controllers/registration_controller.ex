defmodule GameServicesWeb.RegistrationController do
  @moduledoc false
  use GameServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, %{"register" => user_params}) do
    {:ok, user} =
      UserManager.register_new_user(
        Map.get(user_params, "username"),
        Map.get(user_params, "email"),
        Map.get(user_params, "password")
      )

    render(conn, "index.html")
  end
end
