defmodule Blueberry.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :title, :string
      add :score, :integer
      add :comment, :string

      timestamps()
    end
  end
end
