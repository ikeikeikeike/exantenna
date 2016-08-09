defmodule Exantenna.Toon.WorksController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    works = Profile.get :works, Toon, Toon.query_all(3)
    render(conn, "index.html", works: works, nav: works)
  end

  def sub(conn, %{"name" => name} = _params) do
    works = Profile.get :works, Toon, Toon.query_all(3), name
    render(conn, "index.html", works: works, nav: Profile.get(:works, Toon, Toon))
  end

end
