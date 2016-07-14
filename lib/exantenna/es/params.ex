defmodule Exantenna.Es.Params do
  import Exantenna.Imitation.Converter, only: [to_i: 1]

  def pager_option(options) do
    # for pagination
    page = max(options[:page] |> to_i, 1)
    per_page = (options[:limit] || options[:per_page] || options[:page_size] || 10000)
    offset = options[:offset] || (page - 1) * per_page

    [page: page, per_page: per_page, offset: offset]
  end

end
