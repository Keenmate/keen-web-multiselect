defmodule TestAppWeb.Fixtures.CommandLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  alias Keenmate.WebMultiselect

  # Grouped options so scroll_to_group / scroll_to_value have somewhere to go.
  @skills [
    %{value: "phoenix", label: "Phoenix", group: "backend"},
    %{value: "ecto", label: "Ecto", group: "backend"},
    %{value: "postgres", label: "Postgres", group: "database"},
    %{value: "redis", label: "Redis", group: "database"},
    %{value: "svelte", label: "Svelte", group: "frontend"},
    %{value: "react", label: "React", group: "frontend"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    # One-shot guard: the ready event can be replayed on reconnect, and the hook
    # also replays it from el.isReady — only auto-open the first time.
    {:ok, assign(socket, skills: @skills, auto_opened: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>web_multiselect:command + web_multiselect:ready channel</h1>
    <p>Targeted by <code>e2e/command.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">manual triggers — drive #auto from the server</div>
      <button id="cmd-close" phx-click="close" type="button">Close</button>
      <button id="cmd-open-scroll-redis" phx-click="open_scroll_redis" type="button">
        Open + scroll to "redis"
      </button>
    </div>

    <div class="fixture">
      <div class="fixture-label">
        auto-open — opens + scrolls to group "database" on the ready event
      </div>
      <.web_multiselect
        id="auto"
        hook="KeenWebMultiselectHook"
        options={@skills}
        allow_groups={true}
        ready_event="web_multiselect:ready"
      />
    </div>
    """
  end

  @impl true
  def handle_event("web_multiselect:ready", %{"id" => "auto"}, socket) do
    if socket.assigns.auto_opened do
      {:noreply, socket}
    else
      {:noreply,
       socket
       |> assign(auto_opened: true)
       |> WebMultiselect.push_command("auto", open: true, scroll_to_group: "database")}
    end
  end

  def handle_event("close", _params, socket) do
    {:noreply, WebMultiselect.push_command(socket, "auto", close: true)}
  end

  def handle_event("open_scroll_redis", _params, socket) do
    {:noreply, WebMultiselect.push_command(socket, "auto", open: true, scroll_to_value: "redis")}
  end

  # Drain the remaining hook events so they don't crash the test.
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}
end
