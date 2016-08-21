defmodule Exantenna.Repo.Migrations.CreateBlogsScores do
  use Ecto.Migration

  def change do
    create table(:blogs_scores, primary_key: false) do
      add :assoc_id, :integer, primary_key: true
      add :name, :string, primary_key: true

      add :count, :integer

      timestamps
    end
    create index(:blogs_scores, [:assoc_id, :name, :count])
    create index(:blogs_scores, [:assoc_id, :count])

  end
end
