defmodule Exantenna.Router.Book do
  use Exantenna.Web, :router
  use ExSentry.Plug

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
    get "/robots.txt", RobotController, :index
  end

  scope "/", Exantenna.Sub.Book do
    pipe_through :browser # Use the default browser stack

    get "/", AntennaController, :index

    get "/new-stuff", EntryController, :index
    get "/news.html", EntryController, :index
    # TODO: need to redirect under line from /elog/v:id/:title and /elog/v:id by nginx
    scope "/s" do
      # TODO: need to redirect under line from /book/viewer:id and /book/viewer:id/:title by nginx
      get "/:id/viewer", EntryController, :view
      get "/:id/viewer/:title", EntryController, :view

      get "/:id", EntryController, :show
      get "/:id/:title", EntryController, :show
    end

    get "/hot-stuff", SummaryController, :index
    get "/hots.html", SummaryController, :index

    # XXX: redirect from search path
    get "/search.html", AntennaController, :index

    get "/tags", TagController, :index
    get "/tags.html", TagController, :index

    get "/tag/:id/:name", TagController, :show
    get "/tag/:name", TagController, :show

    # TODO: need to redirect under line from /blog/v:id/:title and /blog/v:id by nginx
    get "/blogs", BlogController, :index
    scope "/b" do
      get "/:id", BlogController, :show
      get "/:id/:name", BlogController, :show
    end

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
      get "/", FeedController, :xml
      get "/rdf.xml", FeedController, :xml
      get "/rss.xml", FeedController, :xml
      get "/atom.xml", FeedController, :xml
    end

    # TODO: consider redirecting below by nginx

    get "/divas", DivaController, :index
    get "/divas.html", DivaController, :index  # TODO: to be redirect

    get "/diva/:id/:name", DivaController, :show
    get "/diva/:name", DivaController, :show

    get "/toons", ToonController, :index
    get "/animes.html", ToonController, :index  # TODO: to be redirect

    get "/toon/:id/:name", ToonController, :show
    get "/toon/:name", ToonController, :show
    get "/anime/:name", ToonController, :show  # TODO: to be redirect

    get "/characters", CharController, :index
    get "/characters.html", CharController, :index  # TODO: to be redirect

    get "/character/:id/:name", CharController, :show
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

end
