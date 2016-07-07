defmodule Exantenna.Repo.Migrations.CreateBlogVerifier do
  use Ecto.Migration

  def change do
    create table(:blog_verifiers) do
      add :blog_id, references(:blogs, on_delete: :nothing)

      add :name, :string
      add :state, :integer # , default: 1

      timestamps
    end
    create index(:blog_verifiers, [:blog_id])

    create index(:blog_verifiers, [:name])
    create index(:blog_verifiers, [:state])

  end
end
