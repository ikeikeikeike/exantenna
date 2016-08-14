defmodule Exantenna.Diva.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    bracups = Profile.get :bracup, Profile.args(sub, Diva, Diva.query)

    render(conn, "index.html", bracups: bracups, nav: bracups)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get :bracup, Profile.args(sub, Diva, Diva.query)
    bracups = Profile.get :bracup, Profile.args(sub, Diva, Diva.query, name)

    render(conn, "index.html", bracups: bracups, nav: nav)
  end

end
