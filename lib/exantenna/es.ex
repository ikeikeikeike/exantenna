defmodule Exantenna.Es do

  require Logger

  def name_type(mod) do
    mod
    |> to_string
    |> String.downcase
    |> String.split(".")
    |> Enum.join("_")
  end

  def pprint(index) do
    url  = Tirexs.HTTP.url(index[:index])
    json = JSX.prettify!(JSX.encode!(Tirexs.Mapping.to_resource_json(index)))
    Logger.debug "\n# => curl -X PUT -d '#{json}' #{url}"
  end

end
