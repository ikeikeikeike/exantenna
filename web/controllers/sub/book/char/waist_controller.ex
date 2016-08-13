defmodule Exantenna.Sub.Book.Char.WaistController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.WaistView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Char.WaistController
  defdelegate sub(conn, params), to: Exantenna.Char.WaistController

end
