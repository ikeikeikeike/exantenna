defmodule Exantenna.Sub.Video.AntennaController do
  use Exantenna.Web, :controller

  plug :put_view, Exantenna.AntennaView
  plug :put_layout, {Exantenna.Sub.Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  defdelegate index(conn, params), to: Exantenna.AntennaController

end
