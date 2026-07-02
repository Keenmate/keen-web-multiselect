defmodule TestAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :test_app

  @session_options [
    store: :cookie,
    key: "_test_app_key",
    signing_salt: "abcdefgh",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # The wrapper's bundled JS+CSS, served straight from the dep's priv/static.
  plug Plug.Static,
    at: "/keen_web_multiselect",
    from: {:keen_web_multiselect, "priv/static"},
    gzip: false,
    only: ~w(multiselect.js multiselect.css keen_web_multiselect_hook.js)

  # Phoenix runtime JS (phoenix.mjs + phoenix_live_view.esm.js) — served from the
  # transitive deps so the test app needs no esbuild step.
  plug Plug.Static,
    at: "/vendor/phoenix",
    from: {:phoenix, "priv/static"},
    gzip: false,
    only: ~w(phoenix.mjs phoenix.mjs.map)

  plug Plug.Static,
    at: "/vendor/phoenix_live_view",
    from: {:phoenix_live_view, "priv/static"},
    gzip: false,
    only: ~w(phoenix_live_view.esm.js phoenix_live_view.esm.js.map)

  # test_app's own assets (app.js, app.css, favicon)
  plug Plug.Static,
    at: "/",
    from: :test_app,
    gzip: false,
    only: TestAppWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug TestAppWeb.Router
end
