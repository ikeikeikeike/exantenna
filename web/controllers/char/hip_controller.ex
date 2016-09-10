defmodule Exantenna.Char.HipController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    hips = Profile.get :hip, Profile.args(sub, Char, Char.query_all(2))

    render(conn, "index.html", hips: hips, nav: hips)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :hip, Profile.args(sub, Char, Char.query)
    hips = Profile.get :hip, Profile.args(sub, Char, Char.query_all(2), numeric)

    render(conn, "index.html", hips: hips, nav: nav)
  end

end
