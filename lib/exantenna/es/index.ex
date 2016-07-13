defmodule Exantenna.Es.Index do
  import Tirexs.Manage.Aliases

  alias Tirexs.HTTP
  alias Tirexs.Resources
  alias Tirexs.Resources.Indices

  alias Exantenna.Es

  def name_index(mod) do
    index =
      mod
      |> to_string
      |> String.split(".")
      |> List.last
      |> String.downcase

    "es_#{index}"
  end

  def name_type(mod) do
    mod
    |> to_string
    |> String.downcase
    |> String.split(".")
    |> Enum.join("_")
  end

  def reindex(mod), do: reindex(mod, [])
  def reindex(mod, data) do

    index = name_index(mod)

    # create new index if es doesn't have that.
    #
    if ! get_aliase(index) do
        newidx = name_reindex(index)

        mod.create_esindex(newidx)

        aliasquery =
          aliases do
            add index: newidx, alias: index
          end

        Es.Logger.ppdebug aliasquery
        Resources.bump(aliasquery)._aliases
    end

    old_index = get_aliase(index)
    new_index = name_reindex(index)

    # create new index
    #
    mod.create_esindex(new_index)

    #
    # Send data to es
    #
    Es.Document.put_document(data, new_index)

    # change alias
    #
    aliasquery =
      (aliases do
        remove index: old_index, alias: index
        add    index: new_index, alias: index
      end)
    Es.Logger.ppdebug aliasquery
    Resources.bump(aliasquery)._aliases

    # remove old index
    HTTP.delete("#{old_index}")

    :ok
  end

  defp name_reindex(index) do
    suffix =
      Timex.DateTime.now
      |> Timex.format!("%Y%m%d%H%M%S%f", :strftime)

    "#{index}_#{suffix}"
  end

  defp get_aliase(index) do
    case HTTP.get(Indices._aliases(index)) do
      {:ok, 200, map} ->
        alias =
          map
          |> Dict.keys
          |> List.first
          |> to_string

      _ -> nil
    end
  end

end
