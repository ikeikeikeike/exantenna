defmodule Exantenna.Ecto.Q.Profile do
  import Ecto.Query
  alias Exantenna.Repo
  alias Exantenna.Score
  import Exantenna.Ecto.Extractor, only: [toname: 1]

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

  defp joinner(mod), do: {"#{toname mod}s_scores", Score}

  def get(:atoz, mod, query) do
    get :atoz, mod, query, @kunrei_romaji, 10
  end
  def get(:atoz, mod, query, letter), do: get :atoz, mod, query, letter, @limited
  def get(:atoz, mod, query, letter,  limited) when is_bitstring(letter), do: get :atoz, mod, query, [letter], limited
  def get(:atoz, mod, query, letters, limited) do
    Enum.map(letters, fn letter ->
      models =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.gyou == ^letter)
        |> where([q], not is_nil(q.gyou))
        |> limit(^limited)
        |> Repo.all

      {letter, models}
    end)
  end

  def get(:author, mod, query) do
    authors =
      mod
      |> group_by([p], p.author)
      |> select([p], p.author)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      |> where([q], not is_nil(q.author))
      |> where([q], q.author != "")
      |> where([q], q.author != "-")
      |> order_by([q], [q.author])
      |> Repo.all

    get :author, mod, query, authors, 10
  end
  def get(:author, mod, query, author), do: get :author, mod, query, author, @limited
  def get(:author, mod, query, author,  limited) when is_bitstring(author), do: get :author, mod, query, [author], limited
  def get(:author, mod, query, authors, limited) do
    Enum.map(authors, fn author ->
      models =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.author == ^author)
        |> where([q], not is_nil(q.author))
        |> limit(^limited)
        |> Repo.all

      {author, models}
    end)
  end

  def get(:works, mod, query) do
    works =
      mod
      |> group_by([p], p.works)
      |> select([p], p.works)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      |> where([q], not is_nil(q.works))
      |> where([q], q.works != "")
      |> where([q], q.works != "-")
      |> order_by([q], [q.works])
      |> Repo.all

    get :works, mod, query, works, 10
  end
  def get(:works, mod, query, work), do: get :works, mod, query, work, @limited
  def get(:works, mod, query, work,  limited) when is_bitstring(work), do: get :works, mod, query, [work], limited
  def get(:works, mod, query, works, limited) do
    Enum.map(works, fn work ->
      models =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.works == ^work)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.works))
        |> limit(^limited)
        |> Repo.all

      {work, models}
    end)
  end

  def get(:blood, mod, query) do
    types = ["A", "B", "O", "AB"]
    get :blood, mod, query, types, 10
  end
  def get(:blood, mod, query, type), do: get :blood, mod, query, type, @limited
  def get(:blood, mod, query, type,  limited) when is_bitstring(type), do: get :blood, mod, query, [type], limited
  def get(:blood, mod, query, types, limited) do
    Enum.map(types, fn blood ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.blood == ^blood)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.blood))
        |> limit(^limited)
        |> Repo.all
      {blood, divas}
    end)
  end

  def get(:bracup, mod, query) do
    cups = Enum.map(?A..?Z, &IO.iodata_to_binary([&1]))
    get :bracup, mod, query, cups, 10
  end

  def get(:bracup, mod, query, cup), do: get :bracup, mod, query, cup, @limited
  def get(:bracup, mod, query, cup,  limited) when is_bitstring(cup), do: get :bracup, mod, query, [cup], limited
  def get(:bracup, mod, query, cups, limited) do
    Enum.map(cups, fn bracup ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.bracup == ^bracup)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.bracup))
        |> order_by([q], [asc: q.bust])
        |> limit(^limited)
        |> Repo.all
      {bracup, divas}
    end)
  end

  def get(:height, mod, query) do
    range =
      [
        130, 135, 140, 145, 150, 155, 160,
        165, 170, 175, 180, 185, 190
      ]

    get(:height, mod, query, range, 10)
  end
  def get(:height, mod, query, numeric), do: get :height, query, numeric, @limited
  def get(:height, mod, query, numeric, limited) when is_integer(numeric), do: get :height, mod, query, [numeric], limited
  def get(:height, mod, query, numeric, limited) when is_bitstring(numeric) do
    {n, _} = Integer.parse numeric
    get :height, mod, query, [n], limited
  end
  def get(:height, mod, query, range, limited) when is_list(range) do
    Enum.map(range, fn height ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.height >= ^height)
        |> where([q], q.height < ^(height + 5))
        |> where([q], q.height > 130)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.height))
        |> order_by([q], [asc: q.height])
        |> limit(^limited)
        |> Repo.all
      {height, divas}
    end)
  end


  def get(:waist, mod, query) do
    range =
      [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]

    get(:waist, mod, query, range, 10)
  end
  def get(:waist, mod, query, numeric), do: get :waist, mod, query, numeric, @limited
  def get(:waist, mod, query, numeric, limited) when is_integer(numeric), do: get :waist, mod, query, [numeric], limited
  def get(:waist, mod, query, numeric, limited) when is_bitstring(numeric) do
    {n, _} = Integer.parse numeric
    get :waist, mod, query, [n], limited
  end
  def get(:waist, mod, query, range, limited) when is_list(range) do
    Enum.map(range, fn waist ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.waist >= ^waist)
        |> where([q], q.waist < ^(waist + 5))
        |> where([q], q.waist > 40)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.waist))
        |> order_by([q], [asc: q.waist])
        |> limit(^limited)
        |> Repo.all
      {waist, divas}
    end)
  end

  def get(:hip, mod, query) do
    range =
      [
        50, 55, 60, 65, 70, 75, 80, 85,
        90, 95, 100, 105, 110, 115, 120
      ]

    get(:hip, mod, query, range, 10)
  end
  def get(:hip, mod, query, numeric), do: get :hip, mod, query, numeric, @limited
  def get(:hip, mod, query, numeric, limited) when is_integer(numeric), do: get :hip, mod, query, [numeric], limited
  def get(:hip, mod, query, numeric, limited) when is_bitstring(numeric) do
    {n, _} = Integer.parse numeric
    get :hip, mod, query, [n], limited
  end
  def get(:hip, mod, query, range, limited) do
    Enum.map(range, fn hip ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
        |> where([q], q.hip >= ^hip)
        |> where([q], q.hip < ^(hip + 5))
        |> where([q], q.hip > 50)
        # |> where([q], q.appeared > 0)
        |> where([q], not is_nil(q.hip))
        |> order_by([q], [asc: q.hip])
        |> limit(^limited)
        |> Repo.all
      {hip, divas}
    end)
  end

  def get(:bust, mod, query) do
    range = [
      60, 65, 70, 75, 80, 85, 90, 95, 100,
      105, 110, 115, 120, 125, 130, 135
    ]

    get(:bust, mod, query, range, 10)
  end
  def get(:bust, mod, query, numeric), do: get :bust, mod, query, numeric, @limited
  def get(:bust, mod, query, numeric, limited) when is_integer(numeric), do: get :bust, mod, query, [numeric], limited
  def get(:bust, mod, query, numeric, limited) when is_bitstring(numeric) do
    {n, _} = Integer.parse numeric
    get :bust, mod, query, [n], limited
  end
  def get(:bust, mod, query, range, limited) when is_list(range) do
    Enum.map(range, fn bust ->
      divas =
        query
        |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
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

  def get(:month, mod, query, %{"year" => year, "month" => month}) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    next_month =
      Timex.Date.from({year, month, 01})
      |> Timex.Date.shift(months: 1)

    birthdays =
      mod
      |> select([p], p.birthday)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
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
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday  < ^next_month)
      |> where([q], q.birthday >= ^Timex.Date.from({year, month , 01}))
      |> Repo.all

    {birthdays, divas}
  end

  def get(:year, mod, query, %{"year" => year}) do
    birthdays =
      mod
      |> select([p], p.birthday)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
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
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> Repo.all

    {birthdays, divas}
  end

  def get(:birthday, mod) do
    mod
    |> group_by([p], p.birthday)
    |> select([p], p.birthday)
    |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
    # |> where([q], q.appeared > 0)
    |> where([q], not is_nil(q.birthday))
    |> order_by([q], [desc: q.birthday])
    |> Repo.all
    |> Enum.uniq_by(fn birthday ->
      if birthday, do: birthday.year
    end)
  end

  def get(:release_month, mod, query, %{"year" => year, "month" => month}) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    next_month =
      Timex.Date.from({year, month, 01})
      |> Timex.Date.shift(months: 1)

    releases =
      mod
      |> select([q], q.release_date)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.release_date))
      |> where([q], q.release_date  < ^next_month)
      |> where([q], q.release_date >= ^Timex.Date.from({year, month , 01}))
      |> order_by([q], [asc: q.release_date])
      |> Repo.all
      |> Enum.uniq_by(fn release_date ->
        if release_date, do: release_date.day
      end)

    divas =
      query
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.release_date))
      |> where([q], q.release_date  < ^next_month)
      |> where([q], q.release_date >= ^Timex.Date.from({year, month , 01}))
      |> Repo.all

    {releases, divas}
  end

  def get(:release_year, mod, query, %{"year" => year}) do
    releases =
      mod
      |> select([p], p.release_date)
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.release_date))
      |> where([q], q.release_date <= ^"#{year}-12-31")
      |> where([q], q.release_date >= ^"#{year}-01-01")
      |> order_by([q], [asc: q.release_date])
      |> Repo.all
      |> Enum.uniq_by(fn release_date ->
        if release_date, do: release_date.month
      end)

   toons =
      query
      |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
      # |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.release_date))
      |> where([q], q.release_date <= ^"#{year}-12-31")
      |> where([q], q.release_date >= ^"#{year}-01-01")
      |> Repo.all

    {releases, toons}
  end

  def get(:release, mod) do
    mod
    |> group_by([p], p.release_date)
    |> select([p], p.release_date)
    |> join(:inner, [c], s in ^joinner(mod), s.assoc_id == c.id and s.name == "video" and s.count > 0)
    # |> where([q], q.appeared > 0)
    |> where([q], not is_nil(q.release_date))
    |> order_by([q], [desc: q.release_date])
    |> Repo.all
    |> Enum.uniq_by(fn release_date ->
      if release_date, do: release_date.year
    end)
  end

end
