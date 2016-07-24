defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    busts = Profile.with :bust, Diva.query
    render(conn, "index.html", busts: busts)
  end

end
