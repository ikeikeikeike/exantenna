defmodule Exantenna.Router.Video do
  use Exantenna.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Exantenna.Locale.Plug.AssignLocale
    plug Exantenna.Locale.Plug.HandleLocalizedPath
    plug Exantenna.Locale.Plug.ConfigureGettext
  end

  scope "/", Exantenna.Sub.Video do
    pipe_through :browser # Use the default browser stack

    get "/", AntennaController, :index

    get "/news", EntryController, :index
    get "/news.html", EntryController, :index

    # TODO: need to redirect under line from /video/v:id/:title and /video/v:id by nginx
    scope "/s" do
      get "/:id", EntryController, :show
      get "/:id/:title", EntryController, :show
    end

  end


end
