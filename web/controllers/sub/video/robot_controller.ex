defmodule Exantenna.Sub.Video.RobotController do
  use Exantenna.Web, :controller
  defdelegate index(conn, params), to: Exantenna.RobotController
end
