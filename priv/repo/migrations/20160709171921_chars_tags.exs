defmodule Exantenna.Repo.Migrations.CharsTags do
  use Ecto.Migration

  def change do
    create table(:chars_tags, primary_key: false) do
      add :char_id, references(:chars)
      add :tag_id, references(:tags)
    end
    create index(:chars_tags,  [:tag_id, :char_id], unique: true)
    create index(:chars_tags,  [:char_id, :tag_id], unique: true)
  end
end
