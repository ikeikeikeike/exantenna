defmodule Exantenna.Ecto.Q do
  import Ecto.Query, only: [from: 1, from: 2]

  alias Exantenna.Repo
  alias Exantenna.Blank

  def exists?(queryable) do
    query =
      Ecto.Query.from(x in queryable, limit: 1)
      |> Ecto.Queryable.to_query

    case Repo.all(query) do
      [] -> false
      _  -> true
    end
  end

  def fuzzy_find(mod, name) when is_nil(name), do: fuzzy_find(mod, [])
  def fuzzy_find(mod, name) when is_bitstring(name) do
    case String.split(name, ~r(、|（|）)) do
      names when length(names) == 1 ->
        diva = Repo.get_by(mod, name: List.first(names))
        if diva, do: diva, else: fuzzy_find mod, names

      names when length(names)  > 1 ->
        fuzzy_find mod, names

      _ -> nil
    end
  end
  def fuzzy_find(_mod, []), do: nil
  def fuzzy_find(mod, [name|tail]) do
    case Blank.blank?(name) do
      true  -> fuzzy_find(mod, tail)
      false ->
        query =
          from p in mod,
            where: ilike(p.name, ^"%#{name}%"),
            limit: 1

        fuzzy_find(mod, [], Repo.one(query))
    end
  end
  def fuzzy_find(_mod, [], diva), do: diva

end
