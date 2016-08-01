defmodule Exantenna.Sub.Book.FeedController do
  use Exantenna.Web, :controller

  defdelegate xml(conn, params), to: Exantenna.FeedController

end
