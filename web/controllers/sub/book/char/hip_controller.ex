defmodule Exantenna.Sub.Book.Char.HipController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.HipView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.Char.HipController
  defdelegate sub(conn, params), to: Exantenna.Char.HipController

end
