defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    busts = Profile.get :bust, Profile.args(sub, Diva, Diva.query)

    render(conn, "index.html", busts: busts, nav: busts)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :bust, Profile.args(sub, Diva, Diva.query)
    busts = Profile.get :bust, Profile.args(sub, Diva, Diva.query, numeric)

    render(conn, "index.html", busts: busts, nav: Profile.get(:bust, Diva, Diva.query))
  end

end
