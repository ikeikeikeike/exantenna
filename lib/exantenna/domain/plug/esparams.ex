defmodule Exantenna.Domain.Plug.Esparams do
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    if sub = conn.private[:subdomain] do
      filter = %{"is_#{sub}": true}

      params = Map.merge(conn.params, %{
        "filter" => filter, "subdomain" => sub
      })
    end

    struct conn, [params: params]
  end

end
