defmodule BlueberryWeb.ReviewLiveTest do
  use BlueberryWeb.ConnCase

  import Phoenix.LiveViewTest
  import Blueberry.BooksFixtures

  @create_attrs %{title: "some title", comment: "some comment", score: 42, password: "1234"}
  @update_attrs %{
    title: "some updated title",
    comment: "some updated comment",
    score: 43,
    password: "1234"
  }
  @invalid_attrs %{title: nil, comment: nil, score: nil}

  defp create_review(_) do
    review = review_fixture()
    %{review: review}
  end

  describe "Index" do
    setup [:create_review]

    test "lists all reviews", %{conn: conn, review: review} do
      {:ok, _index_live, html} = live(conn, ~p"/reviews")

      assert html =~ "Listing Reviews"
      assert html =~ review.title
    end

    test "saves new review", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("a", "서평쓰기") |> render_click() =~
               "서평쓰기"

      assert_patch(index_live, ~p"/reviews/new")

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#review-form", review: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "서평을 기록했습니다."
      assert html =~ "some title"
    end

    test "updates review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{review.id} a", "편집") |> render_click() =~
               "Edit Review"

      assert_patch(index_live, ~p"/reviews/#{review}/edit")

      assert index_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#review-form", review: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/reviews")

      html = render(index_live)
      assert html =~ "서평을 수정했습니다."
      assert html =~ "some updated title"
    end

    test "deletes review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{review.id} a", "삭제") |> render_click()
      refute has_element?(index_live, "#reviews-#{review.id}")
    end
  end

  describe "Show" do
    setup [:create_review]

    test "displays review", %{conn: conn, review: review} do
      {:ok, _show_live, html} = live(conn, ~p"/reviews/#{review}")

      assert html =~ "Show Review"
      assert html =~ review.title
    end

    test "updates review within modal", %{conn: conn, review: review} do
      {:ok, show_live, _html} = live(conn, ~p"/reviews/#{review}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Review"

      assert_patch(show_live, ~p"/reviews/#{review}/show/edit")

      assert show_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#review-form", review: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/reviews/#{review}")

      html = render(show_live)
      assert html =~ "서평을 수정했습니다."
      assert html =~ "some updated title"
    end
  end
end
