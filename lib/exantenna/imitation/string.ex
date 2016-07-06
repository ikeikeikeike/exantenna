defmodule Exantenna.Imitation.String do
  def is_ascii?(text) do
    text
    |> to_char_list
    |> Enum.map(&(&1 < 128))
    |> Enum.all?
  end
end
