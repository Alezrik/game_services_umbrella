defmodule UserManager do
  @moduledoc """
  Documentation for UserManager.
  """

  @doc """
    call a genserver to register a new user returns {:ok, user} or {:error, changeset}
  """
  def register_new_user(name, email, password) do
    GenServer.call(
      {:via, :swarm, UserManager.RegisterWorker},
      {:register_user, name, email, password}
    )
  end
end
