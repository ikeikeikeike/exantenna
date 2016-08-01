defmodule Exantenna.FeedController do
  use Exantenna.Web, :controller
  alias Exantenna.Antenna

  def xml(conn, _params) do
    antennas =
      Antenna.query_all
      |> Repo.all

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("rdf.xml", antennas: antennas)
  end

end
