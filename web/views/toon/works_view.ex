defmodule Exantenna.Toon.WorksView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do: gettext("toon works index page title") <> " - " <> gettext("Default Page Title")
  def page_title(_, _), do: gettext("toon works index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Toon,Page,Keywords")

  def page_description(:index, assigns), do: gettext("toon works index page title with %{name}", name: gettext("Site Name"))
  def page_description(_, _), do: gettext "Toon Page Description"

end
