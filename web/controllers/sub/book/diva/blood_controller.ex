defmodule Exantenna.Sub.Book.Diva.BloodController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.BloodView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Diva.BloodController
  defdelegate sub(conn, params), to: Exantenna.Diva.BloodController

end
