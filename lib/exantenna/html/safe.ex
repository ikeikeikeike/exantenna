defmodule Exantenna.HTML.Safe do

  def safe_router(path) do
    Regex.replace(~r/\\|\/|\:/, path, "-")
  end

end
