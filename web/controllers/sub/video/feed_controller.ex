defmodule Exantenna.Sub.Video.FeedController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.FeedView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate xml(conn, params), to: Exantenna.FeedController

end
