defmodule Exantenna.Router.Book do
  use Exantenna.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  scope "/", Exantenna.Sub.Book do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

end
