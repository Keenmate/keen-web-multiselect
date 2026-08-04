defmodule TestAppWeb.Examples.ServerEventsPanel do
  @moduledoc """
  An always-visible "server round-trip" monitor for the demo pages.

  Rendered once per example page, it pins a small floating card to the
  bottom-right of the viewport. Its `ServerMonitor` JS hook listens for
  `select` / `deselect` / `change` on **every** `<web-multiselect>` on the page
  and forwards each to THIS LiveComponent (via `phx-target={@myself}`). The
  component keeps a server-side counter + log and re-renders on each event.

  So: pick an option anywhere on the page and the floating counter ticks up with
  the value and a UTC timestamp — direct proof the `keen_web_multiselect`
  LiveView wrapper is doing a real client → server → re-render round-trip, not
  just the standalone web component.
  """

  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, assign(socket, count: 0, last: nil, events: [])}
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(:id, assigns.id)
     |> assign_new(:count, fn -> 0 end)
     |> assign_new(:last, fn -> nil end)
     |> assign_new(:events, fn -> [] end)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div id={@id <> "-panel"} phx-hook="ServerMonitor" phx-target={@myself} class="server-monitor">
        <div class="server-monitor__head">
          <strong>🔌 Server round-trip</strong>
          <div class="server-monitor__actions">
            <span id={@id <> "-count"} class="server-monitor__count">{@count}</span>
            <button
              type="button"
              phx-click="clear"
              phx-target={@myself}
              title="Reset the counter and log"
              class="server-monitor__clear"
            >Clear</button>
          </div>
        </div>
        <div class="server-monitor__desc">
          The LiveView server saw <strong>{@count}</strong> event(s) from the wrapper.
          <span :if={@last}><br />last value: <code>{@last}</code></span>
        </div>
        <pre class="server-monitor__log">{log(@events)}</pre>
      </div>
    </div>
    """
  end

  defp log([]), do: "(pick an option anywhere on this page)"
  defp log(events), do: Enum.join(events, "\n")

  # `change` carries the full selection (`values`); `select`/`deselect` carry the
  # single option that changed (`value`) plus the resulting `values`.
  @impl true
  def handle_event("web_multiselect:" <> kind, payload, socket)
      when kind in ["change", "select", "deselect"] do
    seq = socket.assigns.count + 1
    stamp = Calendar.strftime(DateTime.utc_now(), "%H:%M:%S")
    id = payload["id"] || "(unnamed)"
    shown = payload["value"] || payload["values"] || ""
    entry = "##{seq} [#{stamp} UTC] #{kind} · #{id} → #{inspect(shown)}"

    {:noreply,
     assign(socket,
       count: seq,
       last: format_last(shown),
       events: Enum.take([entry | socket.assigns.events], 10)
     )}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, count: 0, last: nil, events: [])}
  end

  defp format_last(shown) when is_list(shown), do: Enum.join(shown, ", ")
  defp format_last(shown) when is_binary(shown) or is_number(shown) or is_atom(shown),
    do: to_string(shown)

  # Any other shape (e.g. a map payload) — render inspectably instead of crashing.
  defp format_last(shown), do: inspect(shown)
end
