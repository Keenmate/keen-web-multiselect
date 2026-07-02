defmodule TestAppWeb.Fixtures.SelectionLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"},
    %{value: "date", label: "Date"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>selection & multiplicity</h1>
    <p>Targeted by <code>e2e/selection.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">multi-select (default)</div>
      <.web_multiselect id="multi" options={@fruits} />
    </div>

    <div class="fixture">
      <div class="fixture-label">single-select (multiple={false}) — boolean rendered as explicit "false"</div>
      <.web_multiselect id="single" multiple={false} options={@fruits} />
    </div>

    <div class="fixture">
      <div class="fixture-label">value={["banana"]} flows into initial-values</div>
      <.web_multiselect id="initial" options={@fruits} value={["banana"]} />
    </div>

    <div class="fixture">
      <div class="fixture-label">close_on_select={true} → close-on-select="true"</div>
      <.web_multiselect id="close-on-select" close_on_select={true} options={@fruits} />
    </div>
    """
  end
end
