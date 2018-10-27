defmodule Authentication do
  @moduledoc """
  Documentation for Authentication.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Authentication.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
    Attempt to retrieve a User by its Credential name and password

    returns - {:ok, user} | {:error, "no user"}
  """
  def get_user_by_credential(username, password) do
    GenServer.call(
      {:via, :swarm, Authentication.AuthenticationWorker},
      {:authenticate, username, password}
    )
  end
end
