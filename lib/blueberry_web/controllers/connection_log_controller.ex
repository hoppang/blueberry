defmodule BlueberryWeb.ConnectionLogController do
  use BlueberryWeb, :controller
  import Ecto.Query
  require Logger

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    items =
      from(l in Schema.ConnectionCount)
      |> order_by([l], desc: l.id)
      |> limit(300)
      |> Blueberry.Repo.all()
      |> Enum.map(fn item ->
        %{id: item.id, ip: item.ip, country: item.country, count: item.count}
      end)

    render(conn, :index, layout: {BlueberryWeb.Layouts, :app}, items: items)
  end
end
