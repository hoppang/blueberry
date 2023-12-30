defmodule BlueberryWeb.ReviewLive.FormComponent do
  use BlueberryWeb, :live_component

  alias Blueberry.Books

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle><%= gettext("Leave score and simple comment.") %></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="review-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label={gettext("Title")} />
        <.input field={@form[:score]} type="number" label={gettext("Score")} min="1" max="5" />
        <.input field={@form[:comment]} type="text" label={gettext("Comment")} />
        <:actions>
          <.button phx-disable-with="Saving..."><%= gettext("저장") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{review: review} = assigns, socket) do
    changeset = Books.change_review(review)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"review" => review_params}, socket) do
    changeset =
      socket.assigns.review
      |> Books.change_review(review_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"review" => review_params}, socket) do
    save_review(socket, socket.assigns.action, review_params)
  end

  defp save_review(socket, :edit, review_params) do
    case Books.update_review(socket.assigns.review, review_params) do
      {:ok, review} ->
        notify_parent({:saved, review})

        {:noreply,
         socket
         |> put_flash(:info, "Review updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_review(socket, :new, review_params) do
    case Books.create_review(review_params) do
      {:ok, review} ->
        notify_parent({:saved, review})

        {:noreply,
         socket
         |> put_flash(:info, "Review created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
