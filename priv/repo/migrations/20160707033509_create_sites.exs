defmodule Exantenna.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :url, :string
      add :domain, :string
      add :rss, :string

      timestamps
    end
    create unique_index(:sites, [:domain, :rss])
    create index(:sites, [:name])

  end
end
