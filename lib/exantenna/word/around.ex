defmodule Exantenna.Word.Around do
  @moduledoc false

  def ten(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    ten(locale, n)
  end

  def ten(locale, number) when is_number(number) do
    case locale do
      "en" ->
        case number do
          x when x in 10..19   -> "Around 10-19"
          x when x in 20..29   -> "Around 20-29"
          x when x in 30..39   -> "Around 30-39"
          x when x in 40..49   -> "Around 40-49"
          x when x in 50..59   -> "Around 50-59"
          x when x in 60..69   -> "Around 60-69"
          x when x in 70..79   -> "Around 70-79"
          x when x in 80..89   -> "Around 80-89"
          x when x in 90..99   -> "Around 90-99"
          x when x in 100..109 -> "Around 100-109"
          x when x in 110..119 -> "Around 110-119"
          x when x in 120..129 -> "Around 120-129"
          x when x in 130..139 -> "Around 130-139"
          x when x in 140..149 -> "Around 140-149"
          x when x in 150..159 -> "Around 150-159"
          x when x in 160..169 -> "Around 160-169"
          x when x in 170..179 -> "Around 170-179"
        end
      "ja" ->
        case number do
          x when x in 10..19   -> "10-19"
          x when x in 20..29   -> "20-29"
          x when x in 30..39   -> "30-39"
          x when x in 40..49   -> "40-49"
          x when x in 50..59   -> "50-59"
          x when x in 60..69   -> "60-69"
          x when x in 70..79   -> "70-79"
          x when x in 80..89   -> "80-89"
          x when x in 90..99   -> "90-99"
          x when x in 100..109 -> "100-109"
          x when x in 110..119 -> "110-119"
          x when x in 120..129 -> "120-129"
          x when x in 130..139 -> "130-139"
          x when x in 140..149 -> "140-149"
          x when x in 150..159 -> "150-159"
          x when x in 160..169 -> "160-169"
          x when x in 170..179 -> "170-179"
        end
    end
  end

  def five(locale, number) when not is_number(number) do
    {n, _} = Integer.parse(number)
    five(locale, n)
  end

  def five(locale, number) when is_number(number) do
    case locale do
      "en" ->
        case number do
          x when x in 0..4     -> "Around 0-4"
          x when x in 5..9     -> "Around 5-9"
          x when x in 10..14   -> "Around 10-14"
          x when x in 15..19   -> "Around 15-19"
          x when x in 20..24   -> "Around 20-24"
          x when x in 25..29   -> "Around 25-29"
          x when x in 30..34   -> "Around 30-34"
          x when x in 35..39   -> "Around 35-39"
          x when x in 40..44   -> "Around 40-44"
          x when x in 45..49   -> "Around 45-49"
          x when x in 50..54   -> "Around 50-54"
          x when x in 55..59   -> "Around 55-59"
          x when x in 60..64   -> "Around 60-64"
          x when x in 65..69   -> "Around 65-69"
          x when x in 70..74   -> "Around 70-74"
          x when x in 75..79   -> "Around 75-79"
          x when x in 80..84   -> "Around 80-84"
          x when x in 85..89   -> "Around 85-89"
          x when x in 90..94   -> "Around 90-94"
          x when x in 95..99   -> "Around 95-99"
          x when x in 100..104 -> "Around 100-104"
          x when x in 105..109 -> "Around 105-109"
          x when x in 110..114 -> "Around 110-114"
          x when x in 115..119 -> "Around 115-119"
          x when x in 120..124 -> "Around 120-124"
          x when x in 125..129 -> "Around 125-129"
          x when x in 130..134 -> "Around 130-134"
          x when x in 135..139 -> "Around 135-139"
          x when x in 140..144 -> "Around 140-144"
          x when x in 145..149 -> "Around 145-149"
          x when x in 150..154 -> "Around 150-154"
          x when x in 155..159 -> "Around 155-159"
          x when x in 160..164 -> "Around 160-164"
          x when x in 165..169 -> "Around 165-169"
          x when x in 170..174 -> "Around 170-174"
          x when x in 175..179 -> "Around 175-179"
          x when x in 180..184 -> "Around 180-184"
        end
      "ja" ->
        case number do
          x when x in 0..4     -> "0-4"
          x when x in 5..9     -> "5-9"
          x when x in 10..14   -> "10-14"
          x when x in 15..19   -> "15-19"
          x when x in 20..24   -> "20-24"
          x when x in 25..29   -> "25-29"
          x when x in 30..34   -> "30-34"
          x when x in 35..39   -> "35-39"
          x when x in 40..44   -> "40-44"
          x when x in 45..49   -> "45-49"
          x when x in 50..54   -> "50-54"
          x when x in 55..59   -> "55-59"
          x when x in 60..64   -> "60-64"
          x when x in 65..69   -> "65-69"
          x when x in 70..74   -> "70-74"
          x when x in 75..79   -> "75-79"
          x when x in 80..84   -> "80-84"
          x when x in 85..89   -> "85-89"
          x when x in 90..94   -> "90-94"
          x when x in 95..99   -> "95-99"
          x when x in 100..104 -> "100-104"
          x when x in 105..109 -> "105-109"
          x when x in 110..114 -> "110-114"
          x when x in 115..119 -> "115-119"
          x when x in 120..124 -> "120-124"
          x when x in 125..129 -> "125-129"
          x when x in 130..134 -> "130-134"
          x when x in 135..139 -> "135-139"
          x when x in 140..144 -> "140-144"
          x when x in 145..149 -> "145-149"
          x when x in 150..154 -> "150-154"
          x when x in 155..159 -> "155-159"
          x when x in 160..164 -> "160-164"
          x when x in 165..169 -> "165-169"
          x when x in 170..174 -> "170-174"
          x when x in 175..179 -> "175-179"
          x when x in 180..184 -> "180-184"
        end
    end
  end
end
