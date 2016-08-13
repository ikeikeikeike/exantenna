defmodule Exantenna.Sub.Book.Char.BloodController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.BloodView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.BloodController
  defdelegate sub(conn, params), to: Exantenna.Char.BloodController

end
