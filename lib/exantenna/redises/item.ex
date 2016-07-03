defmodule Exantenna.Redises.Item do

  @uri Application.get_env(:exantenna, :redises)[:item]

  def conn do
    case Redix.start_link(@uri, name: :redises_item) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def all(key) do
    items = Redix.command!(conn, ~w(LRANGE #{key} 0 -1))
    Enum.map items, &Poison.Parser.parse! &1
  end

end
