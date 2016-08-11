defmodule Exantenna.Filter do
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Extractor

  import Exantenna.Blank

  @reHKA3 ~r/^([ぁ-んー－]|[ァ-ヴー－]|[a-z]){3,4}$/iu

  def right_names(names, item) when is_list(names) do
    Enum.filter names, &right_name?(&1, item)
  end

  def right_name?(name) do
    ! blank?(name) && ! Regex.match?(@reHKA3, name) && String.length(name) > 2
  end

  def right_name?(name, %{"title" => _, "explain" => _, "tags" => _} = item) do
    bool = right_name?(name)
    cond do
      bool && String.contains?(item["title"], name)   -> true
      bool && String.contains?(item["explain"], name) -> true
      bool && name in item["tags"]                    -> true
      true                                            -> false
    end
  end

  def right_name?([name: name, alias: aka], item, filters) do
    # XXX: Consider add detectioning more from video info's map |> item["videos"]
    cond do
      ! (aka in filters) && right_name?(aka, item)   -> true
      ! (name in filters) && right_name?(name, item) -> true
      true                                           -> false
    end
  end

  def separate_name(name) do
    Enum.filter(String.split(name, ~r(、|（|）)), fn(name) ->
      right_name?(name)
    end)
  end

  def allow?(:summary, %Antenna{} = antenna), do: !!antenna.summary
  def allow?(:book, %Antenna{} = antenna), do: 5 < length(Extractor.thumb(antenna))
  def allow?(:video, %Antenna{} = antenna) do
    # if length(antenna.video.metadatas) > 0 do
      # require IEx; IEx.pry
    # end

    antenna.video
    |> Map.get(:metadatas, [])
    |> Enum.map(fn meta ->
      ! blank?(meta.embed_code)
    end)
    |> Enum.any?
  end

end
