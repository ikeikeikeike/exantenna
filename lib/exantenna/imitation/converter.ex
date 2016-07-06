defmodule Exantenna.Imitation.Converter do
  def to_i(num) when is_integer(num), do: num
  def to_i(num) when is_float(num),   do: round(num)
  def to_i(num) when is_nil(num),     do: 0
  def to_i(num) do
    case Integer.parse(num) do
      :error -> 0
      {n, _} -> n
    end
  end
end
