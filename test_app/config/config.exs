import Config

config :test_app, TestAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4_060],
  server: true,
  secret_key_base: String.duplicate("a", 64),
  live_view: [signing_salt: "e2e-signing-salt-not-secret"],
  render_errors: [formats: [html: TestAppWeb.ErrorHTML], layout: false],
  pubsub_server: TestApp.PubSub,
  check_origin: false,
  code_reloader: false,
  debug_errors: true

config :phoenix, :json_library, Jason

config :logger, level: :debug

import_config "#{config_env()}.exs"
