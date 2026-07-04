import Config

# config/runtime.exs runs *after compilation, before the supervision tree
# starts*, and is the only config file that runs inside an OTP release. It is
# where every value that must vary per deploy is read from the environment.
# Anything that affects compiled bytecode must stay in config.exs / <env>.exs.
#
# The whole block is guarded by `config_env() == :prod` — dev and test get
# their values from config.exs + dev.exs / test.exs.
if config_env() == :prod do
  # Public examples/demo app for https://keen-web-multiselect.keenmate.dev.
  # Assets ship straight from priv/static (no esbuild step), so the release
  # only needs the endpoint bound to all interfaces with a real host + secret.

  # Required — never bake a secret into the image or VCS. Generate one per
  # deploy with `mix phx.gen.secret`.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      Generate one with: mix phx.gen.secret
      (a 64+ character base64 string)
      """

  host = System.get_env("PHX_HOST", "keen-web-multiselect.keenmate.dev")
  port = String.to_integer(System.get_env("PORT", "4060"))

  config :test_app, TestAppWeb.Endpoint,
    server: true,
    # TLS is terminated by the reverse proxy in front of the container; the app
    # speaks plain HTTP internally but advertises https URLs to the browser.
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0}, port: port],
    check_origin: ["https://#{host}"],
    secret_key_base: secret_key_base
end
