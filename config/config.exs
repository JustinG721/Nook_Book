# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :nook_book, NookBookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OAricyvs++lAup/Sz3e672T7BEzpz7bxr8A2DWKRrrj2vC5TMXyTk5QtFcs7/3BM",
  render_errors: [view: NookBookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NookBook.PubSub,
  live_view: [signing_salt: "iIb23cr+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mnesia, :dir, 'mnesia/data'

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
