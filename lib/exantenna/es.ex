defmodule Exantenna.Es do

  require Logger

  def ppdebug([type: _, index: _, mapping: _, settings: _] = index) do
    url  = Tirexs.HTTP.url(index[:index])
    json = JSX.prettify!(JSX.encode!(Tirexs.Mapping.to_resource_json(index)))
    Logger.debug "\n# => curl -X PUT -d '#{json}' #{url}"
  end

  def ppdebug([type: _, index: _, mapping: _] = index) do
    url  = Tirexs.HTTP.url(index[:index])
    json = JSX.prettify!(JSX.encode!(Tirexs.Mapping.to_resource_json(index)))
    Logger.debug "\n# => curl -X PUT -d '#{json}' #{url}"
  end

  def ppdebug([type: _, index: _, settings: _] = index) do
    url  = Tirexs.HTTP.url(index[:index])
    json = JSX.prettify!(JSX.encode!(Tirexs.ElasticSearch.Settings.to_resource_json(index)))
    Logger.debug "\n# => curl -X PUT -d '#{json}' #{url}"
  end

  def ppdebug([type: _, index: _, search: _] = index) do
    url  = Tirexs.HTTP.url(index[:index])
    json = JSX.prettify!(JSX.encode!(Tirexs.Query.to_resource_json(index)))
    Logger.debug "\n# => curl -X PUT -d '#{json}' #{url}"
  end

  # def ppdebug(query) do
    # json = JSX.prettify!(JSX.encode!(query))
    # Logger.debug json
  # end

end
