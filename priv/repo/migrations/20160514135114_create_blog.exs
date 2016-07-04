defmodule Exantenna.Repo.Migrations.CreateBlog do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :string
      add :explain, :text

      add :url, :string
      add :rss, :string

      add :mediatype, :string
      add :contenttype, :string

      add :last_modified, :datetime

      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create unique_index(:blogs, [:rss])
    create index(:blogs, [:mediatype])
    create index(:blogs, [:contenttype])
    create index(:blogs, [:last_modified])

  end
end
