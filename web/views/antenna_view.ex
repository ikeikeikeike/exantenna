defmodule Exantenna.AntennaView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do:
    gettext("Antenna View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  def page_title(_, _),           do: gettext "Default Page Title"

end
