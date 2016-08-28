defmodule Exantenna.ToonView do
  use Exantenna.Web, :view

  def render("suggest.json", %{names: names}),
    do: Exantenna.SuggestView.render("suggest.json", %{names: names})

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :profile_page_title

end
