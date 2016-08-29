defmodule Exantenna.Sitemeta do
  import Exantenna.Gettext
  import Exantenna.Blank
  use Phoenix.HTML.SimplifiedHelpers

  def page_title(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(get_total(assigns))

    title =
      cond do
        ! blank?(params["tag"])    -> gettext "%{word} showing %{num} results", word: params["tag"],    num: num
        ! blank?(params["diva"])   -> gettext "%{word} showing %{num} results", word: params["diva"],   num: num
        ! blank?(params["toon"])   -> gettext "%{word} showing %{num} results", word: params["toon"],   num: num
        ! blank?(params["search"]) -> gettext "%{word} Found %{num} results",   word: params["search"], num: num
        ! blank?(params["q"])      -> gettext "%{word} Found %{num} results",   word: params["q"],      num: num
        true                       -> gettext "Showing %{num} results", num: num
      end

    (if title, do: title <> " - ", else: "") <> gettext("Default Page Title")
  end
  def page_title(:show, assigns) do
    word = truncate(get_title(assigns), length: 100)
    num  = number_with_delimiter(get_total(assigns))

    title = gettext "%{word} with %{num} relevents", word: word,  num: num
    title <> " - " <> gettext("Default Page Title")
  end
  def page_title(_, _),           do: gettext "Default Page Title"

  defp get_title(%{antenna: model}), do: model.metadata.seo_title
  defp get_title(%{toon: model}), do: model.name
  defp get_title(%{diva: model}), do: model.name
  defp get_title(%{char: model}), do: model.name
  defp get_title(%{blog: model}), do: model.name
  defp get_title(%{tag: model}), do: model.name

  defp get_total(%{pager: pager}), do: pager.total_entries
  defp get_total(%{antennas: pager}), do: pager.total_entries

end
