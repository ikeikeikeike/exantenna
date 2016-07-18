defmodule Exantenna.Redis.Imginfo do

  use Rdtype,
    uri: Application.get_env(:exantenna, :redis)[:imginfo],
    coder: Exantenna.Redis.Json,
    type: :string

end
