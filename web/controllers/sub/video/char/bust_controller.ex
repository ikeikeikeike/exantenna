defmodule Exantenna.Sub.Video.Char.BustController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.BustView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.BustController
  defdelegate sub(conn, params), to: Exantenna.Char.BustController

end
