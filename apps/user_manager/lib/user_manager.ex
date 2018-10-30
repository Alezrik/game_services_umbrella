defmodule UserManager do
  @moduledoc """
  Documentation for UserManager.
  """

  @doc """
    Register a New User Account
  """
  @spec register_new_user(String.t(), String.t(), String.t()) ::
          {:ok, %GameServices.Account.User{}} | {:error, any()}
  def register_new_user(name, email, password) do
    GenServer.call(
      ClusterManager.get_registration_worker(),
      {:register_user, name, email, password}
    )
  end
end
