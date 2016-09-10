defmodule Exantenna.Char.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    busts = Profile.get :bust, Profile.args(sub, Char, Char.query_all(1))

    render(conn, "index.html", busts: busts, nav: busts)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :bust, Profile.args(sub, Char, Char.query)
    busts = Profile.get :bust, Profile.args(sub, Char, Char.query_all(1), numeric)

    render(conn, "index.html", busts: busts, nav: nav)
  end

end
