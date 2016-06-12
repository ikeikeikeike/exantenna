defmodule Exantenna.Repo.Migrations.TagsThumbs do
  use Ecto.Migration

  def change do
    create table(:tags_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:tags_thumbs, [:assoc_id])

    create index(:tags_thumbs, [:src])
    create index(:tags_thumbs, [:ext])
    create index(:tags_thumbs, [:width])
    create index(:tags_thumbs, [:height])

  end
end
