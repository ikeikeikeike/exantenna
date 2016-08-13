defmodule Exantenna.Sub.Video.Char.HipController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.HipView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.HipController
  defdelegate sub(conn, params), to: Exantenna.Char.HipController

end
