defmodule GameServices.Identity.Credential do
  @moduledoc """
    a set of Credentials to Identify a User
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field :email, :string
    field :name, :string
    field :password, :string
    belongs_to :user, GameServices.Account.User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:name, :email, :password, :user_id])
    |> validate_required([:name, :email, :password])
  end
end
