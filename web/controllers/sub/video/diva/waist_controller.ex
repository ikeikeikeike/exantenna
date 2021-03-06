defmodule Exantenna.Sub.Video.Diva.WaistController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.WaistView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.WaistController
  defdelegate sub(conn, params), to: Exantenna.Diva.WaistController

end
