defmodule Exantenna.Redis.Feed do

  use Exantenna.Redis,
    uri: Application.get_env(:exantenna, :redis)[:feed]

  def get(key) do
    case Redix.command!(pid, ~w(GET #{key})) do
      nil -> nil
      val -> Poison.Parser.parse!(val)
    end
  end

end
