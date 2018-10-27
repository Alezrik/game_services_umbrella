defmodule GameServices.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_one :credential, GameServices.Identity.Credential
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
