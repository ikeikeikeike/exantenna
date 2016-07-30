defmodule Exantenna.Sub.Book.Char.AtozController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.AtozView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.Char.AtozController
  defdelegate sub(conn, params), to: Exantenna.Char.AtozController

end
