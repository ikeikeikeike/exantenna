defmodule Exantenna.Toon.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.get :atoz, Toon.query_all(2)
    render(conn, "index.html", letters: letters, nav: letters)
  end

  def sub(conn, %{"name" => name} = _params) do
    letters = Profile.get :atoz, Toon.query_all(2), name
    render(conn, "index.html", letters: letters, nav: Profile.get(:atoz, Toon.query))
  end

end
