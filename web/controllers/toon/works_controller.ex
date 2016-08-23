defmodule Exantenna.Toon.WorksController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    works = Profile.get :works, Profile.args(sub, Toon, Toon.query_all(2))

    render(conn, "index.html", works: works, nav: works)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get :works, Profile.args(sub, Toon)
    works = Profile.get :works, Profile.args(sub, Toon, Toon.query_all(3), name)

    render(conn, "index.html", works: works, nav: nav)
  end

end
