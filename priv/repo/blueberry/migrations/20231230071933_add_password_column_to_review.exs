defmodule Blueberry.Repo.Migrations.AddPasswordColumnToReview do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      add :password, :string
    end
  end
end
