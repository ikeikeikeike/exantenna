# XXX: OMG https://github.com/Zatvobor/tirexs/issues/173

defmodule Exantenna.Es.Filter do
  import Tirexs.Query
  import Tirexs.Search
  require Tirexs.Query.Filter

  def is_(%{is_summary: is_summary, is_video: is_video, is_book: is_book}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_summary", [is_summary]
          terms "is_video",   [is_video]
          terms "is_book",    [is_book]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_video: is_video, is_book: is_book}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_video",   [is_video]
          terms "is_book",    [is_book]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_summary: is_summary, is_video: is_video}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_summary", [is_summary]
          terms "is_video",   [is_video]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_summary: is_summary, is_book: is_book}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_summary", [is_summary]
          terms "is_book",    [is_book]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_summary: is_summary}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_summary", [is_summary]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_video: is_video}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_video",   [is_video]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(%{is_book: is_book}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_book",    [is_book]
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def is_(_) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "is_summary", [true, false]
          terms "is_video",   [true, false]
          terms "is_book",    [true, false]
        end
      end
    end
    |> Keyword.get(:filter)
  end

end
