defmodule Exantenna.Sub.Video.EntryController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.EntryView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}

  defdelegate index(conn, params), to: Exantenna.EntryController
  defdelegate show(conn, params), to: Exantenna.EntryController

end
