defmodule Exantenna.Repo.Migrations.CreatePicturesThumbs do
  use Ecto.Migration

  def change do
    create table(:pictures_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:pictures_thumbs, [:assoc_id])

    create index(:pictures_thumbs, [:src])
    create index(:pictures_thumbs, [:ext])
    create index(:pictures_thumbs, [:width])
    create index(:pictures_thumbs, [:height])

  end
end
