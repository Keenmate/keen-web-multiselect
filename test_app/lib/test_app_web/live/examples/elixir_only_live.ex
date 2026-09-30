defmodule TestAppWeb.Examples.ElixirOnlyLive do
  @moduledoc """
  "Elixir Only" — the wrapper's declarative surface. Almost everything here is done with
  pure HEEx attributes and application config: options, selection, a shared shadow-DOM
  theme configured once (the `shadow_styles/1` feature), per-instance theming via CSS
  variables, and server-driven data through the hook (`push_event`, `{:reply, …}`).

  Even client-side REST loading stays declarative: EO06/EO07 point the element at an HTTP
  endpoint with `data-fetch-*` attributes (URL, headers, mode) passed through `:rest`, so it
  fetches its own options with no per-instance JavaScript at all.

  The one exception is EO05's action button: action buttons carry function callbacks
  (`onClick`) that can't be serialized as HEEx attributes, so that card uses a small inline
  `<script>`. Even there, though, the click's real work — the customer lookup — routes back
  to Elixir through the hook's `pushToServer` bridge, so the *logic* stays server-side.
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

  # -- EO05 · Action button → server bridge (fetch a selection) ----------------

  @customers [
    %{value: "c-1001", label: "Acme Corp", subtitle: "billing@acme.example"},
    %{value: "c-1002", label: "Globex", subtitle: "ap@globex.example"},
    %{value: "c-1003", label: "Initech", subtitle: "finance@initech.example"},
    %{value: "c-1004", label: "Umbrella Co", subtitle: "accounts@umbrella.example"},
    %{value: "c-1005", label: "Stark Industries", subtitle: "billing@stark.example"},
    %{value: "c-1006", label: "Wayne Enterprises", subtitle: "ap@wayne.example"},
    %{value: "c-1007", label: "Wonka Ltd", subtitle: "finance@wonka.example"},
    %{value: "c-1008", label: "Cyberdyne", subtitle: "accounts@cyberdyne.example"},
    %{value: "c-1009", label: "Soylent Corp", subtitle: "billing@soylent.example"},
    %{value: "c-1010", label: "Hooli", subtitle: "ap@hooli.example"},
    %{value: "c-1011", label: "Pied Piper", subtitle: "finance@piedpiper.example"},
    %{value: "c-1012", label: "Vandelay Industries", subtitle: "accounts@vandelay.example"}
  ]

  @payment_code """
  # HEEx — options declarative; hook={true} installs the pushToServer bridge:
  <.web_multiselect id="customers" hook={true} multiple options={@customers} />

  // JS — the ONE callback on this page. Action-button onClick can't be an attribute
  // (it's a function), but the work it triggers is a plain LiveView round-trip:
  el.actionButtons = [
    { action: 'custom', text: '⚠️ Payment issues',
      onClick: (_ms, ctx) => {
        ctx.controller.showMessage('Loading recent payment issues…', { duration: 0 }); // loader
        ctx.element.pushToServer('payment_issues', {}, (reply) => {
          ctx.controller.hideMessage();
          ctx.controller.setSelected(reply.values, { notify: true });                   // select
        });
      } },
    { action: 'clear-all', text: 'Clear' },
  ];

  # Elixir — the logic lives here: simulate a 1–2s upstream call, reply with ids:
  def handle_event("payment_issues", %{"id" => "customers"}, socket) do
    Process.sleep(1500)
    {:reply, %{values: recent_issue_ids()}, socket}
  end
  """

  # -- EO06 · Client-side REST from an external public API (declarative) --------

  @rest_external_code """
  # HEEx — fully declarative. hook={true} installs the data-fetch-* wiring, and the
  # element fetches its OWN options from the public API on mount. No <script>, no callback.
  <.web_multiselect
    id="rest-users"
    hook={true}
    multiple
    value_member="id"
    display_value_member="name"
    subtitle_member="email"
    placeholder="Loading users…"
    data-fetch-url="https://jsonplaceholder.typicode.com/users"
    data-fetch-headers={Jason.encode!(%{"X-Demo-Header" => "hello-from-elixir"})} />

  # The header value is rendered SERVER-SIDE (from assigns/config), so an API key is
  # minted in Elixir and never hardcoded in a JS asset:
  #   data-fetch-headers={Jason.encode!(%{"Authorization" => "Bearer " <> @api_token})}
  """

  # -- EO07 · Client-side REST from an authenticated same-origin API ------------

  @rest_api_code """
  # router.ex — a same-origin JSON API. :fetch_session makes the cookie available.
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", TestAppWeb.Api do
    pipe_through :api
    get "/products", ProductsController, :index
  end

  # controller — the browser's fetch used credentials: "same-origin" (the wrapper's
  # default), so the Phoenix session cookie arrived with the request. authorize/1 can
  # gate on the logged-in user; NO token is exposed in the DOM.
  def index(conn, params) do
    case authorize(conn) do
      :ok -> json(conn, filter(@products, params["q"]))
      :unauthorized -> conn |> put_status(:unauthorized) |> json(%{error: "unauthorized"})
    end
  end

  # HEEx — declarative, hitting our own authed endpoint with a fixed ?q= filter.
  <.web_multiselect
    id="rest-products"
    hook={true}
    multiple
    value_member="value"
    display_value_member="label"
    subtitle_member="subtitle"
    placeholder="Loading products over $100…"
    data-fetch-url="/api/products?q=price>100"
    data-fetch-credentials="same-origin" />

  # Turn the same endpoint into a live typeahead by switching modes — the hook then
  # installs a searchCallback that hits /api/products?q=<typed text>:
  #   data-fetch-mode="search"  (query param defaults to "q"; override with
  #   data-fetch-query-param="…")
  """

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
     |> assign(:departments, [])
     |> assign(:customers, @customers)
     |> assign(:issue_round, 0)
     |> assign(:payment_code, @payment_code)
     |> assign(:rest_external_code, @rest_external_code)
     |> assign(:rest_api_code, @rest_api_code)}
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

  # EO05 · Action-button server bridge. The button's onClick calls
  # `ctx.element.pushToServer("payment_issues", {}, cb)`, which tunnels here through the
  # hook. We simulate a slow upstream (payment gateway / reporting DB) and reply with the
  # customer ids to select; the browser callback hides the loader and selects them.
  #
  # NOTE: Process.sleep blocks THIS LiveView process — fine for a single-user demo (it's
  # what makes the client-side loader worth showing). A real app would run the lookup async
  # (start_async / Task) so the process stays responsive.
  def handle_event("payment_issues", %{"id" => "customers"}, socket) do
    Process.sleep(1500)
    round = socket.assigns.issue_round
    {:reply, %{values: recent_issue_ids(round)}, assign(socket, :issue_round, round + 1)}
  end

  # The hooked widgets forward select/deselect/change; drain any we don't act on
  # so an unhandled event can't crash the page (see ai/server-updates.txt).
  def handle_event("web_multiselect:" <> _, _params, socket), do: {:noreply, socket}

  # A rotating 4-customer window so repeated clicks return a different "recent" set —
  # the demo feels live rather than canned.
  defp recent_issue_ids(round) do
    ids = Enum.map(@customers, & &1.value)
    n = length(ids)
    start = rem(round * 3, n)
    Enum.map(0..3, fn i -> Enum.at(ids, rem(start + i, n)) end)
  end

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
      <.note title="Declarative first — server logic, not client logic">
        The Custom Rendering and Data &amp; API pages wire the element from an inline
        <code>&lt;script&gt;</code> (<code>wait(id).then(el => …)</code>). Here it's HEEx and
        config: options and selection as attributes, a shared shadow-DOM theme from
        <code>config</code>, one-off tweaks via CSS variables, and server-driven data through the
        hook. The lone exception is <strong>EO05</strong>'s action button — <code>onClick</code> is a
        function, so it can't be an attribute — but even there the actual work is a LiveView
        round-trip (<code>pushToServer</code> → <code>handle_event</code>), so the logic stays in Elixir.
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

      <.card title="EO05 · Action button → server → selection (with a loader)">
        <.tip>
          <code>hook={true}</code> · action-button <code>onClick</code> uses <code>ctx.element.pushToServer</code> · reply → <code>{"ctx.controller.setSelected(reply.values, { notify: true })"}</code>
        </.tip>
        <p>
          A real-world shape: customers pay online, so statuses settle with a delay. The
          <strong>⚠️ Payment issues</strong> action button doesn't know the answer — it asks the
          server. Because the lookup takes a second or two, the callback shows a <strong>loader</strong>
          (<code>ctx.controller.showMessage(…, &lbrace; duration: 0 &rbrace;)</code>) while it waits, then
          selects whatever the reply returns. The button reaches the server through
          <code>ctx.element.pushToServer</code> — the bridge the hook installs — since action callbacks
          can't call <code>pushEventTo</code> themselves.
        </p>

        <.note>
          This is the page's one bit of per-instance JS: action buttons carry function callbacks
          (<code>onClick</code>), which can't be serialized as HEEx attributes. But it's the same
          server round-trip as EO03/EO04 under the hood — the <code>handle_event/3</code> below does
          the work and replies with <code>{"{:reply, %{values: ids}, socket}"}</code>.
        </.note>

        <.form_group>
          <label class="demo-label">Open the picker, then click <strong>⚠️ Payment issues</strong> in the action bar:</label>
          <.web_multiselect
            id="customers"
            hook={true}
            multiple={true}
            options={@customers}
            value_member="value"
            display_value_member="label"
            subtitle_member="subtitle"
            search_placeholder="Search customers…"
          />
          <.output_panel id="out-customers" label="Selected customers:" placeholder="[]" />
        </.form_group>

        <.code_block lang="elixir">{@payment_code}</.code_block>

        <script type="module">
          const wait = (id) => new Promise((resolve) => {
            const check = () => {
              const el = document.getElementById(id);
              if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
              else requestAnimationFrame(check);
            };
            check();
          });

          wait('customers').then((el) => {
            el.actionButtons = [
              {
                action: 'custom',
                text: '⚠️ Payment issues',
                cssClass: 'js-issues',
                tooltip: 'Fetch customers with recent payment issues from the server',
                onClick: (_ms, ctx) => {
                  // Loader: a sticky toast via the shared controller (visible even in the
                  // fullscreen overlay). duration:0 keeps it up until we hide it.
                  ctx.controller.showMessage('⏳ Loading recent payment issues…', { variant: 'info', duration: 0 });

                  // The bridge lives on the element (installed by the hook). Guard so the
                  // demo degrades gracefully if the element wasn't hooked.
                  if (typeof ctx.element.pushToServer !== 'function') {
                    ctx.controller.hideMessage();
                    ctx.controller.showMessage('Server bridge unavailable — add hook={true}.', { variant: 'error' });
                    return;
                  }

                  // Ask the server; the reply carries the customer ids to select.
                  ctx.element.pushToServer('payment_issues', {}, (reply) => {
                    ctx.controller.hideMessage();
                    const values = (reply && reply.values) || [];
                    ctx.controller.setSelected(values, { notify: true });
                    ctx.controller.showMessage(`Selected ${values.length} customer(s) with recent issues`, { variant: 'success', duration: 2500 });
                  });
                }
              },
              { action: 'clear-all', text: 'Clear' }
            ];

            // Mirror the live selection into the output panel.
            const pre = document.getElementById('out-customers');
            const renderOut = () => { if (pre) pre.textContent = JSON.stringify(el.getValue(), null, 2); };
            el.addEventListener('change', renderOut);
            renderOut();
          });
        </script>
      </.card>

      <.card title="EO06 · Client-side REST — fetch options from an external API (with a header)">
        <.tip>
          <code>hook={true}</code> · <code>data-fetch-url="…"</code> · <code>data-fetch-headers={"{Jason.encode!(%{…})}"}</code> — no <code>&lt;script&gt;</code>
        </.tip>
        <p>
          Sometimes the options live behind a plain HTTP endpoint and there's no reason to relay
          them through the LiveView. Point the element at the URL with <code>data-fetch-url</code>
          and the hook fetches it on mount, assigning the JSON straight to <code>options</code>
          (raw rows are consumed as-is via <code>value_member</code>/<code>display_value_member</code>).
          It stays <strong>fully declarative</strong> — the attributes pass through the component's
          <code>:rest</code>, so there's no per-instance JavaScript.
        </p>
        <p>
          To add an HTTP header — an API key, an <code>Authorization: Bearer …</code>, a custom
          <code>X-*</code> — pass <code>data-fetch-headers</code> a JSON object. Crucially the value is
          rendered <strong>server-side</strong> from <code>@assigns</code>/config, so a secret is minted
          in Elixir and never hardcoded into a JS bundle. Here we send a demo <code>X-Demo-Header</code>.
        </p>

        <.form_group>
          <label>Users (browser → jsonplaceholder.typicode.com, with a custom header)</label>
          <.web_multiselect
            id="rest-users"
            hook={true}
            multiple
            value_member="id"
            display_value_member="name"
            subtitle_member="email"
            placeholder="Loading users…"
            data-fetch-url="https://jsonplaceholder.typicode.com/users"
            data-fetch-headers={Jason.encode!(%{"X-Demo-Header" => "hello-from-elixir"})}
          />
        </.form_group>

        <.code_block lang="heex">{@rest_external_code}</.code_block>

        <.note>
          Cross-origin note: a custom request header (anything beyond the CORS "simple" set) makes
          the browser send a <strong>preflight</strong> <code>OPTIONS</code> first — the API must
          answer it with a matching <code>Access-Control-Allow-Headers</code>, or the fetch is
          blocked. jsonplaceholder reflects requested headers, so the demo works; your own API needs
          the CORS headers configured. For any endpoint that <em>doesn't</em> allow browser CORS,
          route the fetch through the LiveView instead (see EO04).
        </.note>
      </.card>

      <.card title="EO07 · Client-side REST — an authenticated same-origin API (cookie auth)">
        <.tip>
          <code>data-fetch-url="/api/products?q=price&gt;100"</code> · <code>data-fetch-credentials="same-origin"</code> — the session cookie authenticates it
        </.tip>
        <p>
          When the endpoint is your <strong>own</strong> app, authentication is free. The wrapper's
          fetch defaults to <code>credentials: "same-origin"</code>, so the Phoenix
          <strong>session cookie rides along automatically</strong> — the same cookie every other
          request carries. The API's ordinary session/auth plug pipeline gates it server-side, and
          <strong>no token is ever placed in the DOM</strong>. The <code>?q=price&gt;100</code> filter
          is just part of the URL; the controller applies it and returns the matching rows.
        </p>

        <.form_group>
          <label>Products over $100 (browser → /api/products, authenticated by the session cookie)</label>
          <.web_multiselect
            id="rest-products"
            hook={true}
            multiple
            value_member="value"
            display_value_member="label"
            subtitle_member="subtitle"
            placeholder="Loading products over $100…"
            data-fetch-url="/api/products?q=price>100"
            data-fetch-credentials="same-origin"
          />
        </.form_group>

        <.code_block lang="elixir">{@rest_api_code}</.code_block>

        <.note>
          Same-origin cookie auth is the simple, safe default for your own API. For a <em>separate</em>
          service (different origin, token-based), don't ship a long-lived secret to the browser —
          mint a short-lived, scoped token server-side with <code>Phoenix.Token.sign/4</code>, inject
          it into <code>data-fetch-headers</code> as an <code>Authorization: Bearer</code>, and verify
          it on the API with <code>Phoenix.Token.verify/4</code>. Switch this card to a live typeahead
          by adding <code>data-fetch-mode="search"</code> — the hook then queries
          <code>/api/products?q=&lt;typed text&gt;</code> on each keystroke.
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
