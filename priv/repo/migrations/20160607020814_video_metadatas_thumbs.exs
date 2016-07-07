defmodule Exantenna.Repo.Migrations.VideoMetadatasThumbs do
  use Ecto.Migration

  def change do
    create table(:video_metadatas_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:video_metadatas_thumbs, [:assoc_id])

    create index(:video_metadatas_thumbs, [:src])
    create index(:video_metadatas_thumbs, [:ext])
    create index(:video_metadatas_thumbs, [:width])
    create index(:video_metadatas_thumbs, [:height])

  end

end
