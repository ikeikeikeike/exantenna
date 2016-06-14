defmodule Exantenna.Repo.Migrations.CreateVideosSites do
  use Ecto.Migration

  def change do
    create table(:videos_sites) do
      add :assoc_id, :integer

      add :name, :string
      add :domain, :string
      add :rss, :string

      timestamps
    end
    create index(:videos_sites, [:assoc_id])

    create unique_index(:videos_sites, [:domain, :rss])

  end
end
