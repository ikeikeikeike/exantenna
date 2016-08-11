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

    get "/", AntennaController, :index

    get "/new-stuff", EntryController, :index
    get "/news.html", EntryController, :index
    # TODO: need to redirect under line from /elog/v:id/:title and /elog/v:id by nginx
    scope "/s" do
      get "/:id", EntryController, :show
      get "/:id/:title", EntryController, :show
    end

    get "/hot-stuff", SummaryController, :index
    get "/hots.html", SummaryController, :index

    # XXX: redirect from search path
    get "/search.html", AntennaController, :index

    get "/tags", TagController, :index
    get "/tags.html", TagController, :index
    get "/tag/:name", TagController, :show

    # TODO: need to redirect under line from /blog/v:id/:title and /blog/v:id by nginx
    get "/blogs", BlogController, :index
    scope "/b" do
      get "/:id", BlogController, :show
      get "/:id/:name", BlogController, :show
    end

    get "/orig", PageController, :index

    get "/suggest/tg/:search", TagController, :suggest
    get "/suggest/da/:search", DivaController, :suggest
    get "/suggest/tn/:search", ToonController, :suggest
    get "/suggest/cr/:search", CharController, :suggest

    get "/about", AboutController, :index
    get "/abouts.html", AboutController, :index

    scope "/media" do
      get "/", MediaController, :index
      get "/rss", MediaController, :rss
      get "/parts", MediaController, :parts
      get "/links", MediaController, :links
    end

    get "/register.html", MediaController, :index
    scope "/register" do
      # get ".html", MediaController, :index
      get "/rss.html", MediaController, :rss
      get "/parts.html", MediaController, :parts
      get "/links.html", MediaController, :links
    end

    scope "/feed" do
      get "/rdf.xml", FeedController, :xml
      get "/rss.xml", FeedController, :xml
      get "/atom.xml", FeedController, :xml
    end

    # TODO: consider redirecting below by nginx

    get "/divas", DivaController, :index
    get "/divas.html", DivaController, :index  # TODO: to be redirect
    get "/diva/:name", DivaController, :show

    get "/toons", ToonController, :index
    get "/animes.html", ToonController, :index  # TODO: to be redirect
    get "/toon/:name", ToonController, :show

    get "/characters", CharController, :index
    get "/characters.html", CharController, :index  # TODO: to be redirect
    get "/character/:name", CharController, :show

    scope "/t", Toon, as: "t" do

      get "/atoz/:name", AtozController, :sub
      get "/atoz", AtozController, :index

      get "/release/:year/:month", ReleaseController, :month
      get "/release/:year", ReleaseController, :year
      get "/release", ReleaseController, :index

      get "/works/:name", WorksController, :sub
      get "/works", WorksController, :index

      get "/author/:name", AuthorController, :sub
      get "/author", AuthorController, :index

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
