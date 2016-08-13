defmodule Exantenna.Repo.Migrations.AlterIntToBigint do
  use Ecto.Migration
  def up do
    execute "ALTER TABLE tags_scores     ALTER COLUMN id TYPE BIGINT;"
    execute "ALTER TABLE divas_scores    ALTER COLUMN id TYPE BIGINT;"
    execute "ALTER TABLE toons_scores    ALTER COLUMN id TYPE BIGINT;"
    execute "ALTER TABLE chars_scores    ALTER COLUMN id TYPE BIGINT;"
    execute "ALTER TABLE blogs_scores    ALTER COLUMN id TYPE BIGINT;"
    execute "ALTER TABLE antennas_scores ALTER COLUMN id TYPE BIGINT;"
  end

  def down do
    execute "ALTER TABLE tags_scores     ALTER COLUMN id TYPE INTEGER;"
    execute "ALTER TABLE divas_scores    ALTER COLUMN id TYPE INTEGER;"
    execute "ALTER TABLE toons_scores    ALTER COLUMN id TYPE INTEGER;"
    execute "ALTER TABLE chars_scores    ALTER COLUMN id TYPE INTEGER;"
    execute "ALTER TABLE blogs_scores    ALTER COLUMN id TYPE INTEGER;"
    execute "ALTER TABLE antennas_scores ALTER COLUMN id TYPE INTEGER;"
  end

end
