defmodule Exantenna.Diva.WaistController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    waists = Profile.get :waist, Diva.query
    render(conn, "index.html", waists: waists)
  end

end
