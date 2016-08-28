 # XXX: OMG https://github.com/Zatvobor/tirexs/issues/173
defmodule Exantenna.Es.Aggs do
  import Tirexs.Query
  import Tirexs.Search
  import Tirexs.Search.Aggs

  def is_(_) do
    aggs do
      tags do
        terms field: "tags",  size: 20, order: [_count: "desc"]
      end
      divas do
        terms field: "divas", size: 20, order: [_count: "desc"]
      end
      toons do
        terms field: "toons", size: 20, order: [_count: "desc"]
      end
      chars do
        terms field: "chars", size: 20, order: [_count: "desc"]
      end
    end
    |> Keyword.get(:aggs)
  end

end
