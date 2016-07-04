defmodule Exantenna.Redises.Item do

  @uri Application.get_env(:exantenna, :redises)[:item]

  def conn do
    case Redix.start_link(@uri, name: :redises_item) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def shift(key) do
    case Redix.command!(conn, ~w(LPOP #{key})) do
      nil -> nil
      val -> Poison.Parser.parse!(val)
    end
  end

  def all(key) do
    Redix.command!(conn, ~w(LRANGE #{key} 0 -1))
    |> Enum.map(&Poison.Parser.parse!(&1))
  end

end
