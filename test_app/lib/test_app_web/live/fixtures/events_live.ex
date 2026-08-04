defmodule TestAppWeb.Fixtures.EventsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"}
  ]

  # Custom-shaped data keyed by `userId` (no `value`/`id` field) — exercises the
  # hook's value extraction under a custom `value_member`. A regression here would
  # push whole option maps as `value`/`values`.
  @users [
    %{userId: 1, fullName: "John Doe"},
    %{userId: 2, fullName: "Jane Smith"},
    %{userId: 3, fullName: "Alice Johnson"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits, users: @users, events: [])}
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

    <div class="fixture">
      <div class="fixture-label">custom value_member="userId" — value/values must be scalars</div>
      <.web_multiselect
        id="picker-custom"
        hook="KeenWebMultiselectHook"
        options={@users}
        value_member="userId"
        display_value_member="fullName"
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">custom picker captured events (newest first)</div>
      <div data-testid="custom-events">{format(for {_n, p} = e <- @events, p["id"] == "picker-custom", do: e)}</div>
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
