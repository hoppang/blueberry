defmodule Blueberry.Books.Review do
  @moduledoc """
  서평 정보 DB 테이블 모듈
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %Blueberry.Books.Review{}

  schema "reviews" do
    field(:title, :string)
    field(:comment, :string)
    field(:score, :integer)
    field(:password, :string)

    timestamps()
  end

  @allowed [:title, :score, :comment, :password]

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, @allowed)
    |> validate_required(@allowed)
  end
end
