defmodule Exantenna.Sub.Book.Char.BustController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.BustView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.Char.BustController
  defdelegate sub(conn, params), to: Exantenna.Char.BustController

end
