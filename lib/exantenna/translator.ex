defmodule Exantenna.Translator do
  alias Exantenna.Translator.Bing
  alias Exantenna.Translator.Proofreading

  @doc """
  translator
  """
  defdelegate translate?(word), to: Bing, as: :translate?
  defdelegate translate(word), to: Bing, as: :translate
  defdelegate translate(word, opts), to: Bing, as: :translate

  @doc """
  Proofreading
  """
  defdelegate tag(word), to: Proofreading, as: :tag
  defdelegate sentence(word), to: Proofreading, as: :sentence

  @doc """
  configuration
  """
  def configure do
    BingTranslator.configure
    Proofreading.configure
  end
end
