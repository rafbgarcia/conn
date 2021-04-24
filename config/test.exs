use Mix.Config

config :connect, :xandra,
  nodes: ["127.0.0.1:9042"],
  keyspace: "connect_test"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :connect, ConnectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
