defmodule Exantenna.Sub.Book.Diva.HipController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.HipView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.Diva.HipController
  defdelegate sub(conn, params), to: Exantenna.Diva.HipController

end
