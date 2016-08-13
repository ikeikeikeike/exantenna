defmodule Exantenna.Ecto.Extractor do
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

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
           acc ++ defget(model.thumbs, [])
         end)
      ++ Enum.reduce(antenna.toons, [], fn model, acc ->
           acc ++ Enum.reduce model.chars, [], fn mo, ac ->
             ac ++ defget(mo.thumbs, [])
           end
         end)
      ++ Enum.reduce(antenna.divas, [], fn model, acc ->
          acc ++ defget(model.thumbs, [])
         end)
      ++ Enum.reduce(antenna.video.metadatas, [], fn model, acc ->
          acc ++ defget(model.thumbs, [])
         end)
      ++ Enum.reduce(antenna.tags, [], fn model, acc ->
          acc ++ defget(model.thumbs, [])
         end)
  end

  defp defget(model, default) do
    case model do
      %Ecto.Association.NotLoaded{} -> default
      _ -> model
    end
  end

  def model_to_string(model) when is_map(model), do: model_to_string model.__struct__
  def model_to_string(st) do
    st
    |> to_string
    |> String.split(".")
    |> List.last
    |> String.downcase
  end

  def toname(model), do: model_to_string model

end
