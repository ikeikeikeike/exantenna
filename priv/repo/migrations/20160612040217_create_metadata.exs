defmodule Exantenna.Repo.Migrations.CreateMetadata do
  use Ecto.Migration

  def change do
    create table(:metadatas) do
      add :url, :text
      add :title, :text
      add :content, :text
      add :seo_title, :text
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
