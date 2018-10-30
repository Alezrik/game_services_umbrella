defmodule GameServicesWeb.CreateUser do
  def get_user() do
    Ecto.Adapters.SQL.Sandbox.mode(GameServices.Repo, {:shared, self()})
    {:ok, user} = GameServices.Account.create_user()
    user
  end
end