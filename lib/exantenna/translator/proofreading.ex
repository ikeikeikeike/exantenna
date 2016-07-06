defmodule Exantenna.Translator.Proofreading do
  alias Translator.Proofreading, as: Proof

  def tag(word) when "" ==  word,  do: word
  def tag(word) when is_nil(word), do: word
  def tag(word) do
    word
    |> matched_sub_tags(Proof.filters[:tags])
  end

  defp matched_sub_tags(word, []), do: word
  defp matched_sub_tags(word, [map|tail]) do
    cond do
      word == map["from_word"] ->
        matched_sub_tags(map["to_word"], [])
      ! String.valid?(word) ->
        # XXX: invalid char to be change random word.
        matched_sub_tags(Enum.random(tail)["to_word"], [])
      true ->
        matched_sub_tags(word, tail)
    end
  end

  # sentence needs data types below.
  #
  #  - from_word: 'from word'
  #  - to_word: 'to_word'
  #  or
  #  - from_word: 'from word'
  #  - to_word: 'word1,word2,ward3'
  #
  def sentence(word) when "" ==  word,  do: word
  def sentence(word) when is_nil(word), do: word
  def sentence(word) do
    filters = Proof.filters

    word
    |> sub_tags(filters[:tags])
    |> sub_sentences(filters[:sentences])
  end

  defp sub_tags(word, []), do: word
  defp sub_tags(word, [map|tail]) do
    word
    |> String.replace(map["from_word"], map["to_word"])
    |> sub_tags(tail)
  end

  defp sub_sentences(word, []), do: word
  defp sub_sentences(word, [map|tail]) do
    value = Enum.random(String.split(map["to_word"], ","))

    word
    |> String.replace(map["from_word"], value)
    |> sub_sentences(tail)
  end

  def configure do
    filters =
      Application.get_env(:exantenna, :translate_filters)[:db]

    start_link([
      tags: filters["tags"],
      sentences: filters["sentences"]]
    )
    {:ok, []}
  end

  def configure(tags_filter, sentences_filter) do
    start_link([
      tags: tags_filter,
      sentences: sentences_filter]
    )
    {:ok, []}
  end

  defp start_link(value) do
    Agent.start_link(fn -> value end, name: __MODULE__)
  end

  @doc """
  Get the filters
  """
  def filters do
    Agent.get(__MODULE__, fn config -> config end)
  end

end
