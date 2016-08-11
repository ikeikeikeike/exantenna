defmodule Exantenna.Es.Paginator do

  alias Exantenna.Es
  alias Exantenna.Repo

  import Ecto.Query

  defstruct [
    tirexs: [],
    entries: [],
    page_number: 0,
    page_size: 0,
    prev_page: 0,
    next_page: 0,
    has_prev: false,
    has_next: false,
    total_entries: 0,
    total_pages: 0,
  ]

  def paginate(tirexs, query), do: paginate tirexs, query, []
  def paginate(%{error: _}, _query, _options), do: %__MODULE__{}
  def paginate(tirexs, query, options) do
    opt = Es.Params.pager_option(options)

    page = opt[:page]
    # offset = opt[:offset]
    page_size = opt[:per_page]
    pages = total_pages(tirexs[:hits][:total], page_size)

    st = %__MODULE__{
      entries: entries(tirexs[:hits][:hits], query),
      page_size: options[:page_size],
      page_number: page,
      total_entries: tirexs[:hits][:total],
      total_pages: pages,
      tirexs: tirexs,
    }

    addition st
  end

  def addition(st) do
    Map.merge st, %{
      prev_page: st.page_number - 1,
      next_page: st.page_number + 1,
      has_prev: st.page_number > 1,
      has_next: st.page_number < st.total_pages
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
