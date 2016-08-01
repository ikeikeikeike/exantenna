defmodule Exantenna.Redis.Inlog do

  use Rdtype,
    uri: Application.get_env(:exantenna, :redis)[:inlog],
    coder: Exantenna.Redis.Json,
    type: :list

  def inlogs do
    all("inlog")
  end

end
