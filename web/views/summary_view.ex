defmodule Exantenna.SummaryView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do:
    gettext("Summary View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title

  def page_description(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(totals(assigns))

    cond do
      ! blank?(params["tag"])    -> gettext "You would search %{word}. showing %{name} results", word: params["tag"],    name: num
      ! blank?(params["diva"])   -> gettext "You would search %{word}. showing %{name} results", word: params["diva"],   name: num
      ! blank?(params["toon"])   -> gettext "You would search %{word}. showing %{name} results", word: params["toon"],   name: num
      ! blank?(params["search"]) -> gettext "You would search %{word}. Found %{name} results",   word: params["search"], name: num
      ! blank?(params["q"])      -> gettext "You would search %{word}. Found %{name} results",   word: params["q"],      name: num
      true                       -> gettext "%{name} results. Entry Default Page Description", name: num
    end
  end
  def page_description(_, _),           do: gettext "Summary Default Page Description"

end
