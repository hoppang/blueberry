defmodule Blueberry.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blueberry.Books` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(attrs \\ %{}) do
    {:ok, review} =
      attrs
      |> Enum.into(%{
        title: "some title",
        comment: "some comment",
        score: 42
      })
      |> Blueberry.Books.create_review()

    review
  end
end
