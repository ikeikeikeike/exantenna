defmodule Exantenna.Repo.Migrations.CreateBlogsScores do
  use Ecto.Migration

  def change do
    create table(:blogs_scores) do
      add :assoc_id, :integer
      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:blogs_scores, [:assoc_id])
    create index(:blogs_scores, [:name])
    create index(:blogs_scores, [:count])

  end
end
