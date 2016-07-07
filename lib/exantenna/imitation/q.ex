defmodule Exantenna.Imitation.Q do

  def find_or_create(query, cset) do
    case model = Exantenna.Repo.one(query) do
      nil ->
        case Exantenna.Repo.insert(cset) do
          {:ok, model} ->
            {:new, model}

          {:error, cset} ->
            {:error, cset}
        end
      _ ->
        {:ok, model}
    end
  end

end
