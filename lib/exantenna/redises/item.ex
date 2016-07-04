defmodule Exantenna.Redises.Item do

  use Exantenna.Redises.Redis,
    uri: Application.get_env(:exantenna, :redises)[:item]

  def shift(key) do
    case Redix.command!(pid, ~w(LPOP #{key})) do
      nil -> nil
      val -> Poison.Parser.parse!(val)
    end
  end

  def all(key) do
    Redix.command!(pid, ~w(LRANGE #{key} 0 -1))
    |> Enum.map(&Poison.Parser.parse!(&1))
  end

end
