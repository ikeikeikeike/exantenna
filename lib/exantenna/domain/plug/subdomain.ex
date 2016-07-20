defmodule Exantenna.Domain.Plug.Subdomain do
  import Plug.Conn

  @doc false
  def init(default) do
    default
  end

  @doc false
  def call(conn, routers) do
    case get_subdomain(conn, routers) do
      {subdomain, router} when byte_size(subdomain) > 0 ->
        conn
        |> put_private(:subdomain, subdomain)
        |> router.call(router.init({}))
        |> halt
      _ -> conn
    end
  end

  defp get_subdomain(conn, routers) do
    routers
    |> Enum.filter(fn {domain, _router} ->
      name = to_string(domain)
      String.starts_with?(conn.host, "#{name}.")
    end)
    |> Enum.map(fn {domain, router} ->
      {to_string(domain), router}
    end)
    |> List.first
  end
end
