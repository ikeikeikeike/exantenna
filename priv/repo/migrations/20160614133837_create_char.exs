defmodule Exantenna.Repo.Migrations.CreateChar do
  use Ecto.Migration

  def change do
    create table(:chars) do
      add :toon_id, references(:toons, on_delete: :nothing)

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
    create index(:chars, [:toon_id])

    create index(:chars, [:name], unique: true)
    create index(:chars, [:kana])
    create index(:chars, [:gyou])

    create index(:chars, [:bust])
    create index(:chars, [:hip])
    create index(:chars, [:bracup])

    create index(:chars, [:height])
    create index(:chars, [:weight])

    create index(:chars, [:blood])
    create index(:chars, [:birthday])
  end
end
