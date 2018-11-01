defmodule GameServices.Repo.Migrations.IndexForCredentials do
  use Ecto.Migration

  def change do
    create index(:credentials, :name)
    create index(:credentials, :email)
  end
end
