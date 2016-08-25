defmodule Exantenna.Builders.Summary do

  alias Exantenna.Blank
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Score.Inlog

  require Logger

  def aggs do
    Exantenna.Builders.Score.inscore_into

  end

end
