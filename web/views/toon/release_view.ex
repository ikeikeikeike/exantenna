defmodule Exantenna.Toon.ReleaseView do
  use Exantenna.Web, :view
  alias Exantenna.Word.Month

  def page_title(:index, assigns), do: gettext("toon release index page title") <> " - " <> gettext("Default Page Title")
  def page_title(:year, assigns) do
    params = assigns.conn.params
    gettext("toon release year page title with %{year}", year: params["year"]) <> " - " <> gettext("Default Page Title")
  end
  def page_title(:month, assigns) do
    params = assigns.conn.params
    gettext("toon release month page title with %{year} and %{month}",
             year: params["year"], month: Month.ordinalize(locale, params["month"])) <> " - " <> gettext("Default Page Title")
  end
  def page_title(_, _), do: gettext("toon release index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Toon,Page,Keywords")

  def page_description(:index, assigns), do: gettext("toon release index page title with %{name}", name: gettext("Site Name"))
  def page_description(:year, assigns) do
    params = assigns.conn.params
    gettext "toon release year page title with %{name} and %{year}",
             name: gettext("Site Name"), year: params["year"]
  end
  def page_description(:month, assigns) do
    params = assigns.conn.params
    gettext "toon release month page title with %{name} and %{year} and %{month}",
             name: gettext("Site Name"), year: params["year"], month: Month.ordinalize(locale, params["month"])
  end
  def page_description(_, _), do: gettext "Toon Page Description"

end
