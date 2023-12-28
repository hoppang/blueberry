defmodule Blueberry.Log.Repo.Migrations.ModifyLogConnection do
  use Ecto.Migration

  def change do
    drop table(:log_connection)
  end
end
