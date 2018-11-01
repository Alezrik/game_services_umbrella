defmodule UserManagerTest do
  use ExUnit.Case
  doctest UserManager
  use ExUnitProperties

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GameServices.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
  end

  property "register_new_user/3 with valid user" do
    #
    check all name <- string(:alphanumeric, min_length: 5, max_length: 20),
              email <- string(:alphanumeric, min_length: 5, max_length: 20),
              password <- string(:alphanumeric, min_length: 5, max_length: 20) do
      Enum.map(GameServices.Identity.list_credentials(), fn x ->
        GameServices.Identity.delete_credential(x)
      end)

      {:ok, user} = UserManager.register_new_user(name, email, password)
    end
  end

  property "register_new_user/3 with invalid user" do
    #
    check all name <- string(:alphanumeric, min_length: 0, max_length: 4),
              email <- string(:alphanumeric, min_length: 0, max_length: 4),
              password <- string(:alphanumeric, min_length: 0, max_length: 4) do
      Enum.map(GameServices.Identity.list_credentials(), fn x ->
        GameServices.Identity.delete_credential(x)
      end)

      {:error, create_credential, changeset, others} =
        UserManager.register_new_user(name, email, password)
    end
  end
end
