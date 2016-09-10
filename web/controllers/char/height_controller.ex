defmodule Exantenna.Char.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    heights = Profile.get :height, Profile.args(sub, Char, Char.query_all(2))

    render(conn, "index.html", heights: heights, nav: heights)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :height, Profile.args(sub, Char, Char.query)
    heights = Profile.get :height, Profile.args(sub, Char, Char.query_all(2), numeric)

    render(conn, "index.html", heights: heights, nav: nav)
  end

end
