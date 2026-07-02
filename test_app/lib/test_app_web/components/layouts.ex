defmodule TestAppWeb.Layouts do
  use TestAppWeb, :html

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
      </head>
      <body>
        {@inner_content}
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
