defmodule Exantenna.Repo.Migrations.CreateMetadata do
  use Ecto.Migration

  def change do
    create table(:metadatas) do
      add :url, :string
      add :title, :string
      add :content, :text
      add :seo_title, :string
      add :seo_content, :text
      add :creator, :string
      add :publisher, :string
      add :published_at, :datetime

      timestamps
    end

    create index(:metadatas, [:published_at])
    create unique_index(:metadatas, [:url])

  end
end
