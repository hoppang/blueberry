defmodule Blueberry.Log.Repo.Migrations.CreateConnectionLog do
  use Ecto.Migration

  def change do
    create table(:log_connection) do
      add(:ip, :string)
      add(:country, :string)
    end

    create index(:log_connection, [:ip])
  end
end
