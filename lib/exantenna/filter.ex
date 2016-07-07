defmodule Exantenna.Filter do

  @reHKA3 ~r/^([ぁ-んー－]|[ァ-ヴー－]|[a-z]){3,4}$/iu

  def right_name?(name) do
    !Blank.blank?(name) && !Regex.match?(@reHKA3, name) && String.length(name) > 2
  end

  def separate_name(name) do
    Enum.filter(String.split(name, ~r(、|（|）)), fn(name) ->
      right_name?(name)
    end)
  end

end
