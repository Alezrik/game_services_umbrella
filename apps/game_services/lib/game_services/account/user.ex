defmodule GameServices.Account.User do
  @moduledoc """
    Main User object, has pointers to metadata resources about the user
  """
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
