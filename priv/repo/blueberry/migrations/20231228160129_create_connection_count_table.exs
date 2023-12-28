defmodule Blueberry.Repo.Migrations.CreateConnectionCountTable do
  use Ecto.Migration

  def change do
    create table(:connection_count) do
      add(:ip, :string)
      add(:country, :string)
      add(:count, :integer)
    end

    create unique_index(:connection_count, [:ip])
  end
end
