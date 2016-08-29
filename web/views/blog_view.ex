defmodule Exantenna.BlogView do
  use Exantenna.Web, :view

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title
end
