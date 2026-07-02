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

    live "/examples/classic", Examples.ClassicLive
    live "/examples/new-api", Examples.NewApiLive
    live "/examples/performance", Examples.PerformanceLive
    live "/examples/templating", Examples.TemplatingLive
    live "/examples/action-buttons", Examples.ActionButtonsLive
    live "/examples/tooltips", Examples.TooltipsLive
    live "/examples/events-callbacks", Examples.EventsCallbacksLive
    live "/examples/sizes", Examples.SizesLive
    live "/examples/base-variables", Examples.BaseVariablesLive
    live "/examples/theming", Examples.ThemingLive
    live "/examples/logging", Examples.LoggingLive
    live "/examples/positioning", Examples.PositioningLive
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
