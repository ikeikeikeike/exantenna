defmodule Exantenna.Diva.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bracups = Profile.with :bracup, Diva.query
    render(conn, "index.html", bracups: bracups, nav: bracups)
  end

  def sub(conn, %{"name" => name} = _params) do
    bracups = Profile.with :bracup, Diva.query, name
    render(conn, "index.html", bracups: bracups, nav: Profile.with(:bracup, Diva.query))
  end


end
