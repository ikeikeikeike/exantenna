defmodule Exantenna.Repo.Migrations.CreateBlogsThumbs do
  use Ecto.Migration

  def change do
    create table(:blogs_thumbs) do
      add :assoc_id, :integer

      add :name, :string
      add :src, :text
      add :ext, :string
      add :mime, :string
      add :width, :integer
      add :height, :integer

      timestamps
    end
    create index(:blogs_thumbs, [:assoc_id])

    create index(:blogs_thumbs, [:src])
    create index(:blogs_thumbs, [:ext])
    create index(:blogs_thumbs, [:width])
    create index(:blogs_thumbs, [:height])

  end
end
