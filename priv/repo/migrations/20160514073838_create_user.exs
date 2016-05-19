defmodule Exantenna.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :encrypted_password, :string
      add :last_logintime, :datetime

      timestamps
    end

    create index(:users, [:email], unique: true)
  end
end
