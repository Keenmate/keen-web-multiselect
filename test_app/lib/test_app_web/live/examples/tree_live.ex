defmodule TestAppWeb.Examples.TreeLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Each option carries a materialized dot-path; parent/level are derived from it.
  # A 4-root, up-to-4-level catalogue (~51 nodes) so cascade rollup, partial
  # branches, and deep nesting are all exercisable — mirrors the upstream demo.
  @categories [
    # Fruit — 4 sub-branches, one going 4 levels deep (Berries › Strawberry › varieties)
    %{value: "fruit", label: "Fruit", path: "1"},
    %{value: "pome", label: "Pome fruit", path: "1.1"},
    %{value: "apple", label: "Apple", path: "1.1.1"},
    %{value: "pear", label: "Pear", path: "1.1.2"},
    %{value: "quince", label: "Quince", path: "1.1.3"},
    %{value: "stone", label: "Stone fruit", path: "1.2"},
    %{value: "peach", label: "Peach", path: "1.2.1"},
    %{value: "plum", label: "Plum", path: "1.2.2"},
    %{value: "cherry", label: "Cherry", path: "1.2.3"},
    %{value: "apricot", label: "Apricot", path: "1.2.4"},
    %{value: "berries", label: "Berries", path: "1.3"},
    %{value: "straw", label: "Strawberry", path: "1.3.1"},
    %{value: "straw-cam", label: "Camarosa", path: "1.3.1.1"},
    %{value: "straw-alb", label: "Albion", path: "1.3.1.2"},
    %{value: "blue", label: "Blueberry", path: "1.3.2"},
    %{value: "rasp", label: "Raspberry", path: "1.3.3"},
    %{value: "citrus", label: "Citrus", path: "1.4"},
    %{value: "orange", label: "Orange", path: "1.4.1"},
    %{value: "lemon", label: "Lemon", path: "1.4.2"},
    %{value: "lime", label: "Lime", path: "1.4.3"},
    # Vegetables — 3 sub-branches of varying size
    %{value: "veg", label: "Vegetables", path: "2"},
    %{value: "root", label: "Root", path: "2.1"},
    %{value: "carrot", label: "Carrot", path: "2.1.1"},
    %{value: "beet", label: "Beetroot", path: "2.1.2"},
    %{value: "radish", label: "Radish", path: "2.1.3"},
    %{value: "leafy", label: "Leafy", path: "2.2"},
    %{value: "kale", label: "Kale", path: "2.2.1"},
    %{value: "spinach", label: "Spinach", path: "2.2.2"},
    %{value: "lettuce", label: "Lettuce", path: "2.2.3"},
    %{value: "chard", label: "Chard", path: "2.2.4"},
    %{value: "brassica", label: "Brassica", path: "2.3"},
    %{value: "broccoli", label: "Broccoli", path: "2.3.1"},
    %{value: "caulif", label: "Cauliflower", path: "2.3.2"},
    %{value: "cabbage", label: "Cabbage", path: "2.3.3"},
    # Dairy — a whole extra root
    %{value: "dairy", label: "Dairy", path: "3"},
    %{value: "cheese", label: "Cheese", path: "3.1"},
    %{value: "cheddar", label: "Cheddar", path: "3.1.1"},
    %{value: "brie", label: "Brie", path: "3.1.2"},
    %{value: "gouda", label: "Gouda", path: "3.1.3"},
    %{value: "milk", label: "Milk", path: "3.2"},
    %{value: "milk-w", label: "Whole milk", path: "3.2.1"},
    %{value: "milk-s", label: "Skim milk", path: "3.2.2"},
    %{value: "milk-o", label: "Oat milk", path: "3.2.3"},
    # Grains — a fourth root
    %{value: "grains", label: "Grains", path: "4"},
    %{value: "cereal", label: "Cereal", path: "4.1"},
    %{value: "wheat", label: "Wheat", path: "4.1.1"},
    %{value: "rice", label: "Rice", path: "4.1.2"},
    %{value: "oats", label: "Oats", path: "4.1.3"},
    %{value: "bakery", label: "Bakery", path: "4.2"},
    %{value: "sourdough", label: "Sourdough", path: "4.2.1"},
    %{value: "rye", label: "Rye bread", path: "4.2.2"}
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

  # Different separator (e.g. 1/1/2 instead of 1.1.2)?
  <.web_multiselect options={@categories} path_member="path" tree_path_separator="/" />
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
  <.web_multiselect id="tree" options={@categories} path_member="path"
    show_checkboxes={true} checkbox_mode="cascade" cascade_select_policy="rolled-up" />

  // Both are live — flip them any time (in JS) and the current selection re-projects:
  el.checkboxMode = "cascade"            // independent | cascade
  el.cascadeSelectPolicy = "rolled-up"   // rolled-up | leaves | all
  """

  @rendering_code ~S"""
  // 1) Content — compact label + child count. ctx carries tree metadata
  //    (isBranch/isLeaf/childCount/level/depth/path/isSelectable/isIndeterminate):
  el.renderOptionContentCallback = (item, ctx) => ctx.isBranch
    ? `<span><strong>${item.label}</strong> <small class="node-count">${ctx.childCount}</small></span>`
    : `<span>${item.label}</span>`;

  // 2) Full-row background per node type via the branch/leaf theming hooks — the
  //    render callback only fills the content area (after the checkbox):
  el.customStylesCallback = () => `
    .ms__option--tree-branch { background: #eef2ff; font-weight: 600; }
    .ms__option--tree-leaf   { background: #fff; }
    .node-count { opacity: .55; font-weight: 400; }
  `;
  """

  @fulltitle_code ~S"""
  <.web_multiselect
    options={@categories} path_member="path"
    full_title_member="full_title" show_badge_full_title={true} />
  """

  @count_code ~S"""
  <.web_multiselect badges_display_mode="count" show_counter={true}
    options={@categories} path_member="path" show_checkboxes={true} />

  // Breadcrumb per popover row (the popover reuses badge rendering):
  el.fullTitleMember = "full_title";
  el.getBadgeDisplayCallback = (item) => item.full_title || item.label;
  // Drop the "N selected" text too with badges_display_mode="none" — just the [N] chip.
  """

  @widths_code ~S"""
  <.web_multiselect
    style="width: 15rem;"                    {!-- the control (input) --}
    dropdown_width="60rem"                    {!-- → --ms-dropdown-width --}
    selected_popover_width="30rem"            {!-- → --ms-selected-popover-width --}
    badges_display_mode="count" show_counter={true} ... />

  /* Or theme every picker at once — the same variables, at app level: */
  web-multiselect { --ms-dropdown-width: 60rem; --ms-selected-popover-width: 30rem; }
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

  @search_code ~S"""
  <!-- default: filter — hierarchy narrows to matches + their ancestors -->
  <web-multiselect path-member="path"></web-multiselect>

  <!-- navigate — keep the whole tree on screen; jump focus between matches -->
  <web-multiselect path-member="path" search-mode="navigate"></web-multiselect>

  <!-- add a built-in filter<->navigate toggle to the fullscreen search bar -->
  <web-multiselect path-member="path" search-mode="navigate" show-search-mode-toggle></web-multiselect>

  /* Fullscreen (phones) adds a count + prev/next match navigator automatically;
     desktop steps with Ctrl+ArrowUp / Ctrl+ArrowDown. */
  """

  @scrollto_code ~S"""
  el.open();
  el.scrollToValue('2211');        // any node by value — tree is always expanded
  el.scrollToIndex(el /* count-1 */); // last visible node
  el.scrollToGroup('x');           // → false in tree mode

  // If a search filtered the node out, reveal it first:
  el.clearSearch();
  el.scrollToValue('2211');
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
     |> assign(:fulltitle_code, @fulltitle_code)
     |> assign(:leaves_code, @leaves_code)
     |> assign(:indent_code, @indent_code)
     |> assign(:rowheight_code, @rowheight_code)
     |> assign(:cascade_code, @cascade_code)
     |> assign(:rendering_code, @rendering_code)
     |> assign(:count_code, @count_code)
     |> assign(:widths_code, @widths_code)
     |> assign(:actions_code, @actions_code)
     |> assign(:paths_code, @paths_code)
     |> assign(:scrollto_code, @scrollto_code)
     |> assign(:search_code, @search_code)}
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

  # Six cards consolidate the upstream examples-tree.html demos by theme (the model,
  # selection, search, styling, breadcrumbs, real data) so the page reads like the
  # rewritten upstream one. The `<.tip>` lines are the wrapper's own one-line "here's
  # the HEEx attribute" hints; the closing `<.keen_card>` is the LiveView-only bit.
  def render(assigns) do
    ~H"""
    <style>
      /* Page-specific only — .demo-area / .demo-label / .controls come from examples-shared.css. */
      .demo-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.5rem; }
      .controls[data-disabled="true"] { opacity: 0.5; }
    </style>

    <.example_page
      icon="🌳"
      title="Tree of Options"
      subtitle="Render options as an always-expanded hierarchy, indented by depth"
    >
      <.card title="TR01 · The Tree Model">
        <.tip>Set <code>path_member="path"</code> — tree mode auto-enables; parent/depth are derived from the path. Use <code>tree_path_separator="/"</code> for slash paths.</.tip>
        <p>
          Give each option a materialized dot-path (<code>"1"</code>, <code>"1.1"</code>,
          <code>"1.1.1"</code>, …) and set <code>path_member</code>. Tree mode auto-enables:
          the component derives parent and depth from the path and renders the options
          depth-first, indented by level. The model is a trimmed lift of
          <code>@keenmate/web-treeview</code>'s <code>ltree</code>. When your paths use a
          different separator (e.g. <code>1/1/2</code>), set <code>tree_path_separator</code>.
        </p>
        <div class="demo-grid">
          <div>
            <label class="demo-label">Dot-path (<code>path_member="path"</code>) — every node expanded:</label>
            <.web_multiselect id="tree-basic" placeholder="Pick categories…" options={@categories} path_member="path" />
          </div>
          <div>
            <label class="demo-label">Slash-path (<code>tree_path_separator="/"</code>):</label>
            <.web_multiselect id="tree-slash" tree_path_separator="/" placeholder="Pick categories…" options={@slash_categories} path_member="path" />
          </div>
        </div>
        <.code_block lang="elixir">{@data_code}</.code_block>
        <.code_block>{@basic_code}</.code_block>
        <.note title="No collapse:">
          The tree is always fully expanded — there is no chevron/toggle. Reach for
          <a href="https://github.com/keenmate/web-treeview" target="_blank">@keenmate/web-treeview</a>
          when you need expand/collapse.
        </.note>
      </.card>

      <.card title="TR02 · Selection, Checkboxes & Cascade">
        <.tip>Every node is a normal option — flip <code>multiple</code>, <code>show_checkboxes</code>, <code>checkbox_mode</code> and <code>cascade_select_policy</code> live and the selection re-projects.</.tip>
        <p>
          Every node — branch or leaf — is a normal, selectable option; selection, single/multi
          mode, and checkboxes all behave exactly as they do for a flat list. Two orthogonal knobs
          govern how <em>branches</em> behave: <code>checkbox_mode</code> controls <em>how checking a
          branch behaves</em>; <code>cascade_select_policy</code> controls <em>which values the
          selection emits</em> (badges / form / <code>change</code>). Flip everything below on one
          live picker, then check <strong>Fruit</strong> and try <strong>removing a badge</strong> —
          watch how the emitted value changes.
        </p>
        <ul>
          <li><code>checkbox_mode="independent"</code> — each node toggles on its own; checking a branch selects <strong>only that node</strong>.</li>
          <li><code>checkbox_mode="cascade"</code> — checking a branch checks its <strong>whole subtree</strong>; a partial branch shows a <strong>tristate</strong> (dash) box.</li>
        </ul>
        <ul>
          <li><code>rolled-up</code> — <strong>minimal cover</strong>: a fully-selected subtree collapses to its root; a partial branch emits its individually-checked descendants.</li>
          <li><code>leaves</code> — only the checked leaf nodes.</li>
          <li><code>all</code> — every fully-checked node (branches + leaves), like <code>@keenmate/web-treeview</code>.</li>
        </ul>
        <div class="demo-area">
          <div class="controls">
            <label><input type="checkbox" id="sel-multiple" checked /> <code>multiple</code></label>
            <label><input type="checkbox" id="sel-checks" checked /> <code>show_checkboxes</code></label>
          </div>
          <div class="controls" id="mode-group">
            <strong><code>checkbox_mode</code>:</strong>
            <label><input type="radio" name="cb-mode" value="independent" checked /> <code>independent</code></label>
            <label><input type="radio" name="cb-mode" value="cascade" /> <code>cascade</code></label>
          </div>
          <div class="controls" id="policy-group" data-disabled="true">
            <strong><code>cascade_select_policy</code>:</strong>
            <label><input type="radio" name="cb-policy" value="rolled-up" checked disabled /> <code>rolled-up</code></label>
            <label><input type="radio" name="cb-policy" value="leaves" disabled /> <code>leaves</code></label>
            <label><input type="radio" name="cb-policy" value="all" disabled /> <code>all</code></label>
          </div>
          <label class="demo-label">Check "Fruit", then remove a badge:</label>
          <.web_multiselect id="tree-select" multiple={true} show_checkboxes={true} checkbox_mode="independent" placeholder="Pick categories…" options={@categories} path_member="path" />
          <div class="output">
            <div class="output-label">Emitted <code>getValue()</code>:</div>
            <pre id="casc-emitted" phx-update="ignore">[]</pre>
          </div>
        </div>
        <.code_block>{@cascade_code}</.code_block>

        <h3 class="subsection">Selectable leaves only</h3>
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

        <h3 class="subsection">Action buttons</h3>
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

      <.card title="TR03 · Search — Filter vs Navigate">
        <.tip><code>search_mode="navigate"</code> keeps the whole tree visible and jumps focus between matches; the default <code>filter</code> narrows to matches + ancestors. Add <code>show_search_mode_toggle</code> for a built-in switch.</.tip>
        <p>
          Two search behaviors on one picker. <strong>Filter</strong> (the default) narrows the
          hierarchy to the <strong>matching nodes plus their ancestors</strong>, so the indentation of
          the results still makes sense. <strong>Navigate</strong> (<code>search_mode="navigate"</code>)
          keeps the <strong>whole tree on screen</strong> and typing <em>jumps focus</em> between
          matching nodes instead of hiding anything — handy on a tree, where filtering can hide the
          structure you were reading. Matched rows keep a highlight; step through them with
          <kbd>Ctrl</kbd>+<kbd>↑</kbd>/<kbd>↓</kbd> on desktop. In the <strong>fullscreen overlay</strong>
          (touch, or the preview toggle below) a <code>N of M</code> count with prev/next buttons appears
          under the search box.
        </p>
        <p>
          This picker also sets <code>show_search_mode_toggle</code>, which adds a
          <strong>built-in mode switch</strong> to the fullscreen search bar: the leading icon
          (magnifier = navigate, funnel = filter) flips the mode <em>in place</em> on tap — no reopen.
          Enable fullscreen preview, then tap the icon to switch without touching the host-page radios.
        </p>
        <div class="controls">
          <span>Search mode:</span>
          <label><input type="radio" name="tree-nav-mode" value="filter" checked /> <code>filter</code></label>
          <label><input type="radio" name="tree-nav-mode" value="navigate" /> <code>navigate</code></label>
        </div>
        <label class="toggle-label">
          <input type="checkbox" id="tree-nav-fs-preview" /> Preview as fullscreen (desktop)
        </label>
        <div class="demo-area">
          <label class="demo-label">In <code>filter</code> type <code>kale</code> (get Vegetables → Leafy → Kale); switch to <code>navigate</code> and type <code>a</code> to jump between matches:</label>
          <.web_multiselect
            id="tree-search"
            multiple={true}
            show_search_mode_toggle={true}
            placeholder="Search the tree…"
            options={@categories}
            path_member="path"
          />
        </div>
        <.code_block>{@search_code}</.code_block>
      </.card>

      <.card title="TR04 · Styling Rows">
        <.tip>Tune <code>--ms-tree-indent</code> / <code>--ms-tree-base-indent</code>; set <code>--ms-option-min-height</code> and the <code>--ms-option-title-*</code> trio; replace inner content with <code>renderOptionContentCallback(item, ctx)</code>.</.tip>
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

        <h3 class="subsection">Row height &amp; long labels</h3>
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

        <h3 class="subsection">Custom node rendering</h3>
        <p>
          <code>renderOptionContentCallback</code> works on tree rows too — it replaces the
          <strong>inner content</strong> of a node (icon / title / subtitle) while the component still
          draws the tree <em>chrome</em> around it: the checkbox, depth indentation, and the
          branch/leaf/selected/indeterminate state classes. In tree mode the callback's context
          carries <strong>tree metadata</strong> so you can branch on it without re-deriving anything:
        </p>
        <ul>
          <li><code>isTreeNode</code> / <code>isBranch</code> / <code>isLeaf</code> — is it a tree row, and does it have children.</li>
          <li><code>childCount</code> — number of direct children (0 for a leaf).</li>
          <li><code>level</code> / <code>depth</code> — 1-based level and 0-based indent depth (<code>--ms-tree-depth</code>).</li>
          <li><code>path</code>, <code>isSelectable</code>, and <code>isIndeterminate</code> (cascade tristate).</li>
        </ul>
        <div class="demo-area">
          <label class="demo-label">Branches are tinted and bold with a child count; leaves sit on white — the whole picker scaled compact via <code>--ms-rem: 8px</code>:</label>
          <.web_multiselect
            id="tree-render"
            show_checkboxes={true}
            checkbox_mode="cascade"
            style="--ms-rem: 8px; --ms-tree-indent: 1rem;"
            placeholder="Pick categories…"
            options={@categories}
            path_member="path"
          />
        </div>
        <.code_block lang="js">{@rendering_code}</.code_block>
      </.card>

      <.card title="TR05 · Breadcrumbs & Selection Display">
        <.tip><code>full_title_member="full_title"</code> + <code>{"show_badge_full_title={true}"}</code> shows breadcrumbs; <code>badges_display_mode="count"</code> + <code>{"show_counter={true}"}</code> moves the selection into a popover; <code>dropdown_width</code> / <code>selected_popover_width</code> size the panels.</.tip>
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

        <h3 class="subsection">No badges — selections in a popover</h3>
        <p>
          For a deep tree, a wall of badges gets noisy fast. Set <code>badges_display_mode="count"</code>
          and the component drops the individual badges for a single <strong>"N selected"</strong> chip.
          Click it to open the <strong>selected-items popover</strong> — the full list, each with its own
          remove button — without touching the options dropdown. The popover reuses badge rendering, so a
          <code>full_title_member</code> + <code>getBadgeDisplayCallback</code> gives each row its
          <strong>breadcrumb</strong>, which is what makes leaves that share a name distinguishable.
        </p>
        <.note title="Want zero chrome instead?">
          Use <code>badges_display_mode="none"</code> together with <code>{"show_counter={true}"}</code>:
          no badges and no "N selected" text — just a compact <code>[N]</code> counter next to the toggle
          that opens the same popover.
        </.note>
        <div class="demo-area">
          <label class="demo-label">Three leaves are pre-selected — click <strong>"N selected"</strong> or the <code>[N]</code> counter chip to open the popover:</label>
          <.web_multiselect
            id="tree-count"
            show_checkboxes={true}
            badges_display_mode="count"
            show_counter={true}
            checkbox_mode="cascade"
            value={["apple", "peach", "kale"]}
            placeholder="Pick categories…"
            options={@categories}
            path_member="path"
            full_title_member="full_title"
          />
        </div>
        <.code_block>{@count_code}</.code_block>

        <h3 class="subsection">Independent panel widths</h3>
        <p>
          The control, the options dropdown, and the selected-items popover are three separate panels —
          and they can each have their own width. Here the input is a narrow <strong>15rem</strong>, the
          tree dropdown opens to a roomy <strong>60rem</strong> (deep breadcrumbs need the space), and the
          badges popover sits at <strong>30rem</strong>. Both panel widths are just CSS variables
          (<code>--ms-dropdown-width</code>, <code>--ms-selected-popover-width</code>); the
          <code>dropdown_width</code> / <code>selected_popover_width</code> attributes are sugar that set
          those variables on the element.
        </p>
        <.note title="Theme once, override locally:">
          Set the variables at app/theme level — <code>{"web-multiselect { --ms-dropdown-width: 60rem }"}</code>
          — and every picker follows; the attributes then override a single instance. Defaults: the
          dropdown tracks the input width, the popover is an intrinsic 32rem.
        </.note>
        <div class="demo-area">
          <label class="demo-label">15rem input · 60rem tree dropdown · 30rem badges popover — open the dropdown, pick a few, then click <strong>"N selected"</strong>:</label>
          <.web_multiselect
            id="tree-widths"
            show_checkboxes={true}
            checkbox_mode="cascade"
            badges_display_mode="count"
            show_counter={true}
            dropdown_width="60rem"
            selected_popover_width="30rem"
            style="width: 15rem;"
            placeholder="Pick…"
            options={@categories}
            path_member="path"
            full_title_member="full_title"
          />
        </div>
        <.code_block>{@widths_code}</.code_block>
      </.card>

      <.card title="TR06 · Real Data — ISCO-08 & Scroll-to API">
        <.tip>Dense rows via <code>{"option_height={32}"}</code>; <code>getBadgeDisplayCallback</code> / <code>getBadgeTooltipCallback</code> / <code>getSearchValueCallback</code> wired in JS; <code>scrollToValue</code> reaches any node (<code>scrollToGroup</code> → <code>false</code> in tree mode).</.tip>
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

        <h3 class="subsection">Scroll-to API in a tree</h3>
        <p>
          The tree is <strong>always fully expanded</strong>, so <code>scrollToValue</code> reaches
          any node by its value (here the ISCO code) — and it works with virtual scroll (the row
          need not be rendered). <code>scrollToGroup</code> does <em>not</em> apply in tree mode and
          returns <code>false</code>. If a <strong>search</strong> has filtered the tree, the node
          may be hidden — call <code>clearSearch()</code> first to reveal it, then scroll.
        </p>
        <div class="demo-area">
          <label class="demo-label">Jump to an ISCO occupation by code:</label>
          <div style="display:flex; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
            <div style="flex:1 1 260px; min-width:260px;">
              <.web_multiselect
                id="tree-scroll"
                multiple={true}
                enable_virtual_scroll={true}
                option_height={32}
                options={@isco}
                path_member="path"
                value_member="value"
                display_value_member="label"
                is_selectable_member="selectable"
                style="--ms-option-padding: 0.3rem 0.85rem; --ms-option-title-white-space: nowrap; --ms-option-title-overflow: hidden; --ms-option-title-text-overflow: ellipsis;"
              />
            </div>
            <div style="display:flex; flex-direction:column; gap:0.5rem; flex:0 0 auto; min-width:210px;">
              <button type="button" data-tr="value:1111">1111 · Legislators</button>
              <button type="button" data-tr="value:2211">2211 · Medical Practitioners</button>
              <button type="button" data-tr="value:7212">7212 · Welders</button>
              <button type="button" data-tr="last">⇲ last node (index)</button>
              <button type="button" data-tr="group:health">scrollToGroup (tree → false)</button>
              <button type="button" data-tr="clear">clearSearch()</button>
            </div>
          </div>
          <div id="tr-scroll-log" class="log-panel"><div class="muted">scrollTo* results log here…</div></div>
        </div>
        <.code_block lang="js">{@scrollto_code}</.code_block>
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

      // TR02 live control panel — flip multiple / show-checkboxes / checkbox-mode /
      // cascade-select-policy via the controls; all apply live, so the current selection
      // re-projects the instant a control changes.
      wait('tree-select').then((el) => {
        const emittedOut = document.getElementById('casc-emitted');
        const showEmitted = () => { emittedOut.textContent = JSON.stringify(el.getValue()); };
        el.addEventListener('change', showEmitted);

        // Enable each control only where it has an effect, following the chain:
        //   show-checkboxes → only multi-select renders checkboxes
        //   checkbox-mode   → only when checkboxes are shown
        //   cascade policy  → only in cascade mode
        // Nodes are re-resolved on every call since LiveView may replace them on connect.
        const setGroupEnabled = (group, on) => {
          if (!group) return;
          group.dataset.disabled = String(!on);
          group.querySelectorAll('input').forEach((i) => { i.disabled = !on; });
        };
        const syncEnablement = () => {
          const selMultiple = document.getElementById('sel-multiple');
          const selChecks = document.getElementById('sel-checks');
          const cascadeRadio = document.querySelector('input[name="cb-mode"][value="cascade"]');
          const multipleOn = selMultiple ? selMultiple.checked : true;
          const checksOn = multipleOn && (selChecks ? selChecks.checked : true);
          const cascadeOn = checksOn && cascadeRadio && cascadeRadio.checked;
          if (selChecks) {
            selChecks.disabled = !multipleOn;
            const lbl = selChecks.closest('label');
            if (lbl) lbl.style.opacity = multipleOn ? '' : '0.45';
          }
          setGroupEnabled(document.getElementById('mode-group'), checksOn);
          setGroupEnabled(document.getElementById('policy-group'), cascadeOn);
        };

        // Delegate on document: listeners bound directly to these controls are dropped when
        // LiveView patches the card's DOM on connect (the <web-multiselect> survives via
        // phx-update="ignore", plain controls do not).
        document.addEventListener('change', (e) => {
          const r = e.target;
          if (!r) return;
          if (r.id === 'sel-multiple') {
            r.checked ? el.removeAttribute('multiple') : el.setAttribute('multiple', 'false');
            syncEnablement();
            showEmitted();
          } else if (r.id === 'sel-checks') {
            // The attribute defaults to true when ABSENT, so write the explicit value —
            // removing it wouldn't hide the checkboxes.
            el.setAttribute('show-checkboxes', String(r.checked));
            syncEnablement();
          } else if (r.name === 'cb-mode' && r.checked) {
            el.checkboxMode = r.value; // 'independent' | 'cascade'
            syncEnablement();
            showEmitted();
          } else if (r.name === 'cb-policy' && r.checked) {
            el.cascadeSelectPolicy = r.value;
            showEmitted();
          }
        });

        syncEnablement();
      });

      // TR03 Search — whole tree stays visible in navigate mode, focus jumps between
      // matches. A radio group flips search-mode live; a checkbox previews the fullscreen
      // overlay (where the N-of-M match navigator shows) on desktop.
      wait('tree-search').then((treeSearch) => {
        // Delegate on document: listeners bound directly to these controls are dropped
        // when LiveView patches the card's DOM on connect (the <web-multiselect> survives
        // via phx-update="ignore", plain controls do not).
        document.addEventListener('change', (e) => {
          const t = e.target;
          if (!t) return;
          if (t.name === 'tree-nav-mode' && t.checked) treeSearch.setAttribute('search-mode', t.value);
          else if (t.id === 'tree-nav-fs-preview') treeSearch.setAttribute('mobile-presentation', t.checked ? 'fullscreen' : 'auto');
        });
      });

      // TR04 Custom node rendering — content via renderOptionContentCallback (ctx carries
      // tree metadata); full-row backgrounds via the branch/leaf theming hooks.
      wait('tree-render').then((el) => {
        el.renderOptionContentCallback = (item, ctx) => ctx.isBranch
          ? `<span><strong>${item.label}</strong> <small class="node-count">${ctx.childCount}</small></span>`
          : `<span>${item.label}</span>`;
        el.customStylesCallback = () => `
          .ms__option--tree-branch { background: #eef2ff; font-weight: 600; }
          .ms__option--tree-leaf   { background: #fff; }
          .node-count { opacity: .55; font-weight: 400; }
        `;
      });

      // TR05 — the selected-items popover reuses badge rendering, so give each row
      // its full-title breadcrumb (wrapper option keys are snake_case).
      for (const id of ['tree-count', 'tree-widths']) {
        wait(id).then((el) => {
          el.getBadgeDisplayCallback = (item) => item.full_title || item.label;
        });
      }

      // TR02 Action buttons on a cascade tree — custom actions are JS-only. The built-in
      // Select All is cascade-aware, so it emits the rolled-up roots.
      wait('tree-actions').then((el) => {
        el.actionButtons = [
          { action: 'select-all', text: 'Select All' },
          { action: 'clear-all', text: 'Clear All' },
          { action: 'custom', text: 'All fruit', onClick: (ms) => ms.setSelected(['fruit'], { notify: true }) }
        ];
      });

      // TR04 Bold the branch (parent) rows via a scoped stylesheet injected into the shadow DOM.
      wait('tree-bold').then((el) => {
        el.customStylesCallback = () => `
          .ms__option--tree-branch .ms__option-title { font-weight: 600; }
          .ms__option--tree-leaf   .ms__option-title { font-weight: 400; }
        `;
      });

      // TR06 ISCO: widen the built-in filter beyond the title so "2211" (code) or "health"
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

      // TR06 Scroll-to in a tree — reuses the ISCO data (server-provided). The tree is
      // always expanded, so scrollToValue reaches any node; scrollToGroup returns false.
      wait('tree-scroll').then((treeScroll) => {
        const trLogEl = document.getElementById('tr-scroll-log');
        if (!trLogEl) return;
        treeScroll.getSearchValueCallback = (item) => `${item.label} ${item.value} ${item.full_title}`;

        const trLog = (msg) => {
          if (trLogEl.querySelector('.muted')) trLogEl.innerHTML = '';
          const row = document.createElement('div');
          row.style.marginBottom = '0.4rem';
          row.textContent = msg;
          trLogEl.appendChild(row);
          trLogEl.scrollTop = trLogEl.scrollHeight;
        };
        const trDescribe = (targetValue) => {
          const container = treeScroll.shadowRoot && treeScroll.shadowRoot.querySelector('.ms__options');
          if (!container) { trLog('   ↳ (dropdown not open)'); return; }
          const crect = container.getBoundingClientRect();
          const rows = [...container.querySelectorAll('.ms__option')];
          const visible = rows.filter((o) => {
            const r = o.getBoundingClientRect();
            return r.bottom > crect.top + 1 && r.top < crect.bottom - 1;
          });
          const lbl = (o) => o ? `"${(o.querySelector('.ms__option-title') || o).textContent.trim()}"` : '—';
          let note = '';
          if (targetValue != null) {
            const hit = visible.some((o) => o.dataset.value === String(targetValue));
            note = hit ? ` · target ${targetValue} VISIBLE` : ` · target ${targetValue} NOT in view`;
          }
          trLog(`   ↳ scrollTop=${Math.round(container.scrollTop)} · shows ${lbl(visible[0])} … ${lbl(visible[visible.length - 1])} (${visible.length} rows)${note}`);
        };

        // Delegate on document so the listeners survive LiveView's DOM patch on connect.
        // As of @keenmate/web-multiselect 2.1.0 no stopPropagation()/capture-phase workaround
        // is needed: open() and every scrollTo* arm a one-tick outside-click guard, so
        // re-driving the already-open dropdown from an external button no longer closes it.
        document.addEventListener('click', (e) => {
          const btn = e.target.closest('[data-tr]');
          if (!btn) return;
          treeScroll.open();
          const spec = btn.dataset.tr;
          if (spec === 'clear') { treeScroll.clearSearch(); trLog('clearSearch() — search reset, full tree restored'); return; }
          if (spec === 'last') {
            const lastIndex = (treeScroll.options ? treeScroll.options.length : 0) - 1;
            const ok = treeScroll.scrollToIndex(lastIndex);
            trLog(`▶ scrollToIndex(${lastIndex}) → ${ok}`);
            setTimeout(() => trDescribe(null), 90);
            return;
          }
          const [kind, arg] = spec.split(':');
          let ok, target = null;
          if (kind === 'value')      { ok = treeScroll.scrollToValue(arg); target = arg; }
          else if (kind === 'group') { ok = treeScroll.scrollToGroup(arg); }
          const call = kind === 'group' ? `scrollToGroup('${arg}')` : `scrollToValue('${arg}')`;
          trLog(`▶ ${call} → ${ok}`);
          if (kind === 'value') setTimeout(() => trDescribe(target), 90);
        });
      });
    </script>
    """
  end
end
