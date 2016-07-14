defmodule Exantenna.Es.Paginator do

  alias Exantenna.Es
  alias Exantenna.Repo

  import Ecto.Query

  defstruct [:entries, :page_number, :page_size, :total_entries, :total_pages, :tirexs]

  def paginate(tirexs, query, options \\ []) do
    opt = Es.Params.pager_option(options)

    page = opt[:page]
    # offset = opt[:offset]
    page_size = opt[:per_page]

    %__MODULE__{
      page_size: options[:page_size],
      page_number: page,
      entries: entries(tirexs[:hits][:hits], query),
      total_entries: tirexs[:hits][:total],
      total_pages: total_pages(tirexs[:hits][:total], page_size),
      tirexs: tirexs,
    }
  end

  defp entries(hits, query) do
    Enum.map hits, fn(hit) ->
      query
      |> where([q], q.id == ^hit[:_id])
      |> Repo.one
    end
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end

end
