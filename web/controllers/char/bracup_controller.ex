defmodule Exantenna.Char.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bracups = Profile.get :bracup, Char.query
    render(conn, "index.html", bracups: bracups)
  end

  def cup(conn, %{"name" => name} = _params) do
    bracups = Profile.get :bracup, Char.query, name
    render(conn, "index.html", bracups: bracups, nav: Profile.get(:bracup, Char.query))
  end


end
