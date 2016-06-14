defmodule Exantenna.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos) do
      timestamps
    end

  end
end
