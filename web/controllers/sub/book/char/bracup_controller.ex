defmodule Exantenna.Sub.Book.Char.BracupController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.BracupView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.BracupController
  defdelegate sub(conn, params), to: Exantenna.Char.BracupController

end
