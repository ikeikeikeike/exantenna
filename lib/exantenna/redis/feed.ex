defmodule Exantenna.Redis.Feed do

  use Rdtype,
    uri: Application.get_env(:exantenna, :redis)[:feed],
    coder: Exantenna.Redis.Json,
    type: :string

end
