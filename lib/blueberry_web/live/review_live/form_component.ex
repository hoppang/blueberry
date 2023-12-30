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
        <.input field={@form[:password]} type="password" label={gettext("비밀번호")} value="" />
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

  @spec save_review(Phoenix.LiveView.Socket.t(), :new | :edit, Blueberry.Books.Review.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  defp save_review(socket, :edit, review_params) do
    review = socket.assigns.review
    id = review.id

    case Books.find_review(id, Map.get(review_params, "password", "")) do
      :ok ->
        case Books.update_review(review, review_params) do
          {:ok, review} ->
            notify_parent({:saved, review})

            {:noreply,
             socket
             |> put_flash(:info, gettext("서평을 수정했습니다."))
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end

      {:error, :review_not_exists} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("서평이 없습니다."))
         |> push_patch(to: socket.assigns.patch)}

      {:error, :password_not_match} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("비밀번호가 틀립니다."))
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp save_review(socket, :new, review_params) do
    case Books.create_review(review_params) do
      {:ok, review} ->
        notify_parent({:saved, review})

        {:noreply,
         socket
         |> put_flash(:info, gettext("서평을 기록했습니다."))
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
