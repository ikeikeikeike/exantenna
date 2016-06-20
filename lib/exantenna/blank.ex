defprotocol Exantenna.Blank do
  @fallback_to_any true
  def blank?(data)
end

defimpl Exantenna.Blank, for: Integer do
  def blank?(_), do: false
end

defimpl Exantenna.Blank, for: String do
  def blank?(''),    do: true
  def blank?(_),     do: false
end

defimpl Exantenna.Blank, for: BitString do
  def blank?(""),    do: true
  def blank?(_),     do: false
end

defimpl Exantenna.Blank, for: List do
  def blank?([]), do: true
  def blank?(_),  do: false
end

defimpl Exantenna.Blank, for: Tuple do
  def blank?({}), do: true
  def blank?(_),  do: false
end

defimpl Exantenna.Blank, for: Map do
  def blank?(%{}), do: true
  def blank?(_),  do: false
end

defimpl Exantenna.Blank, for: Atom do
  def blank?(false), do: true
  def blank?(nil),   do: true
  def blank?(_),     do: false
end

defimpl Exantenna.Blank, for: Ecto.Date do
  def blank?(%Ecto.Date{year: 0, month: 0, day: 0}), do: true
  def blank?(%Ecto.Date{year: 1, month: 1, day: 1}), do: true
  def blank?(_),  do: false
end

defimpl Exantenna.Blank, for: Any do
  def blank?(_), do: false
end
