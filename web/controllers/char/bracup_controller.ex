defmodule Exantenna.Char.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    bracups = Profile.get :bracup, Profile.args(sub, Char, Char.query_all(1))

    render(conn, "index.html", bracups: bracups, nav: bracups)
  end

  def cup(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get :bracup, Profile.args(sub, Char, Char.query)
    bracups = Profile.get :bracup, Profile.args(sub, Char, Char.query_all(1), name)

    render(conn, "index.html", bracups: bracups, nav: nav)
  end


end
