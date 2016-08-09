defmodule Exantenna.Toon.AuthorController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    authors = Profile.get :author, Toon, Toon.query_all(3)
    render(conn, "index.html", authors: authors, nav: authors)
  end

  def sub(conn, %{"name" => name} = _params) do
    authors = Profile.get :author, Toon, Toon.query_all(3), name
    render(conn, "index.html", authors: authors, nav: Profile.get(:author, Toon, Toon))
  end

end
