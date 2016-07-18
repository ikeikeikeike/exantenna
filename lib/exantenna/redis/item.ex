defmodule Exantenna.Redis.Item do

  use Rdtype,
    uri: Application.get_env(:exantenna, :redis)[:item],
    coder: Exantenna.Redis.Json,
    type: :list

end
