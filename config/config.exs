# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :blueberry,
  ecto_repos: [Blueberry.Repo, Blueberry.Log.Repo]

config :blueberry, Blueberry.Repo,
  priv: "priv/repo/blueberry"

config :blueberry, Blueberry.Log.Repo,
  priv: "priv/repo/log"

# Configures the endpoint
config :blueberry, BlueberryWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BlueberryWeb.ErrorHTML, json: BlueberryWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Blueberry.PubSub,
  live_view: [signing_salt: "8Rg6Rb31"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :blueberry, Blueberry.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# gettext 언어 설정
config :gettext, :default_locale, "ko"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
