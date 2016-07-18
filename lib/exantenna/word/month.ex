defmodule Exantenna.Word.Month do
  @moduledoc false

  def ordinalize(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    ordinalize(locale, n)
  end

  def ordinalize(locale, number) when is_number(number) do
    case locale do
      "en" ->
        case number do
          1  -> "Jan."
          2  -> "Feb."
          3  -> "Mar."
          4  -> "Apr."
          5  -> "May."
          6  -> "Jun."
          7  -> "Jul."
          8  -> "Aug."
          9  -> "Sep."
          10 -> "Oct."
          11 -> "Nov."
          12 -> "Dec."
        end
      "ja" ->
        case number do
          1  -> "1月"
          2  -> "2月"
          3  -> "3月"
          4  -> "4月"
          5  -> "5月"
          6  -> "6月"
          7  -> "7月"
          8  -> "8月"
          9  -> "9月"
          10 -> "10月"
          11 -> "11月"
          12 -> "12月"
        end
    end
  end

end
