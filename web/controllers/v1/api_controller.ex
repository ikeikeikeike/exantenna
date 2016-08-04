defmodule Exantenna.ApiController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna

  def parts(conn, params) do
    # chars =
      # Char.query  # TODO: query_all or query
      # # |> where([q], q.appeared > 0)
      # # |> order_by([q], [desc: q.appeared])
      # |> limit(100)
      # |> Repo.all

    # render(conn, "parts.json", chars: chars)
  end

end
