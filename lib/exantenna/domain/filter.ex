defmodule Exantenna.Domain.Filter do

  def book?(%Plug.Conn{} = conn) do
    case conn.private[:subdomain] do
      :book  -> true
      "book" -> true
      _  -> false
    end
  end

  def video?(%Plug.Conn{} = conn) do
    case conn.private[:subdomain] do
      :video  -> true
      "video" -> true
      _  -> false
    end
  end

  def what(%Plug.Conn{} = conn) do
    conn.private[:subdomain]
  end

end
