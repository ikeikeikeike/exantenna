defmodule Exantenna.Redis.Feed do

  use Exantenna.Redis,
    uri: Application.get_env(:exantenna, :redis)[:feed], type: :string

end
