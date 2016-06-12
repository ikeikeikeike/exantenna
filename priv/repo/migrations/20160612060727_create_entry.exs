defmodule Exantenna.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do

      timestamps
    end

  end
end
