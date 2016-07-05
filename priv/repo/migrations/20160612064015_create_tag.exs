defmodule Exantenna.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :kana, :string
      add :romaji, :string
      add :orig, :string
      add :gyou, :string

      timestamps
    end

    create index(:tags, [:name], unique: true)
    create index(:tags, [:kana])
    create index(:tags, [:gyou])

  end
end
