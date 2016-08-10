defmodule Exantenna.HTML.Safe do

  def safe_router(path) do
    Regex.replace(~r/\\|\/|\:|\(|\)\|\'/, path, "-")
  end

  def sha256(data) do
    ConCache.get_or_store(:common, "sha256:#{data}", fn ->
      :crypto.hash(:common, data) |> Base.encode16(case: :lower)
    end)
  end

end
