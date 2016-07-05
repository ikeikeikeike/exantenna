defmodule Exantenna.Repo.Migrations.CreateAnime do
  use Ecto.Migration

  def change do
    create table(:animes) do
      add :name, :string
      add :alias, :string
      add :kana, :string
      add :romaji, :string
      add :gyou, :string

      add :url, :string

      add :author, :string
      add :works, :string

      add :release_date, :datetime

      add :outline, :text

      timestamps
    end
    create index(:animes, [:name], unique: true)
    create index(:animes, [:gyou])
    create index(:animes, [:release_date])

  end
end
