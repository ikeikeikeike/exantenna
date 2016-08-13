defmodule Exantenna.Repo.Migrations.CreateDivasThumbs do
  use Ecto.Migration

  def change do
    create table(:divas_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:divas_thumbs, [:assoc_id])

    create index(:divas_thumbs, [:src])
    create index(:divas_thumbs, [:ext])
    create index(:divas_thumbs, [:width])
    create index(:divas_thumbs, [:height])

  end
end
