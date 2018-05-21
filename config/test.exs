use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :medialibrary, MedialibraryWeb.Endpoint,
	http: [port: 4001],
	server: false

config :medialibrary, :http, Medialibrary.HttpMock
# Print only warnings and errors during test
config :logger, level: :warn
