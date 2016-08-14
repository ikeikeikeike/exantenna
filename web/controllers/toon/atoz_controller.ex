defmodule Exantenna.Toon.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    letters = Profile.get :atoz, Profile.args(sub, Toon, Toon.query_all(2))

    render(conn, "index.html", letters: letters, nav: letters)
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get :atoz, Profile.args(sub, Toon, Toon.query)
    letters = Profile.get :atoz, Profile.args(sub, Toon, Toon.query_all(2), name)

    render(conn, "index.html", letters: letters, nav: nav)
  end

end
