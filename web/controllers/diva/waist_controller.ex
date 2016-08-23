defmodule Exantenna.Diva.WaistController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    waists = Profile.get :waist, Profile.args(sub, Diva, Diva.query_all(2))

    render(conn, "index.html", waists: waists, nav: waists)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :waist, Profile.args(sub, Diva, Diva.query)
    waists = Profile.get :waist, Profile.args(sub, Diva, Diva.query_all(2), numeric)

    render(conn, "index.html", waists: waists, nav: nav)
  end

end
