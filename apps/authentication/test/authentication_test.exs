defmodule AuthenticationTest do
  use ExUnit.Case
  doctest Authentication

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  end

  use ExUnitProperties

  property "get_user_by_credential/2 validate valid user credentials" do
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

      {:ok, user} = Authentication.get_user_by_credential(name, password)
    end
  end

  property "get_user_by_credential/2 validate invalid user credentials" do
    check all name <- string(:alphanumeric, min_length: 5, max_length: 20),
              email <- string(:alphanumeric, min_length: 5, max_length: 20),
              password <- string(:alphanumeric, min_length: 5, max_length: 20) do
      {:error, "no user"} = Authentication.get_user_by_credential(name, password)
    end
  end
end
