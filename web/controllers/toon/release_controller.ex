defmodule Exantenna.Toon.ReleaseController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    {releases, toons} = Profile.get :release_month, Toon, Toon.query, params
    render(conn, "month.html", releases: releases, toons: toons)
  end

  def year(conn, %{"year" => _} = params) do
    {releases, toons} = Profile.get :release_year, Toon, Toon.query, params
    render(conn, "year.html", releases: releases, toons: toons)
  end

  def index(conn, _params) do
    releases = Profile.get :release, Toon
    render(conn, "index.html", releases: releases)
  end

end
