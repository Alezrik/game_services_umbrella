defmodule UserManager do
  @moduledoc """
  Documentation for UserManager.
  """

  @doc """
    Register a New User Account
  """
  require Logger

  @spec register_new_user(String.t(), String.t(), String.t()) ::
          {:ok, %GameServices.Account.User{}} | {:error, atom(), any(), any()}
  def register_new_user(name, email, password) do
    Logger.info(fn -> "Register User Request" end, name: name, email: email, password: password)

    GenServer.call(
      ClusterManager.get_registration_worker(),
      {:register_user, name, email, password}
    )
  end
end
