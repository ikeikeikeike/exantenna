defmodule Exantenna.Sub.Book.Diva.BracupController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.BracupView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.Diva.BracupController
  defdelegate sub(conn, params), to: Exantenna.Diva.BracupController

end
