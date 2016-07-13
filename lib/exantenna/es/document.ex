defmodule Exantenna.Es.Document do
  import Tirexs.Bulk
  alias Exantenna.Es

  def put_document(model), do: put_document model, Es.Index.name_index(model.__struct__)
  def put_document(%{} = model, name), do: put_document [model], name
  def put_document(models, name) when is_list(models) do
    mod = List.first(models).__struct__

    idx = [type: mod.estype, index: mod.esindex(name)]

    payload =
      bulk do
        index idx, Enum.map(models, &mod.search_data(&1))
      end

    Tirexs.bump!(payload)._bulk({[refresh: true]})
  end
  def put_document([], _name), do: :error

  def delete_document(model), do: delete_document model, Es.Index.name_index(model.__struct__)
  def delete_document(%{} = model, name), do: delete_document [model], name
  def delete_document(models, name) when is_list(models) do
    mod = List.first(models).__struct__

    idx = [type: mod.estype, index: mod.esindex(name)]

    payload =
      bulk do
        delete idx, Enum.map(models, &mod.search_data(&1))
      end

    Tirexs.bump!(payload)._bulk({[refresh: true]})
  end
  def delete_document([], _name), do: :error

end
