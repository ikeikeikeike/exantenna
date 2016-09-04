defmodule Exantenna.Sitemap do
  use Sitemap

  alias Exantenna.Repo

  alias Exantenna.Tag
  alias Exantenna.Blog
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Char
  alias Exantenna.Antenna

  alias Exantenna.Router.Helpers

  def gen_sitemap([]), do: gen_sitemap
  def gen_sitemap do
    metas = Application.get_env(:exantenna, :sitemetas)

    Enum.each metas, fn {name, meta} ->
      gen_sitemap name, meta[:fqdn]
    end
  end

  def gen_sitemap(name, host) do
    create [filename: "#{name}.sitemap", host: host] do

      antennas =
        Antenna
        |> Repo.all

      blogs =
        Blog
        |> Repo.all

      divas =
        Diva
        |> Repo.all

      toons =
        Toon
        |> Repo.all

      chars =
        Char
        |> Repo.all

      tags =
        Tag
        |> Repo.all

      Enum.each [false, true], fn bool ->

        add Helpers.antenna_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.entry_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.summary_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.tag_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.blog_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.diva_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.toon_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.char_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.t_atoz_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.t_release_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.t_works_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.t_author_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.d_atoz_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_birthday_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_waist_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_bracup_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_bust_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_hip_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_height_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.d_blood_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.c_atoz_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_birthday_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_waist_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_bracup_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_bust_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_hip_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_height_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        add Helpers.c_blood_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        current_year = Timex.DateTime.now.year

        beginning_year = 1966  # TODO: Getting begging year from database.
        Enum.each beginning_year..(current_year - 18), fn year ->
          add Helpers.d_birthday_path(Exantenna.Endpoint, :year, year),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

          Enum.each 1..12, fn month ->
            add Helpers.d_birthday_path(Exantenna.Endpoint, :month, year, month),
              priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
          end
        end

        beginning_year = 1966  # TODO: Getting begging year from database.
        Enum.each beginning_year..current_year, fn year ->
          add Helpers.c_birthday_path(Exantenna.Endpoint, :year, year),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

          Enum.each 1..12, fn month ->
            add Helpers.c_birthday_path(Exantenna.Endpoint, :month, year, month),
              priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
          end
        end

        beginning_year = 1966  # TODO: Getting begging year from database.
        Enum.each beginning_year..current_year, fn year ->
          add Helpers.t_release_path(Exantenna.Endpoint, :year, year),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

          Enum.each 1..12, fn month ->
            add Helpers.t_release_path(Exantenna.Endpoint, :month, year, month),
              priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
          end
        end

        Enum.each antennas, fn m ->
          add Helpers.entry_path(Exantenna.Endpoint, :show, m.id),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

        if name == :book do
          Enum.each antennas, fn m ->
            add Helpers.entry_path(Exantenna.Endpoint, :view, m.id),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
          end
        end

        Enum.each blogs, fn m ->
          add Helpers.blog_path(Exantenna.Endpoint, :show, m.id),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

        Enum.each tags, fn m ->
          add Helpers.tag_path(Exantenna.Endpoint, :show, m.name),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

        Enum.each divas, fn m ->
          add Helpers.diva_path(Exantenna.Endpoint, :show, m.name),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

        Enum.each toons, fn m ->
          add Helpers.tag_path(Exantenna.Endpoint, :show, m.name),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

        Enum.each chars, fn m ->
          add Helpers.tag_path(Exantenna.Endpoint, :show, m.name),
            priority: 0.5, changefreq: nil, expires: nil, mobile: bool
        end

      end
    end

    ping ~w(
    http://api.my.yahoo.co.jp/RPC2
    http://api.my.yahoo.co.jp/rss/ping?u=%s
    http://blogsearch.google.co.jp/ping/RPC2
    http://blogsearch.google.com/ping/RPC2
    http://blog.goo.ne.jp/XMLRPC
    http://rpc.reader.livedoor.com/ping
    http://ping.fc2.com
    http://ping.blogoon.net/
    http://rpc.blogrolling.com/pinger/
    http://ping.namaan.net/rpc
    http://jugem.jp/?mode=NEWENTRY
    http://blogranking.net/
    http://blog.with2.net/
    http://www.blogmura.com/xmlrpc/8twglx4iaa9x
    http://www.blogpeople.net/
    http://ping.blo.gs/
    http://ping.bloggers.jp/rpc/
    http://ping.dendou.jp/
    http://ping.freeblogranking.com/xmlrpc/
    http://ping.myblog.jp/
    http://ping.rss.drecom.jp/
    http://pingoo.jp/ping/
    http://rpc.weblogs.com/RPC2
    http://serenebach.net/rep.cgi
    http://taichistereo.net/xmlrpc/
    http://news.atode.cc/rssdaily.php
    http://hamham.info/blog/xmlrpc/
    http://ping.cocolog-nifty.com/xmlrpc
    http://ping.exblog.jp/xmlrpc
    http://ping.feedburner.com
    http://ping.rootblog.com/rpc.php
    http://ping.sitecms.net
    http://ranking.kuruten.jp/ping
    http://rpc.pingomatic.com/
    http://www.bloglines.com/ping
    http://www.i-learn.jp/ping/
    http://xping.pubsub.com/ping/
    http://rpc.technorati.com/rpc/ping
    http://api.my.yahoo.com/RPC2
    http://xmlrpc.blogg.de/
    http://services.newsgator.com/ngws/xmlrpcping.aspx
    http://api.moreover.com/RPC2
    http://rpc.icerocket.com
    http://audiorpc.weblogs.com/RPC2
    http://rpc.icerocket.com:10080/
    http://blogsearch.google.com/ping/RPC2
    http://1470.net/api/ping
    http://api.feedster.com/ping
    http://api.moreover.com/RPC2
    http://api.moreover.com/ping
    http://api.my.yahoo.com/RPC2
    http://api.my.yahoo.com/rss/ping
    http://bblog.com/ping.php
    http://bitacoras.net/ping
    http://blog.goo.ne.jp/XMLRPC
    http://blogdb.jp/xmlrpc
    http://blogmatcher.com/u.php
    http://bulkfeeds.net/rpc
    http://coreblog.org/ping/
    http://mod-pubsub.org/kn_apps/blogchatt
    http://www.lasermemory.com/lsrpc/
    http://ping.amagle.com/
    http://ping.bitacoras.com
    http://ping.blo.gs/
    http://ping.bloggers.jp/rpc/
    http://ping.cocolog-nifty.com/xmlrpc
    http://ping.blogmura.jp/rpc/
    http://ping.exblog.jp/xmlrpc
    http://ping.feedburner.com
    http://ping.myblog.jp
    http://ping.rootblog.com/rpc.php
    http://ping.syndic8.com/xmlrpc.php
    http://ping.weblogalot.com/rpc.php
    http://ping.weblogs.se/
    http://pingoat.com/goat/RPC2
    http://rcs.datashed.net/RPC2/
    http://rpc.blogbuzzmachine.com/RPC2
    http://rpc.blogrolling.com/pinger/
    http://rpc.icerocket.com:10080/
    http://rpc.newsgator.com/
    http://rpc.pingomatic.com
    http://rpc.technorati.com/rpc/ping
    http://rpc.weblogs.com/RPC2
    http://topicexchange.com/RPC2
    http://trackback.bakeinu.jp/bakeping.php
    http://www.a2b.cc/setloc/bp.a2b
    http://www.bitacoles.net/ping.php
    http://www.blogdigger.com/RPC2
    http://www.blogoole.com/ping/
    http://www.blogoon.net/ping/
    http://www.blogpeople.net/servlet/weblogUpdates
    http://www.blogroots.com/tb_populi.blog?id=%s
    http://www.blogshares.com/rpc.php
    http://www.blogsnow.com/ping
    http://www.blogstreet.com/xrbin/xmlrpc.cgi
    http://www.mod-pubsub.org/kn_apps/blogchatter/ping.php
    http://www.newsisfree.com/RPCCloud
    http://www.newsisfree.com/xmlrpctest.php
    http://www.popdex.com/addsite.php
    http://www.snipsnap.org/RPC2
    http://www.weblogues.com/RPC/
    http://xmlrpc.blogg.de
    http://xping.pubsub.com/ping/
    http://rpc.copygator.com/ping/
    http://submissions.ask.com/ping?sitemap=%s
    http://www.didikle.com/ping?sitemap=%s
    )

  end
end
