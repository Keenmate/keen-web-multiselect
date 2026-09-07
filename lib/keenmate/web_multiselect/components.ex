defmodule Keenmate.WebMultiselect.Components do
  @moduledoc """
  Phoenix function component wrapping `<web-multiselect>`.
  """

  use Phoenix.Component

  alias Keenmate.WebMultiselect.{FormHelpers, OptionHelpers}
  alias Phoenix.HTML.FormField

  @doc """
  Renders a `<web-multiselect>` custom element.

  ## Examples

      <.web_multiselect
        id="languages"
        placeholder="Pick a language"
        options={[%{value: "js", label: "JavaScript"}, %{value: "py", label: "Python"}]} />

      <.web_multiselect field={@form[:tags]} options={@tag_options} />

  ## LiveView events

  When `hook={true}` is set (see the README), the underlying `select`, `deselect`, and
  `change` events are forwarded to the server. Listen for them with `handle_event/3`:

      def handle_event("web_multiselect:change", %{"id" => id, "values" => values}, socket) do
        ...
      end

  To push option or selection changes back from the server, use
  `Keenmate.WebMultiselect.push_update/3`.

  ## Attribute defaults

  Every attribute defaults to `nil`, which means "don't emit it" — the underlying
  component's own default then applies. The docs below note the upstream default where
  it's useful to know. See the [upstream usage docs](https://github.com/keenmate/web-multiselect/blob/main/docs/usage.md)
  for the full behavior of each option.
  """

  # -- Form integration ------------------------------------------------------

  attr :id, :string, default: nil, doc: "DOM id; required when used with a LV hook."
  attr :field, FormField, default: nil, doc: "A `Phoenix.HTML.FormField` to bind to."
  attr :name, :string, default: nil, doc: "Form field name (overridden by `:field` if set)."

  attr :value, :any,
    default: nil,
    doc:
      "Initial selected value(s). Strings, numbers, list, or nil. Seeds the underlying `initial-values` attribute unless `:initial_values` is given explicitly (which takes precedence)."

  attr :options, :any,
    default: nil,
    doc: """
    Option list. Accepts:
      * a list of maps with `:value`/`:label` (and optional `:icon`, `:subtitle`, `:group`, `:disabled`)
      * a list of `{value, label}` tuples
      * a list of arbitrary maps when paired with `*_member` or `get_*_callback` props (JS side)
    """

  attr :data_options_format, :string,
    default: nil,
    doc: """
    One of `"json"` / `"csv"` / `"plain"`. Format of a **raw `data-options` string** you supply
    yourself (via `:rest`), added upstream
    in 2.0.0: `json` (default — a JSON array), `csv` (first row is a header; map columns with
    `*_member`), or `plain` (bare values → `value=label`). Not needed for the `:options` prop —
    that path always emits JSON, so leave this at the `json` default unless you hand-write
    `data-options` as CSV/plain text.
    """

  attr :data_options_splitter, :string,
    default: nil,
    doc: """
    Field/cell delimiter for `csv`/`plain` `data-options` (default `,`). Honours `\\t` `\\n` `\\r`
    escapes, so a tab (TSV) is expressible in the attribute. Ignored for `json`.
    """

  attr :data_options_row_splitter, :string,
    default: nil,
    doc: """
    Row/record delimiter for `csv`/`plain` `data-options` (default newline). Honours `\\t` `\\n`
    `\\r` escapes. Ignored for `json`.
    """

  attr :hook, :any,
    default: nil,
    doc: """
    Forwards `select`/`deselect`/`change` events to LiveView. Pass `hook={true}` for
    the bundled `"KeenWebMultiselectHook"`, or a string to name a custom hook. `false`
    or `nil` renders no hook. Requires `:id`.
    """

  attr :search_event, :string,
    default: nil,
    doc: """
    Server-side search hook. When set, the LV hook installs a `searchCallback` on the
    element that pushes this event name to the LV with `%{"query" => q, "id" => id}` and
    awaits a `{:reply, %{results: [...]}, socket}` response. The results populate the
    dropdown asynchronously. Requires `hook={true}`.
    """

  # -- Behaviour -------------------------------------------------------------

  attr :multiple, :boolean,
    default: nil,
    doc:
      "Allow selecting more than one option. Defaults to `true` upstream — set `false` for a single-select."

  attr :search_placeholder, :string,
    default: nil,
    doc: "Placeholder text for the search/filter input inside the dropdown."

  attr :search_hint, :string,
    default: nil,
    doc: "Hint line shown near the search input to guide the user (e.g. \"Type to filter…\")."

  attr :allow_groups, :boolean,
    default: nil,
    doc: "Render options grouped by their `group_member` (optgroup-style headers). Off by default."

  attr :show_checkboxes, :boolean,
    default: nil,
    doc: "Render a checkbox in each option row. Off by default."

  attr :show_select_all, :boolean,
    default: nil,
    doc: """
    Shows upstream's built-in "Select All" action button above the option list
    (internal: `isSelectAllShown`). Pairs naturally with `show_checkboxes`. For
    finer control over the button row use the `action_buttons` API instead.
    """

  attr :checkbox_align, :string,
    default: nil,
    values: [nil, "top", "center", "bottom"],
    doc: "Vertical alignment of each option's checkbox within its row."

  attr :close_on_select, :boolean,
    default: nil,
    doc: "Close the dropdown after a selection is made (typical for single-select)."

  attr :dropdown_min_width, :string,
    default: nil,
    doc: "Minimum width of the dropdown panel, as a CSS length (e.g. `\"320px\"`)."

  attr :dropdown_max_width, :string,
    default: nil,
    doc: "Maximum width of the dropdown panel, as a CSS length."

  attr :dropdown_width, :string,
    default: nil,
    doc: """
    Width of the **options dropdown** panel, as a CSS length (e.g. `"60rem"`). Sugar that
    sets `--ms-dropdown-width` on the element; defaults to tracking the input width. Set the
    variable at app/theme level to size every picker at once.
    """

  attr :selected_popover_width, :string,
    default: nil,
    doc: """
    Width of the **selected-items popover** (the panel opened from the "N selected" chip / `[N]`
    counter), as a CSS length. Sugar that sets `--ms-selected-popover-width`; defaults to an
    intrinsic `32rem`. Independent of the input and dropdown widths.
    """

  attr :max_height, :string,
    default: nil,
    doc: "Maximum height of the option list before it scrolls, as a CSS length."

  attr :empty_message, :string,
    default: nil,
    doc: "Message shown when there are no options to display."

  attr :loading_message, :string,
    default: nil,
    doc: "Message shown while async options are loading."

  attr :select_placeholder, :string,
    default: nil,
    doc: """
    Placeholder shown when the input isn't a usable search box (`enable_search={false}`,
    or `search_input_mode` is `"readonly"`/`"hidden"`). Defaults to `"Pick an option..."`
    upstream — set this to override.
    """

  attr :no_data_placeholder, :string,
    default: nil,
    doc: """
    Placeholder shown when the option list is empty. Useful for cascade multiselects
    whose parent isn't resolved yet. Takes priority over `placeholder` and `search_placeholder`
    when the list is empty. Unset by default so async-loaded selects don't flash an
    empty-state message before their data arrives.
    """

  # -- Badges ---------------------------------------------------------------

  attr :badges_display_mode, :string,
    default: nil,
    values: [nil, "badges", "count", "compact", "partial", "none"],
    doc:
      "How selected items appear in the control: `badges` (default), `count`, `compact`, `partial`, or `none`."

  attr :badges_threshold, :integer,
    default: nil,
    doc: "Selected-count at which the display collapses to the `badges_threshold_mode` summary."

  attr :badges_threshold_mode, :string,
    default: nil,
    values: [nil, "count", "partial"],
    doc: "How to summarize once `badges_threshold` is exceeded — `count` or `partial`."

  attr :badges_max_visible, :integer,
    default: nil,
    doc: "Maximum number of badges rendered before the remainder collapse into a summary."

  attr :badges_position, :string,
    default: nil,
    values: [nil, "top", "bottom", "left", "right"],
    doc: "Where the badges render relative to the input."

  attr :show_counter, :boolean,
    default: nil,
    doc: "Show a count of the selected items."

  attr :collapse_badges_below, :integer,
    default: nil,
    doc: """
    Container-responsive opt-in (off by default). When set to a pixel width, the control watches
    its **own** border box (not the window) and collapses `badges_display_mode` to `count`
    ("N selected") while the box is narrower than this — so a picker in a narrow column/sidebar
    never overflows with pills, even on a wide monitor. Widening back past the threshold restores
    the configured badges mode. A distinct axis from `mobile_presentation`, and composes with it.
    """

  attr :enable_selected_popover, :boolean,
    default: nil,
    doc: """
    Whether the selected-items popover may open (from the count/compact/"+X more" badge or the
    in-input `[N]` counter). Defaults to `true` upstream — set `false` when you render your own
    selection UI, so those affordances become inert and lose the pointer cursor.
    """

  attr :show_badge_full_title, :boolean,
    default: nil,
    doc: """
    Make badges display each option's `full_title_member` value instead of its display value
    (falling back to the display value for options without one). Off by default.
    """

  attr :enable_badge_tooltips, :boolean,
    default: nil,
    doc: "Show a tooltip with the full label when hovering a badge. Off by default."

  attr :badge_tooltip_placement, :string,
    default: nil,
    values: [
      nil,
      "top",
      "top-start",
      "top-end",
      "bottom",
      "bottom-start",
      "bottom-end",
      "left",
      "left-start",
      "left-end",
      "right",
      "right-start",
      "right-end"
    ],
    doc: "Placement of the badge tooltip (a Floating-UI placement)."

  attr :badge_tooltip_delay, :integer,
    default: nil,
    doc: "Show/hide delay for badge tooltips, in milliseconds."

  attr :badge_tooltip_offset, :integer,
    default: nil,
    doc: "Distance of the badge tooltip from the badge, in pixels."

  attr :remove_button_tooltip_text, :string,
    default: nil,
    doc:
      ~s(Format string for the remove-button tooltip. `{0}` interpolates the item name. Defaults to `"Remove {0}"` upstream.)

  # -- Option tooltips ------------------------------------------------------

  attr :enable_option_tooltips, :boolean,
    default: nil,
    doc: """
    Show a hover tooltip on each dropdown option row. Default content is the option's
    display value, plus its subtitle on a second line when present. Override per option
    with the JS-side `getOptionTooltipCallback`. Off by default upstream.
    """

  attr :option_tooltip_placement, :string,
    default: nil,
    values: [
      nil,
      "top",
      "top-start",
      "top-end",
      "bottom",
      "bottom-start",
      "bottom-end",
      "left",
      "left-start",
      "left-end",
      "right",
      "right-start",
      "right-end"
    ],
    doc:
      ~s(Placement relative to the option row. Defaults to `"top-start"` upstream \(anchored to the row's start edge\). Use `left`/`right` for a narrow control's side.)

  attr :option_tooltip_follow_cursor, :boolean,
    default: nil,
    doc:
      "Anchor the option tooltip to the mouse pointer and follow it across the row. Useful for very wide rows. Defaults to `false` upstream."

  attr :option_tooltip_delay, :integer,
    default: nil,
    doc: "Show/hide delay in ms. Falls back to `badge_tooltip_delay`, then `100` upstream."

  attr :option_tooltip_offset, :integer,
    default: nil,
    doc: "Tooltip offset in px from the row. Falls back to `badge_tooltip_offset`, then `8` upstream."

  # -- Search ---------------------------------------------------------------

  attr :enable_search, :boolean,
    default: nil,
    doc: "Show the search/filter input inside the dropdown. On by default upstream."

  attr :search_input_mode, :string,
    default: nil,
    values: [nil, "normal", "readonly", "hidden"],
    doc:
      "Search input behavior: `normal`, `readonly`, or `hidden`. When not usable, `select_placeholder` shows."

  attr :search_mode, :string,
    default: nil,
    values: [nil, "filter", "navigate"],
    doc:
      "What typing does: `filter` narrows the list, `navigate` jumps to matching rows without hiding others."

  attr :show_search_mode_toggle, :boolean,
    default: nil,
    doc: """
    Show a clickable toggle in the phone fullscreen overlay's search header that flips
    `search_mode` between `filter` and `navigate` live (internal: `isSearchModeToggleShown`).
    Fullscreen-only — no effect in the floating presentation or when search is disabled. Off by
    default.
    """

  attr :min_search_length, :integer,
    default: nil,
    doc: "Minimum number of characters before searching/filtering kicks in."

  attr :keep_options_on_search, :boolean,
    default: nil,
    doc: "Keep the full option list visible while searching instead of filtering it down."

  attr :should_keep_search_on_close, :boolean,
    default: nil,
    doc: "Preserve the search text when the dropdown closes instead of clearing it."

  attr :allow_add_new, :boolean,
    default: nil,
    doc: "Allow creating a new option from the search text when nothing matches."

  attr :search_debounce, :integer,
    default: nil,
    doc: """
    Debounce delay in milliseconds before the async `searchCallback` fires. A burst of
    keystrokes collapses into a single request instead of one per character. Applies to
    the async path only — local in-memory filtering stays instant. Defaults to `0`
    (no debounce) upstream.
    """

  # -- Actions / placement --------------------------------------------------

  attr :sticky_actions, :boolean,
    default: nil,
    doc: "Keep the action-buttons row pinned while the option list scrolls."

  attr :actions_layout, :string,
    default: nil,
    values: [nil, "nowrap", "wrap"],
    doc: "Whether action buttons stay on a single row (`nowrap`) or wrap onto multiple rows (`wrap`)."

  attr :actions_position, :string,
    default: nil,
    values: [nil, "top", "bottom"],
    doc: ~s(Render the action-buttons block as a sticky header \(`"top"`, default\) or footer \(`"bottom"`\).)

  attr :actions_align, :string,
    default: nil,
    values: [nil, "stretch", "left", "right", "center", "space-between"],
    doc:
      ~s(Horizontal arrangement of buttons within a row. `"stretch"` \(default\) keeps full-width; the others size buttons to content and distribute them.)

  attr :lock_placement, :boolean,
    default: nil,
    doc: "Lock the dropdown's placement instead of auto-flipping/shifting to fit the viewport."

  # -- Mobile / fullscreen presentation -------------------------------------

  attr :mobile_presentation, :string,
    default: nil,
    values: [nil, "auto", "floating", "fullscreen"],
    doc: """
    How the open dropdown is presented on phones. `auto` (default upstream) keeps the floating
    panel on desktop/tablet and switches to a full-screen overlay on phone-sized touch devices
    (touch-primary + shorter viewport side `< 600px`, orientation-robust); `floating` forces the
    anchored panel everywhere; `fullscreen` forces the overlay on any device (handy for previewing
    the mobile view on desktop). Resolved reactively from device/viewport/orientation changes.
    """

  attr :fullscreen_autofocus, :boolean,
    default: nil,
    doc: """
    In the phone fullscreen overlay, auto-focus the search field on open (which pops the soft
    keyboard immediately). Defaults to `false` upstream — the sheet opens with the list visible and
    the keyboard closed, appearing only when the user taps the search. Set `true` to type-to-filter
    right away. No effect in the floating presentation.
    """

  # -- Data extraction members ----------------------------------------------

  attr :value_member, :string,
    default: nil,
    doc: ~s(Object key to read each option's value from. The wrapper defaults this to `"value"`.)

  attr :display_value_member, :string,
    default: nil,
    doc: ~s(Object key for each option's display label. The wrapper defaults this to `"label"`.)

  attr :search_value_member, :string,
    default: nil,
    doc:
      "Object key for the text search matches against. Not defaulted — falls back to the display value upstream."

  attr :icon_member, :string,
    default: nil,
    doc: ~s(Object key for an option's icon. The wrapper defaults this to `"icon"`.)

  attr :subtitle_member, :string,
    default: nil,
    doc: ~s(Object key for an option's secondary line. The wrapper defaults this to `"subtitle"`.)

  attr :full_title_member, :string,
    default: nil,
    doc: """
    Object key for an option's **full title** — a fully-qualified label that ships with the
    data (e.g. a breadcrumb like `"Fruit / Pome fruit / Apple"`); never computed by the
    component. Pair with `show_badge_full_title` to render it on badges. Not defaulted.
    """

  attr :group_member, :string,
    default: nil,
    doc:
      ~s(Object key for an option's group name \(used when `allow_groups`\). The wrapper defaults this to `"group"`.)

  attr :disabled_member, :string,
    default: nil,
    doc: ~s(Object key marking an option disabled. The wrapper defaults this to `"disabled"`.)

  # -- Tree of options ------------------------------------------------------

  attr :path_member, :string,
    default: nil,
    doc: """
    Object key holding each option's **materialized dot-path** (e.g. `"1"`, `"1.1"`,
    `"1.1.1"`). Setting this turns on **tree mode**: options render as an always-expanded
    hierarchy, indented by depth. Parent and level are derived from the path. There is no
    collapse — reach for `@keenmate/web-treeview` when you need expand/collapse.
    """

  attr :parent_path_member, :string,
    default: nil,
    doc: "Object key holding an option's parent path. Optional — derived from `path_member` when unset."

  attr :level_member, :string,
    default: nil,
    doc: "Object key holding an option's depth/level. Optional — derived from `path_member` when unset."

  attr :has_children_member, :string,
    default: nil,
    doc: "Object key holding a precomputed `hasChildren` flag. Optional — derived from the tree when unset."

  attr :is_selectable_member, :string,
    default: nil,
    doc: """
    Object key holding a per-option **selectability** flag for tree mode. A node with a falsy
    value renders *normally* — **not** greyed out like `disabled` — but has no checkbox, is
    skipped by keyboard focus, and cannot be toggled or picked by Select&nbsp;All. Options
    default to selectable. Use it for structural branch rows (e.g. a leaves-only tree); use
    `disabled_member` for genuinely unavailable options. The JS-only `getIsSelectableCallback`
    (predicate over the built node, so it can read `hasChildren`) has no HEEx attribute.
    """

  attr :tree_path_separator, :string,
    default: nil,
    doc: ~s(Separator used in tree paths. Defaults to `"."` upstream.)

  attr :checkbox_mode, :string,
    default: nil,
    values: [nil, "independent", "cascade"],
    doc: """
    Tree checkbox interaction. `"independent"` (default) toggles only the clicked node.
    `"cascade"` checks a node's whole subtree and shows a **tristate** (checked /
    indeterminate / unchecked) box on partially-selected branches. Tree + multiple only.
    Pair with `cascade_select_policy` to control which values a cascade selection emits.
    """

  attr :cascade_select_policy, :string,
    default: nil,
    values: [nil, "rolled-up", "leaves", "all"],
    doc: """
    In `checkbox_mode="cascade"`, which values a selection emits (badges / form / change):
    `"rolled-up"` (default) — the **minimal cover**: a fully-selected subtree collapses to
    its root ("complete node"); a partially-selected branch emits its individually-checked
    descendants, rolling to the nearest selectable descendant when the complete node itself
    is non-selectable. `"leaves"` — only the checked leaf nodes. `"all"` — every fully-checked
    node (branches and leaves), like `@keenmate/web-treeview`.
    """

  # -- Form value serialization ---------------------------------------------

  attr :value_format, :string,
    default: nil,
    values: [nil, "json", "csv", "array"],
    doc: "How selected values are serialized into the hidden form input: `json`, `csv`, or `array`."

  attr :initial_values, :any,
    default: nil,
    doc: "Pre-selected values. List/term; encoded as JSON for the underlying attribute."

  # -- Virtual scroll -------------------------------------------------------

  attr :enable_virtual_scroll, :boolean,
    default: nil,
    doc: "Enable windowed rendering of the option list so large datasets stay fast."

  attr :virtual_scroll_threshold, :integer,
    default: nil,
    doc: "Option count above which virtual scrolling activates automatically."

  attr :option_height, :integer,
    default: nil,
    doc: "Fixed pixel height of each option row — required for the virtual-scroll offset math."

  attr :badge_height, :integer,
    default: nil,
    doc: "Pixel height per badge row in the popover virtual-scroll list. Defaults to `36` upstream."

  attr :virtual_scroll_buffer, :integer,
    default: nil,
    doc: "Extra rows rendered above and below the viewport while virtual-scrolling."

  # -- Passthrough ----------------------------------------------------------

  attr :placeholder, :string,
    default: nil,
    doc: "Placeholder shown when no item is selected (passthrough)."

  attr :class, :string, default: nil, doc: "CSS class(es) applied to the `<web-multiselect>` element."
  attr :style, :string, default: nil, doc: "Inline `style` applied to the `<web-multiselect>` element."

  attr :show_debug_info, :boolean,
    default: nil,
    doc: """
    Toggles upstream's `.ms__debug-info` stats panel inside the shadow DOM. Reactive — flipping
    between renders adds/removes the panel without reinitializing the component. Useful while
    diagnosing virtual-scroll thresholds, search timing, and option-list growth.
    """

  attr :rest, :global, doc: "Any extra HTML / phx-* attribute; passed through verbatim."

  slot :inner_block,
    doc: "Optional declarative `<option>` / `<optgroup>` markup."

  @spec web_multiselect(map()) :: Phoenix.LiveView.Rendered.t()
  def web_multiselect(assigns) do
    assigns = FormHelpers.assign_from_field(assigns)
    assigns = assign(assigns, :hook, resolve_hook(assigns.hook))
    assigns = assign(assigns, :attributes, OptionHelpers.to_html_attributes(assigns))

    ~H"""
    <web-multiselect
      id={@id}
      name={@name}
      phx-hook={@hook}
      phx-update={@id && "ignore"}
      class={@class}
      style={@style}
      data-ready=""
      data-search-event={@search_event}
      {@attributes}
      {@rest}
    >
      {render_slot(@inner_block)}
    </web-multiselect>
    """
  end

  # `hook={true}` is sugar for the bundled hook name; a string names a custom hook.
  defp resolve_hook(true), do: "KeenWebMultiselectHook"
  defp resolve_hook(hook) when is_binary(hook), do: hook
  defp resolve_hook(_), do: nil
end
