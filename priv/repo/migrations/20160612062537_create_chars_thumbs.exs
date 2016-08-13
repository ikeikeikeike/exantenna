defmodule Exantenna.Repo.Migrations.CreateCharsThumbs do
  use Ecto.Migration

  def change do
    create table(:chars_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:chars_thumbs, [:assoc_id])

    create index(:chars_thumbs, [:src])
    create index(:chars_thumbs, [:ext])
    create index(:chars_thumbs, [:width])
    create index(:chars_thumbs, [:height])

  end
end
