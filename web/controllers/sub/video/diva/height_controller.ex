defmodule Exantenna.Sub.Video.Diva.HeightController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.HeightView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.HeightController
  defdelegate sub(conn, params), to: Exantenna.Diva.HeightController

end
