defmodule Exantenna.Sitemeta do
  import Exantenna.Gettext
  import Exantenna.Blank
  use Phoenix.HTML.SimplifiedHelpers

  def listed_page_title(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(assigns.antennas.total_entries)
    title =
      cond do
        ! blank?(params["tag"])    -> gettext "%{word} showing %{num} results", word: params["tag"],    num: num
        ! blank?(params["diva"])   -> gettext "%{word} showing %{num} results", word: params["diva"],   num: num
        ! blank?(params["toon"])   -> gettext "%{word} showing %{num} results", word: params["toon"],   num: num
        ! blank?(params["search"]) -> gettext "%{word} Found %{num} results",   word: params["search"], num: num
        ! blank?(params["q"])      -> gettext "%{word} Found %{num} results",   word: params["q"],      num: num
        true                     -> gettext "Showing %{num} results", num: num
      end

    (if title, do: title <> " - ", else: "") <> gettext("Default Page Title")
  end
  def listed_page_title(:show, assigns), do: truncate(assigns.antenna.metadata.seo_title, length: 100) <> " - " <> gettext("Default Page Title")
  def listed_page_title(_, _),           do: gettext "Default Page Title"

  def profile_page_title(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(assigns.pager.total_entries)
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
  def profile_page_title(:show, assigns) do
    num  = number_with_delimiter(assigns.antennas.total_entries)
    word = truncate(profmodel(assigns).name, length: 100)

    title = gettext "%{word} showing %{num} results", word: word,  num: num
    title <> " - " <> gettext("Default Page Title")
  end
  def profile_page_title(_, _),           do: gettext "Default Page Title"

  defp profmodel(%{toon: model}), do: model
  defp profmodel(%{diva: model}), do: model

end
