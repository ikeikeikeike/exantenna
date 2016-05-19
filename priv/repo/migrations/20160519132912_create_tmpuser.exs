defmodule Exantenna.Repo.Migrations.CreateTmpuser do
  use Ecto.Migration

  def change do
    create table(:tmpusers) do
      add :url, :string
      add :rss, :string

      add :email, :string
      add :encrypted_password, :string

      add :mediatype, :string
      add :contenttype, :string

	  add :token, :string
      add :tokentype, :string
	  add :expires, :datetime

      timestamps
    end

  end
end
