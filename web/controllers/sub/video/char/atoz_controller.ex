defmodule Exantenna.Sub.Video.Char.AtozController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.AtozView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.AtozController
  defdelegate sub(conn, params), to: Exantenna.Char.AtozController

end
