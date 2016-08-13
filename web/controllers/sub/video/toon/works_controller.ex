defmodule Exantenna.Sub.Video.Toon.WorksController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Toon.WorksView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Toon.WorksController
  defdelegate sub(conn, params), to: Exantenna.Toon.WorksController

end
