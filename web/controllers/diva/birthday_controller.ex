defmodule Exantenna.Diva.BirthdayController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def month(conn, %{"year" => year, "month" => month}) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    next_month =
      Timex.Date.from({year, month, 01})
      |> Timex.Date.shift(months: 1)

    birthdays =
      Model
      |> select([p], p.birthday)
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday  < ^next_month)
      |> where([q], q.birthday >= ^Timex.Date.from({year, month , 01}))
      |> order_by([q], [asc: q.birthday])
      |> Exantenna.Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.day
      end)

   divas =
      Model
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday  < ^next_month)
      |> where([q], q.birthday >= ^Timex.Date.from({year, month , 01}))
      |> Exantenna.Repo.all

    render(conn, "month.html", birthdays: birthdays, divas: divas)
  end

  def year(conn, %{"year" => year}) do
    birthdays =
      Model
      |> select([p], p.birthday)
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> order_by([q], [asc: q.birthday])
      |> Exantenna.Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.month
      end)

   divas =
      Model
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> Exantenna.Repo.all

    render(conn, "year.html", birthdays: birthdays, divas: divas)
  end

  def index(conn, _params) do
    birthdays =
      Model
      |> group_by([p], p.birthday)
      |> select([p], p.birthday)
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> order_by([q], [desc: q.birthday])
      |> Exantenna.Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.year
      end)

    render(conn, "index.html", birthdays: birthdays)
  end

end
