use Mix.Config

config :connect, :db, keyspace: "connect_test"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :connect, ConnectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Reduce the number of rounds so it does not slow down the test suite
config :bcrypt_elixir, :log_rounds, 4
