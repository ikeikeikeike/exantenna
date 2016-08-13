defmodule Exantenna.Sub.Book.Char.BirthdayController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Char.BirthdayView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate month(conn, params), to: Exantenna.Char.BirthdayController
  defdelegate year(conn, params), to: Exantenna.Char.BirthdayController
  defdelegate index(conn, params), to: Exantenna.Char.BirthdayController

end
