defmodule BlueberryWeb.ReviewLive.Index do
  use BlueberryWeb, :live_view

  alias Blueberry.Books
  alias Blueberry.Books.Review

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :reviews, Books.list_reviews())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Review")
    |> assign(:review, Books.get_review!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Review")
    |> assign(:review, %Review{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reviews")
    |> assign(:review, nil)
  end

  @impl true
  def handle_info({BlueberryWeb.ReviewLive.FormComponent, {:saved, review}}, socket) do
    {:noreply, stream_insert(socket, :reviews, review)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Books.get_review!(id)
    {:ok, _} = Books.delete_review(review)

    {:noreply, stream_delete(socket, :reviews, review)}
  end
end
