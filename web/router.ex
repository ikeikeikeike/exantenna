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

    get "/", PageController, :index
  end

  scope "/admin", Exantenna.Admin, as: "admin" do
    pipe_through [:browser, :browser_auth]

    get  "/auth/signup", LoginController, :signup
    post "/auth/register", LoginController, :register
    get  "/auth/register_confirm/:token", LoginController, :register_confirm
    get  "/auth/signup", LoginController, :signup

    get  "/auth/:provider", AuthController, :login
    get  "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :identity_callback
    delete "/auth/logout", AuthController, :logout

    get  "/", UserController, :dashboard

  end


  # Other scopes may use custom stacks.
  # scope "/api", Exantenna do
  #   pipe_through :api
  # end
end
