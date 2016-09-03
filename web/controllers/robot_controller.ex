defmodule Exantenna.RobotController do
  use Exantenna.Web, :controller

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    host = Plug.Conn.get_req_header(conn, "host") |> List.first

    text conn, """
    Sitemap: http://#{host}/#{sub || "default"}.sitemap.xml.gz
    """
  end

end
