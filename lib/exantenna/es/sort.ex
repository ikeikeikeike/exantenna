 # XXX: OMG https://github.com/Zatvobor/tirexs/issues/173
defmodule Exantenna.Es.Sort do
  import Tirexs.Query
  import Tirexs.Search

  def is_(:random) do
    Tirexs.Search.sort do
      [
        _script: [
          script: "Math.random() * 200000",
          type: "number",
          order: "asc",
        ]
      ]
    end
    |> Keyword.get(:sort)
  end

  def is_(%{published_at: sort}) do
    Tirexs.Search.sort do
      [published_at: [order: sort]]
    end
    |> Keyword.get(:sort)
  end

  def is_(_) do
    Tirexs.Search.sort do
      [_score: [order: "desc"]]
    end
    |> Keyword.get(:sort)
  end


end
