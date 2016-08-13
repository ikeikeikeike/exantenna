defmodule Exantenna.Sub.Book.Diva.BustController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.BustView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.BustController
  defdelegate sub(conn, params), to: Exantenna.Diva.BustController

end
