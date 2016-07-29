defmodule Exantenna.Sub.Book.ToonController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.ToonView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.ToonController
  defdelegate show(conn, params), to: Exantenna.ToonController
  defdelegate suggest(conn, params), to: Exantenna.ToonController

end
