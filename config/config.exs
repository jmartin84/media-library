# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :medialibrary,
	elastic_search: "localhost:9200"

# Configures the endpoint
config :medialibrary, MedialibraryWeb.Endpoint,
	url: [host: "localhost"],
	secret_key_base: "mfM7nc0yglyomfvsl2GFgBnKgi8iSWSScd1mmPGJwWybpsTfxIhcfbMz+tAhRS8W",
	render_errors: [view: MedialibraryWeb.ErrorView, accepts: ~w(html json)],
	cache_static_manifest: "priv/static/manifest.json",
	pubsub: [name: Medialibrary.PubSub,
					 adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
	format: "$time $metadata[$level] $message\n",
	metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
