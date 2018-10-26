defmodule GameServicesWeb.CredentialControllerTest do
  use GameServicesWeb.ConnCase

  alias GameServices.Identity

  @create_attrs %{email: "some email", name: "some name", password: "some password"}
  @update_attrs %{
    email: "some updated email",
    name: "some updated name",
    password: "some updated password"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:credential) do
    {:ok, credential} = Identity.create_credential(@create_attrs)
    credential
  end

  describe "index" do
    test "lists all credentials", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Credentials"
    end
  end

  describe "new credential" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :new))
      assert html_response(conn, 200) =~ "New Credential"
    end
  end

  describe "create credential" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.credential_path(conn, :show, id)

      conn = get(conn, Routes.credential_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Credential"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Credential"
    end
  end

  describe "edit credential" do
    setup [:create_credential]

    test "renders form for editing chosen credential", %{conn: conn, credential: credential} do
      conn = get(conn, Routes.credential_path(conn, :edit, credential))
      assert html_response(conn, 200) =~ "Edit Credential"
    end
  end

  describe "update credential" do
    setup [:create_credential]

    test "redirects when data is valid", %{conn: conn, credential: credential} do
      conn =
        put(conn, Routes.credential_path(conn, :update, credential), credential: @update_attrs)

      assert redirected_to(conn) == Routes.credential_path(conn, :show, credential)

      conn = get(conn, Routes.credential_path(conn, :show, credential))
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, credential: credential} do
      conn =
        put(conn, Routes.credential_path(conn, :update, credential), credential: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Credential"
    end
  end

  describe "delete credential" do
    setup [:create_credential]

    test "deletes chosen credential", %{conn: conn, credential: credential} do
      conn = delete(conn, Routes.credential_path(conn, :delete, credential))
      assert redirected_to(conn) == Routes.credential_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.credential_path(conn, :show, credential))
      end
    end
  end

  defp create_credential(_) do
    credential = fixture(:credential)
    {:ok, credential: credential}
  end
end
