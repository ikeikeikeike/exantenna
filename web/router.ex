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
  end

  pipeline :api do
    plug :accepts, ["json"]

    [host: host, port: port] =
      Application.get_env(:exantenna, Exantenna.Endpoint)[:url]

    fqdn = "#{host}:#{port}"

    plug CORSPlug,
      origin:      [fqdn, "http://#{fqdn}", "https://#{fqdn}"],
      credentials: true,
      methods:     ["POST", "OPTIONS"]

  end

  scope "/", Exantenna do
    pipe_through [:browser, :browser_auth]

    get "/", AntennaController, :home

    get "/new-stuff", EntryController, :index
    get "/news.html", EntryController, :index

    get "/hot-stuff", SummaryController, :index
    get "/hots.html", SummaryController, :index

    # TODO: consider redirecting below by nginx

    get "/divas", DivaController, :index
    get "/divas.html", DivaController, :index  # TODO: to be redirect
    get "/diva/:name", DivaController, :show

    get "/toons", ToonController, :index
    get "/animes.html", ToonController, :index  # TODO: to be redirect

    get "/characters", CharController, :index
    get "/characters.html", CharController, :index  # TODO: to be redirect

    get "/tag/:name", TagController, :show

    get "/orig", PageController, :index

    get "/suggest/tg/:search", TagController, :suggest
    get "/suggest/da/:search", DivaController, :suggest
    get "/suggest/tn/:search", ToonController, :suggest
    get "/suggest/cr/:search", CharController, :suggest

    scope "/feed" do
      get "/rdf.xml", FeedController, :xml
      get "/rss.xml", FeedController, :xml
      get "/atom.xml", FeedController, :xml
    end

    # TODO: need to redirect under line from /elog/v:id/:title and /elog/v:id by nginx
    scope "/s" do
      get "/:id", EntryController, :show
      get "/:id/:title", EntryController, :show
    end

    scope "/d", Diva, as: "d" do

      get "/atoz", AtozController, :index
      get "/atoz/:name", AtozController, :sub

      get "/birthday/:year/:month", BirthdayController, :month
      get "/birthday/:year", BirthdayController, :year
      get "/birthday", BirthdayController, :index

      get "/waist", WaistController, :index
      get "/waist/around-:name", WaistController, :sub

      get "/bracup", BracupController, :index
      get "/bracup/cup-:name", BracupController, :sub

      get "/bust", BustController, :index
      get "/bust/around-:name", BustController, :sub

      get "/hip", HipController, :index
      get "/hip/around-:name", HipController, :sub

      get "/height", HeightController, :index
      get "/height/around-:name", HeightController, :sub

      get "/blood-type", BloodController, :index
      get "/blood-type/:name", BloodController, :sub
      get "/blood", BloodController, :index
    end

    scope "/c", Char, as: "c" do
      get "/atoz", AtozController, :index
      get "/birthday/:year/:month", BirthdayController, :month
      get "/birthday/:year", BirthdayController, :year
      get "/birthday", BirthdayController, :index
      get "/waist", WaistController, :index

      get "/bracup", BracupController, :index
      get "/bracup/cup-:cup", BracupController, :cup

      get "/bust", BustController, :index
      get "/bust/around-:range", BustController, :around

      get "/hip", HipController, :index
      get "/height", HeightController, :index
      get "/blood-type", BloodController, :index
      get "/blood", BloodController, :index
    end

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

  scope "/v1", Exantenna.V1Api, as: "v1api" do
    pipe_through :api

    get "/parts.json", PartsController, :json
    post "/parts.json", PartsController, :json
    post "/parts.xml", PartsController, :json
    options "/parts.json", PartsController, :options
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exantenna do
  #   pipe_through :api
  # end
end
