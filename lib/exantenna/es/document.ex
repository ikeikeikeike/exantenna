defmodule Exantenna.Es.Document do
  import Tirexs.Bulk
  alias Exantenna.Es
  alias Exantenna.Blank

  def put_document(model), do: put_document model, Es.Index.name_index(model.__struct__)
  def put_document(%{} = model, name), do: put_document [model], name
  def put_document(models, name) when is_list(models), do: put_document models, name, List.first(models).__struct__
  def put_document([], _name), do: :error
  def put_document(models, name), do: put_document models, name, List.first(Enum.take(models, 1)).__struct__
  def put_document(models, name, mod) do
    idx = [type: mod.estype, index: mod.esindex(name)]

    data =
      models
      |> Stream.map(&mod.search_data(&1))
      |> Stream.filter(fn item -> ! Blank.blank?(item) end)

    payload =
      bulk do
        index idx, data
      end

    Tirexs.bump!(payload)._bulk({[refresh: true]})
  end

  def delete_document(model), do: delete_document model, Es.Index.name_index(model.__struct__)
  def delete_document(%{} = model, name), do: delete_document [model], name
  def delete_document(models, name) when is_list(models), do: delete_document models, name, List.first(models).__struct__
  def delete_document([], _name), do: :error
  def delete_document(models, name), do: delete_document models, name, List.first(Enum.take(models, 1)).__struct__
  def delete_document(models, name, mod) do
    idx = [type: mod.estype, index: mod.esindex(name)]

    payload =
      bulk do
        delete idx, Stream.map(models, &mod.search_data(&1))
      end

    Tirexs.bump!(payload)._bulk({[refresh: true]})
  end

end
