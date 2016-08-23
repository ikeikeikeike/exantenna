defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    busts = Profile.get :bust, Profile.args(sub, Diva, Diva.query_all(2))

    render(conn, "index.html", busts: busts, nav: busts)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :bust, Profile.args(sub, Diva, Diva.query)
    busts = Profile.get :bust, Profile.args(sub, Diva, Diva.query_all(2), numeric)

    render(conn, "index.html", busts: busts, nav: nav)
  end

end
