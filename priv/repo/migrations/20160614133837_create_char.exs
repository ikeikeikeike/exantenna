defmodule Exantenna.Repo.Migrations.CreateChar do
  use Ecto.Migration

  def change do
    create table(:chars) do
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
    create unique_index(:chars, [:name, :alias], name: :chars_name_alias_index)

    create index(:chars, [:name])
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
