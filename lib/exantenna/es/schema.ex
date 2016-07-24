defmodule Exantenna.Es.Schema do
  alias Exantenna.Es

  def completion(index) do
    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      settings do
        analysis do
          tokenizer "ngram_tokenizer",
            type: "nGram",  min_gram: "2", max_gram: "3",
              token_chars: ["letter", "digit"]

          analyzer "default",
            type: "custom", tokenizer: "ngram_tokenizer"
          analyzer "ngram_analyzer",
            tokenizer: "ngram_tokenizer"
        end
      end

      mappings do
        indexes "name",   type: "string", analyzer: "ngram_analyzer"
        indexes "kana",   type: "string", analyzer: "ngram_analyzer"
        indexes "alias",  type: "string", analyzer: "ngram_analyzer"
        indexes "romaji", type: "string", analyzer: "ngram_analyzer"
      end

      Es.Logger.ppdebug(index)

    index end)

  end
end
