defmodule Exantenna.Toon.ReleaseController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    sub = conn.private[:subdomain]
    {releases, toons} = Profile.get :release_month, Profile.args(sub, Toon, Toon.query_all(2), params)

    render(conn, "month.html", releases: releases, toons: toons)
  end

  def year(conn, %{"year" => _} = params) do
    sub = conn.private[:subdomain]
    {releases, toons} = Profile.get :release_year, Profile.args(sub, Toon, Toon.query_all(2), params)

    render(conn, "year.html", releases: releases, toons: toons)
  end

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    releases = Profile.get :release, Profile.args(sub, Toon)

    render(conn, "index.html", releases: releases)
  end

end
