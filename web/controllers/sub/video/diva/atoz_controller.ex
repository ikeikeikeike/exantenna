defmodule Exantenna.Sub.Video.Diva.AtozController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.AtozView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.AtozController
  defdelegate sub(conn, params), to: Exantenna.Diva.AtozController

end
