defmodule TestAppWeb.Fixtures.PushUpdateLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @parents [
    %{value: "fruit", label: "Fruit"},
    %{value: "veg", label: "Vegetable"}
  ]

  @children_by_parent %{
    "fruit" => [
      %{value: "apple", label: "Apple"},
      %{value: "banana", label: "Banana"}
    ],
    "veg" => [
      %{value: "carrot", label: "Carrot"},
      %{value: "potato", label: "Potato"}
    ]
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, parents: @parents)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>web_multiselect:update server→client channel</h1>
    <p>Targeted by <code>e2e/push_update.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">parent — drives child options via push_event</div>
      <.web_multiselect
        id="parent"
        hook="KeenWebMultiselectHook"
        options={@parents}
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">child — starts empty, options injected by push_event scoped to id="child"</div>
      <.web_multiselect
        id="child"
        hook="KeenWebMultiselectHook"
        options={[]}
        no_data_placeholder="Pick a parent first..."
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">sibling — same page, different id; must NOT be touched by updates targeted at "child"</div>
      <.web_multiselect
        id="sibling"
        hook="KeenWebMultiselectHook"
        options={@parents}
      />
    </div>

    <div class="fixture">
      <div class="fixture-label">manual trigger — preselects "banana" on the child (assumes child is on Fruit)</div>
      <button id="preselect-banana" phx-click="preselect_banana" type="button">Preselect Banana on child</button>
    </div>
    """
  end

  @impl true
  def handle_event("web_multiselect:change", %{"id" => "parent", "values" => [parent | _]}, socket) do
    children = Map.get(@children_by_parent, parent, [])

    {:noreply,
     socket
     |> push_event("web_multiselect:update", %{id: "child", options: children, value: []})}
  end

  def handle_event("web_multiselect:change", %{"id" => "parent", "values" => []}, socket) do
    {:noreply,
     socket
     |> push_event("web_multiselect:update", %{id: "child", options: [], value: []})}
  end

  def handle_event("preselect_banana", _params, socket) do
    {:noreply, push_event(socket, "web_multiselect:update", %{id: "child", value: ["banana"]})}
  end

  # Drain the remaining hook events so they don't crash the test.
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}
end
