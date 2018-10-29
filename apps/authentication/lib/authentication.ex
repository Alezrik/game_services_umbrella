defmodule Authentication do
  @moduledoc """
  Documentation for Authentication.
  """

  @doc """
    Attempt to retrieve a User by its Credential name and password
  """

  @spec get_user_by_credential(String.t(), String.t()) ::
          {:ok, %GameServices.Account.User{}} | {:error, any()}
  def get_user_by_credential(username, password) do
    GenServer.call(
      {:via, :swarm, Authentication.AuthenticationWorker},
      {:authenticate, username, password}
    )
  end
end
