defmodule TestAppWeb.Fixtures.AttributesLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>snake_case → kebab-case attribute mapping</h1>
    <p>Targeted by <code>e2e/attributes.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        every snake_case attr below must appear kebab-cased on the rendered element
      </div>
      <.web_multiselect
        id="kebab-check"
        options={@fruits}
        search_placeholder="Search fruits..."
        badges_display_mode="badges"
        badges_threshold={3}
        badges_max_visible={2}
        badges_position="top"
        enable_search={true}
        search_mode="filter"
        min_search_length={2}
        enable_virtual_scroll={true}
        virtual_scroll_threshold={100}
        option_height={32}
        value_format="json"
        value_member="value"
        display_value_member="label"
        checkbox_align="top"
        dropdown_max_width="40rem"
        remove_button_tooltip_text="Drop {0}"
        badge_height={40}
        show_debug_info={true}
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">booleans render as explicit "true"/"false" strings, never bare</div>
      <.web_multiselect id="bool-true" options={@fruits} multiple={true} />
      <.web_multiselect id="bool-false" options={@fruits} multiple={false} />
    </div>
    """
  end
end
