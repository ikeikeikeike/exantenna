defmodule Exantenna.Sub.Video.Char.HeightController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.HeightView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.HeightController
  defdelegate sub(conn, params), to: Exantenna.Char.HeightController

end
