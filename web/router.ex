defmodule Exantenna.Router do
  use Exantenna.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Exantenna do
    pipe_through [:browser, :browser_auth]

    get "/", EntryController, :index
    get "/orig", PageController, :index
  end

  scope "/admin", Exantenna.Admin, as: "admin" do
    pipe_through [:browser, :browser_auth]

    get    "/auth/signin", AuthController, :signin
    get    "/auth/signup", AuthController, :signup
    delete "/auth/logout", AuthController, :logout
    post   "/auth/register", AuthController, :register
    get    "/auth/register_confirm/:token", AuthController, :register_confirm

    get    "/auth/:provider", AuthController, :login
    get    "/auth/:provider/callback", AuthController, :callback
    post   "/auth/:provider/callback", AuthController, :identity_callback

    get    "/", UserController, :dashboard
    resources  "/blogs", BlogController

  end


  # Other scopes may use custom stacks.
  # scope "/api", Exantenna do
  #   pipe_through :api
  # end
end
