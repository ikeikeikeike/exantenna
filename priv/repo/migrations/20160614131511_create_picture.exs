defmodule Exantenna.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  def change do
    create table(:pictures) do

      timestamps
    end

  end
end
