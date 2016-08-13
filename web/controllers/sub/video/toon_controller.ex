defmodule Exantenna.Sub.Video.ToonController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.ToonView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.ToonController
  defdelegate show(conn, params), to: Exantenna.ToonController
  defdelegate suggest(conn, params), to: Exantenna.ToonController

end
