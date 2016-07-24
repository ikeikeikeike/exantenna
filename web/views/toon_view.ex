defmodule Exantenna.ToonView do
  use Exantenna.Web, :view

  def render("suggest.json", %{names: names}),
    do: Exantenna.SuggestView.render("suggest.json", %{names: names})

end
