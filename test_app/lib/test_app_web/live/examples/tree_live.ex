defmodule TestAppWeb.Examples.TreeLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Each option carries a materialized dot-path; parent/level are derived from it.
  @categories [
    %{value: "fruit", label: "Fruit", path: "1"},
    %{value: "pome", label: "Pome fruit", path: "1.1"},
    %{value: "apple", label: "Apple", path: "1.1.1"},
    %{value: "pear", label: "Pear", path: "1.1.2"},
    %{value: "stone", label: "Stone fruit", path: "1.2"},
    %{value: "peach", label: "Peach", path: "1.2.1"},
    %{value: "plum", label: "Plum", path: "1.2.2"},
    %{value: "veg", label: "Vegetables", path: "2"},
    %{value: "root", label: "Root", path: "2.1"},
    %{value: "carrot", label: "Carrot", path: "2.1.1"},
    %{value: "beet", label: "Beetroot", path: "2.1.2"},
    %{value: "leafy", label: "Leafy", path: "2.2"},
    %{value: "kale", label: "Kale", path: "2.2.1"},
    %{value: "spinach", label: "Spinach", path: "2.2.2"}
  ]

  # Same shape, but the path uses "/" — resolved with tree_path_separator="/".
  @slash_categories Enum.map(@categories, fn item ->
                      %{item | path: String.replace(item.path, ".", "/")}
                    end)

  @data_code ~S"""
  # Give each option a materialized dot-path. Parent + depth are derived from it.
  @categories = [
    %{value: "fruit", label: "Fruit",       path: "1"},
    %{value: "pome",  label: "Pome fruit",  path: "1.1"},
    %{value: "apple", label: "Apple",       path: "1.1.1"},
    %{value: "veg",   label: "Vegetables",  path: "2"}
  ]
  """

  @basic_code ~S"""
  <.web_multiselect id="tree" options={@categories} path_member="path" />
  """

  @separator_code ~S"""
  <.web_multiselect options={@categories} path_member="path" tree_path_separator="/" />
  """

  @fulltitle_code ~S"""
  <.web_multiselect
    options={@categories} path_member="path"
    full_title_member="full_title" show_badge_full_title={true} />
  """

  @leaves_code ~S"""
  # Precompute the flag from the data: a node is a branch when another
  # option's path extends it. (The JS-only getIsSelectableCallback, which
  # reads the built node's hasChildren, has no HEEx attribute.)
  def only_leaves_selectable(items) do
    paths = MapSet.new(items, & &1.path)
    Enum.map(items, fn item ->
      branch? = Enum.any?(paths, &String.starts_with?(&1, item.path <> "."))
      Map.put(item, :selectable, not branch?)
    end)
  end

  # <.web_multiselect path_member="path" is_selectable_member="selectable" show_checkboxes={true} />
  """

  @indent_code ~S"""
  web-multiselect {
    --ms-tree-indent: 1.25rem;      /* per-level step */
    --ms-tree-base-indent: 0.75rem; /* first-level inline-start padding */
  }
  """

  @rowheight_code ~S"""
  web-multiselect {
    --ms-option-min-height: 56px;                 /* consistent row height */

    /* truncate long titles to one line + ellipsis */
    --ms-option-title-white-space: nowrap;
    --ms-option-title-overflow: hidden;
    --ms-option-title-text-overflow: ellipsis;
  }
  """

  @cascade_code ~S"""
  <.web_multiselect
    options={@categories} path_member="path" show_checkboxes={true}
    checkbox_mode="cascade" cascade_select_policy="rolled-up" />
  """

  @actions_code ~S"""
  # Built-in Select All alone: show_select_all={true}. For custom actions, wire
  # el.actionButtons in a <script> (JS-only — there is no HEEx attribute for it):
  el.actionButtons = [
    { action: "select-all", text: "Select All" },
    { action: "clear-all",  text: "Clear All" },
    // setSelected is silent by default; { notify: true } fires one aggregate
    // `change` so the button press reaches the server (see the round-trip panel).
    { action: "custom", text: "All fruit", onClick: (ms) => ms.setSelected(["fruit"], { notify: true }) }
  ];
  """

  @paths_code ~S"""
  # The value the server receives is whatever value_member points at.
  # Point it at the path and change/select events carry materialized paths.
  <.web_multiselect
    options={@categories}
    path_member="path"
    value_member="path"        # ← wire value = the path, not the id
    checkbox_mode="cascade" /> # optional: rolled-up sends one parent path per full branch

  def handle_event("web_multiselect:change", %{"values" => paths}, socket) do
    paths            # => ["1.1", "1.1.2"]   (or ["1.1"] with cascade rolled-up)
    {:noreply, socket}
  end
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tree of Options — keen_web_multiselect")
     |> assign(:categories, with_full_titles(@categories))
     |> assign(:slash_categories, @slash_categories)
     |> assign(:leaf_categories, only_leaves_selectable(@categories))
     |> assign(:long_categories, with_long_labels(@categories))
     |> assign(:isco, TestApp.Isco08.all())
     |> assign(:isco_count, TestApp.Isco08.count())
     |> assign(:data_code, @data_code)
     |> assign(:basic_code, @basic_code)
     |> assign(:separator_code, @separator_code)
     |> assign(:fulltitle_code, @fulltitle_code)
     |> assign(:leaves_code, @leaves_code)
     |> assign(:indent_code, @indent_code)
     |> assign(:rowheight_code, @rowheight_code)
     |> assign(:cascade_code, @cascade_code)
     |> assign(:actions_code, @actions_code)
     |> assign(:paths_code, @paths_code)}
  end

  # Precompute an `is_selectable_member` flag so only leaves are selectable: a node
  # is a branch when some other option's path starts with "<path><sep>". The JS-only
  # `getIsSelectableCallback` (which reads the built node's derived hasChildren) has no
  # HEEx attribute, so from LiveView you supply the flag as data like this.
  defp only_leaves_selectable(items) do
    paths = MapSet.new(items, & &1.path)

    Enum.map(items, fn item ->
      has_children? = Enum.any?(paths, &String.starts_with?(&1, item.path <> "."))
      Map.put(item, :selectable, not has_children?)
    end)
  end

  # A "full title" is a breadcrumb that ships WITH the data — here the server builds
  # it by joining each option's ancestor labels. The component never computes it.
  defp with_full_titles(items) do
    by_path = Map.new(items, fn i -> {i.path, i.label} end)

    Enum.map(items, fn item ->
      crumb =
        item.path
        |> String.split(".")
        |> Enum.scan(&(&2 <> "." <> &1))
        |> Enum.map(&Map.get(by_path, &1))
        |> Enum.reject(&is_nil/1)
        |> Enum.join(" / ")

      Map.put(item, :full_title, crumb)
    end)
  end

  # Deliberately long labels so the truncation / row-height demos have something to chew on.
  defp with_long_labels(items) do
    Enum.map(items, fn item ->
      %{item | label: item.label <> " — a deliberately long category label that may need truncation or a taller row"}
    end)
  end

  # Sections mirror the upstream examples-tree.html 1:1 (same order, headings, demos
  # and data) so the two pages line up side by side. The `<.tip>` lines are the
  # wrapper's own one-line "here's the HEEx attribute" hints.
  def render(assigns) do
    ~H"""
    <style>
      .demo-area { background: #f7fafc; padding: 1.5rem; border-radius: 8px; margin: 1rem 0; }
      .demo-label { display: block; font-size: 0.85rem; color: #4a5568; margin-bottom: 0.5rem; }
      .demo-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.5rem; }
    </style>

    <.example_page
      icon="🌳"
      title="Tree of Options"
      subtitle="Render options as an always-expanded hierarchy, indented by depth"
    >
      <.card title="1. Basic Tree">
        <.tip>Set <code>path_member="path"</code> — tree mode auto-enables; parent/depth are derived from the path.</.tip>
        <p>
          Give each option a materialized dot-path (<code>"1"</code>, <code>"1.1"</code>,
          <code>"1.1.1"</code>, …) and set <code>path_member</code>. Tree mode auto-enables:
          the component derives parent and depth from the path and renders the options
          depth-first, indented by level. The model is a trimmed lift of
          <code>@keenmate/web-treeview</code>'s <code>ltree</code>.
        </p>
        <div class="demo-area">
          <label class="demo-label">Open the dropdown — every node is expanded:</label>
          <.web_multiselect id="tree-basic" placeholder="Pick categories…" options={@categories} path_member="path" />
        </div>
        <.code_block lang="elixir">{@data_code}</.code_block>
        <.code_block>{@basic_code}</.code_block>
        <.note title="No collapse:">
          The tree is always fully expanded — there is no chevron/toggle. Reach for
          <a href="https://github.com/keenmate/web-treeview" target="_blank">@keenmate/web-treeview</a>
          when you need expand/collapse.
        </.note>
      </.card>

      <.card title="2. Single-Select & Checkboxes">
        <.tip>Every node is a normal option — <code>{"multiple={false}"}</code> and <code>{"show_checkboxes={true}"}</code> work as on a flat list.</.tip>
        <p>
          Every node — branch or leaf — is a normal, selectable option. Selection, single/multi
          mode, and checkboxes all behave exactly as they do for a flat list.
        </p>
        <div class="demo-grid">
          <div>
            <label class="demo-label">Single-select (<code>{"multiple={false}"}</code>):</label>
            <.web_multiselect id="tree-single" multiple={false} placeholder="Pick one…" options={@categories} path_member="path" />
          </div>
          <div>
            <label class="demo-label">With checkboxes (<code>{"show_checkboxes={true}"}</code>):</label>
            <.web_multiselect id="tree-checks" show_checkboxes={true} placeholder="Pick categories…" options={@categories} path_member="path" />
          </div>
        </div>
      </.card>

      <.card title="3. Ancestor-Preserving Search">
        <.tip>Typing filters to matches <strong>plus their ancestors</strong>, so indentation stays coherent.</.tip>
        <p>
          Typing filters the hierarchy to the <strong>matching nodes plus their ancestors</strong>,
          so the indentation of the results still makes sense.
        </p>
        <div class="demo-area">
          <label class="demo-label">Open the list and type <code>kale</code> — you get Vegetables → Leafy → Kale:</label>
          <.web_multiselect id="tree-search" placeholder="Search the tree…" options={@categories} path_member="path" />
        </div>
      </.card>

      <.card title="4. Custom Path Separator">
        <.tip><code>tree_path_separator="/"</code> — when your paths use <code>1/1/2</code> instead of <code>1.1.2</code>.</.tip>
        <p>
          When your paths use a different separator (e.g. <code>1/1/2</code>), set
          <code>tree_path_separator</code>.
        </p>
        <div class="demo-area">
          <label class="demo-label"><code>tree_path_separator="/"</code>:</label>
          <.web_multiselect id="tree-slash" tree_path_separator="/" placeholder="Pick categories…" options={@slash_categories} path_member="path" />
        </div>
        <.code_block>{@separator_code}</.code_block>
      </.card>

      <.card title="5. Full Breadcrumb on Badges">
        <.tip><code>full_title_member="full_title"</code> + <code>{"show_badge_full_title={true}"}</code> — badges show the fully-qualified path.</.tip>
        <p>
          A <strong>full title</strong> is a fully-qualified label that ships with the data
          (never computed here). Set <code>full_title_member</code> and turn on
          <code>show_badge_full_title</code>, and badges render <em>Fruit / Pome fruit / Apple</em>
          instead of just <em>Apple</em> — disambiguating leaves that share a name across branches.
        </p>
        <div class="demo-area">
          <label class="demo-label">Two items are pre-selected — see the breadcrumb badges:</label>
          <.web_multiselect id="tree-fulltitle" value={["apple", "kale"]} placeholder="Pick categories…" options={@categories} path_member="path" full_title_member="full_title" show_badge_full_title={true} />
        </div>
        <.code_block>{@fulltitle_code}</.code_block>
      </.card>

      <.card title="6. Selectable Leaves Only">
        <.tip><code>is_selectable_member="selectable"</code> — branches render normally but aren't selectable.</.tip>
        <p>
          A node can be marked <strong>non-selectable</strong> via <code>is_selectable_member</code>
          (a data flag). Non-selectable nodes render <em>normally</em> — they are <strong>not</strong>
          greyed out like <code>disabled</code> — but they drop their checkbox, are skipped by
          keyboard arrows, and can't be toggled or picked by Select&nbsp;All. The classic use is a
          tree where only the leaves are real choices and the branches are pure structure.
        </p>
        <div class="demo-area">
          <label class="demo-label">Branches are labels only — try clicking one, then a leaf:</label>
          <.web_multiselect id="tree-leaves" show_checkboxes={true} placeholder="Pick leaf categories…" options={@leaf_categories} path_member="path" is_selectable_member="selectable" />
        </div>
        <.code_block lang="elixir">{@leaves_code}</.code_block>
      </.card>

      <.card title="7. Styling the Indentation">
        <.tip>Tune <code>--ms-tree-indent</code> (per-level step) and <code>--ms-tree-base-indent</code> (first-level offset).</.tip>
        <p>
          Each row is indented via an inline <code>--ms-tree-depth</code> custom property
          (0 at the top level). Tune the step with <code>--ms-tree-indent</code> and the
          first-level offset with <code>--ms-tree-base-indent</code>. Branch/leaf rows also
          carry <code>.ms__option--tree-branch</code> / <code>.ms__option--tree-leaf</code>
          theming hooks.
        </p>
        <div class="demo-grid">
          <div>
            <label class="demo-label">Wide indent (<code>--ms-tree-indent: 2rem</code>):</label>
            <.web_multiselect id="tree-wide" style="--ms-tree-indent: 2rem;" placeholder="Pick categories…" options={@categories} path_member="path" />
          </div>
          <div>
            <label class="demo-label">Bold branch labels (via <code>.ms__option--tree-branch</code>):</label>
            <.web_multiselect id="tree-bold" placeholder="Pick categories…" options={@categories} path_member="path" />
          </div>
        </div>
        <.code_block lang="css">{@indent_code}</.code_block>
      </.card>

      <.card title="8. Row Height & Long Labels">
        <.tip>Set <code>--ms-option-min-height</code> for a consistent row height; flip the <code>--ms-option-title-*</code> trio to truncate.</.tip>
        <p>
          Deep indentation eats horizontal space, so long labels matter. By default a title
          <strong>wraps</strong> to multiple lines (rows grow). Set a consistent row height with
          <code>--ms-option-min-height</code>, and/or truncate long titles to a single line with
          an ellipsis by flipping the three <code>--ms-option-title-*</code> variables.
          <code>.ms__option-title</code> is the label hook. Pair truncation with
          <code>enable_option_tooltips</code> to reveal the full text on hover. These apply to
          flat lists too — they're option-level, not tree-only.
        </p>
        <div class="demo-grid">
          <div>
            <label class="demo-label">Truncated (ellipsis) + tooltip:</label>
            <.web_multiselect
              id="tree-truncate"
              enable_option_tooltips={true}
              style="--ms-option-title-white-space: nowrap; --ms-option-title-overflow: hidden; --ms-option-title-text-overflow: ellipsis;"
              placeholder="Pick categories…"
              options={@long_categories}
              path_member="path"
            />
          </div>
          <div>
            <label class="demo-label">Taller rows (<code>--ms-option-min-height: 56px</code>):</label>
            <.web_multiselect id="tree-tall" style="--ms-option-min-height: 56px;" placeholder="Pick categories…" options={@long_categories} path_member="path" />
          </div>
        </div>
        <.code_block lang="css">{@rowheight_code}</.code_block>
      </.card>

      <.card title="9. Real Data — Full ISCO-08 Classification">
        <.tip>Dense rows via <code>{"option_height={32}"}</code>; <code>getBadgeDisplayCallback</code> / <code>getBadgeTooltipCallback</code> / <code>getSearchValueCallback</code> wired in JS.</.tip>
        <p>
          Everything at once on real data: the whole <strong>International Standard Classification
          of Occupations</strong> (ISCO-08) — {@isco_count} groups (10 major → 43 sub-major →
          130 minor → 436 unit). The ISCO code <em>is</em> the hierarchy (<code>2211</code> → path
          <code>2.22.221.2211</code>), so it drops straight into <code>path_member</code>. Only the
          <strong>unit groups</strong> (leaves) are selectable. A custom badge shows just the
          <strong>leaf title</strong> (prefixed <code>.. /</code> when it has ancestors), with the
          <strong>full breadcrumb in the badge tooltip</strong>; a <code>getSearchValueCallback</code>
          widens the built-in filter to match the title, <strong>code, and breadcrumb</strong>;
          long titles truncate; virtual scroll keeps 600+ rows smooth.
        </p>
        <div class="demo-area">
          <label class="demo-label">Search e.g. <code>welder</code>, <code>2211</code>, or <code>health</code> — then hover a badge:</label>
          <.web_multiselect
            id="tree-isco"
            placeholder="Search by title, code, or breadcrumb…"
            options={@isco}
            path_member="path"
            is_selectable_member="selectable"
            enable_badge_tooltips={true}
            enable_virtual_scroll={true}
            option_height={32}
            enable_option_tooltips={true}
            style="--ms-option-padding: 0.3rem 0.85rem; --ms-option-title-white-space: nowrap; --ms-option-title-overflow: hidden; --ms-option-title-text-overflow: ellipsis;"
          />
        </div>
        <small class="form-text">
          Source: <em>International Standard Classification of Occupations, ISCO-08</em>
          (© International Labour Organization) — demo data.
        </small>
      </.card>

      <.card title="10. Cascade Checkboxes & Value Policy">
        <.tip><code>checkbox_mode="cascade"</code> checks a node's whole subtree (tristate on partial branches); <code>cascade_select_policy</code> picks which values it emits.</.tip>
        <p>
          Set <code>checkbox_mode="cascade"</code> and checking a branch checks its
          <strong>whole subtree</strong>; a partially-selected branch shows a <strong>tristate</strong>
          (dash) box. Independent of the interaction, <code>cascade_select_policy</code> decides
          <em>which values</em> the selection emits (badges / form / <code>change</code>):
        </p>
        <ul>
          <li>
            <code>rolled-up</code> <em>(default)</em> — the <strong>minimal cover</strong>: a
            fully-selected subtree collapses to its root ("complete node"); a partially-selected
            branch emits its individually-checked descendants (rolling to the nearest selectable
            descendant when the complete node itself is non-selectable).
          </li>
          <li><code>leaves</code> — only the checked leaf nodes.</li>
          <li><code>all</code> — every fully-checked node (branches + leaves), like <code>@keenmate/web-treeview</code>.</li>
        </ul>
        <div class="demo-grid">
          <div>
            <label class="demo-label">rolled-up (check "Fruit" → one <em>Fruit</em> badge):</label>
            <.web_multiselect id="tree-casc-rolled" show_checkboxes={true} checkbox_mode="cascade" placeholder="Cascade — rolled-up…" options={@categories} path_member="path" />
          </div>
          <div>
            <label class="demo-label">leaves (check "Fruit" → a badge per leaf):</label>
            <.web_multiselect id="tree-casc-leaves" show_checkboxes={true} checkbox_mode="cascade" cascade_select_policy="leaves" placeholder="Cascade — leaves…" options={@categories} path_member="path" />
          </div>
          <div>
            <label class="demo-label">all (check "Fruit" → branches + leaves):</label>
            <.web_multiselect id="tree-casc-all" show_checkboxes={true} checkbox_mode="cascade" cascade_select_policy="all" placeholder="Cascade — all…" options={@categories} path_member="path" />
          </div>
        </div>
        <.code_block>{@cascade_code}</.code_block>
      </.card>

      <.card title="11. Action Buttons">
        <.tip>Built-in Select All via <code>{"show_select_all={true}"}</code>; custom actions are JS-only (<code>el.actionButtons</code>). Select All is cascade-aware.</.tip>
        <p>
          Action buttons work with tree mode. The built-in <code>select-all</code> /
          <code>clear-all</code> honour selectability (non-selectable branches are skipped), and in
          <strong>cascade</strong> mode <strong>Select All emits the same rolled-up shape a click
          would</strong> — selecting everything collapses to just the two roots (<em>Fruit</em>,
          <em>Vegetables</em>), not one badge per node. Custom actions take an <code>onClick(ms)</code>
          that receives the picker instance.
        </p>
        <div class="demo-area">
          <label class="demo-label">Cascade tree — Select All / Clear All + a custom "All fruit" action:</label>
          <.web_multiselect
            id="tree-actions"
            show_checkboxes={true}
            checkbox_mode="cascade"
            actions_position="top"
            placeholder="Pick categories…"
            options={@categories}
            path_member="path"
          />
        </div>
        <.code_block lang="js">{@actions_code}</.code_block>
      </.card>

      <.keen_card title="Sending paths to the server (LiveView)">
        <p>
          The value that reaches your <code>handle_event/3</code> is whatever
          <code>value_member</code> points at — nothing tree-specific. Point it at the
          <strong>path</strong> and the <code>select</code> / <code>change</code> events carry
          the <strong>materialized paths</strong> (<code>"1.1"</code>, <code>"1.1.2"</code>)
          instead of the ids, which is handy when the path is your server-side key. The display is
          unaffected — badges still use <code>display_value_member</code>. Pick below and watch the
          <strong>“server round-trip”</strong> panel (bottom-right) log the paths.
        </p>
        <.grid>
          <div>
            <label>Plain — one path per pick</label>
            <small class="form-text"><code>value_member="path"</code></small>
            <.web_multiselect
              id="tree-paths"
              show_checkboxes={true}
              placeholder="Pick — the server sees paths…"
              options={@categories}
              path_member="path"
              value_member="path"
            />
          </div>
          <div>
            <label>Cascade + rolled-up — a full branch sends its parent path</label>
            <small class="form-text"><code>value_member="path"</code> + <code>checkbox_mode="cascade"</code></small>
            <.web_multiselect
              id="tree-paths-cascade"
              show_checkboxes={true}
              checkbox_mode="cascade"
              placeholder="Check a branch — the server sees one path…"
              options={@categories}
              path_member="path"
              value_member="path"
            />
          </div>
        </.grid>
        <.code_block lang="elixir">{@paths_code}</.code_block>
      </.keen_card>
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

      // Action buttons on a cascade tree — custom actions are JS-only. The built-in
      // Select All is cascade-aware, so it emits the rolled-up roots.
      wait('tree-actions').then((el) => {
        el.actionButtons = [
          { action: 'select-all', text: 'Select All' },
          { action: 'clear-all', text: 'Clear All' },
          { action: 'custom', text: 'All fruit', onClick: (ms) => ms.setSelected(['fruit'], { notify: true }) }
        ];
      });

      // Bold the branch (parent) rows via a scoped stylesheet injected into the shadow DOM.
      wait('tree-bold').then((el) => {
        el.customStylesCallback = () => `
          .ms__option--tree-branch .ms__option-title { font-weight: 600; }
          .ms__option--tree-leaf   .ms__option-title { font-weight: 400; }
        `;
      });

      // ISCO: widen the built-in filter beyond the title so "2211" (code) or "health"
      // (breadcrumb) also find their nodes; badge shows only the leaf title (".. /" hints
      // at hidden ancestors), full breadcrumb in the badge tooltip. Wrapper keys are snake_case.
      wait('tree-isco').then((el) => {
        el.getSearchValueCallback = (item) => `${item.label} ${item.value} ${item.full_title}`;
        el.getBadgeDisplayCallback = (item) => {
          const segs = String(item.full_title || item.label).split(' / ');
          const last = segs[segs.length - 1];
          return segs.length > 1 ? `.. / ${last}` : last;
        };
        el.getBadgeTooltipCallback = (item) => item.full_title || item.label;
      });
    </script>
    """
  end
end
