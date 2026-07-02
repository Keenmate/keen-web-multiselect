import Config

config :test_app, TestAppWeb.Endpoint,
  code_reloader: true,
  reloadable_apps: [:test_app, :keen_web_multiselect]

# LiveDebugger console — kept on the +1 sibling port so we have a
# consistent xxx0/xxx1 pattern: 4060 main web, 4061 debug console.
config :live_debugger,
  port: 4061
