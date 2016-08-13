defmodule Exantenna.Sub.Video.Diva.BracupController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.BracupView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.BracupController
  defdelegate sub(conn, params), to: Exantenna.Diva.BracupController

end
