defmodule Exantenna.Repo.Migrations.DropIndexToThumbsTables do
  use Ecto.Migration

  def change do
    drop_if_exists index(:video_metadatas_thumbs, [:src])
    drop_if_exists index(:video_metadatas_thumbs, [:ext])
    drop_if_exists index(:video_metadatas_thumbs, [:height])
    drop_if_exists index(:entries_thumbs, [:src])
    drop_if_exists index(:entries_thumbs, [:ext])
    drop_if_exists index(:entries_thumbs, [:height])
    drop_if_exists index(:pictures_thumbs, [:src])
    drop_if_exists index(:pictures_thumbs, [:ext])
    drop_if_exists index(:pictures_thumbs, [:height])
    drop_if_exists index(:sites_thumbs, [:src])
    drop_if_exists index(:sites_thumbs, [:ext])
    drop_if_exists index(:sites_thumbs, [:height])
    drop_if_exists index(:tags_thumbs, [:src])
    drop_if_exists index(:tags_thumbs, [:ext])
    drop_if_exists index(:tags_thumbs, [:height])
    drop_if_exists index(:blogs_thumbs, [:src])
    drop_if_exists index(:blogs_thumbs, [:ext])
    drop_if_exists index(:blogs_thumbs, [:height])
    drop_if_exists index(:divas_thumbs, [:src])
    drop_if_exists index(:divas_thumbs, [:ext])
    drop_if_exists index(:divas_thumbs, [:height])
    drop_if_exists index(:chars_thumbs, [:src])
    drop_if_exists index(:chars_thumbs, [:ext])
    drop_if_exists index(:chars_thumbs, [:height])
    drop_if_exists index(:toons_thumbs, [:src])
    drop_if_exists index(:toons_thumbs, [:ext])
    drop_if_exists index(:toons_thumbs, [:height])
  end
end
