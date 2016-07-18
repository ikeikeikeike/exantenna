defmodule Exantenna.ViewHelpers do
  use Phoenix.HTML
  import Exantenna.Gettext

  alias Exantenna.Thumb
  alias Exantenna.Antenna

  defdelegate blank?(word), to: Exantenna.Blank, as: :blank?

  def locale do
    Gettext.get_locale(Exantenna.Gettext)
  end

  def human_datetime(datetime) do
    Timex.format! datetime, "%F %R", :strftime
  end

  def to_age(date) do
    d = Timex.Date.today
    age = d.year - date.year
    if (date.month > d.month or (date.month >= d.month and date.day > d.day)), do: age = age - 1
    age
  end

  def pick(%Thumb{} = thumb), do: thumb
  def pick(thumbs) when is_list(thumbs), do: List.first thumbs

  # TODO: make sure that thumb are desc or asc in better ordering.
  # def better(%Thumb{} = thumb), do: thumb
  # def better(thumbs) when is_list(thumbs), do: List.first thumbs

  def choose_thumb(%Antenna{} = antenna, :entry) do
    choose_thumb(antenna)
  end
  def choose_thumb(%Antenna{} = antenna, :picture) do
    thumb = List.first antenna.picture.thumbs

    unless thumb, do: thumb = models_thumb(thumb, antenna.toons)
    unless thumb, do: thumb = models_thumb(thumb, antenna.toons, [:chars])
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :video) do
    thumb = List.first antenna.picture.thumbs
    unless thumb, do: thumb = models_thumb(thumb, antenna.divas)
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna) do
    thumb = List.first antenna.entry.thumbs
    unless thumb, do: thumb = List.first antenna.picture.thumbs

    thumb =
      thumb
      |> models_thumb(antenna.toons)
      |> models_thumb(antenna.toons, [:chars])
      |> models_thumb(antenna.divas)
      |> models_thumb(antenna.video.metadatas)
      |> models_thumb(antenna.tags)
  end

  def models_thumb(%Thumb{} = thumb, _models), do: thumb
  def models_thumb(thumb, models) do
    unless thumb do
      if model = List.first models do
        thumb = List.first model.thumbs
      end
    end

    thumb
  end
  def models_thumb(thumb, _models, []), do: thumb
  def models_thumb(thumb, models, [h|tail]) do
    unless thumb do
      if model = List.first models do
        if blank?(tail) do
          thumb = List.first model.thumbs
        else
          thumb = models_thumb(thumb, Map.get(model, h), tail)
        end
      end
    end

    thumb
  end

  def fallback, do: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"

end
