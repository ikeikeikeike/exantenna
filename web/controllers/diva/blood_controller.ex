defmodule Exantenna.Diva.BloodController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    bloods = Profile.get :blood, Profile.args(sub, Diva, Diva.query_all(2))

    render(conn, "index.html", bloods: bloods, nav: bloods)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get(:blood, Profile.args(sub, Diva, Diva.query))
    bloods = Profile.get :blood, Profile.args(sub, Diva, Diva.query_all(2), name)

    render(conn, "index.html", bloods: bloods, nav: nav)
  end

end
