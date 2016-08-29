defmodule Exantenna.ToonView do
  use Exantenna.Web, :view

  def render("suggest.json", %{names: names}),
    do: Exantenna.SuggestView.render("suggest.json", %{names: names})

  def page_title(:index, assigns), do:
    gettext("Toon View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title

end
