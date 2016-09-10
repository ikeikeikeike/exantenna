defmodule Exantenna.Char.BirthdayController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    sub = conn.private[:subdomain]
    {birthdays, chars} = Profile.get :month, Profile.args(sub, Char, Char.query_all(1), params)

    render(conn, "month.html", birthdays: birthdays, chars: chars)
  end

  def year(conn, %{"year" => _} = params) do
    sub = conn.private[:subdomain]
    {birthdays, chars} = Profile.get :year, Profile.args(sub, Char, Char.query_all(1), params)

    render(conn, "year.html", birthdays: birthdays, chars: chars)
  end

  def index(conn, _params) do
    sub = conn.private[:subdomain]
    birthdays = Profile.get :birthday, Profile.args(sub, Char)

    render(conn, "index.html", birthdays: birthdays)
  end

end
