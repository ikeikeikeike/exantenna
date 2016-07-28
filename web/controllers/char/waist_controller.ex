defmodule Exantenna.Char.WaistController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    waists = Profile.get :waist, Char.query
    render(conn, "index.html", waists: waists)
  end

end
