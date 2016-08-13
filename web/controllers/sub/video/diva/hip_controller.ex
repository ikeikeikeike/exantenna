defmodule Exantenna.Sub.Video.Diva.HipController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.HipView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.HipController
  defdelegate sub(conn, params), to: Exantenna.Diva.HipController

end
