defmodule TestAppWeb.Layouts do
  use TestAppWeb, :html

  # Privacy-friendly analytics for the public examples site. Kept as a raw
  # string (not inline HEEx) so the whole block — comment + both scripts — can
  # be rendered conditionally with one `{raw(...)}`, and so the inline init
  # script's literal `{ }` never risks HEEx interpolation. Only emitted when
  # the :analytics flag is on (prod only — see config/config.exs + runtime.exs).
  @plausible_snippet """
  <!-- Privacy-friendly analytics by Plausible -->
  <script async src="https://stats.keenmate.services/js/pa-mpFovW7Z1BGsoCR85-Z1m.js"></script>
  <script>
    window.plausible=window.plausible||function(){(plausible.q=plausible.q||[]).push(arguments)},plausible.init=plausible.init||function(i){plausible.o=i||{}};
    plausible.init()
  </script>
  """

  defp analytics_html do
    if Application.get_env(:test_app, :analytics, false),
      do: raw(@plausible_snippet),
      else: raw("")
  end

  def root(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>{assigns[:page_title] || "keen_web_multiselect e2e"}</title>
        {Application.get_env(:live_debugger, :live_debugger_tags)}
        <link rel="stylesheet" href="/keen_web_multiselect/multiselect.css" />
        <link rel="stylesheet" href="/assets/app.css" />
        <script type="importmap">
          {
            "imports": {
              "phoenix": "/vendor/phoenix/phoenix.mjs",
              "phoenix_live_view": "/vendor/phoenix_live_view/phoenix_live_view.esm.js",
              "keen_web_multiselect/hook": "/keen_web_multiselect/keen_web_multiselect_hook.js",
              "keen_web_multiselect": "/keen_web_multiselect/multiselect.js"
            }
          }
        </script>
        <script type="module" src="/assets/app.js"></script>
      </head>
      <body>
        {@inner_content}
      </body>
    </html>
    """
  end

  def demo_root(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>{assigns[:page_title] || "keen_web_multiselect — examples"}</title>
        {Application.get_env(:live_debugger, :live_debugger_tags)}
        <link rel="stylesheet" href="/keen_web_multiselect/multiselect.css" />
        <link rel="stylesheet" href="/assets/examples-shared.css" />
        <link rel="stylesheet" href="/assets/examples-keen.css" />
        <link
          :if={assigns[:font_awesome]}
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        />
        <script type="importmap">
          {
            "imports": {
              "phoenix": "/vendor/phoenix/phoenix.mjs",
              "phoenix_live_view": "/vendor/phoenix_live_view/phoenix_live_view.esm.js",
              "keen_web_multiselect/hook": "/keen_web_multiselect/keen_web_multiselect_hook.js",
              "keen_web_multiselect": "/keen_web_multiselect/multiselect.js"
            }
          }
        </script>
        <script type="module" src="/assets/app.js"></script>
        <Keenmate.WebMultiselect.Components.shadow_styles />
        {analytics_html()}
      </head>
      <body>
        {@inner_content}
        <!-- Floating right-edge "on this page" jump navigator (mirrors upstream). -->
        <script type="module" src="/assets/examples-chapter-nav.js"></script>
      </body>
    </html>
    """
  end

  def app(assigns) do
    ~H"""
    <div id="lv-ready-marker" phx-hook="LvReady" style="display:none"></div>
    {@inner_content}
    """
  end
end
