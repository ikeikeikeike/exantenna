defmodule Exantenna.Sub.Video.DivaController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.DivaView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.DivaController
  defdelegate show(conn, params), to: Exantenna.DivaController
  defdelegate suggest(conn, params), to: Exantenna.DivaController

end
