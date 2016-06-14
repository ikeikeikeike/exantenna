defmodule Exantenna.Repo.Migrations.CreateVideoMetadatasSites do
  use Ecto.Migration

  def change do
    create table(:video_metadatas_sites) do
      add :assoc_id, :integer

      add :name, :string
      add :domain, :string
      add :rss, :string

      timestamps
    end
    create index(:video_metadatas_sites, [:assoc_id])

    create unique_index(:video_metadatas_sites, [:domain, :rss])

  end
end
