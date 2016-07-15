defmodule Exantenna.Redis.Imginfo do

  use Exantenna.Redis,
    uri: Application.get_env(:exantenna, :redis)[:imginfo], type: :string

end
