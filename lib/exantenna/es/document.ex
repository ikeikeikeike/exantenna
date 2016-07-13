defmodule Exantenna.Es.Document do
  import Tirexs.Bulk

  def put_document(model), do: put_document model, Es.name_index(model.__struct__)
  def put_document(%{} = model, name), do: put_document [model], name
  def put_document([%{}] = model, name) do
    mod = model.__struct__

    idx = [type: mod.estype, index: mod.esindex(name)]

    payload =
      bulk do
        index idx, Enum.map(model, &mod.search_data(&1))
      end

    Tirexs.bump!(payload)._bulk
  end
  def put_document([], _name), do: :error

  def delete_document(model), do: delete_document model, Es.name_index(model.__struct__)
  def delete_document(%{} = model, name), do: delete_document [model], name
  def delete_document([%{}] = model, name) do
    mod = model.__struct__

    idx = [type: mod.estype, index: mod.esindex(name)]

    payload =
      bulk do
        delete idx, Enum.map(model, &mod.search_data(&1))
      end

    Tirexs.bump!(payload)._bulk
  end
  def delete_document([], _name), do: :error

end
