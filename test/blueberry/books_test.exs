defmodule Blueberry.BooksTest do
  use Blueberry.DataCase

  alias Blueberry.Books

  describe "reviews" do
    alias Blueberry.Books.Review

    import Blueberry.BooksFixtures

    @invalid_attrs %{title: nil, comment: nil, score: nil}

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Books.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Books.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      valid_attrs = %{title: "some title", comment: "some comment", score: 42}

      assert {:ok, %Review{} = review} = Books.create_review(valid_attrs)
      assert review.title == "some title"
      assert review.comment == "some comment"
      assert review.score == 42
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      update_attrs = %{title: "some updated title", comment: "some updated comment", score: 43}

      assert {:ok, %Review{} = review} = Books.update_review(review, update_attrs)
      assert review.title == "some updated title"
      assert review.comment == "some updated comment"
      assert review.score == 43
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_review(review, @invalid_attrs)
      assert review == Books.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Books.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Books.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Books.change_review(review)
    end
  end
end
