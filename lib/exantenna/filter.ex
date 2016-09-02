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

  @allow_video_elements 1
  @allow_picture_elements 5

  def allow_video_elements, do: @allow_video_elements
  def allow_picture_elements, do: @allow_picture_elements

  def allow?(:summary, %Antenna{} = antenna), do: !!antenna.summary
  def allow?(:book, %Antenna{} = antenna), do: @allow_picture_elements < length(Extractor.thumb(antenna))
  def allow?(:video, %Antenna{} = antenna) do
    antenna.video
    |> Map.get(:metadatas, [])
    |> Enum.map(fn meta ->
      ! blank?(meta.embed_code)
    end)
    |> Enum.any?
  end

end
