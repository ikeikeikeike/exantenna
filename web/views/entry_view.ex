defmodule Exantenna.EntryView do
  use Exantenna.Web, :view

  def page_title(:index, assigns) do
    params = assigns.conn.params
    title =
      cond do
        ! Blank.blank? params["tag"]  -> gettext "%{word} showing %{num} results", word: params["tag"],  num: number_with_delimiter(assigns.entries.total_entries)
        ! Blank.blank? params["diva"] -> gettext "%{word} showing %{num} results", word: params["diva"], num: number_with_delimiter(assigns.entries.total_entries)
        ! Blank.blank? params["q"]    -> gettext "%{word} Found %{num} results",   word: params["q"],    num: number_with_delimiter(assigns.entries.total_entries)
        true                          -> nil
      end

    (if title, do: title <> " - ", else: "") <> gettext("Default Page Title")
  end
  def page_title(:show, assigns),    do: truncate(assigns[:entry].title, length: 100) <> " - " <> gettext("Default Page Title")
  def page_title(_, _),              do: gettext "Default Page Title"

  def page_keywords(:index, assigns) do
    params = assigns.conn.params
    keywords =
      cond do
        ! Blank.blank? params["tag"]  -> gettext ",%{word}", word: params["tag"]
        ! Blank.blank? params["diva"] -> gettext ",%{word}", word: params["diva"]
        ! Blank.blank? params["q"]    -> gettext ",%{word}", word: params["q"]
        true                          -> ""
      end

    gettext("Default,Page,Keywords") <> keywords
  end
  def page_keywords(:show, assigns), do: gettext("Default,Page,Keywords") <> "," <> Enum.join(Enum.map(assigns[:entry].tags, fn(tag) -> tag.name end), ",")
  def page_keywords(_, _),           do: gettext "Default,Page,Keywords"

  def page_description(:index, assigns) do
    params = assigns.conn.params
    cond do
      ! Blank.blank? params["tag"]    -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["tag"]
      ! Blank.blank? params["diva"]   -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["diva"]
      ! Blank.blank? params["q"]      -> gettext "You would search '%{word}' in XXX. Let's see the Article in XXX !!", word: params["q"]
      true                            -> gettext "Default Page Description"
    end
  end
  def page_description(:show, assigns) do
    assigns[:antennas].entries
    |> Enum.reverse
    |> Enum.map(fn entry -> entry.title end)
    |> Enum.join(", ")
    |> truncate(length: 100)
  end
  def page_description(_, _),        do: gettext "Default Page Description"

end
