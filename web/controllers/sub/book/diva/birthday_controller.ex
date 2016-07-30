defmodule Exantenna.Sub.Book.Diva.BirthdayController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Diva.BirthdayView
  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  defdelegate month(conn, params), to: Exantenna.Diva.BirthdayController
  defdelegate year(conn, params), to: Exantenna.Diva.BirthdayController
  defdelegate index(conn, params), to: Exantenna.Diva.BirthdayController

end
