defmodule BlueberryWeb.ReviewLive.Show do
  use BlueberryWeb, :live_view

  alias Blueberry.Books

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:review, Books.get_review!(id))}
  end

  defp page_title(:show), do: "Show Review"
  defp page_title(:edit), do: "Edit Review"
end
