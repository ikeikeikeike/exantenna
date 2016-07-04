defmodule Exantenna.Redises.Feed do

  use Exantenna.Redises.Redis,
    uri: Application.get_env(:exantenna, :redises)[:feed]

  def get(key) do
    case Redix.command!(pid, ~w(GET #{key})) do
      nil -> nil
      val -> Poison.Parser.parse!(val)
    end
  end

end
