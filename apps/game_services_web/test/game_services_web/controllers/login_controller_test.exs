defmodule GameServicesWeb.LoginControllerTest do
  use GameServicesWeb.ConnCase

  use ExUnitProperties

  #  setup do
  #     Explicitly get a connection before each test
  #    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
  #    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  #  end

  test "GET /login", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "login"
  end

  property "POST /login valid user", %{conn: conn} do
    #
    check all name <- string(:alphanumeric, min_length: 5, max_length: 20),
              email <- string(:alphanumeric, min_length: 5, max_length: 20),
              password <- string(:alphanumeric, min_length: 5, max_length: 20) do
      {:ok, user} = GameServices.Account.create_user(%{})

      {:ok, credential} =
        GameServices.Identity.create_credential(%{
          name: name,
          password: password,
          email: email,
          user_id: user.id
        })

      conn = post(conn, "/login", %{"login" => %{username: name, password: password}})
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  property "POST /login invalid user", %{conn: conn} do
    #
    check all name <- string(:alphanumeric, min_length: 1, max_length: 20),
              email <- string(:alphanumeric, min_length: 1, max_length: 20),
              password <- string(:alphanumeric, min_length: 1, max_length: 20) do
      conn = post(conn, "/login", %{"login" => %{username: name, password: password}})
      assert html_response(conn, 200) =~ "Invalid Login Credentials"
    end
  end
end
