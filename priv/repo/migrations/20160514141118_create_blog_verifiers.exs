defmodule Exantenna.Repo.Migrations.CreateBlogVerifier do
  use Ecto.Migration

  def change do
    create table(:blog_verifiers) do
      add :name, :string
      add :state, :integer

      add :blog_id, references(:blogs, on_delete: :nothing)

      timestamps
    end

    create index(:blog_verifiers, [:name])
    create index(:blog_verifiers, [:state])

    create index(:blog_verifiers, [:blog_id])

  end
end
