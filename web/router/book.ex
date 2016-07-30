defmodule Exantenna.Router.Book do
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

  scope "/", Exantenna.Sub.Book do
    pipe_through :browser # Use the default browser stack

    get "/", AntennaController, :home
    get "/news", EntryController, :index
    get "/news.html", EntryController, :index

    # TODO: need to redirect under line from /video/v:id/:title and /video/v:id by nginx
    scope "/s" do
      get "/:id", EntryController, :show
      get "/:id/:title", EntryController, :show
    end

    # TODO: consider redirecting below by nginx

    get "/divas", DivaController, :index
    get "/divas.html", DivaController, :index  # TODO: to be redirect
    get "/diva/:name", DivaController, :show

    get "/toons", ToonController, :index
    get "/animes.html", ToonController, :index  # TODO: to be redirect

    get "/characters", CharController, :index
    get "/characters.html", CharController, :index  # TODO: to be redirect

    get "/orig", PageController, :index

    get "/suggest/tg/:search", TagController, :suggest
    get "/suggest/da/:search", DivaController, :suggest
    get "/suggest/tn/:search", ToonController, :suggest
    get "/suggest/cr/:search", CharController, :suggest

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

end
