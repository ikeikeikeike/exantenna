defmodule Exantenna.Repo.Migrations.ToonsChars do
  use Ecto.Migration

  def change do
    create table(:toons_chars, primary_key: false) do
      add :toon_id, references(:toons)
      add :char_id, references(:chars)
    end
    create index(:toons_chars,  [:toon_id, :char_id], unique: true)
    create index(:toons_chars,  [:char_id, :toon_id], unique: true)
  end
end
