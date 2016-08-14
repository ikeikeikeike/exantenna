defmodule Exantenna.Sub.Video.SummaryController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.SummaryView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.SummaryController

end
