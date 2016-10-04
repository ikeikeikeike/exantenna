defmodule Exantenna.Builders.Translation do
  alias Exantenna.Repo
  alias Exantenna.Tag
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Char

  import Ecto.Query, only: [from: 1, from: 2]
  require Logger

  def tag do
    from(u in Tag)
    |> Repo.stream
    |> Stream.each(fn model ->
      update_ruby model
    end)
    |> Stream.run
  end

  def diva do
    from(u in Diva)
    |> Repo.stream
    |> Stream.each(fn model ->
      update_ruby model
    end)
    |> Stream.run
  end

  def toon do
    from(u in Toon)
    |> Repo.stream
    |> Stream.each(fn model ->
      update_ruby model
    end)
    |> Stream.run
  end

  def char do
    from(u in Char)
    |> Repo.stream
    |> Stream.each(fn model ->
      update_ruby model
    end)
    |> Stream.run
  end

  def update_ruby(%{kana: _, romaji: _, gyou: _} = model) do
    ExSentry.capture_exceptions fn ->
      params = %{
        "kana" => Exkanji.hira(model.name),
        "romaji" => Exkanji.romaji(model.name),
        "gyou" => sound_romaji(model.name),
      }

      Repo.update model.__struct__.changeset(model, params)
    end
  end

  defp sound_romaji(word) do
    word
    |> Exkanji.sound
    |> Exkanji.romaji
  end

end
