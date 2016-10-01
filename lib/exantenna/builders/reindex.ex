defmodule Exantenna.Builders.Reindex do

  def evolve do
    ExSentry.capture_exceptions fn ->
      evolve :tag
      evolve :toon
      evolve :char
      evolve :diva
    end
  end
  def evolve([]), do: evolve
  def evolve(:tag), do: evolve Exantenna.Tag
  def evolve(:toon), do: evolve Exantenna.Toon
  def evolve(:char), do: evolve Exantenna.Char
  def evolve(:diva), do: evolve Exantenna.Diva
  def evolve(mod), do: mod.esreindex

end
