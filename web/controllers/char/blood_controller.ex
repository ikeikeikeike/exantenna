defmodule Exantenna.Char.BloodController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bloods = Profile.get(:blood, Char.query)
    render(conn, "index.html", bloods: bloods)
  end

end
