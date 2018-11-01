defmodule GameServicesWeb.RegistrationControllerTest do
  use GameServicesWeb.ConnCase

  use ExUnitProperties

  #  setup do
  #     Explicitly get a connection before each test
  #    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
  #    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  #  end

  test "GET /registration", %{conn: conn} do
    conn = get(conn, "/registration")
    assert html_response(conn, 200) =~ "register"
  end

  property "POST /register valid user", %{conn: conn} do
    #
    check all name <- string(:alphanumeric, min_length: 5, max_length: 20),
              email <- string(:alphanumeric, min_length: 5, max_length: 20),
              password <- string(:alphanumeric, min_length: 5, max_length: 20) do
      Enum.map(GameServices.Identity.list_credentials(), fn x ->
        GameServices.Identity.delete_credential(x)
      end)

      Enum.map(GameServices.Account.list_users(), fn x -> nil end)

      conn =
        post(conn, "/registration", %{
          "register" => %{username: name, password: password, email: email}
        })

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end
  property "POST /register invalid user", %{conn: conn} do
    #
    check all name <- string(:alphanumeric, min_length: 0, max_length: 4),
          email <- string(:alphanumeric, min_length: 0, max_length: 4),
          password <- string(:alphanumeric, min_length: 0, max_length: 4) do
      Enum.map(GameServices.Identity.list_credentials(), fn x ->
        GameServices.Identity.delete_credential(x)
      end)

      Enum.map(GameServices.Account.list_users(), fn x -> nil end)

      conn =
        post(conn, "/registration", %{
          "register" => %{username: name, password: password, email: email}
        })

      assert html_response(conn, 200) =~ "Invalid Register Credentials"
    end
  end
end
