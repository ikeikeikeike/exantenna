defmodule Exantenna.Diva.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    heights = Profile.get :height, Profile.args(sub, Diva, Diva.query)

    render(conn, "index.html", heights: heights, nav: heights)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    numeric = List.first String.split(name, "-")

    nav = Profile.get :height, Profile.args(sub, Diva, Diva.query)
    heights = Profile.get :height, Profile.args(sub, Diva, Diva.query, numeric)

    render(conn, "index.html", heights: heights, nav: nav)
  end

end
