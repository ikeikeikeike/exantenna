defmodule Exantenna.Es.Q do
  alias Exantenna.Es

  def completion(word, index) do
    Tirexs.DSL.define fn ->
      import Tirexs.Search

      q =
        search [index: index, from: 0, size: 5, fields: [:name]] do
          query do
            dis_max do
              queries do
                multi_match word, ["name"]
                prefix "name", word
                multi_match word, ["kana"]
                prefix "kana", word
                multi_match word, ["alias"]
                prefix "alias", word
                multi_match word, ["romaji"]
                prefix "romaji", word
              end
            end
          end
          # sort do
            # [published_at: [order: "desc"]]
          # end
        end

      Es.Logger.ppdebug(q)

      q
    end
  end
end
