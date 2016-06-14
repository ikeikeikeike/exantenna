defmodule Exantenna.Repo.Migrations.SitesThumbs do
  use Ecto.Migration

  def change do
    create table(:sites_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:sites_thumbs, [:assoc_id])

    create index(:sites_thumbs, [:src])
    create index(:sites_thumbs, [:ext])
    create index(:sites_thumbs, [:width])
    create index(:sites_thumbs, [:height])

  end
end
