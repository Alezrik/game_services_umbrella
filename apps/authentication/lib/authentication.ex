defmodule Authentication do
  @moduledoc """
  Documentation for Authentication.
  """

  require Logger

  @doc """
    Attempt to retrieve a User by its Credential name and password
  """
  @spec get_user_by_credential(String.t(), String.t()) ::
          {:ok, %GameServices.Account.User{}} | {:error, any()}
  def get_user_by_credential(username, password) do
    Logger.info(fn -> "Authenticate By Credential Request" end,
      username: username,
      password: password
    )

    GenServer.call(
      ClusterManager.get_authentication_worker(),
      {:authenticate, username, password}
    )
  end

  @doc """
    insert Authentication Token into Http Conn
  """
  @spec login_connection(Plug.Conn.t(), %GameServices.Account.User{}) :: Plug.Conn.t()
  def login_connection(conn, user) do
    Authentication.Guardian.Plug.sign_in(conn, user)
  end

  @doc """
    remove Authentication Token from Http Conn
  """
  @spec logout_connection(Plug.Conn.t()) :: Plug.Conn.t()
  def logout_connection(conn) do
    Authentication.Guardian.Plug.sign_out(conn)
  end

  @doc """
    get the Connections current authentication status
  """
  @spec get_connection_auth_status(%Plug.Conn{}) :: :not_authenticated | :authenticated
  def get_connection_auth_status(conn) do
    case Authentication.Guardian.Plug.current_token(conn) do
      nil -> :not_authenticated
      _token -> :authenticated
    end
  end

  @doc """
  generate user token
"""
  def get_user_token(user) do
    {:ok, token, _claims} = Authentication.Guardian.encode_and_sign(user)
    {:ok, token}
  end
end
