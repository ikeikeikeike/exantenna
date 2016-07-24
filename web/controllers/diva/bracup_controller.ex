defmodule Exantenna.Diva.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bracups = Profile.with :bracup, Diva.query
    render(conn, "index.html", bracups: bracups)
  end

end
