defmodule Exantenna.Char.WaistView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do: gettext("char waist index page title") <> " - " <> gettext("Default Page Title")
  def page_title(_, _), do: gettext("char waist index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Char,Page,Keywords")

  def page_description(:index, assigns), do: gettext("char waist index page title with %{name}", name: gettext("Site Name"))
  def page_description(_, _), do: gettext "Char Page Description"

end
