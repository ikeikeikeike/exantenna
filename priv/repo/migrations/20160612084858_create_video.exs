defmodule Exantenna.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :url, :text

      add :title, :text
      add :content, :text
      add :embed_code, :text

      add :duration, :integer

      timestamps
    end
    create unique_index(:videos, [:url])

  end
end
