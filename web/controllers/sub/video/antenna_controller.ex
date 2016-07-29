defmodule Exantenna.Sub.Video.AntennaController do
  use Exantenna.Web, :controller

  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}

  def home(conn, _params) do
    render(conn, "home.html", antennas: [])
  end

end
