defmodule Exantenna.Sub.Book.BlogController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.BlogView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate show(conn, params), to: Exantenna.BlogController
end
