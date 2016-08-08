defmodule Exantenna.Toon.AuthorController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.get :author, Toon.query
    render(conn, "index.html", letters: letters, nav: letters)
  end

  def sub(conn, %{"name" => name} = _params) do
    letters = Profile.get :author, Toon.query, name
    render(conn, "index.html", letters: letters, nav: Profile.get(:author, Toon.query))
  end

end
