defmodule GameServicesWeb.CreateUser do
  @moduledoc false

  ## helper to create user in test with checking out repo
  def get_user() do
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
    {:ok, user} = GameServices.Account.create_user()
    user
  end
end
