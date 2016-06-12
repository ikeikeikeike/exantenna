defmodule Exantenna.Repo.Migrations.AnimesThumbs do
  use Ecto.Migration

  def change do
    create table(:animes_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:animes_thumbs, [:assoc_id])

    create index(:animes_thumbs, [:src])
    create index(:animes_thumbs, [:ext])
    create index(:animes_thumbs, [:width])
    create index(:animes_thumbs, [:height])

  end
end
