defmodule Exantenna.Repo do
  use Ecto.Repo, otp_app: :exantenna
  use Scrivener, page_size: 50
  use Tributary
end
