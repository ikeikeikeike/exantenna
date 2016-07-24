defmodule Exantenna.Diva.BirthdayController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def month(conn, %{"year" => _, "month" => _} = params) do
    {birthdays, divas} = Profile.with :month, Diva, Diva.query, params
    render(conn, "month.html", birthdays: birthdays, divas: divas)
  end

  def year(conn, %{"year" => _} = params) do
    {birthdays, divas} = Profile.with :year, Diva, Diva.query, params
    render(conn, "year.html", birthdays: birthdays, divas: divas)
  end

  def index(conn, _params) do
    birthdays = Profile.with :birthday, Diva
    render(conn, "index.html", birthdays: birthdays)
  end

end
