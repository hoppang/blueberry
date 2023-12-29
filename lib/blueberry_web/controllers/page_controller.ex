defmodule BlueberryWeb.PageController do
  use BlueberryWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: {BlueberryWeb.Layouts, :app})
  end
end
