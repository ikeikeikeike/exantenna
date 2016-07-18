defmodule Exantenna.Es.Params do
  import Exantenna.Imitation.Converter, only: [to_i: 1]

  @default_page 1
  @default_page_size 35

  def pager_option(options) do
    options =
      Enum.reduce(options, %{}, fn {k, v}, map ->
        Map.put(map, String.to_atom(k), v)
      end)

    # for pagination
    page = max(options[:page] |> to_i, @default_page)
    per_page = (options[:limit] || options[:per_page] || options[:page_size] || @default_page_size)
    offset = options[:offset] || (page - 1) * per_page

    [page: page, per_page: per_page, offset: offset]
  end

end
