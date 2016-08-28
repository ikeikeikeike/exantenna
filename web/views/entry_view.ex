defmodule Exantenna.EntryView do
  use Exantenna.Web, :view

  defdelegate page_title(any, assigns), to: Exantenna.Sitemeta, as: :listed_page_title

  # def page_keywords(:index, assigns) do
    # params = assigns.conn.params
    # keywords =
      # cond do
        # ! Blank.blank? params["tag"]  -> gettext ",%{word}", word: params["tag"]
        # ! Blank.blank? params["diva"] -> gettext ",%{word}", word: params["diva"]
        # ! Blank.blank? params["q"]    -> gettext ",%{word}", word: params["q"]
        # true                          -> ""
      # end

    # gettext("Default,Page,Keywords") <> keywords
  # end
  # def page_keywords(:show, assigns), do: gettext("Default,Page,Keywords") <> "," <> Enum.join(Enum.map(assigns[:entry].tags, fn(tag) -> tag.name end), ",")
  # def page_keywords(_, _),           do: gettext "Default,Page,Keywords"

  # def page_description(:index, assigns) do
    # params = assigns.conn.params
    # cond do
      # ! Blank.blank? params["tag"]    -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["tag"]
      # ! Blank.blank? params["diva"]   -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["diva"]
      # ! Blank.blank? params["q"]      -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["q"]
      # true                            -> gettext "Default Page Description"
    # end
  # end
  # def page_description(:show, assigns) do
    # assigns[:antennas].entries
    # |> Enum.reverse
    # |> Enum.map(fn entry -> entry.title end)
    # |> Enum.join(", ")
    # |> truncate(length: 100)
  # end
  # def page_description(_, _),        do: gettext "Default Page Description"

end
