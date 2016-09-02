defmodule Sitemaps do
  use Sitemap
  alias Exantenna.Router.Helpers

  def gen_sitemap do
    create do

      entries =
        Exantenna.Entry
        |> Exantenna.Repo.all

      divas =
        Exantenna.Diva
        |> Exantenna.Repo.all

      tags =
        Exantenna.Tag
        |> Exantenna.Repo.all

      Enum.each [false, true], fn bool ->
        add Helpers.entry_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.diva_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.tag_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.blood_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.height_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.hip_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.bust_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.waste_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.bracup_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        add Helpers.birthday_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        # Wing it
        Enum.each 1966..1996, fn year ->
          add Helpers.birthday_path(Exantenna.Endpoint, :year, year),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

          Enum.each 1..12, fn month ->
            add Helpers.birthday_path(Exantenna.Endpoint, :month, year, month),
              priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
          end
        end

        add Helpers.atoz_path(Exantenna.Endpoint, :index),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

        entries
        |> Enum.each(fn entry ->
          add Helpers.entry_path(Exantenna.Endpoint, :show, entry.id, TextExtractor.safe_title(entry.title)),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

        divas
        |> Enum.each(fn diva ->
          add Helpers.entrydiva_path(Exantenna.Endpoint, :index, diva.name),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

        tags
        |> Enum.each(fn tag ->
          add Helpers.entrytag_path(Exantenna.Endpoint, :index, tag.name),
            priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
        end)

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
