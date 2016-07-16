defmodule Exantenna.ViewHelpers do
  use Phoenix.HTML
  import Exantenna.Gettext

  alias Exantenna.Thumb
  alias Exantenna.Antenna

  defdelegate blank?(word), to: Exantenna.Blank, as: :blank?

  def human_datetime(datetime) do
    Timex.format! datetime, "%F %R", :strftime
  end

  def pick(%Thumb{} = thumb), do: thumb
  def pick(thumbs) when is_list(thumbs), do: List.first thumbs

  # TODO: make sure that thumb are desc or asc in better ordering.
  # def better(%Thumb{} = thumb), do: thumb
  # def better(thumbs) when is_list(thumbs), do: List.first thumbs

  def choose_thumb(%Antenna{} = antenna, :entry) do
    thumb = List.first antenna.entry.thumbs
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :picture) do
    thumb = List.first antenna.picture.thumbs
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :video) do
    choose_thumb antenna, :picture
  end
  def choose_thumb(%Antenna{} = antenna) do
    thumb = List.first antenna.entry.thumbs

    unless thumb, do: thumb = List.first antenna.picture.thumbs
    unless thumb, do: thumb = List.first antenna.toons.thumbs
    unless thumb, do: thumb = List.first antenna.divas.thumbs
    unless thumb do
      if toon = List.first antenna.toons do
        if char = List.first toon.chars do
          thumb = List.first char.thumbs
        end
      end
    end
    unless thumb do
      if meta = List.first antenna.video.metadatas do
        thumb = List.first meta.thumbs
      end
    end
    unless thumb do
      if tag = List.first antenna.tags do
        thumb = List.first tag.thumbs
      end
    end

    thumb
  end

end
