defmodule Exantenna.Repo.Migrations.ToonsTags do
  use Ecto.Migration

  def change do
    create table(:toons_tags, primary_key: false) do
      add :toon_id, references(:toons)
      add :tag_id, references(:tags)
    end
    create index(:toons_tags,  [:tag_id, :toon_id], unique: true)
    create index(:toons_tags,  [:toon_id, :tag_id], unique: true)
  end
end
