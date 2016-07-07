defmodule Exantenna.Repo.Migrations.CreateCharacter do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :anime_id, references(:animes, on_delete: :nothing)

      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :height, :integer
      add :weight, :integer

      add :bust, :integer
      add :bracup, :string
      add :waist, :integer
      add :hip, :integer

      add :blood, :string
      add :birthday, :date

      timestamps
    end
    create index(:characters, [:anime_id])

    create index(:characters, [:name], unique: true)
    create index(:characters, [:kana])
    create index(:characters, [:gyou])

    create index(:characters, [:bust])
    create index(:characters, [:hip])
    create index(:characters, [:bracup])

    create index(:characters, [:height])
    create index(:characters, [:weight])

    create index(:characters, [:blood])
    create index(:characters, [:birthday])
  end
end
