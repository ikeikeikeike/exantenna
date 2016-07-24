defmodule Exantenna.Diva.BloodController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bloods = Profile.with(:blood, Diva.query)
    render(conn, "index.html", bloods: bloods)
  end

end
