defmodule Exantenna.Sub.Book.TagController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.TagView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.TagController
  defdelegate show(conn, params), to: Exantenna.TagController
  defdelegate suggest(conn, params), to: Exantenna.TagController

end
