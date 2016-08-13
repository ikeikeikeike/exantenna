defmodule Exantenna.Sub.Book.Toon.AtozController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Toon.AtozView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Toon.AtozController
  defdelegate sub(conn, params), to: Exantenna.Toon.AtozController

end
