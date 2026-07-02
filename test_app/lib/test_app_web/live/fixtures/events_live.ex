defmodule TestAppWeb.Fixtures.EventsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits, events: [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>LV hook event forwarding</h1>
    <p>Targeted by <code>e2e/events.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">hook="KeenWebMultiselectHook" — select/deselect/change forwarded to handle_event/3</div>
      <.web_multiselect
        id="picker"
        hook="KeenWebMultiselectHook"
        options={@fruits}
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">captured events (newest first)</div>
      <div data-testid="captured-events">{format(@events)}</div>
    </div>
    """
  end

  defp format([]), do: "(none yet)"

  defp format(events) do
    events
    |> Enum.map(fn {name, payload} -> "#{name} #{inspect(payload)}" end)
    |> Enum.join("\n")
  end

  @impl true
  def handle_event("web_multiselect:" <> kind = name, payload, socket) when kind in ["select", "deselect", "change"] do
    {:noreply, update(socket, :events, &[{name, payload} | &1])}
  end
end
