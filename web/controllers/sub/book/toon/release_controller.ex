defmodule Exantenna.Sub.Book.Toon.ReleaseController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Toon.ReleaseView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate month(conn, params), to: Exantenna.Toon.ReleaseController
  defdelegate year(conn, params), to: Exantenna.Toon.ReleaseController
  defdelegate index(conn, params), to: Exantenna.Toon.ReleaseController

end
