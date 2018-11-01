defmodule GameServices.IdentityTest do
  use GameServices.DataCase

  alias GameServices.Identity

  describe "credentials" do
    alias GameServices.Identity.Credential

    {:ok, user} = GameServices.Account.create_user()

    @valid_attrs %{
      email: "some email",
      name: "some name",
      password: "some password",
      user_id: user.id
    }
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      password: "some up password"
    }
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Identity.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential = credential_fixture()
      assert Identity.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Identity.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Identity.create_credential(@valid_attrs)
      assert credential.email == "some email"
      assert credential.name == "some name"
      assert credential.password == "some password"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Identity.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()

      assert {:ok, %Credential{} = credential} =
               Identity.update_credential(credential, @update_attrs)

      assert credential.email == "some updated email"
      assert credential.name == "some updated name"
      assert credential.password == "some up password"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Identity.update_credential(credential, @invalid_attrs)
      assert credential == Identity.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Identity.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Identity.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Identity.change_credential(credential)
    end

    use ExUnitProperties

    property "get_user_by_credential_name_and_password/2 gets a user" do
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

          {:ok, user} = Identity.get_user_by_credential_name_and_password(name, password)
      end
    end
  end
end
