defmodule Exantenna.Repo.Migrations.CreateVideoMetadata do
  use Ecto.Migration

  def change do
    create table(:video_metadatas) do
      add :video_id, references(:videos, on_delete: :nothing)

      add :url, :text

      add :title, :text
      add :content, :text
      add :embed_code, :text

      add :duration, :integer

      timestamps
    end
    create index(:video_metadatas, [:video_id])
    create index(:video_metadatas, [:duration])

  end
end
