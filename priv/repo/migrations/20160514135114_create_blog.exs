defmodule Exantenna.Repo.Migrations.CreateBlog do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :string
      add :url, :string
      add :rss, :string

      add :adtype, :string
      add :mediatype, :string

      add :penalty, :string
      add :last_modified, :datetime

      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create index(:blogs, [:url], unique: true)

    create index(:blogs, [:adtype])
    create index(:blogs, [:mediatype])
    create index(:blogs, [:penalty])
    create index(:blogs, [:last_modified])

  end
end
