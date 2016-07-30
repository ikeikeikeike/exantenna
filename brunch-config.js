exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    //  javascripts: {
    //    joinTo: "js/app.js"

    //    // To use a separate vendor.js bundle, specify two files path
    //    // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
    //    // joinTo: {
    //    //  "js/app.js": /^(web\/static\/js)/,
    //    //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
    //    // }
    //    //
    //    // To change the order of concatenation of files, explicitly mention here
    //    // https://github.com/brunch/brunch/tree/master/docs#concatenation
    //    // order: {
    //    //   before: [
    //    //     "web/static/vendor/js/jquery-2.1.1.js",
    //    //     "web/static/vendor/js/bootstrap.min.js"
    //    //   ]
    //    // }
    //  },
    //  stylesheets: {
    //    joinTo: "css/app.css"
    //  },
    //  templates: {
    //    joinTo: "js/app.js"
    //  }

    javascripts: {
      joinTo: "js/app.js",
      order: {
        before: [
          "bower_components/jquery/dist/jquery.min.js",
          "bower_components/bootstrap/dist/js/bootstrap.min.js",
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/app-def.css": /^(web\/static\/css\/(def|modules)|bower_components)/,
        "css/app-book.css": /^(web\/static\/css\/(book|modules)|bower_components)/,
        "css/app-video.css": /^(web\/static\/css\/(video|modules)|bower_components)/,
        "css/app-none.css": /^(web\/static\/css\/(none|modules)|bower_components)/,
        "css/app-view.css": /^(web\/static\/css\/(view|modules)|bower_components)/,
      },
      order: {
        before: [
          "bower_components/bootstrap/dist/css/bootstrap.min.css",
          // "bower_components/bootstrap/dist/css/bootstrap-theme.css",
        ]
      }
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "deps/phoenix/web/static",
      "deps/phoenix_html/web/static",
      "web/static",
      "test/static",
      "bower_components/bootstrap/dist/css",
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    afterBrunch: [
      'mkdir -p priv/static/fonts',
      'cp -f bower_components/bootstrap/fonts/* priv/static/fonts',
    ]
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]
  }
};
