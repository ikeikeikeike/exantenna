defmodule Exantenna.Sitemeta do
  use Phoenix.HTML.SimplifiedHelpers
  import Exantenna.Blank
  import Exantenna.Gettext

  alias Exantenna.Antenna
  alias Exantenna.Char
  alias Exantenna.Blog
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Tag
  alias Exantenna.Ecto.Extractor

  alias Exantenna.Helpers, as: H

  def page_title(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(totals(assigns))

    title =
      cond do
        ! blank?(params["tag"])    -> gettext "%{word} showing %{num} results", word: params["tag"],    num: num
        ! blank?(params["diva"])   -> gettext "%{word} showing %{num} results", word: params["diva"],   num: num
        ! blank?(params["toon"])   -> gettext "%{word} showing %{num} results", word: params["toon"],   num: num
        ! blank?(params["search"]) -> gettext "%{word} Found %{num} results",   word: params["search"], num: num
        ! blank?(params["q"])      -> gettext "%{word} Found %{num} results",   word: params["q"],      num: num
        true                       -> gettext "%{num} results", num: num
      end

    (if title, do: title <> " - ", else: "") <> gettext("%{sitetitle}", sitetitle: H.sitemeta(assigns.conn.private[:subdomain], :title))
  end
  def page_title(:show, assigns) do
    word = truncate(extract_title(H.object :show, assigns), length: 100)
    num  = number_with_delimiter(totals(assigns))

    title = gettext "%{word} with %{num} relevents", word: word,  num: num
    title <> " - " <> gettext("Default Page Title")
  end
  def page_title(_, _),           do: gettext "Default Page Title"

  defp extract_title(%Antenna{} = model), do: model.metadata.seo_title
  defp extract_title(%Blog{} = model), do: model.name
  defp extract_title(%Diva{} = model), do: model.name
  defp extract_title(%Char{} = model), do: model.name
  defp extract_title(%Toon{} = model), do: model.name
  defp extract_title(%Tag{} = model), do: model.name

  defp totals(%{pager: pager}), do: pager.total_entries
  defp totals(%{antennas: pager}), do: pager.total_entries

end
