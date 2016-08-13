defmodule Exantenna.Sub.Video.Toon.AuthorController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.Toon.AuthorView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.Toon.AuthorController
  defdelegate sub(conn, params), to: Exantenna.Toon.AuthorController

end
