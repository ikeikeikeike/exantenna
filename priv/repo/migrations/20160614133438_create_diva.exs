defmodule Exantenna.Repo.Migrations.CreateDiva do
  use Ecto.Migration

  def change do
    create table(:divas) do
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

      add :outline, :text

      timestamps
    end
    create unique_index(:divas, [:name, :alias], name: :divas_name_alias_index)

    create index(:divas, [:name])
    create index(:divas, [:kana])
    create index(:divas, [:gyou])

    create index(:divas, [:bust])
    create index(:divas, [:hip])
    create index(:divas, [:bracup])

    create index(:divas, [:height])
    create index(:divas, [:weight])

    create index(:divas, [:blood])
    create index(:divas, [:birthday])

  end
end
