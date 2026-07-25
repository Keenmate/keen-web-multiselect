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
  <.web_multiselect id="tree" options={@categories} path_member="path"
    show_checkboxes={true} checkbox_mode="cascade" cascade_select_policy="rolled-up" />

  // Both are live — flip them any time (in JS) and the current selection re-projects:
  el.checkboxMode = "cascade"            // independent (default) | cascade
  el.cascadeSelectPolicy = "rolled-up"   // rolled-up (default) | leaves | all
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
     |> assign(:rendering_code, @rendering_code)
     |> assign(:count_code, @count_code)
     |> assign(:widths_code, @widths_code)
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
      .controls { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5rem 1rem; margin-bottom: 0.75rem; }
      .controls[data-disabled="true"] { opacity: 0.5; }
      .controls label { display: inline-flex; align-items: center; gap: 0.3rem; }
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
        <.tip>Both are live — flip <code>checkbox_mode</code> / <code>cascade_select_policy</code> (JS props) any time and the current selection re-projects.</.tip>
        <p>
          Two orthogonal knobs. <code>checkbox_mode</code> controls <em>how checking a branch
          behaves</em>; <code>cascade_select_policy</code> controls <em>which values the selection
          emits</em> (badges / form / <code>change</code>). Flip them below on a single live picker,
          then check <strong>Fruit</strong> and try <strong>removing a badge</strong> — watch how the
          emitted value changes in each mode.
        </p>
        <ul>
          <li><code>checkbox_mode="independent"</code> <em>(default)</em> — each node toggles on its own; checking a branch selects <strong>only that node</strong>.</li>
          <li><code>checkbox_mode="cascade"</code> — checking a branch checks its <strong>whole subtree</strong>; a partial branch shows a <strong>tristate</strong> (dash) box.</li>
        </ul>
        <ul>
          <li><code>rolled-up</code> <em>(default)</em> — <strong>minimal cover</strong>: a fully-selected subtree collapses to its root; a partial branch emits its individually-checked descendants.</li>
          <li><code>leaves</code> — only the checked leaf nodes.</li>
          <li><code>all</code> — every fully-checked node (branches + leaves), like <code>@keenmate/web-treeview</code>.</li>
        </ul>
        <div class="demo-area">
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
          <.web_multiselect id="tree-casc-live" show_checkboxes={true} placeholder="Pick categories…" options={@categories} path_member="path" />
          <div class="output">
            <div class="output-label">Emitted <code>getValue()</code>:</div>
            <pre id="casc-emitted" phx-update="ignore">[]</pre>
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

      <.card title="12. Custom Node Rendering">
        <.tip>JS-only: <code>renderOptionContentCallback(item, ctx)</code> — in tree mode <code>ctx</code> carries tree metadata (<code>isBranch</code>, <code>childCount</code>, <code>level</code>, <code>depth</code>, <code>path</code>, <code>isIndeterminate</code>…).</.tip>
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

      <.card title="13. No Badges — Selections in a Popover">
        <.tip><code>badges_display_mode="count"</code> + <code>{"show_counter={true}"}</code> — a compact chip that opens the selected-items popover.</.tip>
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
      </.card>

      <.card title="14. Independent Panel Widths">
        <.tip><code>dropdown_width</code> / <code>selected_popover_width</code> set the panel widths (or the <code>--ms-dropdown-width</code> / <code>--ms-selected-popover-width</code> vars at theme level).</.tip>
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

      // §10 live control panel — flip checkbox-mode / cascade-select-policy via radios;
      // both are applied live, so the current selection re-projects the instant a radio flips.
      wait('tree-casc-live').then((el) => {
        const emittedOut = document.getElementById('casc-emitted');
        const policyGroup = document.getElementById('policy-group');
        const showEmitted = () => { emittedOut.textContent = JSON.stringify(el.getValue()); };
        el.addEventListener('change', showEmitted);
        document.querySelectorAll('input[name="cb-mode"]').forEach((r) => {
          r.addEventListener('change', () => {
            const cascade = r.value === 'cascade' && r.checked;
            el.checkboxMode = cascade ? 'cascade' : 'independent';
            policyGroup.dataset.disabled = String(!cascade);
            policyGroup.querySelectorAll('input').forEach((p) => { p.disabled = !cascade; });
            showEmitted();
          });
        });
        document.querySelectorAll('input[name="cb-policy"]').forEach((r) => {
          r.addEventListener('change', () => { if (r.checked) el.cascadeSelectPolicy = r.value; showEmitted(); });
        });
      });

      // §12 Custom node rendering — content via renderOptionContentCallback (ctx carries
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

      // §13 / §14 — the selected-items popover reuses badge rendering, so give each row
      // its full-title breadcrumb (wrapper option keys are snake_case).
      for (const id of ['tree-count', 'tree-widths']) {
        wait(id).then((el) => {
          el.getBadgeDisplayCallback = (item) => item.full_title || item.label;
        });
      }

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
