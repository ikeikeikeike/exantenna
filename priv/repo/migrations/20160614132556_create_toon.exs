defmodule Exantenna.Repo.Migrations.CreateToon do
  use Ecto.Migration

  def change do
    create table(:toons) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :url, :string

      add :author, :string
      add :works, :string

      add :release_date, :date

      add :outline, :text

      timestamps
    end
    create unique_index(:toons, [:name, :alias], name: :toons_name_alias_index)

    create index(:toons, [:name])
    create index(:toons, [:gyou])
    create index(:toons, [:release_date])

  end
end
