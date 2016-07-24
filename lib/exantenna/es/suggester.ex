defmodule Exantenna.Es.Suggester do
  alias Exantenna.Repo

  def response(tirexs) do
    Enum.map tirexs[:hits][:hits], fn hit ->
      List.first(hit[:fields][:name])
    end
  end

  def completion(model, word) do
    ConCache.get_or_store :es, "#{model}:suggester:#{word}", fn ->
      word
      |> String.split(".")
      |> List.first
      |> model.essearch
      |> response
    end
  end

end
