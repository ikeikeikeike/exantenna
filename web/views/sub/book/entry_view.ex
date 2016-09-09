defmodule Exantenna.Sub.Book.EntryView do
  use Exantenna.Web, :view

  def page_title(:index, assigns), do:
    gettext("Entry View Title") <> " " <> Exantenna.Sitemeta.page_title(:index, assigns)

  def page_title(:view, assigns) do
    model = object :show, assigns

    word = truncate(titles(model), length: 100)
    num = length thumbs_all(model)

    title = gettext "%{word} %{num} pictures", word: word,  num: num
    title <> " - " <> gettext("Default Page Title")
  end

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :page_title

end
