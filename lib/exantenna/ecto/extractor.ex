defmodule Exantenna.Ecto.Extractor do
  alias Exantenna.Antenna

  def tag(%Antenna{} = antenna) do
    tags = [
      antenna.divas,
      antenna.toons,
      Enum.reduce(antenna.toons, [], fn toon, acc ->
        acc ++ toon.chars
      end),
      antenna.tags
    ]

    Enum.reduce tags, [], fn tag, acc ->
      acc ++ tag
    end
  end

  def thumb(%Antenna{} = antenna) do
    antenna.picture.thumbs
      ++ antenna.entry.thumbs
      ++ Enum.reduce(antenna.toons, [], fn model, acc ->
           acc ++ model.thumbs
         end)
      ++ Enum.reduce(antenna.toons, [], fn model, acc ->
           acc ++ Enum.reduce model.chars, [], fn mo, ac ->
             ac ++ mo.thumbs
           end
         end)
      ++ Enum.reduce(antenna.divas, [], fn model, acc ->
          acc ++ model.thumbs
         end)
      ++ Enum.reduce(antenna.video.metadatas, [], fn model, acc ->
          acc ++ model.thumbs
         end)
      ++ Enum.reduce(antenna.tags, [], fn model, acc ->
          acc ++ model.thumbs
         end)
  end

end
