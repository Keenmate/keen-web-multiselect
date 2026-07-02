defmodule TestAppWeb.Fixtures.SearchEventLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  # Toy in-memory catalog. The spec drives queries against this list so the
  # results are deterministic (no upstream API to flake).
  @catalog [
    %{value: "apple", label: "Apple"},
    %{value: "apricot", label: "Apricot"},
    %{value: "avocado", label: "Avocado"},
    %{value: "banana", label: "Banana"},
    %{value: "blackberry", label: "Blackberry"},
    %{value: "blueberry", label: "Blueberry"},
    %{value: "cherry", label: "Cherry"},
    %{value: "coconut", label: "Coconut"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, last_query: nil, query_count: 0, slow_next: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>declarative server-side search via search_event</h1>
    <p>Targeted by <code>e2e/search_event.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        search_event="fruit_search" — hook installs a searchCallback that pushes the query and resolves with reply.results
      </div>
      <.web_multiselect
        id="search"
        hook="KeenWebMultiselectHook"
        search_event="fruit_search"
        search_debounce={0}
        min_search_length={1}
        placeholder="Type a fruit name..."
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">
        next reply will be delayed by 500ms — drive this to verify AbortSignal honoring
      </div>
      <button id="slow-next-on" phx-click="slow_next" phx-value-flag="true" type="button">Delay next reply</button>
      <button id="slow-next-off" phx-click="slow_next" phx-value-flag="false" type="button">Reset</button>
      <div data-testid="slow-next">{to_string(@slow_next)}</div>
    </div>

    <div class="fixture">
      <div class="fixture-label">server observability — last query received + total query count</div>
      <div data-testid="last-query">{inspect(@last_query)}</div>
      <div data-testid="query-count">{@query_count}</div>
    </div>
    """
  end

  @impl true
  def handle_event("fruit_search", %{"query" => query, "id" => _id}, socket) do
    if socket.assigns.slow_next, do: Process.sleep(500)

    results =
      @catalog
      |> Enum.filter(&String.contains?(String.downcase(&1.label), String.downcase(query)))

    {:reply, %{results: results},
     socket
     |> assign(last_query: query)
     |> update(:query_count, &(&1 + 1))
     |> assign(slow_next: false)}
  end

  def handle_event("slow_next", %{"flag" => flag}, socket) do
    {:noreply, assign(socket, slow_next: flag == "true")}
  end

  # Hook-forwarded events are ignored here — the spec only cares about the
  # dropdown's contents.
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}
end
