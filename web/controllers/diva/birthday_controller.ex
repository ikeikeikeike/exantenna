defmodule Exantenna.Diva.BirthdayController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    sub = conn.private[:subdomain]
    {birthdays, divas} = Profile.get :month, Profile.args(sub, Diva, Diva.query, params)

    render(conn, "month.html", birthdays: birthdays, divas: divas)
  end

  def year(conn, %{"year" => _} = params) do
    sub = conn.private[:subdomain]
    {birthdays, divas} = Profile.get :year, Profile.args(sub, Diva, Diva.query, params)

    render(conn, "year.html", birthdays: birthdays, divas: divas)
  end

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    birthdays = Profile.get :birthday, Profile.args(sub, Diva)

    render(conn, "index.html", birthdays: birthdays)
  end

end
