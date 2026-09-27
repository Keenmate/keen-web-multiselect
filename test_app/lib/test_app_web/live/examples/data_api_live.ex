defmodule TestAppWeb.Examples.DataApiLive do
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

  # API07 — imperative open/close/toggle demo dataset.
  @openclose_options [
    {"opt1", "Option 1"},
    {"opt2", "Option 2"},
    {"opt3", "Option 3"},
    {"opt4", "Option 4"}
  ]

  # API08 — programmatic search demo dataset.
  @fruits [
    {"apple", "Apple"},
    {"apricot", "Apricot"},
    {"banana", "Banana"},
    {"blueberry", "Blueberry"},
    {"cherry", "Cherry"},
    {"grape", "Grape"},
    {"mango", "Mango"},
    {"melon", "Melon"},
    {"orange", "Orange"},
    {"peach", "Peach"},
    {"pear", "Pear"},
    {"pineapple", "Pineapple"}
  ]

  # Code samples rendered verbatim (backticks / ${} / {} break HEEx interpolation).
  @api07_code """
  const multiselect = document.querySelector('web-multiselect');

  multiselect.open();      // Open the dropdown
  multiselect.close();     // Close the dropdown
  multiselect.toggle();    // Toggle open/closed

  multiselect.isOpen;          // → true / false
  multiselect.isOpen = true;   // open by assignment
  multiselect.isOpen = false;  // close by assignment\
  """

  @api08_code """
  const el = document.querySelector('web-multiselect');

  el.searchMode = 'filter';  // or 'navigate' — governs how the query behaves
  el.search('an');           // apply (as if typed); flush() applies the mode first
  el.open();                 // …call open() to see the effect
  el.searchText;             // → "an"
  el.clearSearch();          // → ""\
  """

  # API09 — deferred initialization (defer / ready()). Backticks / ${} break HEEx.
  @api09_code """
  // <.web_multiselect id="defer-demo" defer={true} value={["js", "ts"]} />
  // `defer` holds the build, so the element paints NOTHING until ready().
  const el = document.querySelector('#defer-demo');

  // Wire everything WHILE HELD — nothing renders yet:
  el.customStylesCallback = () => `.ms__badge { background: #6d28d9; color: #fff; }`;
  el.addEventListener('ready', () => console.log('built flash-free', el.isReady));

  const langs = await loadLanguages();  // e.g. a 2 s fetch
  el.options = langs;                   // assign options…
  el.ready();                           // …then release: builds ONCE, styled, in one shot

  // In LiveView you'd wire this from a phx-hook's mounted() and call el.ready() after your
  // async options land. For the shared-theme case you need NONE of this — configure
  // :shadow_styles and the wrapper defers + releases every select for you (see Elixir Only).\
  """

  # API05 — event-handling demo dataset (canonical value/label).
  @technologies [
    %{value: "js", label: "JavaScript"},
    %{value: "ts", label: "TypeScript"},
    %{value: "python", label: "Python"},
    %{value: "java", label: "Java"},
    %{value: "csharp", label: "C#"},
    %{value: "php", label: "PHP"},
    %{value: "ruby", label: "Ruby"},
    %{value: "go", label: "Go"}
  ]

  # API06 — synchronous options + setSelected code sample (backticks / ${} break HEEx).
  @api06_code """
  const el = document.querySelector('#api06-compact');
  el.options = languages;          // reactive write (coalesces on a microtask)
  el.setSelected(['js', 'ts', 'py']); // imperative call flushes it synchronously\
  """

  # Example 9 — basic badge tooltips dataset.
  @laptops [
    %{value: "1", label: "MacBook Pro 16\"", subtitle: "M3 Max, 36GB RAM, 1TB SSD"},
    %{value: "2", label: "Dell XPS 15", subtitle: "Intel i9, 32GB RAM, 512GB SSD"},
    %{value: "3", label: "ThinkPad X1 Carbon", subtitle: "Intel i7, 16GB RAM, 256GB SSD"},
    %{value: "4", label: "Surface Laptop 5", subtitle: "Intel i5, 8GB RAM, 256GB SSD"},
    %{value: "5", label: "HP Spectre x360", subtitle: "Intel i7, 16GB RAM, 512GB SSD"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Data & API — keen_web_multiselect")
     |> assign(:users, @users)
     |> assign(:languages, @languages)
     |> assign(:skills, @skills)
     |> assign(:categories, @categories)
     |> assign(:tags, @tags)
     |> assign(:options_simple, @options_simple)
     |> assign(:openclose_options, @openclose_options)
     |> assign(:fruits, @fruits)
     |> assign(:api07_code, @api07_code)
     |> assign(:api08_code, @api08_code)
     |> assign(:api09_code, @api09_code)
     |> assign(:technologies, @technologies)
     |> assign(:api06_code, @api06_code)
     |> assign(:laptops, @laptops)
     |> assign(:form_payload, "(submit the form to see captured params)")}
  end

  def handle_event("form_submit", params, socket) do
    {:noreply, assign(socket, :form_payload, inspect(params, pretty: true))}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🚀"
      title="Data & API"
      subtitle="Custom objects, tuple arrays, member/getter callbacks, async search, form integration (json/csv/array), public API methods, and cascading selects."
    >
      <.card title="DA01 · Custom Object Structure">
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

      <.card title="DA02 · [key, value] Tuple Arrays">
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

      <.card title="DA03 · Callbacks for Complex Logic">
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

      <.card title="API01 · Form Integration — JSON Format">
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

      <.card title="API02 · Form Integration — CSV Format">
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

      <.card title="API03 · Form Integration — Array Format">
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

      <.card title="API04 · Public API Methods">
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
            <.web_multiselect id="single-mode" multiple={false} options={@options_simple} value="opt2" />
            <div class="controls" style="margin-top: 0.75rem;">
              <button type="button" onclick="apiMethodsDemo('single-mode', 'getValue')">getValue()</button>
              <button type="button" onclick="apiMethodsDemo('single-mode', 'selectedValue')">selectedValue</button>
              <button type="button" onclick="apiMethodsDemo('single-mode', 'selectedItem')">selectedItem</button>
              <button type="button" onclick="apiMethodsDemo('single-mode', 'getSelected')">getSelected()</button>
            </div>
            <div class="output">
              <div class="output-label">Result:</div>
              <pre id="output-single-mode" phx-update="ignore">Change the selection, then click a method above.</pre>
            </div>
          </.form_group>
          <.form_group>
            <label>Multi Select:</label>
            <.web_multiselect id="multi-mode" options={@options_simple} value={["opt1", "opt3"]} />
            <div class="controls" style="margin-top: 0.75rem;">
              <button type="button" onclick="apiMethodsDemo('multi-mode', 'getValue')">getValue()</button>
              <button type="button" onclick="apiMethodsDemo('multi-mode', 'selectedValue')">selectedValue</button>
              <button type="button" onclick="apiMethodsDemo('multi-mode', 'selectedItem')">selectedItem</button>
              <button type="button" onclick="apiMethodsDemo('multi-mode', 'getSelected')">getSelected()</button>
            </div>
            <div class="output">
              <div class="output-label">Result:</div>
              <pre id="output-multi-mode" phx-update="ignore">Change the selection, then click a method above.</pre>
            </div>
          </.form_group>
        </.grid_2>
      </.card>

      <.card title="API07 · Open / Close API">
        <p>
          Drive the dropdown open state from your own code — wizards, "open on step", or custom trigger buttons. Calling <code>open()</code> from a button's own click handler works directly: the component ignores that opening click so it won't immediately re-close.
        </p>

        <ul class="feature-list">
          <li><code>open()</code> - Open the dropdown</li>
          <li><code>close()</code> - Close the dropdown</li>
          <li><code>toggle()</code> - Toggle the dropdown open/closed</li>
          <li><code>isOpen</code> - Boolean property; reading returns the state, assigning <code>true</code>/<code>false</code> opens/closes it</li>
        </ul>

        <.form_group>
          <label>Controlled Multiselect:</label>
          <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 1rem;">
            <.web_multiselect id="openclose-demo" options={@openclose_options} style="flex: 1 1 240px;" />

            <div class="controls" style="margin-bottom: 0;">
              <button type="button" onclick="openCloseDemo('open')">open()</button>
              <button type="button" onclick="openCloseDemo('close')">close()</button>
              <button type="button" onclick="openCloseDemo('toggle')">toggle()</button>
              <button type="button" onclick="showOpenState()">Read isOpen</button>
            </div>
          </div>

          <div class="output">
            <div class="output-label">isOpen:</div>
            <pre id="output-openclose" phx-update="ignore">false</pre>
          </div>
        </.form_group>

        <.code_block lang="javascript">{@api07_code}</.code_block>
      </.card>

      <.card title="API08 · Search text — read & drive the query">
        <p>
          Read the current search box text with <code>searchText</code>, set it programmatically with <code>search(term)</code> — it applies exactly as if the user typed (runs <code>beforeSearchCallback</code> / <code>minSearchLength</code> / async <code>searchCallback</code>) and does <em>not</em> open the dropdown — and reset it with <code>clearSearch()</code>. <strong>There's no separate "filter" method:</strong> what the query <em>does</em> is governed by <code>searchMode</code> — set <code>el.searchMode = 'filter'</code> (narrow the list) or <code>'navigate'</code> (keep all options, jump focus to the match) before searching. Handy for deep-links ("open with a query pre-filled"), syncing an external field, or restoring saved state.
        </p>

        <ul class="feature-list">
          <li><code>searchText</code> - read the current query (empty string when nothing is typed)</li>
          <li><code>search(term)</code> - set the query and apply it (does not open the dropdown)</li>
          <li><code>searchMode</code> - <code>'filter'</code> | <code>'navigate'</code>; governs what the query does</li>
          <li><code>clearSearch()</code> - clear the query and restore the full list</li>
        </ul>

        <.form_group>
          <label>Pick a mode, type a query, then apply:</label>
          <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 1rem;">
            <.web_multiselect id="search-api-demo" options={@fruits} style="flex: 1 1 240px;" />

            <div class="controls" style="margin-bottom: 0; display: flex; flex-wrap: wrap; gap: 0.5rem; align-items: center;">
              <label><input type="radio" name="search-api-mode" value="filter" checked /> filter</label>
              <label style="margin-right: 0.5rem;"><input type="radio" name="search-api-mode" value="navigate" /> navigate</label>
              <input type="text" id="search-api-input" placeholder="query, e.g. an" value="an" style="padding: 0.4rem;" />
              <button type="button" onclick="searchApiDemo('apply')">searchMode + search + open</button>
              <button type="button" onclick="searchApiDemo('clear')">clearSearch()</button>
              <button type="button" onclick="searchApiDemo('read')">read searchText</button>
            </div>
          </div>

          <p class="description" style="font-size: 0.85rem; opacity: 0.8; margin: 0.5rem 0 0;">
            Try <code>an</code> in each mode: <strong>filter</strong> narrows to Banana / Mango / Orange; <strong>navigate</strong> keeps every fruit visible and just focuses the first match.
          </p>

          <div class="output">
            <div class="output-label">searchText:</div>
            <pre id="output-search-api" phx-update="ignore">""</pre>
          </div>
        </.form_group>

        <.code_block lang="javascript">{@api08_code}</.code_block>
      </.card>

      <.card title="API09 · Deferred initialization — defer / ready()">
        <.tip>
          <code>defer</code> attribute holds the first render · release with <code>el.ready()</code>
          or by removing the attribute
        </.tip>
        <p>
          With <code>defer={"{true}"}</code> the element builds <strong>nothing</strong> on upgrade —
          it only reserves space. Wire options, callbacks (<code>customStylesCallback</code>) and
          listeners first, then call <code>el.ready()</code> to build <strong>once</strong>,
          flash-free. This closes the classic upgrade-then-restyle flash where a component paints
          with its <em>default</em> styles for a beat before a post-upgrade callback (or a framework's
          shared-stylesheet adoption) restyles it — the styled result appears in one shot.
        </p>

        <ul class="feature-list">
          <li><code>defer</code> — boolean attribute; present = hold the first render</li>
          <li><code>ready()</code> — release the gate and build once (latched — never re-closes)</li>
          <li>
            Removing the <code>defer</code> attribute also releases it — this is how the wrapper's
            shared-styles registry does it, server-driven, with no JS hook
          </li>
          <li>
            <code>isReady</code> — reflected as the <code>is-ready</code> attribute (CSS hook
            <code>:host([defer]:not([is-ready]))</code> reserves space while held)
          </li>
          <li><code>ready</code> — event dispatched once, right after the first build</li>
        </ul>

        <.form_group>
          <label>
            Deferred with a simulated 2 s data load — the reserved space stays empty while held, then
            the purple, pre-selected badges appear in <strong>one shot</strong> on release (no
            default-style flash). The badge color + options are wired while held:
          </label>
          <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 1rem;">
            <.web_multiselect id="defer-demo" defer={true} value={["js", "ts"]} style="flex: 1 1 240px;" />

            <div class="controls" style="margin-bottom: 0;">
              <button type="button" onclick="releaseDeferDemo()">release now (ready())</button>
              <button type="button" onclick="location.reload()">Reload to replay</button>
            </div>
          </div>

          <div class="output">
            <div class="output-label">state:</div>
            <pre id="output-defer" phx-update="ignore">held — waiting for data…</pre>
          </div>
        </.form_group>

        <.note title="How LiveView releases it (and why you rarely call ready() yourself)">
          When <code>:shadow_styles</code> is configured the wrapper adds <code>defer</code> to every
          <code>&lt;web-multiselect&gt;</code> automatically, and its registry adopts the shared sheet
          then removes the attribute — themed badges paint flash-free with no per-instance JS. See the
          💧&nbsp;Elixir&nbsp;Only page. Reach for <code>defer={"{true}"}</code> + your own
          <code>hook</code>/<code>ready()</code> (as below) only when you need to hold the build for
          async wiring.
        </.note>

        <.code_block lang="javascript">{@api09_code}</.code_block>
      </.card>

      <.card title="DA04 · Async Search / Lookup">
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

      <.card title="DA05 · Cascading Selects (Reactive Options)">
        <p>
          Create dependent dropdowns that automatically update! Setting <code>element.options = newArray</code>
          triggers automatic re-rendering. Perfect for Organization → Business Unit → Department flows. This card mirrors upstream's pure-JS reactive cascade; for the server-driven (LiveView) variant see <strong>EO03</strong> on the <a href="/examples/elixir-only">Elixir Only</a> page.
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

      <.card title="API05 · Event Handling">
        <.tip>
          DOM events (no attribute): <code>el.addEventListener("select" | "deselect" | "change", …)</code> — see the inline <code>&lt;script&gt;</code>
        </.tip>
        <p>
          Listen to <code>select</code>, <code>deselect</code>, and <code>change</code> events
        </p>

        <.form_group>
          <label>Select Options (Check Console)</label>
          <.web_multiselect
            id="api05-events-select"
            options={@technologies}
            search_placeholder="Select options..."
          />
          <small class="form-text">Open browser console to see events</small>
        </.form_group>

        <div id="api05-event-log" class="log-panel" phx-update="ignore">
          <div class="muted">Event log will appear here...</div>
        </div>

        <small class="form-text" style="margin-top: 0.75rem; display: block;">
          Looking for the <code>on*</code> property handlers and the
          <code>beforeSelect</code>/<code>beforeDeselect</code> interceptors?
          See <.link navigate="/examples/events-callbacks">Events, Handlers &amp; Interceptors</.link>.
        </small>
      </.card>

      <.card title="API06 · Synchronous options + setSelected">
        <p>
          Assign <code>.options</code>
          and call <code>setSelected(...)</code>
          on the very next line — no <code>await</code>. The property write coalesces onto a microtask, but the
          imperative call flushes it, so the pre-set selection renders immediately. Shown for the
          <code>partial</code>
          and <code>compact</code>
          badge modes (the compact composite badge is what previously mis-rendered when the two calls raced).
        </p>

        <.code_block lang="javascript">{@api06_code}</.code_block>

        <.grid_2>
          <.form_group>
            <label>Partial badges (pre-selected):</label>
            <.web_multiselect
              id="api06-partial"
              badges_display_mode="partial"
              badges_max_visible={2}
            />
          </.form_group>
          <.form_group>
            <label>Compact badges (pre-selected):</label>
            <.web_multiselect id="api06-compact" badges_display_mode="compact" />
          </.form_group>
        </.grid_2>
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

      // API09: deferred initialization. #defer-demo carries `defer` (defer={true}), so it
      // builds NOTHING until ready(). We set a purple-badge customStylesCallback up front, then
      // SIMULATE a 2 s data load: the picker stays held (reserved empty space, live countdown)
      // until "data arrives", when we assign options and call ready(). The styled, pre-selected
      // (value={["js","ts"]}) badges paint in ONE shot — no default-style flash. Because this is
      // a manual defer (flagged `data-kwms-manual`) the shared-styles registry adopts the sheet
      // but leaves the release to us. The `ready` event fires once, after the first build.
      wait('defer-demo').then((deferDemo) => {
        const deferOut = document.getElementById('output-defer');
        deferDemo.customStylesCallback = () => `
          .ms__badge { background: #6d28d9; color: #fff; border-color: #6d28d9; }
        `;
        deferDemo.addEventListener('ready', () => {
          deferOut.textContent = `isReady: ${deferDemo.isReady} — built flash-free ✓`;
        });

        const DELAY_MS = 2000;
        let released = false;
        const started = performance.now();
        (function tick() {
          if (released) return;
          const remain = Math.max(0, DELAY_MS - (performance.now() - started));
          deferOut.textContent = `held — building in ${(remain / 1000).toFixed(1)}s (loading options, no flash)`;
          if (remain > 0) requestAnimationFrame(tick);
        })();

        window.releaseDeferDemo = () => {
          if (released) return;
          released = true;
          // "Data" arrived: assign options, THEN release — both land in the single build.
          deferDemo.options = [
            { value: 'js', label: 'JavaScript' },
            { value: 'ts', label: 'TypeScript' },
            { value: 'py', label: 'Python' },
            { value: 'go', label: 'Go' },
            { value: 'rust', label: 'Rust' }
          ];
          deferDemo.ready();
        };
        setTimeout(() => window.releaseDeferDemo(), DELAY_MS);
      });

      // Event Handling (API05): listen to select / deselect / change.
      wait('api05-events-select').then((eventsSelect) => {
        const eventLog = document.getElementById('api05-event-log');
        const logEvent = (eventName, detail) => {
          const timestamp = new Date().toLocaleTimeString();
          const logEntry = document.createElement('div');
          logEntry.style.marginBottom = '0.5rem';
          logEntry.innerHTML = `<strong style="color: #0066cc;">[${timestamp}] ${eventName}:</strong> ${JSON.stringify(detail, null, 2)}`;
          eventLog.appendChild(logEntry);
          eventLog.scrollTop = eventLog.scrollHeight;
        };
        eventsSelect.addEventListener('select', (e) => logEvent('select', { option: e.detail.option?.label, selectedValues: e.detail.selectedValues }));
        eventsSelect.addEventListener('deselect', (e) => logEvent('deselect', { option: e.detail.option?.label, selectedValues: e.detail.selectedValues }));
        eventsSelect.addEventListener('change', (e) => logEvent('change', { count: e.detail.selectedOptions?.length, selectedValues: e.detail.selectedValues, selectedLabels: e.detail.selectedOptions?.map(o => o.label) }));
      });

      // API06: synchronous options-then-setSelected across badge modes. Assigning
      // .options then calling setSelected() on the next line (no await) must render the
      // pre-set selection right away — the imperative call flushes the coalesced options
      // write. Compact mode's composite badge is the one that regressed when they raced.
      const badgeModeData = [
        { value: 'js', label: 'JavaScript' },
        { value: 'ts', label: 'TypeScript' },
        { value: 'py', label: 'Python' },
        { value: 'go', label: 'Go' },
        { value: 'rust', label: 'Rust' }
      ];
      wait('api06-partial').then((partialMode) => {
        partialMode.options = badgeModeData;
        partialMode.setSelected(['js', 'ts', 'py']);
      });
      wait('api06-compact').then((compactMode) => {
        compactMode.options = badgeModeData;
        compactMode.setSelected(['js', 'ts', 'py']);
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
        document.addEventListener('input', (e) => {
          if (e.target.id !== 'product-delay') return;
          productApiDelay = Number(e.target.value);
          document.getElementById('product-delay-value').textContent = `${productApiDelay} ms`;
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
        let debounceKeystrokes = 0;
        let debounceApiCalls = 0;
        const allProducts = window.__allProducts || [];

        document.addEventListener('input', (e) => {
          if (e.target.id !== 'debounce-ms') return;
          debounceSearchSelect.setAttribute('search-debounce', e.target.value);
          document.getElementById('debounce-ms-value').textContent = `${e.target.value} ms`;
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

      // API04: exercise the value-access API. getValue()/getSelected() are methods;
      // selectedValue/selectedItem are properties. Reflect the result into the card's
      // own output pane so single- vs multi-select return shapes are visible side by side.
      window.apiMethodsDemo = (id, what) => {
        const el = document.getElementById(id);
        let result;
        switch (what) {
          case 'getValue':      result = el.getValue(); break;
          case 'selectedValue': result = el.selectedValue; break;
          case 'selectedItem':  result = el.selectedItem; break;
          case 'getSelected':   result = el.getSelected(); break;
        }
        const label = (what === 'getValue' || what === 'getSelected') ? what + '()' : what;
        document.getElementById('output-' + id).textContent =
          label + ' → ' + JSON.stringify(result, null, 2);
      };

      // API07: call the imperative method, then reflect the resulting isOpen state.
      window.openCloseDemo = (method) => {
        const select = document.getElementById('openclose-demo');
        select[method]();
        window.showOpenState();
      };

      window.showOpenState = () => {
        const select = document.getElementById('openclose-demo');
        document.getElementById('output-openclose').textContent = JSON.stringify({
          'isOpen': select.isOpen
        }, null, 2);
      };

      // API08: set searchMode, drive/read the search text, then reflect el.searchText.
      window.searchApiDemo = (action) => {
        const select = document.getElementById('search-api-demo');
        const input = document.getElementById('search-api-input');
        if (action === 'apply') {
          const mode = document.querySelector('input[name="search-api-mode"]:checked').value;
          select.searchMode = mode;   // reactive; search()'s flush() applies the mode first
          select.search(input.value);
          select.open();              // open so filter-vs-navigate is visible
        } else if (action === 'clear') {
          select.clearSearch();
          input.value = '';
        }
        // 'read' just falls through to the reflect below.
        document.getElementById('output-search-api').textContent = JSON.stringify(select.searchText);
      };
    </script>
    """
  end
end
