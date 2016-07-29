defmodule Exantenna.Sub.Book.AntennaController do
  use Exantenna.Web, :controller

  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  def home(conn, _params) do
    render(conn, "home.html", antennas: [])
  end

end
