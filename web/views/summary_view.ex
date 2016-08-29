defmodule Exantenna.SummaryView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do:
    gettext("Summary View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title

end
