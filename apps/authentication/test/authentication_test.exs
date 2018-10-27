defmodule AuthenticationTest do
  use ExUnit.Case
  doctest Authentication

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  end

  test "validate valid credentials" do
    {:ok, user} = GameServices.Account.create_user(%{})

    {:ok, credential} =
      GameServices.Identity.create_credential(%{
        name: "user",
        password: "pass",
        email: "blah@blah.com",
        user_id: user.id
      })

    {:ok, user} = Authentication.get_user_by_credential("user", "pass")
  end

  test "invalid credentials" do
    {:error, "no user"} = Authentication.get_user_by_credential("nouser", "nopass")
  end
end
