defmodule Exantenna.Repo.Migrations.CreateVideoMetadata do
  use Ecto.Migration

  def change do
    create table(:video_metadatas) do
      add :site_id, references(:sites, on_delete: :nothing)
      add :video_id, references(:videos, on_delete: :nothing)

      add :url, :text

      add :title, :text
      add :content, :text
      add :embed_code, :text

      add :duration, :integer

      timestamps
    end
    create index(:video_metadatas, [:site_id])
    create index(:video_metadatas, [:video_id])

    create index(:video_metadatas, [:duration])
  end
end
