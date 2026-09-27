defmodule TestAppWeb.Examples.ElixirOnlyLive do
  @moduledoc """
  "Elixir Only" — the wrapper's declarative surface. Everything here is done with pure
  HEEx attributes and application config: options, selection, a shared shadow-DOM theme
  configured once (the `shadow_styles/1` feature), and per-instance theming via CSS
  variables. No inline `<script>`, no `wait(id).then(el => …)`, no per-instance JS callbacks.
  """
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  @langs [
    %{value: "js", label: "JavaScript"},
    %{value: "ts", label: "TypeScript"},
    %{value: "py", label: "Python"},
    %{value: "go", label: "Go"},
    %{value: "rust", label: "Rust"},
    %{value: "elixir", label: "Elixir"}
  ]

  # Code samples live in heredocs (not the template) because they contain `{...}` /
  # CSS braces, which HEEx would try to interpolate. Assigned in mount/3 and rendered
  # verbatim via `{@assign}`.
  @config_code """
  # config/config.exs — configure the shared look ONCE
  config :keen_web_multiselect,
    shadow_styles: {:file, "priv/static/assets/ms-elixir-theme.css"}
  """

  @layout_code """
  <%!-- root layout <head>, once --%>
  <Keenmate.WebMultiselect.Components.shadow_styles />
  """

  @css_code """
  /* priv/static/assets/ms-elixir-theme.css */
  :host(.elixir-themed) .ms__badge {
    border-radius: 999px;
    background: linear-gradient(135deg, #7c3aed, #ec4899);
    border-color: transparent;
  }
  :host(.elixir-themed) .ms__badge-text,
  :host(.elixir-themed) .ms__badge-remove {
    background: transparent; color: #fff; border-color: transparent;
  }
  """

  @usage_code """
  <.web_multiselect
    id="langs"
    class="elixir-themed"
    options={@langs}
    value={["js", "ts", "py"]} />
  """

  @vars_code """
  <.web_multiselect
    id="langs"
    style="--ms-accent-color:#0ea5e9; --ms-badge-border-radius:9999px; --ms-input-border-radius:0.5rem;"
    options={@langs}
    value={["go", "rust"]} />
  """

  # -- EO03 · LiveView-driven cascade datasets --------------------------------

  @organizations [
    %{value: "acme", label: "Acme Corp"},
    %{value: "globex", label: "Globex"},
    %{value: "initech", label: "Initech"}
  ]

  @units_by_org %{
    "acme" => [
      %{value: "acme-eng", label: "Engineering"},
      %{value: "acme-sales", label: "Sales"},
      %{value: "acme-ops", label: "Operations"}
    ],
    "globex" => [
      %{value: "globex-rd", label: "Research"},
      %{value: "globex-mfg", label: "Manufacturing"}
    ],
    "initech" => [
      %{value: "initech-tps", label: "TPS Reports"},
      %{value: "initech-it", label: "IT"}
    ]
  }

  @depts_by_unit %{
    "acme-eng" => [
      %{value: "acme-eng-be", label: "Backend"},
      %{value: "acme-eng-fe", label: "Frontend"},
      %{value: "acme-eng-data", label: "Data"}
    ],
    "acme-sales" => [
      %{value: "acme-sales-emea", label: "EMEA"},
      %{value: "acme-sales-amer", label: "Americas"}
    ],
    "acme-ops" => [
      %{value: "acme-ops-it", label: "IT"},
      %{value: "acme-ops-fac", label: "Facilities"},
      %{value: "acme-ops-hr", label: "HR"}
    ],
    "globex-rd" => [
      %{value: "globex-rd-bio", label: "Biotech"},
      %{value: "globex-rd-chem", label: "Chemistry"}
    ],
    "globex-mfg" => [
      %{value: "globex-mfg-assembly", label: "Assembly"},
      %{value: "globex-mfg-qa", label: "Quality Assurance"},
      %{value: "globex-mfg-logistics", label: "Logistics"}
    ],
    "initech-tps" => [
      %{value: "initech-tps-coversheet", label: "Cover Sheet Compliance"},
      %{value: "initech-tps-archive", label: "Archive"}
    ],
    "initech-it" => [
      %{value: "initech-it-support", label: "Support"},
      %{value: "initech-it-infra", label: "Infrastructure"},
      %{value: "initech-it-printers", label: "Printers"}
    ]
  }

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Elixir Only — keen_web_multiselect")
     |> assign(:langs, @langs)
     |> assign(:config_code, @config_code)
     |> assign(:layout_code, @layout_code)
     |> assign(:css_code, @css_code)
     |> assign(:usage_code, @usage_code)
     |> assign(:vars_code, @vars_code)
     |> assign(:organizations, @organizations)
     |> assign(:selected_org, nil)
     |> assign(:business_units, [])
     |> assign(:selected_unit, nil)
     |> assign(:departments, [])}
  end

  # -- EO03 · LiveView-driven cascade (change → push_event options back) -------

  def handle_event("web_multiselect:change", %{"id" => "cascade-org", "values" => [org | _]}, socket) do
    units = Map.get(@units_by_org, org, [])

    {:noreply,
     socket
     |> assign(:selected_org, org)
     |> assign(:business_units, units)
     |> assign(:selected_unit, nil)
     |> assign(:departments, [])
     |> push_event("web_multiselect:update", %{id: "cascade-unit", options: units, value: []})
     |> push_event("web_multiselect:update", %{id: "cascade-dept", options: [], value: []})}
  end

  def handle_event("web_multiselect:change", %{"id" => "cascade-org", "values" => []}, socket) do
    {:noreply,
     socket
     |> assign(:selected_org, nil)
     |> assign(:business_units, [])
     |> assign(:selected_unit, nil)
     |> assign(:departments, [])
     |> push_event("web_multiselect:update", %{id: "cascade-unit", options: [], value: []})
     |> push_event("web_multiselect:update", %{id: "cascade-dept", options: [], value: []})}
  end

  def handle_event("web_multiselect:change", %{"id" => "cascade-unit", "values" => [unit | _]}, socket) do
    depts = Map.get(@depts_by_unit, unit, [])

    {:noreply,
     socket
     |> assign(:selected_unit, unit)
     |> assign(:departments, depts)
     |> push_event("web_multiselect:update", %{id: "cascade-dept", options: depts, value: []})}
  end

  def handle_event("web_multiselect:change", %{"id" => "cascade-unit", "values" => []}, socket) do
    {:noreply,
     socket
     |> assign(:selected_unit, nil)
     |> assign(:departments, [])
     |> push_event("web_multiselect:update", %{id: "cascade-dept", options: [], value: []})}
  end

  # EO04 · async search tunneled through the LV: the hook pushes the query, we
  # fetch GitHub and reply; the {:reply, ...} resolves the searchCallback promise.
  # This search round-trip isn't a select/deselect/change DOM event, so the
  # document-level ServerMonitor can't see it — surface it in the "Server
  # round-trip" panel ourselves via send_update, so the tunneled query shows up
  # alongside the ordinary selection events.
  def handle_event("github_search", %{"query" => query, "id" => id}, socket) do
    results = github_search_users(query)

    send_update(TestAppWeb.Examples.ServerEventsPanel,
      id: "server-events-panel",
      monitor_event: %{kind: "search", id: id, shown: "#{query} → #{length(results)} hit(s)"}
    )

    {:reply, %{results: results}, socket}
  end

  # The hooked widgets forward select/deselect/change; drain any we don't act on
  # so an unhandled event can't crash the page (see ai/server-updates.txt).
  def handle_event("web_multiselect:" <> _, _params, socket), do: {:noreply, socket}

  # Hits the GitHub public user-search API. Unauthenticated requests are
  # rate-limited to ~10/min; the demo accepts that. Returns a list of
  # %{value, label, subtitle} maps that the wrapper consumes as options.
  defp github_search_users(query) when is_binary(query) and byte_size(query) > 0 do
    url = ~c"https://api.github.com/search/users?per_page=10&q=" ++ to_charlist(URI.encode(query))
    headers = [{~c"user-agent", ~c"keen_web_multiselect-demo"}, {~c"accept", ~c"application/vnd.github+json"}]

    case :httpc.request(:get, {url, headers}, [{:timeout, 5_000}], []) do
      {:ok, {{_, 200, _}, _resp_headers, body}} ->
        case Jason.decode(to_string(body)) do
          {:ok, %{"items" => items}} ->
            Enum.map(items, fn item ->
              %{value: item["login"], label: item["login"], subtitle: item["html_url"]}
            end)

          _ ->
            []
        end

      _ ->
        []
    end
  end

  defp github_search_users(_), do: []

  def render(assigns) do
    ~H"""
    <.example_page
      icon="💧"
      title="Elixir Only"
      subtitle="Pure HEEx + config. No inline scripts, no per-instance JS callbacks — the wrapper's declarative surface."
    >
      <.note title="Everything on this page is declarative">
        The Custom Rendering and Data &amp; API pages wire the element from an inline
        <code>&lt;script&gt;</code> (<code>wait(id).then(el => …)</code>). Here it's all HEEx and
        config: options and selection as attributes, a shared shadow-DOM theme from
        <code>config</code>, and one-off tweaks via CSS variables.
      </.note>

      <.card title="EO01 · Theme every select from config (no per-instance JS)">
        <.tip>
          config <code>:shadow_styles</code> + <code>&lt;.shadow_styles/&gt;</code> in the layout · opt in with <code>class="elixir-themed"</code>
        </.tip>
        <p>
          Set the shared CSS <strong>once</strong> in config and drop
          <code>&lt;.shadow_styles/&gt;</code> in your root layout. The wrapper compiles it into one
          stylesheet and adopts it into every <code>&lt;web-multiselect&gt;</code>'s shadow DOM
          (<code>adoptedStyleSheets</code>) — which ordinary page CSS can't reach. This theme is
          scoped with <code>:host(.elixir-themed)</code>, so a select opts in just by adding a class.
        </p>
        <p>
          And it's <strong>flash-free</strong>: with shared styles configured the wrapper adds
          upstream's <code>defer</code> attribute (2.1.0) to each select, so it reserves space but
          builds nothing until the registry has adopted the sheet — then releases the gate. The themed
          pill badges paint in <strong>one shot</strong>, with no default-style flash beforehand.
        </p>

        <.grid_2>
          <.form_group>
            <label>Themed — <code>class="elixir-themed"</code></label>
            <.web_multiselect id="eo-themed" class="elixir-themed" options={@langs} value={["js", "ts", "py"]} />
          </.form_group>
          <.form_group>
            <label>Default — no class</label>
            <.web_multiselect id="eo-plain" options={@langs} value={["js", "ts", "py"]} />
          </.form_group>
        </.grid_2>

        <.code_block lang="elixir">{@config_code}</.code_block>
        <.code_block lang="heex">{@layout_code}</.code_block>
        <.code_block lang="css">{@css_code}</.code_block>
        <.code_block lang="heex">{@usage_code}</.code_block>
      </.card>

      <.card title="EO02 · Per-instance theming with CSS variables">
        <.tip>pure HEEx <code>style="--ms-…"</code> — scoped to one element, no config, no JS</.tip>
        <p>
          For a one-off look, set the <code>--ms-*</code> / <code>--base-*</code> custom properties
          right on the element. Custom properties pierce the shadow DOM, so this needs no callback at
          all. <strong>Prefer this for anything variables can express</strong>; reach for the shared
          adopted-stylesheet theme above only for the arbitrary shadow-DOM CSS residual.
        </p>

        <.form_group>
          <label>Variables only</label>
          <.web_multiselect
            id="eo-vars"
            style="--ms-accent-color:#0ea5e9; --ms-badge-border-radius:9999px; --ms-input-border-radius:0.5rem;"
            options={@langs}
            value={["go", "rust"]}
          />
        </.form_group>

        <.code_block lang="heex">{@vars_code}</.code_block>
      </.card>

      <.card title="EO03 · Cascading selects (LiveView-driven)">
        <.tip>
          <code>hook="KeenWebMultiselectHook"</code> · server-driven <code>{"options={@business_units}"}</code> · <code>push_event "web_multiselect:update"</code>
        </.tip>
        <p>
          Three coupled multiselects. Selecting an organization sends a <code>change</code>
          event through the LV hook; the server looks up the matching business units and pushes the
          new options back to the dependent select via
          <code>push_event(socket, "web_multiselect:update", %{"{id, options, value}"})</code>. Same
          flow from unit → department. No inline <code>&lt;script&gt;</code> — the whole cascade is
          server state.
        </p>

        <.note>
          Why push_event instead of just re-rendering <code>options={"{@business_units}"}</code>? The
          wrapper auto-emits <code>phx-update="ignore"</code>
          on the element so morphdom doesn't tear down the component's internally-managed children.
          That ignore also blocks LV from morphing the <code>data-options</code>
          attribute on subsequent renders — so the canonical way to mutate option-list or selection
          state from the server is through the hook's <code>handleEvent</code>
          channel (equivalently <code>Keenmate.WebMultiselect.push_update/3</code>).
        </.note>

        <.grid>
          <.form_group>
            <label>1. Organization</label>
            <.web_multiselect
              id="cascade-org"
              hook="KeenWebMultiselectHook"
              multiple={false}
              placeholder="Pick an org"
              options={@organizations}
            />
          </.form_group>

          <.form_group>
            <label>2. Business unit</label>
            <.web_multiselect
              id="cascade-unit"
              hook="KeenWebMultiselectHook"
              multiple={false}
              placeholder={if @selected_org, do: "Pick a unit", else: "Select an org first"}
              options={@business_units}
            />
          </.form_group>

          <.form_group>
            <label>3. Department</label>
            <.web_multiselect
              id="cascade-dept"
              hook="KeenWebMultiselectHook"
              multiple={false}
              placeholder={if @selected_unit, do: "Pick a department", else: "Select a unit first"}
              options={@departments}
            />
          </.form_group>
        </.grid>

        <div style="margin-top:1rem;font-size:0.9rem;color:#4a5568">
          Selected: org = <code>{@selected_org || "—"}</code>, unit = <code>{@selected_unit || "—"}</code>
        </div>
      </.card>

      <.card title="EO04 · Async search — LiveView tunneled (Elixir fetches GitHub)">
        <.tip><code>search_event="github_search"</code> · server replies <code>{"{:reply, %{results: [...]}, socket}"}</code></.tip>
        <p>
          Set <code>{"search_event=\"github_search\""}</code>
          on the wrapper. The hook installs a <code>searchCallback</code>
          that pushes <code>{"%{\"query\" => q, \"id\" => id}"}</code>
          to the LV; the server fetches GitHub, returns <code>{"{:reply, %{results: [...]}, socket}"}</code>, and the reply resolves the promise in the browser.
        </p>

        <.form_group>
          <label>Search GitHub users (browser → LiveView → GitHub)</label>
          <.web_multiselect
            id="search-lv"
            hook="KeenWebMultiselectHook"
            search_event="github_search"
            placeholder="Type a name"
            search_placeholder="Search via Elixir..."
            min_search_length={3}
            search_debounce={250}
            multiple={false}
          />
        </.form_group>

        <.note>
          Why route through the server? (1) attach an auth token without leaking it to the client, (2) transform the response (filter, cache, enrich), (3) reach any backend API that doesn't allow CORS from the browser.
        </.note>
      </.card>

      <.note title="Opting in, overriding &amp; extending">
        Because the shared sheet is plain CSS in the shadow root, per-instance differences are just
        <strong>CSS scoping</strong> — no JS. Opt in or diverge with <code>:host(.your-class)</code>
        (here, <code>.elixir-themed</code>); override one select with a more specific
        <code>:host(#id) …</code> rule or inline <code>style="--ms-…"</code> variables. To extend the
        sheet at runtime you <em>can</em> import the hook and call
        <code>registerShadowStyles(getShadowStyles() + extra)</code>, but you rarely need to. See the
        theming guide.
      </.note>
    </.example_page>
    """
  end
end
