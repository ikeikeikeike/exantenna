defmodule Exantenna.AntennaView do
  use Exantenna.Web, :view

  def page_title(:index, assigns) do
    params = assigns.conn.params
    num = number_with_delimiter(assigns.antennas.total_entries)
    title =
      cond do
        ! blank?(params["tag"])  -> gettext "%{word} showing %{num} results", word: params["tag"],  num: num
        ! blank?(params["diva"]) -> gettext "%{word} showing %{num} results", word: params["diva"], num: num
        ! blank?(params["q"])    -> gettext "%{word} Found %{num} results",   word: params["q"],    num: num
        true                     -> gettext "Showing %{num} results", num: num
      end

    (if title, do: title <> " - ", else: "") <> gettext("Default Page Title")
  end
  def page_title(_, _),           do: gettext "Default Page Title"

end
