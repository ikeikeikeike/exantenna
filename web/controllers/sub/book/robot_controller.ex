defmodule Exantenna.Sub.Book.RobotController do
  use Exantenna.Web, :controller
  defdelegate index(conn, params), to: Exantenna.RobotController
end
