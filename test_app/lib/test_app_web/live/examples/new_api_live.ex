defmodule TestAppWeb.Examples.NewApiLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Example 1 — custom object structure (keyed by userId, displayed by fullName).
  @users [
    %{userId: 1, fullName: "John Doe", email: "john@example.com", role: "Admin", avatar: "👨‍💼"},
    %{userId: 2, fullName: "Jane Smith", email: "jane@example.com", role: "User", avatar: "👩‍💻"},
    %{userId: 3, fullName: "Alice Johnson", email: "alice@example.com", role: "Manager", avatar: "👩‍💼"},
    %{userId: 4, fullName: "Bob Wilson", email: "bob@example.com", role: "User", avatar: "👨‍💻"}
  ]

  # Example 2 — [key, value] tuple arrays (auto-detected).
  @languages [
    {"js", "JavaScript"},
    {"ts", "TypeScript"},
    {"py", "Python"},
    {"go", "Go"},
    {"rust", "Rust"},
    {"java", "Java"}
  ]

  # Examples 4-6 — form integration datasets.
  @skills [
    {"js", "JavaScript"},
    {"ts", "TypeScript"},
    {"py", "Python"},
    {"react", "React"},
    {"vue", "Vue.js"}
  ]

  @categories [
    {"tech", "Technology"},
    {"design", "Design"},
    {"business", "Business"},
    {"marketing", "Marketing"},
    {"sales", "Sales"}
  ]

  @tags [
    {"urgent", "Urgent"},
    {"feature", "Feature Request"},
    {"bug", "Bug Fix"},
    {"enhancement", "Enhancement"},
    {"documentation", "Documentation"}
  ]

  # Example 7 — mode-dependent API.
  @options_simple [
    {"opt1", "Option 1"},
    {"opt2", "Option 2"},
    {"opt3", "Option 3"}
  ]

  # Example 9 — basic badge tooltips dataset.
  @laptops [
    %{value: "1", label: "MacBook Pro 16\"", subtitle: "M3 Max, 36GB RAM, 1TB SSD"},
    %{value: "2", label: "Dell XPS 15", subtitle: "Intel i9, 32GB RAM, 512GB SSD"},
    %{value: "3", label: "ThinkPad X1 Carbon", subtitle: "Intel i7, 16GB RAM, 256GB SSD"},
    %{value: "4", label: "Surface Laptop 5", subtitle: "Intel i5, 8GB RAM, 256GB SSD"},
    %{value: "5", label: "HP Spectre x360", subtitle: "Intel i7, 16GB RAM, 512GB SSD"}
  ]

  # ---- Wrapper-specific extras (LiveView-driven cascade + LV-tunneled search) ----

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
     |> assign(:page_title, "New Flexible API — keen_web_multiselect")
     |> assign(:users, @users)
     |> assign(:languages, @languages)
     |> assign(:skills, @skills)
     |> assign(:categories, @categories)
     |> assign(:tags, @tags)
     |> assign(:options_simple, @options_simple)
     |> assign(:laptops, @laptops)
     |> assign(:organizations, @organizations)
     |> assign(:selected_org, nil)
     |> assign(:business_units, [])
     |> assign(:selected_unit, nil)
     |> assign(:departments, [])
     |> assign(:form_payload, "(submit the form to see captured params)")}
  end

  # ---- Wrapper-specific extras: LiveView-driven cascade --------------------

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

  def handle_event("web_multiselect:change", _params, socket), do: {:noreply, socket}
  def handle_event("web_multiselect:select", _params, socket), do: {:noreply, socket}
  def handle_event("web_multiselect:deselect", _params, socket), do: {:noreply, socket}

  def handle_event("github_search", %{"query" => query, "id" => _id}, socket) do
    {:reply, %{results: github_search_users(query)}, socket}
  end

  def handle_event("form_submit", params, socket) do
    {:noreply, assign(socket, :form_payload, inspect(params, pretty: true))}
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
      icon="🚀"
      title="New Flexible API"
      subtitle="Flexible data handling, form integration, and powerful new features"
    >
      <.card title="1. Custom Object Structure">
        <.tip><code>value_member="userId"</code> · <code>display_value_member="fullName"</code> · <code>subtitle_member="email"</code></.tip>
        <p>
          Use your own data structure! Specify which properties to use for value, display, and other fields using <code>value_member</code>
          and <code>display_value_member</code>.
        </p>

        <.form_group>
          <label>Select Users:</label>
          <.web_multiselect
            id="custom-objects"
            options={@users}
            value_member="userId"
            display_value_member="fullName"
            subtitle_member="email"
          />
        </.form_group>
      </.card>

      <.card title="2. [key, value] Tuple Arrays">
        <.tip>Just pass tuples to <code>{"options={@languages}"}</code> — no <code>value_member</code>/<code>display_value_member</code> needed</.tip>
        <p>
          Auto-detected! Simply pass an array of <code>[key, value]</code>
          tuples. Perfect for simple key-value pairs without creating objects.
        </p>

        <.form_group>
          <label>Select Programming Languages:</label>
          <.web_multiselect id="tuples" options={@languages} />
        </.form_group>
      </.card>

      <.card title="3. Callbacks for Complex Logic">
        <p>
          Use callbacks when you need complex logic to extract values. Callbacks take precedence over members.
        </p>

        <.form_group>
          <label>Select Products (out of stock disabled):</label>
          <.web_multiselect id="callbacks" />
        </.form_group>

        <.note>
          <code>getValueCallback</code>, <code>getDisplayValueCallback</code>, <code>getSubtitleCallback</code>
          and <code>getDisabledCallback</code>
          can't be serialized as HTML attributes — they're assigned to the element by id in the inline script below.
        </.note>
      </.card>

      <.card title="4. Form Integration - JSON Format">
        <.tip><code>name="skills"</code> + <code>value_format="json"</code> writes a hidden input the form submits</.tip>
        <p>
          Seamless HTML form integration! Hidden inputs are automatically created and updated. Choose from 3 formats: <code>json</code>, <code>csv</code>, or <code>array</code>.
        </p>

        <form id="form-json" phx-submit="form_submit">
          <label>Select Your Skills:</label>
          <.web_multiselect id="form-json-select" name="skills" value_format="json" options={@skills} />

          <div class="form-actions">
            <button type="submit">Submit Form</button>
          </div>
        </form>
      </.card>

      <.card title="5. Form Integration - CSV Format">
        <.tip><code>value_format="csv"</code> submits a single comma-separated hidden input</.tip>
        <p>
          Use CSV format for traditional comma-separated values. Great for legacy systems.
        </p>

        <form id="form-csv" phx-submit="form_submit">
          <label>Select Categories:</label>
          <.web_multiselect id="form-csv-select" name="categories" value_format="csv" options={@categories} />

          <div class="form-actions">
            <button type="submit">Submit Form</button>
          </div>
        </form>
      </.card>

      <.card title="6. Form Integration - Array Format">
        <.tip><code>value_format="array"</code> emits one hidden input per value as <code>tags[]</code></.tip>
        <p>
          Use array format to create multiple hidden inputs. Standard HTML array handling with <code>name[]</code>.
        </p>

        <form id="form-array" phx-submit="form_submit">
          <label>Select Tags:</label>
          <.web_multiselect id="form-array-select" name="tags" value_format="array" options={@tags} />

          <div class="form-actions">
            <button type="submit">Submit Form</button>
          </div>
        </form>

        <h3 style="margin-top:1rem">Captured params</h3>
        <pre style="background:#f7fafc;padding:1rem;border-radius:8px;font-family:'Courier New',monospace;font-size:0.85rem;white-space:pre-wrap">{@form_payload}</pre>
      </.card>

      <.card title="7. New Public API Methods">
        <.tip><code>{"multiple={false}"}</code> switches single-select mode (returns a scalar); omit it for multi-select</.tip>
        <p>
          New properties and methods for easier value access:
        </p>

        <ul class="feature-list">
          <li><code>getValue()</code> - Returns single value or array depending on mode</li>
          <li><code>selectedValue</code> - Get the selected value(s)</li>
          <li><code>selectedItem</code> - Get the first selected item object</li>
          <li><code>getSelected()</code> - Get all selected item objects</li>
        </ul>

        <.grid_2>
          <.form_group>
            <label>Single Select:</label>
            <.web_multiselect id="single-mode" multiple={false} options={@options_simple} />
          </.form_group>
          <.form_group>
            <label>Multi Select:</label>
            <.web_multiselect id="multi-mode" options={@options_simple} />
          </.form_group>
        </.grid_2>
      </.card>

      <.card title="8. Async Search / Lookup">
        <.tip><code>{"min_search_length={2}"}</code> · <code>{"search_debounce={300}"}</code> · <code>icon_member="flag"</code></.tip>
        <p>
          Load options dynamically as users type. Perfect for large datasets, API searches, or real-time filtering.
        </p>

        <.note>
          <code>searchCallback</code>
          receives an <code>AbortSignal</code>
          as its 2nd argument. Forward it to <code>fetch</code>
          so a superseded keystroke cancels the in-flight request. Pair with <code>search_debounce</code>
          to also coalesce keystroke bursts. These callbacks are assigned to each element by id in the inline script below.
        </.note>

        <h3>User Search (GitHub API with Fallback)</h3>
        <.form_group>
          <label>Search GitHub Users (tries API, falls back to mock data if rate-limited):</label>
          <.web_multiselect
            id="async-search"
            min_search_length={2}
            search_placeholder="Type to search GitHub users..."
            search_hint="💡 Type at least 2 characters to search"
          />
          <div class="req-log" id="github-log"></div>
        </.form_group>

        <h3>Product Search (Simulated API)</h3>
        <.form_group>
          <label>Search Products:</label>
          <div class="delay-control">
            <label for="product-delay">Simulated API delay:</label>
            <input type="range" id="product-delay" min="0" max="5000" step="100" value="1500" />
            <span class="delay-value" id="product-delay-value">1500 ms</span>
          </div>
          <p class="description" style="margin: 0 0 0.5rem;">
            Crank the delay up, then type quickly — each keystroke fires a request and cancels the previous in-flight one (watch the log below).
          </p>
          <.web_multiselect
            id="product-search"
            min_search_length={1}
            search_placeholder="Search products..."
            display_value_member="name"
            subtitle_member="category"
            value_member="id"
          />
          <div class="req-log" id="product-log"></div>
        </.form_group>

        <h3>Debounced Search (<code>search-debounce</code>)</h3>
        <.form_group>
          <label>Type quickly and watch how few API calls actually fire:</label>
          <div class="delay-control">
            <label for="debounce-ms">Debounce:</label>
            <input type="range" id="debounce-ms" min="0" max="800" step="50" value="300" />
            <span class="delay-value" id="debounce-ms-value">300 ms</span>
          </div>
          <p class="description" style="margin: 0 0 0.5rem;">
            The API call fires only after you pause typing for the debounce window — so a fast burst of keystrokes collapses into a single request. Set it to <code>0</code>
            to fire on every keystroke.
          </p>
          <div class="delay-control" style="gap: 1.75rem;">
            <span>Keystrokes: <strong id="debounce-keystrokes">0</strong></span>
            <span>API calls: <strong id="debounce-apicalls">0</strong></span>
          </div>
          <.web_multiselect
            id="debounce-search"
            min_search_length={1}
            search_debounce={300}
            search_placeholder="Search products (debounced)..."
            display_value_member="name"
            subtitle_member="category"
            value_member="id"
          />
          <div class="req-log" id="debounce-log"></div>
        </.form_group>

        <h3>Country Lookup with Icons</h3>
        <.form_group>
          <label>Search Countries:</label>
          <.web_multiselect
            id="country-search"
            min_search_length={2}
            search_placeholder="Search countries..."
            value_member="code"
            display_value_member="name"
            icon_member="flag"
          />
        </.form_group>
      </.card>

      <.card title="💬 Badge Tooltips">
        <.tip><code>{"enable_badge_tooltips={true}"}</code> · <code>badge_tooltip_placement="top"</code></.tip>
        <p>
          Show informative tooltips when hovering over badges and remove buttons. Perfect for truncated text or additional context.
        </p>

        <h3>Basic Tooltips</h3>
        <.form_group>
          <.web_multiselect
            id="tooltips-basic"
            options={@laptops}
            enable_badge_tooltips={true}
            badge_tooltip_placement="top"
            search_placeholder="Select items (hover badges to see tooltips)..."
          />
        </.form_group>

        <h3>Custom Tooltip Callback</h3>
        <.form_group>
          <.web_multiselect
            id="tooltips-custom"
            enable_badge_tooltips={true}
            search_placeholder="Select users (custom tooltip content)..."
          />
        </.form_group>

        <.note>
          <strong>Default content:</strong>
          display value + subtitle. <strong>Custom content:</strong>
          use <code>getBadgeTooltipCallback</code>
          (assigned in the inline script) for rich content. Remove-button tooltips show "Remove [item name]"; placement is configurable (top, bottom, left, right).
        </.note>
      </.card>

      <.card title="🎨 Custom Badge Display">
        <p>
          Show different text in badges vs dropdown options. This example shows <strong>full details in dropdown</strong>
          ("John Doe - Senior Developer") with subtitle showing email, but <strong>just first names in badges</strong>
          ("John") for maximum space efficiency!
        </p>

        <.form_group>
          <label>Select Team Members:</label>
          <.web_multiselect
            id="custom-badge-display"
            search_placeholder="Search team members (see the difference!)..."
          />
        </.form_group>

        <.note>
          <code>getDisplayValueCallback</code>
          drives the dropdown text while <code>getBadgeDisplayCallback</code>
          drives the compact badge text — both assigned in the inline script. It falls back to the standard display value when <code>getBadgeDisplayCallback</code>
          isn't provided.
        </.note>
      </.card>

      <.card title="🎛️ Custom Action Buttons">
        <p>
          Full control over dropdown action buttons! Add Select All, Clear All, and custom actions with dynamic visibility, tooltips, and custom handlers.
        </p>

        <.form_group>
          <label>Select Programming Languages:</label>
          <.web_multiselect
            id="action-buttons-demo"
            search_placeholder="See custom action buttons in dropdown..."
          />
        </.form_group>

        <.note>
          Built-in <code>'select-all'</code>
          / <code>'clear-all'</code>
          plus custom actions with <code>onClick</code>, dynamic visibility via <code>getIsVisibleCallback</code>, tooltips, and CSS classes. The <code>actionButtons</code>
          array is assigned in the inline script below.
        </.note>
      </.card>

      <.card title="🔗 Cascading Selects (Reactive Options)">
        <p>
          Create dependent dropdowns that automatically update! Setting <code>element.options = newArray</code>
          triggers automatic re-rendering. Perfect for Organization → Business Unit → Department flows. This card mirrors upstream's pure-JS reactive cascade; a LiveView-driven variant lives in the extras section below.
        </p>

        <.form_group>
          <label>Organization → Business Unit → Department Cascade:</label>

          <div style="display: grid; gap: 1rem; margin: 1rem 0;">
            <div>
              <label style="display: block; margin-bottom: 0.5rem; color: #4a5568; font-weight: 600;">
                1️⃣ Select Organization
              </label>
              <.web_multiselect
                id="js-cascade-org"
                multiple={false}
                search_placeholder="Select organization..."
              />
            </div>

            <div style="padding-left: 1.5rem; border-left: 3px solid #e2e8f0;">
              <label style="display: block; margin-bottom: 0.5rem; color: #4a5568; font-weight: 600;">
                2️⃣ Select Business Unit
                <span id="bu-status" style="color: #a0aec0; font-weight: normal; font-size: 0.875rem;">(select organization first)</span>
              </label>
              <.web_multiselect
                id="js-cascade-bu"
                multiple={false}
                search_placeholder="Select business unit..."
              />
            </div>

            <div style="padding-left: 3rem; border-left: 3px solid #e2e8f0;">
              <label style="display: block; margin-bottom: 0.5rem; color: #4a5568; font-weight: 600;">
                3️⃣ Select Department
                <span id="dept-status" style="color: #a0aec0; font-weight: normal; font-size: 0.875rem;">(select business unit first)</span>
              </label>
              <.web_multiselect
                id="js-cascade-dept"
                multiple={false}
                search_placeholder="Select department..."
              />
            </div>
          </div>

          <div class="output">
            <div class="output-label">Selected Path:</div>
            <pre id="output-cascade" phx-update="ignore">{"{\n  \"organization\": null,\n  \"businessUnit\": null,\n  \"department\": null\n}"}</pre>
          </div>

          <button type="button" onclick="resetCascade()">Reset Cascade</button>
        </.form_group>
      </.card>

      <.card title="✨ Benefits Summary">
        <.grid_2>
          <div>
            <h3>Flexible Data Handling</h3>
            <ul class="feature-list">
              <li>Works with any data structure</li>
              <li>No need to transform your data</li>
              <li>Auto-detects tuple arrays</li>
              <li>Member or callback patterns</li>
              <li>Full TypeScript support</li>
            </ul>
          </div>
          <div>
            <h3>Form Integration</h3>
            <ul class="feature-list">
              <li>Automatic hidden input creation</li>
              <li>3 format options (JSON, CSV, array)</li>
              <li>Custom formatters via callback</li>
              <li>Auto-updates on changes</li>
              <li>Standard HTML form behavior</li>
            </ul>
          </div>
        </.grid_2>
      </.card>

      <.card title="🧩 Wrapper-specific extras (not in upstream)">
        <.tip><code>hook="KeenWebMultiselectHook"</code> · server-driven <code>{"options={@business_units}"}</code> · <code>search_event="github_search"</code></.tip>
        <.note>
          These examples go beyond upstream's example page — they show the same cascading and async-search
          features driven through Phoenix LiveView (server-side) instead of pure browser JavaScript.
        </.note>

        <h3>🔗 Cascading selects (LiveView-driven)</h3>
        <p>
          Three coupled multiselects. Selecting an organization sends a <code>change</code>
          event through the LV hook, the server fetches the matching business units, then pushes the new options back to the dependent multiselect via <code>push_event(socket, "web_multiselect:update", %{"{id, options, value}"})</code>. Same flow from unit → department.
        </p>

        <.note>
          Why push_event instead of just re-rendering <code>options={"{@business_units}"}</code>? The wrapper auto-emits <code>phx-update="ignore"</code>
          on the element so morphdom doesn't tear down the component's internally-managed children. That ignore also blocks LV from morphing the <code>data-options</code>
          attribute on subsequent renders — so the canonical way to mutate option-list or selection state from the server is through the hook's <code>handleEvent</code>
          channel.
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

        <h3 style="margin-top:1.5rem">🛜 Async search — LiveView tunneled (Elixir fetches GitHub)</h3>
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
    </.example_page>

    <script type="module">
      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // Example 3: Callbacks
      wait('callbacks').then((callbacksSelect) => {
        const products = [
          { sku: 'PRD-001', name: 'Laptop', price: 999, inStock: true },
          { sku: 'PRD-002', name: 'Mouse', price: 29, inStock: false },
          { sku: 'PRD-003', name: 'Keyboard', price: 79, inStock: true },
          { sku: 'PRD-004', name: 'Monitor', price: 299, inStock: false },
          { sku: 'PRD-005', name: 'Webcam', price: 89, inStock: true }
        ];

        callbacksSelect.getValueCallback = (item) => item.sku;
        callbacksSelect.getDisplayValueCallback = (item) => `${item.name} - $${item.price}`;
        callbacksSelect.getSubtitleCallback = (item) => item.inStock ? 'In Stock ✓' : 'Out of Stock';
        callbacksSelect.getDisabledCallback = (item) => !item.inStock;
        callbacksSelect.options = products;
      });

      // Example 8: Async Search

      // Append a colour-coded line to a request log, newest at the bottom.
      function logRequest(logId, kind, message) {
        const log = document.getElementById(logId);
        if (!log) return;
        const entry = document.createElement('div');
        entry.className = `entry entry--${kind}`;
        const label = { start: '→', done: '✓', cancelled: '⛔', error: '⚠️' }[kind] || '•';
        entry.textContent = `${label} ${message}`;
        log.appendChild(entry);
        log.scrollTop = log.scrollHeight;
        while (log.childElementCount > 30) log.removeChild(log.firstChild);
      }

      // A setTimeout that rejects with an AbortError if the signal fires first.
      function abortableDelay(ms, signal) {
        return new Promise((resolve, reject) => {
          if (signal?.aborted) {
            reject(new DOMException('Aborted', 'AbortError'));
            return;
          }
          const timer = setTimeout(resolve, ms);
          signal?.addEventListener('abort', () => {
            clearTimeout(timer);
            reject(new DOMException('Aborted', 'AbortError'));
          }, { once: true });
        });
      }

      // 8a. GitHub Users Search
      wait('async-search').then((asyncSearchSelect) => {
        const mockGitHubUsers = [
          { login: 'octocat', id: 583231 },
          { login: 'torvalds', id: 1024025 },
          { login: 'gaearon', id: 810438 },
          { login: 'tj', id: 25254 },
          { login: 'sindresorhus', id: 170270 },
          { login: 'addyosmani', id: 110953 },
          { login: 'paulirish', id: 39191 },
          { login: 'substack', id: 12631 },
          { login: 'mbostock', id: 230541 },
          { login: 'defunkt', id: 2 }
        ];

        asyncSearchSelect.searchCallback = async (searchTerm, signal) => {
          logRequest('github-log', 'start', `GET users?q=${searchTerm}`);
          try {
            const response = await fetch(
              `https://api.github.com/search/users?q=${searchTerm}&per_page=10`,
              { signal }
            );

            if (!response.ok) {
              console.warn('GitHub API rate limit reached, using mock data');
              const term = searchTerm.toLowerCase();
              const filtered = mockGitHubUsers.filter(user =>
                user.login.toLowerCase().includes(term)
              );

              return [
                {
                  value: '__error__',
                  label: '⚠️ GitHub API Rate Limit - Showing Mock Data',
                  subtitle: 'API is temporarily unavailable',
                  disabled: true
                },
                ...filtered.map(user => ({
                  value: user.login,
                  label: user.login,
                  subtitle: `ID: ${user.id} (mock data)`,
                  icon: '👤'
                }))
              ];
            }

            const data = await response.json();

            if (!data.items || !Array.isArray(data.items)) {
              console.warn('Invalid GitHub API response, using mock data');
              const term = searchTerm.toLowerCase();
              const filtered = mockGitHubUsers.filter(user =>
                user.login.toLowerCase().includes(term)
              );

              return [
                {
                  value: '__error__',
                  label: '⚠️ Invalid API Response - Showing Mock Data',
                  subtitle: 'Could not parse GitHub API response',
                  disabled: true
                },
                ...filtered.map(user => ({
                  value: user.login,
                  label: user.login,
                  subtitle: `ID: ${user.id} (mock data)`,
                  icon: '👤'
                }))
              ];
            }

            logRequest('github-log', 'done', `${data.items.length} users for "${searchTerm}"`);
            return data.items.map(user => ({
              value: user.login,
              label: user.login,
              subtitle: `ID: ${user.id}`,
              icon: '👤'
            }));
          } catch (error) {
            if (error.name === 'AbortError') {
              logRequest('github-log', 'cancelled', `cancelled "${searchTerm}" (superseded)`);
              throw error;
            }
            console.error('GitHub search error:', error);
            const term = searchTerm.toLowerCase();
            const filtered = mockGitHubUsers.filter(user =>
              user.login.toLowerCase().includes(term)
            );

            return [
              {
                value: '__error__',
                label: '⚠️ Network Error - Showing Mock Data',
                subtitle: error.message || 'Could not connect to GitHub API',
                disabled: true
              },
              ...filtered.map(user => ({
                value: user.login,
                label: user.login,
                subtitle: `ID: ${user.id} (mock data)`,
                icon: '👤'
              }))
            ];
          }
        };
      });

      // 8b. Simulated Product Search
      wait('product-search').then((productSearchSelect) => {
        const allProducts = [
          { id: 1, name: 'Laptop Pro 15', category: 'Electronics', price: 1299 },
          { id: 2, name: 'Wireless Mouse', category: 'Electronics', price: 29 },
          { id: 3, name: 'Mechanical Keyboard', category: 'Electronics', price: 89 },
          { id: 4, name: 'USB-C Hub', category: 'Electronics', price: 49 },
          { id: 5, name: 'Office Chair Deluxe', category: 'Furniture', price: 299 },
          { id: 6, name: 'Standing Desk', category: 'Furniture', price: 499 },
          { id: 7, name: 'Desk Lamp LED', category: 'Furniture', price: 39 },
          { id: 8, name: 'Monitor 27"', category: 'Electronics', price: 349 },
          { id: 9, name: 'Webcam HD', category: 'Electronics', price: 79 },
          { id: 10, name: 'Headphones Noise-Canceling', category: 'Electronics', price: 199 },
          { id: 11, name: 'Coffee Maker', category: 'Kitchen', price: 89 },
          { id: 12, name: 'Water Bottle', category: 'Kitchen', price: 15 },
          { id: 13, name: 'Notebook Set', category: 'Stationery', price: 12 },
          { id: 14, name: 'Pen Set Premium', category: 'Stationery', price: 24 },
          { id: 15, name: 'Backpack', category: 'Accessories', price: 59 }
        ];
        window.__allProducts = allProducts;

        let productApiDelay = 1500;
        const productDelaySlider = document.getElementById('product-delay');
        const productDelayValue = document.getElementById('product-delay-value');
        productDelaySlider.addEventListener('input', (e) => {
          productApiDelay = Number(e.target.value);
          productDelayValue.textContent = `${productApiDelay} ms`;
        });

        productSearchSelect.searchCallback = async (searchTerm, signal) => {
          logRequest('product-log', 'start', `search "${searchTerm}" (delay ${productApiDelay}ms)`);
          try {
            await abortableDelay(productApiDelay, signal);
          } catch (error) {
            if (error.name === 'AbortError') {
              logRequest('product-log', 'cancelled', `cancelled "${searchTerm}" (superseded by newer search)`);
            }
            throw error;
          }

          const term = searchTerm.toLowerCase();
          const results = allProducts.filter(product =>
            product.name.toLowerCase().includes(term) ||
            product.category.toLowerCase().includes(term)
          );
          logRequest('product-log', 'done', `${results.length} results for "${searchTerm}"`);
          return results;
        };
      });

      // 8b-2. Debounced Search
      wait('debounce-search').then((debounceSearchSelect) => {
        const debounceMsSlider = document.getElementById('debounce-ms');
        const debounceMsValue = document.getElementById('debounce-ms-value');
        let debounceKeystrokes = 0;
        let debounceApiCalls = 0;
        const allProducts = window.__allProducts || [];

        debounceMsSlider.addEventListener('input', (e) => {
          debounceSearchSelect.setAttribute('search-debounce', e.target.value);
          debounceMsValue.textContent = `${e.target.value} ms`;
        });

        debounceSearchSelect.beforeSearchCallback = (term) => {
          debounceKeystrokes++;
          document.getElementById('debounce-keystrokes').textContent = debounceKeystrokes;
          return term;
        };

        debounceSearchSelect.searchCallback = async (searchTerm, signal) => {
          debounceApiCalls++;
          document.getElementById('debounce-apicalls').textContent = debounceApiCalls;
          logRequest('debounce-log', 'start', `API call #${debounceApiCalls}: "${searchTerm}"`);
          try {
            await abortableDelay(250, signal);
          } catch (error) {
            if (error.name === 'AbortError') {
              logRequest('debounce-log', 'cancelled', `cancelled "${searchTerm}"`);
            }
            throw error;
          }

          const term = searchTerm.toLowerCase();
          const results = allProducts.filter(product =>
            product.name.toLowerCase().includes(term) ||
            product.category.toLowerCase().includes(term)
          );
          logRequest('debounce-log', 'done', `${results.length} results for "${searchTerm}"`);
          return results;
        };
      });

      // 8c. Country Search with Flags
      wait('country-search').then((countrySearchSelect) => {
        const countries = [
          { code: 'us', name: 'United States', flag: '🇺🇸' },
          { code: 'gb', name: 'United Kingdom', flag: '🇬🇧' },
          { code: 'de', name: 'Germany', flag: '🇩🇪' },
          { code: 'fr', name: 'France', flag: '🇫🇷' },
          { code: 'es', name: 'Spain', flag: '🇪🇸' },
          { code: 'it', name: 'Italy', flag: '🇮🇹' },
          { code: 'jp', name: 'Japan', flag: '🇯🇵' },
          { code: 'cn', name: 'China', flag: '🇨🇳' },
          { code: 'in', name: 'India', flag: '🇮🇳' },
          { code: 'br', name: 'Brazil', flag: '🇧🇷' },
          { code: 'ca', name: 'Canada', flag: '🇨🇦' },
          { code: 'au', name: 'Australia', flag: '🇦🇺' },
          { code: 'ru', name: 'Russia', flag: '🇷🇺' },
          { code: 'kr', name: 'South Korea', flag: '🇰🇷' },
          { code: 'mx', name: 'Mexico', flag: '🇲🇽' },
          { code: 'nl', name: 'Netherlands', flag: '🇳🇱' },
          { code: 'se', name: 'Sweden', flag: '🇸🇪' },
          { code: 'ch', name: 'Switzerland', flag: '🇨🇭' },
          { code: 'pl', name: 'Poland', flag: '🇵🇱' },
          { code: 'be', name: 'Belgium', flag: '🇧🇪' }
        ];

        countrySearchSelect.searchCallback = async (searchTerm) => {
          await new Promise(resolve => setTimeout(resolve, 200));
          const term = searchTerm.toLowerCase();
          return countries.filter(country =>
            country.name.toLowerCase().includes(term) ||
            country.code.toLowerCase().includes(term)
          );
        };
      });

      // Badge Tooltips: Custom Callback
      wait('tooltips-custom').then((tooltipsCustomSelect) => {
        const users = [
          { id: 1, name: 'John Doe', email: 'john.doe@example.com', role: 'Admin' },
          { id: 2, name: 'Jane Smith', email: 'jane.smith@example.com', role: 'Manager' },
          { id: 3, name: 'Bob Johnson', email: 'bob.johnson@example.com', role: 'Developer' },
          { id: 4, name: 'Alice Williams', email: 'alice.w@example.com', role: 'Designer' },
          { id: 5, name: 'Charlie Brown', email: 'charlie.b@example.com', role: 'Developer' }
        ];

        tooltipsCustomSelect.getValueCallback = (user) => user.id;
        tooltipsCustomSelect.getDisplayValueCallback = (user) => user.name;
        tooltipsCustomSelect.options = users;

        tooltipsCustomSelect.getBadgeTooltipCallback = (user) => {
          return `${user.name}\n${user.email}\n${user.role}`;
        };
      });

      // Custom Badge Display
      wait('custom-badge-display').then((customBadgeDisplaySelect) => {
        const teamMembers = [
          { id: 1, fullName: 'John Doe', firstName: 'John', email: 'john.doe@company.com', role: 'Senior Developer', avatar: '👨‍💻' },
          { id: 2, fullName: 'Jane Smith', firstName: 'Jane', email: 'jane.smith@company.com', role: 'Product Manager', avatar: '👩‍💼' },
          { id: 3, fullName: 'Bob Johnson', firstName: 'Bob', email: 'bob.j@company.com', role: 'UX Designer', avatar: '🎨' },
          { id: 4, fullName: 'Alice Williams', firstName: 'Alice', email: 'alice.w@company.com', role: 'QA Engineer', avatar: '🔍' },
          { id: 5, fullName: 'Charlie Brown', firstName: 'Charlie', email: 'charlie.b@company.com', role: 'DevOps Engineer', avatar: '⚙️' },
          { id: 6, fullName: 'Diana Martinez', firstName: 'Diana', email: 'diana.m@company.com', role: 'Tech Lead', avatar: '🚀' }
        ];

        customBadgeDisplaySelect.getValueCallback = (user) => user.id;
        customBadgeDisplaySelect.getIconCallback = (user) => user.avatar;
        customBadgeDisplaySelect.getSubtitleCallback = (user) => user.email;
        customBadgeDisplaySelect.getDisplayValueCallback = (user) => `${user.fullName} - ${user.role}`;
        customBadgeDisplaySelect.getBadgeDisplayCallback = (user) => user.firstName;
        customBadgeDisplaySelect.options = teamMembers;
      });

      // Custom Action Buttons
      wait('action-buttons-demo').then((actionButtonsDemo) => {
        actionButtonsDemo.options = [
          ['js', 'JavaScript'],
          ['ts', 'TypeScript'],
          ['py', 'Python'],
          ['java', 'Java'],
          ['go', 'Go'],
          ['rust', 'Rust'],
          ['cpp', 'C++'],
          ['ruby', 'Ruby'],
          ['php', 'PHP'],
          ['swift', 'Swift']
        ];

        actionButtonsDemo.actionButtons = [
          {
            action: 'select-all',
            text: 'Select All',
            tooltip: 'Select all items',
            getIsVisibleCallback: (picker) => {
              const allCount = picker.options.options?.length || 0;
              return picker.getSelected().length < allCount;
            }
          },
          {
            action: 'clear-all',
            text: 'Clear All',
            tooltip: 'Clear selection',
            getIsVisibleCallback: (picker) => picker.getSelected().length > 0
          },
          {
            action: 'custom',
            text: 'Invert Selection',
            tooltip: 'Invert current selection',
            cssClass: 'custom-invert-btn',
            onClick: (picker) => {
              const allOptions = picker.options.options || [];
              const allValues = allOptions.map(opt => opt.value || opt[0]);
              const selectedValues = picker.getValue();
              const inverted = allValues.filter(v => !selectedValues.includes(v));
              picker.setSelected(inverted);
            }
          },
          {
            action: 'custom',
            text: 'Select Popular',
            tooltip: 'Select most popular languages',
            onClick: (picker) => {
              picker.setSelected(['js', 'ts', 'py']);
            }
          }
        ];
      });

      // Cascading Selects (Reactive Options) — pure-JS variant
      Promise.all([wait('js-cascade-org'), wait('js-cascade-bu'), wait('js-cascade-dept')]).then(([cascadeOrgSelect, cascadeBuSelect, cascadeDeptSelect]) => {
        const mockData = {
          organizations: [
            { value: 'acme', label: 'ACME Corporation' },
            { value: 'globex', label: 'Globex Corporation' },
            { value: 'initech', label: 'Initech' }
          ],
          businessUnits: {
            acme: [
              { value: 'acme-eng', label: 'Engineering' },
              { value: 'acme-sales', label: 'Sales' },
              { value: 'acme-ops', label: 'Operations' }
            ],
            globex: [
              { value: 'globex-rd', label: 'Research & Development' },
              { value: 'globex-mkt', label: 'Marketing' },
              { value: 'globex-hr', label: 'Human Resources' }
            ],
            initech: [
              { value: 'initech-it', label: 'IT Services' },
              { value: 'initech-fin', label: 'Finance' }
            ]
          },
          departments: {
            'acme-eng': [
              { value: 'acme-eng-fe', label: 'Frontend Team' },
              { value: 'acme-eng-be', label: 'Backend Team' },
              { value: 'acme-eng-qa', label: 'QA Team' }
            ],
            'acme-sales': [
              { value: 'acme-sales-na', label: 'North America' },
              { value: 'acme-sales-eu', label: 'Europe' }
            ],
            'acme-ops': [
              { value: 'acme-ops-dc', label: 'Data Center' },
              { value: 'acme-ops-cloud', label: 'Cloud Operations' }
            ],
            'globex-rd': [
              { value: 'globex-rd-adv', label: 'Advanced Research' },
              { value: 'globex-rd-prod', label: 'Product Development' }
            ],
            'globex-mkt': [
              { value: 'globex-mkt-digital', label: 'Digital Marketing' },
              { value: 'globex-mkt-brand', label: 'Brand Management' }
            ],
            'globex-hr': [
              { value: 'globex-hr-recruit', label: 'Recruitment' },
              { value: 'globex-hr-learning', label: 'Learning & Development' }
            ],
            'initech-it': [
              { value: 'initech-it-infra', label: 'Infrastructure' },
              { value: 'initech-it-sec', label: 'Security' }
            ],
            'initech-fin': [
              { value: 'initech-fin-acc', label: 'Accounting' },
              { value: 'initech-fin-audit', label: 'Audit' }
            ]
          }
        };

        const fetchBusinessUnits = (orgId) => new Promise((resolve) => {
          setTimeout(() => resolve(mockData.businessUnits[orgId] || []), 300);
        });

        const fetchDepartments = (buId) => new Promise((resolve) => {
          setTimeout(() => resolve(mockData.departments[buId] || []), 300);
        });

        let currentSelection = {
          organization: null, organizationLabel: null,
          businessUnit: null, businessUnitLabel: null,
          department: null, departmentLabel: null
        };

        const updateCascadeOutput = () => {
          const output = document.getElementById('output-cascade');
          output.textContent = JSON.stringify({
            organization: currentSelection.organizationLabel,
            organizationId: currentSelection.organization,
            businessUnit: currentSelection.businessUnitLabel,
            businessUnitId: currentSelection.businessUnit,
            department: currentSelection.departmentLabel,
            departmentId: currentSelection.department
          }, null, 2);
        };

        cascadeOrgSelect.options = mockData.organizations;

        cascadeOrgSelect.addEventListener('change', async (e) => {
          const orgId = e.detail.selectedValues[0];
          const orgItem = e.detail.selectedOptions[0];

          if (orgId) {
            currentSelection.organization = orgId;
            currentSelection.organizationLabel = orgItem ? orgItem.label : null;
            currentSelection.businessUnit = null;
            currentSelection.businessUnitLabel = null;
            currentSelection.department = null;
            currentSelection.departmentLabel = null;

            document.getElementById('bu-status').textContent = '(loading...)';
            const buOptions = await fetchBusinessUnits(orgId);
            cascadeBuSelect.options = buOptions;
            cascadeBuSelect.setSelected([]);
            document.getElementById('bu-status').textContent = `(${buOptions.length} available)`;

            cascadeDeptSelect.options = [];
            cascadeDeptSelect.setSelected([]);
            document.getElementById('dept-status').textContent = '(select business unit first)';
          } else {
            currentSelection = {
              organization: null, organizationLabel: null,
              businessUnit: null, businessUnitLabel: null,
              department: null, departmentLabel: null
            };
            cascadeBuSelect.options = [];
            cascadeDeptSelect.options = [];
            document.getElementById('bu-status').textContent = '(select organization first)';
            document.getElementById('dept-status').textContent = '(select business unit first)';
          }

          updateCascadeOutput();
        });

        cascadeBuSelect.addEventListener('change', async (e) => {
          const buId = e.detail.selectedValues[0];
          const buItem = e.detail.selectedOptions[0];

          if (buId) {
            currentSelection.businessUnit = buId;
            currentSelection.businessUnitLabel = buItem ? buItem.label : null;
            currentSelection.department = null;
            currentSelection.departmentLabel = null;

            document.getElementById('dept-status').textContent = '(loading...)';
            const deptOptions = await fetchDepartments(buId);
            cascadeDeptSelect.options = deptOptions;
            cascadeDeptSelect.setSelected([]);
            document.getElementById('dept-status').textContent = `(${deptOptions.length} available)`;
          } else {
            currentSelection.businessUnit = null;
            currentSelection.businessUnitLabel = null;
            currentSelection.department = null;
            currentSelection.departmentLabel = null;
            cascadeDeptSelect.options = [];
            document.getElementById('dept-status').textContent = '(select business unit first)';
          }

          updateCascadeOutput();
        });

        cascadeDeptSelect.addEventListener('change', (e) => {
          const deptId = e.detail.selectedValues[0];
          const deptItem = e.detail.selectedOptions[0];

          if (deptId) {
            currentSelection.department = deptId;
            currentSelection.departmentLabel = deptItem ? deptItem.label : null;
          } else {
            currentSelection.department = null;
            currentSelection.departmentLabel = null;
          }

          updateCascadeOutput();
        });

        window.resetCascade = () => {
          cascadeOrgSelect.setSelected([]);
          cascadeBuSelect.options = [];
          cascadeDeptSelect.options = [];
          currentSelection = {
            organization: null, organizationLabel: null,
            businessUnit: null, businessUnitLabel: null,
            department: null, departmentLabel: null
          };
          document.getElementById('bu-status').textContent = '(select organization first)';
          document.getElementById('dept-status').textContent = '(select business unit first)';
          updateCascadeOutput();
        };
      });
    </script>
    """
  end
end
