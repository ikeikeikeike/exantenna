defmodule Exantenna.Sub.Video.CharController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.CharView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.CharController
  defdelegate show(conn, params), to: Exantenna.CharController
  defdelegate suggest(conn, params), to: Exantenna.CharController

end
