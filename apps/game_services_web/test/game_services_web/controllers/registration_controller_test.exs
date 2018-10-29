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

  property "POST /login valid user", %{conn: conn} do
    #
    check all name <- string(:alphanumeric, min_length: 1, max_length: 20),
              email <- string(:alphanumeric, min_length: 1, max_length: 20),
              password <- string(:alphanumeric, min_length: 1, max_length: 20) do
      {:ok, user} = GameServices.Account.create_user(%{})

      {:ok, credential} =
        GameServices.Identity.create_credential(%{
          name: name,
          password: password,
          email: email,
          user_id: user.id
        })

      conn =
        post(conn, "/registration", %{
          "register" => %{username: name, password: password, email: email}
        })

      assert html_response(conn, 200) =~ "register"
    end
  end
end
