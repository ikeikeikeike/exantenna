defmodule Exantenna.Redis.Item do

  use Exantenna.Redis,
    uri: Application.get_env(:exantenna, :redis)[:item], type: :list

end
