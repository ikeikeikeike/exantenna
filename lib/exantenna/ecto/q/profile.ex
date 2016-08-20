defmodule Exantenna.Ecto.Q.Profile do
  import Ecto.Query
  alias Exantenna.Repo
  alias Exantenna.Score
  import Exantenna.Ecto.Extractor, only: [toname: 1]

  def query(:score, m) do
    from [c, s] in joinner(m),
    order_by: [desc: s.count]
  end

  @limit 99 * 99 * 99 * 99 * 10

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

  def get(:atoz, %{value: nil} = m) do
    get :atoz, Map.merge(m, %{value: @kunrei_romaji, limit: 10})
  end
  def get(:atoz, m) do
    Enum.map(m[:value], fn letter ->
      qs =
        from [c, s] in joinner(m),
          where: c.gyou == ^letter
            and not is_nil(c.gyou),
          # order_by: [asc: c.gyou],
          limit: ^m[:limit]

      {letter, Repo.all(qs)}
    end)
  end

  def get(:blood, %{value: nil} = m) do
    types = ["A", "B", "O", "AB"]
    get :blood, Map.merge(m, %{value: types, limit: 10})
  end
  def get(:blood, m) do
    Enum.map(m[:value], fn blood ->
      qs =
        from [c, s] in joinner(m),
          where: c.blood == ^blood
            and not is_nil(c.blood),
          # order_by: [asc: c.blood],
          limit: ^m[:limit]

      {blood, Repo.all(qs)}
    end)
  end

  def get(:bracup, %{value: nil} = m) do
    cups = Enum.map(?A..?Z, &IO.iodata_to_binary([&1]))
    get :bracup, Map.merge(m, %{value: cups, limit: 10})
  end

  def get(:bracup, m) do
    Enum.map(m[:value], fn bracup ->
      qs =
        from [c, s] in joinner(m),
          where: c.bracup == ^bracup
            and not is_nil(c.bracup),
          # order_by: [asc: c.bust],
          limit: ^m[:limit]

      {bracup, Repo.all(qs)}
    end)
  end

  def get(:height, %{value: nil} = m) do
    range =
      [
        130, 135, 140, 145, 150, 155, 160,
        165, 170, 175, 180, 185, 190
      ]
    get :height, Map.merge(m, %{value: range, limit: 10})
  end

  def get(:height, %{value: value} = m) when is_list(value) do
    value
    |> toint
    |> Enum.map(fn height ->
      qs =
        from [c, s] in joinner(m),
          where: c.height >= ^height
            and  c.height < ^(height + 5)
            and  c.height > 130
            and not is_nil(c.height),
          # order_by: [asc: c.height],
          limit: ^m[:limit]

      {height, Repo.all(qs)}
    end)
  end

  def get(:waist, %{value: nil} = m) do
    range =
      [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
    get :waist, Map.merge(m, %{value: range, limit: 10})
  end
  def get(:waist, %{value: value} = m) when is_list(value) do
    value
    |> toint
    |> Enum.map(fn waist ->
      qs =
        from [c, s] in joinner(m),
          where: c.waist >= ^waist
            and  c.waist < ^(waist + 5)
            and  c.waist > 40
            and not is_nil(c.waist),
          # order_by: [asc: c.waist],
          limit: ^m[:limit]

      {waist, Repo.all(qs)}
    end)
  end

  def get(:hip, %{value: nil} = m) do
    range =
      [
        50, 55, 60, 65, 70, 75, 80, 85,
        90, 95, 100, 105, 110, 115, 120
      ]
    get :hip, Map.merge(m, %{value: range, limit: 10})
  end
  def get(:hip, %{value: value} = m) when is_list(value) do
    value
    |> toint
    |> Enum.map(fn hip ->
      qs =
        from [c, s] in joinner(m),
          where: c.hip >= ^hip
            and  c.hip < ^(hip + 5)
            and  c.hip > 50
            and not is_nil(c.hip),
          # order_by: [asc: c.hip],
          limit: ^m[:limit]

      {hip, Repo.all(qs)}
    end)
  end

  def get(:bust, %{value: nil} = m) do
    range = [
      60, 65, 70, 75, 80, 85, 90, 95, 100,
      105, 110, 115, 120, 125, 130, 135
    ]
    get :bust, Map.merge(m, %{value: range, limit: 10})
  end
  def get(:bust, %{value: value} = m) when is_list(value) do
    value
    |> toint
    |> Enum.map(fn bust ->
      qs =
        from [c, s] in joinner(m),
          where: c.bust >= ^bust
            and  c.bust < ^(bust + 5)
            and  c.bust > 60
            and not is_nil(c.bust),
          # order_by: [asc: c.bust],
          limit: ^m[:limit]

      {bust, Repo.all(qs)}
    end)
  end

  def get(:author, %{value: nil} = m) do
    resouce = Map.merge(m, %{query: m[:mod]})

    qs =
      from [c, s] in joinner(resouce),
        select: c.author,
        where: not is_nil(c.author)
          and c.author != ""
          and c.author != "-",
        group_by: c.author,
        order_by: [asc: c.author]

    get :author, Map.merge(m, %{value: Repo.all(qs), limit: 10})
  end
  def get(:author, m) do
    Enum.map(m[:value], fn author ->
      qs =
        from [c, s] in joinner(m),
          where: c.author == ^author
            and not is_nil(c.author),
          # order_by: [asc: c.author],
          limit: ^m[:limit]

      {author, Repo.all(qs)}
    end)
  end

  def get(:works, %{value: nil} = m) do
    resouce = Map.merge(m, %{query: m[:mod]})

    qs =
      from [c, s] in joinner(resouce),
        select: c.works,
        where: not is_nil(c.works)
          and c.works != ""
          and c.works != "-",
        group_by: c.works,
        order_by: [asc: c.works]

    get :works, Map.merge(m, %{value: Repo.all(qs), limit: 10})
  end
  def get(:works, m) do
    Enum.map(m[:value], fn works ->
      qs =
        from [c, s] in joinner(m),
          where: c.works == ^works
            and not is_nil(c.works),
          # order_by: [asc: c.works],
          limit: ^m[:limit]

      {works, Repo.all(qs)}
    end)
  end

  def get(:month, %{value: %{"year" => _, "month" => _} = value} = m) do
    {year, month} = toint(value)

    thismonth =
      Timex.Date.from({year, month , 01})

    nextmonth =
      thismonth
      |> Timex.Date.shift(months: 1)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.birthday)
          and c.birthday <  ^nextmonth
          and c.birthday >= ^thismonth,
        order_by: [asc: c.birthday]

    birthdays =
      qs
      |> Repo.all
      |> Enum.uniq_by(fn st ->
        if st.birthday, do: st.birthday.day
      end)
      |> Enum.map(fn st ->
        st.birthday
      end)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.birthday)
          and c.birthday <  ^nextmonth
          and c.birthday >= ^thismonth

    {birthdays, Repo.all(qs)}
  end


  def get(:year, %{value: %{"year" => year}} = m) do
    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.birthday)
          and c.birthday <= ^"#{year}-12-31"
          and c.birthday >= ^"#{year}-01-01",
        order_by: [asc: c.birthday]

    birthdays =
      qs
      |> Repo.all
      |> Enum.uniq_by(fn st ->
        if st.birthday, do: st.birthday.month
      end)
      |> Enum.map(fn st ->
        st.birthday
      end)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.birthday)
          and c.birthday <= ^"#{year}-12-31"
          and c.birthday >= ^"#{year}-01-01",
        order_by: [asc: c.birthday]

    {birthdays, Repo.all(qs)}
  end

  def get(:birthday, m) do
    qs =
      from [c, s] in joinner(m),
        select: c.birthday,
        where: not is_nil(c.birthday),
        group_by: c.birthday,
        order_by: [desc: c.birthday]

    qs
    |> Repo.all
    |> Enum.uniq_by(fn birthday ->
      if birthday, do: birthday.year
    end)
  end

  def get(:release_month, %{value: %{"year" => _, "month" => _} = value} = m) do
    {year, month} = toint(value)

    thismonth =
      Timex.Date.from({year, month , 01})

    nextmonth =
      thismonth
      |> Timex.Date.shift(months: 1)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.release_date)
          and c.release_date <  ^nextmonth
          and c.release_date >= ^thismonth,
        order_by: [asc: c.release_date]

    releases =
      qs
      |> Repo.all
      |> Enum.uniq_by(fn st ->
        if st.release_date, do: st.release_date.day
      end)
      |> Enum.map(fn st ->
        st.release_date
      end)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.release_date)
          and c.release_date <  ^nextmonth
          and c.release_date >= ^thismonth

    {releases, Repo.all(qs)}
  end

  def get(:release_year, %{value: %{"year" => year}} = m) do
    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.release_date)
          and c.release_date <= ^"#{year}-12-31"
          and c.release_date >= ^"#{year}-01-01",
        order_by: [asc: c.release_date]

    releases =
      qs
      |> Repo.all
      |> Enum.uniq_by(fn st ->
        if st.release_date, do: st.release_date.month
      end)
      |> Enum.map(fn st ->
        st.release_date
      end)

    qs =
      from [c, s] in joinner(m),
        where: not is_nil(c.release_date)
          and c.release_date <= ^"#{year}-12-31"
          and c.release_date >= ^"#{year}-01-01"

    {releases, Repo.all(qs)}
  end

  def get(:release, m) do
    qs =
      from [c, s] in joinner(m),
        select: c.release_date,
        where: not is_nil(c.release_date),
        group_by: c.release_date,
        order_by: [desc: c.release_date]

    qs
    |> Repo.all
    |> Enum.uniq_by(fn release_date ->
      if release_date, do: release_date.year
    end)
  end

  def args(sub, mod),
    do: %{sub: sub, mod: mod, query: mod,   value: nil, limit: nil}
  def args(sub, mod, query),
    do: %{sub: sub, mod: mod, query: query, value: nil, limit: nil}
  def args(sub, mod, query, value) when is_bitstring(value) or is_integer(value),
    do: %{sub: sub, mod: mod, query: query, value: [value], limit: @limit}
  def args(sub, mod, query, value),
    do: %{sub: sub, mod: mod, query: query, value: value, limit: @limit}
  def args(sub, mod, query, value, limit) when is_bitstring(value) or is_integer(value),
    do: %{sub: sub, mod: mod, query: query, value: [value], limit: limit}
  def args(sub, mod, query, value, limit),
    do: %{sub: sub, mod: mod, query: query, value: value, limit: limit}

  defp toint(numerics) when is_list(numerics) do
    Enum.map numerics, fn v ->
      if is_bitstring(v) do
        {v, _} = Integer.parse v
      end
      v
    end
  end

  defp toint(%{"year" => year, "month" => month}) do
    {year, _} = Integer.parse(year)
    {month, _} = Integer.parse(month)
    {year, month}
  end

  defp joinqs(mod), do: {"#{toname mod}s_scores", Score}

  defp joinner(m) do
    qs = from c in m[:query],
           join: s in ^joinqs(m[:mod]),
             where: s.assoc_id == c.id
               and  s.count > 0

    qs =
      case m do
        %{sub: nil, mod: mod} ->
          from [c, s] in qs,
            where: s.name == ^Score.name_appeared(toname(mod))
        %{sub: sub, mod: mod} ->
          from [c, s] in qs,
            where: s.name == ^Score.name_appeared(sub, toname(mod))
      end

    qs
  end
end
