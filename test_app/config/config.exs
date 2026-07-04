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

# Plausible analytics on the public examples pages — off by default so dev,
# test, and the e2e harness never emit tracking. runtime.exs flips it on for
# prod (the deployed container).
config :test_app, :analytics, false

config :logger, level: :debug

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

File.regular?("config/.local.exs") && import_config(".local.exs")
File.regular?("config/#{config_env()}.local.exs") && import_config("#{config_env()}.local.exs")
