defmodule Exantenna.Sub.Book.EntryView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do:
    gettext("Entry View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title

end
