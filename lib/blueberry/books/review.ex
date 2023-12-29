defmodule Blueberry.Books.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :title, :string
    field :comment, :string
    field :score, :integer

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:title, :score, :comment])
    |> validate_required([:title, :score, :comment])
  end
end
