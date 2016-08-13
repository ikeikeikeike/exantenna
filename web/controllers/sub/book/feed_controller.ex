defmodule Exantenna.Sub.Book.FeedController do
  use Exantenna.Web, :controller

  plug DomainPlug.Esparams

  defdelegate xml(conn, params), to: Exantenna.FeedController

end
