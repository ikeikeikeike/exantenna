defmodule Exantenna.FeedController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Antenna

  def xml(conn, params) do
    antennas =
      Antenna.essearch(nil, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("rdf.xml", antennas: antennas.entries)
  end

end
