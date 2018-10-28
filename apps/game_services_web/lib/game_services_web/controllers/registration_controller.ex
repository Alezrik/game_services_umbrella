defmodule GameServicesWeb.RegistrationController do
  use GameServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, %{"register" => user_params}) do
    IO.puts(inspect(user_params))

    {:ok, user} =
      UserManager.register_new_user(
        Map.get(user_params, "username"),
        Map.get(user_params, "email"),
        Map.get(user_params, "password")
      )

    IO.puts(inspect(user))
    render(conn, "index.html")
  end
end
