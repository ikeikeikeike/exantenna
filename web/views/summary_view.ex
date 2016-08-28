defmodule Exantenna.SummaryView do
  use Exantenna.Web, :view

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :listed_page_title

end
