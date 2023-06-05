import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_view_issue, LiveViewIssueWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "v0K5Ubb9gq2AAWgjPTmwltILv4Ke0Yl2/Z1ni0kNAW0Bn2rQXqLV9e8MQqWlu3AP",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
