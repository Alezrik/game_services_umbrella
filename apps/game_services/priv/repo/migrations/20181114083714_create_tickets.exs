defmodule GameServices.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :client_token, :string
      add :server_token, :string
      add :username, :string
      add :salt, :string

      timestamps()
    end
  end
end
