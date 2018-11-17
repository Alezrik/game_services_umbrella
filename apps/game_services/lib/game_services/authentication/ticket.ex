defmodule GameServices.Authentication.Ticket do
  @moduledoc """
  Authentication Challenge Tickets
"""
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :client_token, :string
    field :salt, :string
    field :server_token, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:client_token, :server_token, :username, :salt])
    |> validate_required([:client_token, :server_token, :username, :salt])
    |> validate_length(:client_token, min: 1)
    |> validate_length(:server_token, min: 1)
    |> validate_length(:username, min: 1)
    |> validate_length(:salt, min: 1)
  end
end
