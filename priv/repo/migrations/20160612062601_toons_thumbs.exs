defmodule Exantenna.Repo.Migrations.ToonsThumbs do
  use Ecto.Migration

  def change do
    create table(:toons_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:toons_thumbs, [:assoc_id])

    create index(:toons_thumbs, [:src])
    create index(:toons_thumbs, [:ext])
    create index(:toons_thumbs, [:width])
    create index(:toons_thumbs, [:height])

  end
end
