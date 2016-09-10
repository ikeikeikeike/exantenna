defmodule Exantenna.Char.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    letters = Profile.get :atoz, Profile.args(sub, Char, Char.query_all(1))

    render conn, "index.html", letters: letters, nav: letters
  end

  def sub(conn, %{"name" => name} = _params) do
    sub = conn.private[:subdomain]
    nav = Profile.get :atoz, Profile.args(sub, Char, Char.query)
    letters = Profile.get :atoz, Profile.args(sub, Char, Char.query_all(1), name)

    render(conn, "index.html", letters: letters, nav: nav)
  end

end
