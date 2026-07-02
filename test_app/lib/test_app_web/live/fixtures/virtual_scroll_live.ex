defmodule TestAppWeb.Fixtures.VirtualScrollLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  # 500 options, well over the 100 threshold — enough that a windowed render
  # keeps far fewer than 500 .ms__option nodes in the DOM at once.
  @options for i <- 1..500, do: %{value: "item-#{i}", label: "Item #{i}"}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, options: @options, total: length(@options))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>virtual scrolling windows the option DOM</h1>
    <p>Targeted by <code>e2e/virtual_scroll.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        {@total} options, threshold 100 — only the visible window should be in the DOM
      </div>
      <.web_multiselect
        id="virtual"
        options={@options}
        enable_virtual_scroll={true}
        virtual_scroll_threshold={100}
        option_height={40}
        max_height="20rem"
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">
        same data, virtual scroll disabled — control: all rows render
      </div>
      <.web_multiselect
        id="plain"
        options={@options}
        enable_virtual_scroll={false}
      />
    </div>
    """
  end
end
