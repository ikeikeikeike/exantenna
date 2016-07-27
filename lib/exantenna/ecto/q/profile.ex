defmodule Exantenna.Ecto.Q.Profile do
  import Ecto.Query
  alias Exantenna.Repo
  alias Exantenna.Ecto.Q.Profile

  @limited 99 * 99 * 99 * 99 * 10

  @kunrei_romaji ~w{
    a i u e o
    ka ki ku ke ko
    sa si su se so
    ta ti tu te to
    na ni nu ne no
    ha hi hu he ho
    ma mi mu me mo
    ya    yu    yo
    ra ri ru re ro
    wa
  }

  def with(:atoz, query) do
    Enum.map(@kunrei_romaji, fn letter ->
      models =
        query  # TODO: query_all or query
        |> where([q], q.gyou == ^letter)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.gyou))
        |> Repo.all

      {letter, models}
    end)
  end

  def with(:blood, query) do
    ["A", "B", "O", "AB"]
    |> Enum.map(fn blood ->
      divas =
        query
        |> where([q], q.blood == ^blood)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.blood))
        |> Repo.all
      {blood, divas}
    end)
  end

  def with(:bracup, query) do
    cups = Enum.map(?A..?Z, &IO.iodata_to_binary([&1]))
    Profile.with :bracup, query, cups, 10
  end

  def with(:bracup, query, cup), do: Profile.with :bracup, query, cup, @limited
  def with(:bracup, query, cup,  limited) when is_bitstring(cup), do: Profile.with :bracup, query, [cup], limited
  def with(:bracup, query, cups, limited) do
    Enum.map(cups, fn bracup ->
      divas =
        query
        |> where([q], q.bracup == ^bracup)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.bracup))
        |> order_by([q], [asc: q.bust])
        |> limit(^limited)
        |> Repo.all
      {bracup, divas}
    end)
  end

  def with(:height, query) do
    [130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190]
    |> Enum.map(fn height ->
      divas =
        query
        |> where([q], q.height >= ^height)
        |> where([q], q.height < ^(height + 5))
        |> where([q], q.height > 130)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.height))
        |> order_by([q], [asc: q.height])
        |> Repo.all
      {height, divas}
    end)
  end

  def with(:waist, query) do
    [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
    |> Enum.map(fn waist ->
      divas =
        query
        |> where([q], q.waist >= ^waist)
        |> where([q], q.waist < ^(waist + 5))
        |> where([q], q.waist > 40)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.waist))
        |> order_by([q], [asc: q.waist])
        |> Repo.all
      {waist, divas}
    end)
  end

  def with(:hip, query) do
    [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120]
    |> Enum.map(fn hip ->
      divas =
        query
        |> where([q], q.hip >= ^hip)
        |> where([q], q.hip < ^(hip + 5))
        |> where([q], q.hip > 50)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.hip))
        |> order_by([q], [asc: q.hip])
        |> Repo.all
      {hip, divas}
    end)
  end

  def with(:bust, query) do
    range = [
      60, 65, 70, 75, 80, 85, 90, 95, 100,
      105, 110, 115, 120, 125, 130, 135
    ]

    Profile.with(:bust, query, range, 10)
  end

  def with(:bust, query, numeric), do: Profile.with :bust, query, numeric, @limited
  def with(:bust, query, numeric, limited) when is_integer(numeric), do: Profile.with :bust, query, [numeric], limited
  def with(:bust, query, numeric, limited) when is_bitstring(numeric) do
    {n, _} = Integer.parse numeric
    Profile.with :bust, query, [n], limited
  end
  def with(:bust, query, range, limited) when is_list(range) do
    Enum.map(range, fn bust ->
      divas =
        query
        |> where([q], q.bust >= ^bust)
        |> where([q], q.bust < ^(bust + 5))
        |> where([q], q.bust > 60)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.bust))
        |> order_by([q], [asc: q.bust])
        |> limit(^limited)
        |> Repo.all
      {bust, divas}
    end)
  end

  def with(:month, mod, query, %{"year" => year, "month" => month}) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    next_month =
      Timex.Date.from({year, month, 01})
      |> Timex.Date.shift(months: 1)

    birthdays =
      mod
      |> select([p], p.birthday)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday  < ^next_month)
      |> where([q], q.birthday >= ^Timex.Date.from({year, month , 01}))
      |> order_by([q], [asc: q.birthday])
      |> Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.day
      end)

    divas =
      query
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday  < ^next_month)
      |> where([q], q.birthday >= ^Timex.Date.from({year, month , 01}))
      |> Repo.all

    {birthdays, divas}
  end

  def with(:year, mod, query, %{"year" => year}) do
    birthdays =
      mod
      |> select([p], p.birthday)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> order_by([q], [asc: q.birthday])
      |> Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.month
      end)

   divas =
      query
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> Repo.all

    {birthdays, divas}
  end

  def with(:birthday, mod) do
    mod
    |> group_by([p], p.birthday)
    |> select([p], p.birthday)
    # |> where([q], q.appeared > 0)
    |> where([q], not is_nil(q.birthday))
    |> order_by([q], [desc: q.birthday])
    |> Repo.all
    |> Enum.uniq_by(fn birthday ->
      if birthday, do: birthday.year
    end)
  end

end
