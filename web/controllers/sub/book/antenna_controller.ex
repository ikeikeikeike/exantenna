defmodule Exantenna.Sub.Book.AntennaController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.AntennaView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.AntennaController

end
