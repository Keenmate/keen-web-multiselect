defmodule TestAppWeb.Fixtures.BadgesPopoverLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"},
    %{value: "date", label: "Date"},
    %{value: "elderberry", label: "Elderberry"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>badges overflow popover</h1>
    <p>Targeted by <code>e2e/badges_popover.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        partial mode, max 2 visible, 4 preselected — the "+2 more" badge opens the popover
      </div>
      <.web_multiselect
        id="overflow"
        options={@fruits}
        initial_values={["apple", "banana", "cherry", "date"]}
        badges_display_mode="partial"
        badges_max_visible={2}
      />
    </div>
    """
  end
end
