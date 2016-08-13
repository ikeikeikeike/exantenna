defmodule Exantenna.Sub.Video.Toon.ReleaseController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Toon.ReleaseView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate month(conn, params), to: Exantenna.Toon.ReleaseController
  defdelegate year(conn, params), to: Exantenna.Toon.ReleaseController
  defdelegate index(conn, params), to: Exantenna.Toon.ReleaseController

end
