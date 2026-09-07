defmodule TestAppWeb.Router do
  use TestAppWeb, :router

  pipeline :fixtures_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TestAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :demos_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TestAppWeb.Layouts, :demo_root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TestAppWeb do
    pipe_through :demos_browser

    live "/", Examples.IndexLive

    # Example pages mirror upstream @keenmate/web-multiselect examples-*.html 1:1.
    live "/examples/basic", Examples.BasicLive
    live "/examples/data-api", Examples.DataApiLive
    live "/examples/tree", Examples.TreeLive
    live "/examples/external-search", Examples.ExternalSearchLive
    live "/examples/virtual-scrolling", Examples.VirtualScrollingLive
    live "/examples/custom-rendering", Examples.CustomRenderingLive
    live "/examples/action-buttons", Examples.ActionButtonsLive
    live "/examples/tooltips", Examples.TooltipsLive
    live "/examples/events-callbacks", Examples.EventsCallbacksLive
    live "/examples/responsive", Examples.ResponsiveLive
    live "/examples/theming", Examples.ThemingLive
    live "/examples/logging", Examples.LoggingLive
    live "/examples/positioning", Examples.PositioningLive
    # Wrapper-only theming demos (no upstream 1:1 page).
    live "/examples/sizes", Examples.SizesLive
    live "/examples/base-variables", Examples.BaseVariablesLive

    # Redirects from the pre-rc10 URLs (upstream renamed these pages).
    get "/examples/classic", RedirectController, :basic
    get "/examples/new-api", RedirectController, :data_api
    get "/examples/search-index", RedirectController, :external_search
    get "/examples/performance", RedirectController, :virtual_scrolling
    get "/examples/templating", RedirectController, :custom_rendering
  end

  scope "/test", TestAppWeb do
    pipe_through :fixtures_browser

    live "/selection", Fixtures.SelectionLive
    live "/form", Fixtures.FormLive
    live "/events", Fixtures.EventsLive
    live "/attributes", Fixtures.AttributesLive
    live "/search-event", Fixtures.SearchEventLive
    live "/push-update", Fixtures.PushUpdateLive
    live "/declarative", Fixtures.DeclarativeLive
    live "/virtual-scroll", Fixtures.VirtualScrollLive
    live "/badges-popover", Fixtures.BadgesPopoverLive
    live "/add-new", Fixtures.AddNewLive
  end
end
