defmodule GameServices.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :name, :string
      add :email, :string
      add :password, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:credentials, [:user_id])
  end
end
