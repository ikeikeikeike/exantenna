defmodule Exantenna.Repo.Migrations.CharactersThumbs do
  use Ecto.Migration

  def change do
    create table(:characters_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:characters_thumbs, [:assoc_id])

    create index(:characters_thumbs, [:src])
    create index(:characters_thumbs, [:ext])
    create index(:characters_thumbs, [:width])
    create index(:characters_thumbs, [:height])

  end
end
