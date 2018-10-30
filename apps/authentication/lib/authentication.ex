defmodule Authentication do
  @moduledoc """
  Documentation for Authentication.
  """

  @doc """
    Attempt to retrieve a User by its Credential name and password
  """

  require Logger

  @spec get_user_by_credential(String.t(), String.t()) ::
          {:ok, %GameServices.Account.User{}} | {:error, any()}
  def get_user_by_credential(username, password) do
    GenServer.call(
      ClusterManager.get_authentication_worker(),
      {:authenticate, username, password}
    )
  end

  @spec login_connection(Plug.Conn.t(), %GameServices.Account.User{}) :: Plug.Conn.t()
  def login_connection(conn, user) do
    Authentication.Guardian.Plug.sign_in(conn, user)
  end

  @spec get_connection_auth_status(%Plug.Conn{}) :: :not_authenticated | :authenticated
  def get_connection_auth_status(conn) do
    case Authentication.Guardian.Plug.current_token(conn) do
      nil -> :not_authenticated
      token -> :authenticated
    end
  end
end
