defmodule Exantenna.Char.BirthdayController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    {birthdays, divas} = Profile.get :month, Char, Char.query, params
    render(conn, "month.html", birthdays: birthdays, divas: divas)
  end

  def year(conn, %{"year" => _} = params) do
    {birthdays, divas} = Profile.get :year, Char, Char.query, params
    render(conn, "year.html", birthdays: birthdays, divas: divas)
  end

  def index(conn, _params) do
    birthdays = Profile.get :birthday, Char
    render(conn, "index.html", birthdays: birthdays)
  end

end
