defmodule Exantenna.Repo do
  use Ecto.Repo, otp_app: :exantenna
  use Scrivener, page_size: 200
end
