defmodule Exantenna.Router do
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

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource

    plug Exantenna.Locale.Plug.AssignLocale
    plug Exantenna.Locale.Plug.HandleLocalizedPath
    plug Exantenna.Locale.Plug.ConfigureGettext
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Exantenna do
    pipe_through [:browser, :browser_auth]

    get "/", AntennaController, :home
    get "/news", EntryController, :index
    get "/news.html", EntryController, :index

    get "/elog/:id", EntryController, :show
    get "/elog/:id/:title", EntryController, :show

    get "/divas", DivaController, :index
    get "/divas.html", DivaController, :index  # TODO: to be redirect

    get "/diva/:name", DivaController, :show

    get "/d/atoz", Diva.AtozController, :index
    get "/d/birthday/:year/:month", Diva.BirthdayController, :month
    get "/d/birthday/:year", Diva.BirthdayController, :year
    get "/d/birthday", Diva.BirthdayController, :index
    get "/d/bracup", Diva.BracupController, :index
    get "/d/waist", Diva.WaistController, :index
    get "/d/bust", Diva.BustController, :index
    get "/d/hip", Diva.HipController, :index
    get "/d/height", Diva.HeightController, :index
    get "/d/blood", Diva.BloodController, :index

    get "/toons", ToonController, :index
    get "/animes.html", ToonController, :index  # TODO: to be redirect

    get "/characters", CharController, :index
    get "/characters.html", CharController, :index  # TODO: to be redirect

    get "/orig", PageController, :index

    get "/suggest/tg/:search", TagController, :suggest
    get "/suggest/da/:search", DivaController, :suggest
    get "/suggest/tn/:search", ToonController, :suggest
    get "/suggest/cr/:search", CharController, :suggest

  end

  scope "/admin", Exantenna.Admin, as: "admin" do
    pipe_through [:browser, :browser_auth]

    get "/auth/signin", AuthController, :signin
    get "/auth/signup", AuthController, :signup
    delete "/auth/logout", AuthController, :logout
    post "/auth/register", AuthController, :register
    get "/auth/register_confirm/:token", AuthController, :register_confirm

    get "/auth/:provider", AuthController, :login
    get "/auth/:provider/callback", AuthController, :callback
    post "/auth/:provider/callback", AuthController, :identity_callback

    get    "/", UserController, :dashboard
    resources  "/blogs", BlogController

  end


  # Other scopes may use custom stacks.
  # scope "/api", Exantenna do
  #   pipe_through :api
  # end
end
