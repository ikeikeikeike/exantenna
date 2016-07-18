defmodule Exantenna.Diva.HeightView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do: gettext("diva height index page title") <> " - " <> gettext("Default Page Title")
  def page_title(_, _), do: gettext("diva height index page title") <> " - " <> gettext("Default Page Title")

  def page_keywords(_, _), do: gettext("Default,Page,Keywords") <> "," <> gettext("Diva,Page,Keywords")

  def page_description(:index, assigns), do: gettext("diva height index page title with %{name}", name: gettext("Site Name"))
  def page_description(_, _), do: gettext "Diva Page Description"

end
