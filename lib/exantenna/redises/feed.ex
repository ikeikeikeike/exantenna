defmodule Exantenna.Redises.Feed do

  @uri Application.get_env(:exantenna, :redises)[:feed]

  def conn do
    case Redix.start_link(@uri, name: :redises_feed) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def get(key) do
    case Redix.command!(conn, ~w(GET #{key})) do
      nil -> nil
      val -> Poison.Parser.parse!(val)
    end
  end

end
