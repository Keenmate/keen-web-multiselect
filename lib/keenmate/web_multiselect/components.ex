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

  When `hook={true}` is set (see the README), the underlying `select`, `deselect`,
  `change`, and `add` events are forwarded to the server. Listen for them with
  `handle_event/3`:

      def handle_event("web_multiselect:change", %{"id" => id, "values" => values}, socket) do
        ...
      end

  With `allow_add_new`, choosing the "Add new …" prompt fires `"web_multiselect:add"` with
  `%{"id" => id, "value" => typed_text, "option" => created_value_or_nil}` — let the server
  own creation without a JS `addNewCallback`:

      def handle_event("web_multiselect:add", %{"id" => id, "value" => text}, socket) do
        ...
      end

  To push option or selection changes back from the server, use
  `Keenmate.WebMultiselect.push_update/3`. To drive the dropdown imperatively from the
  server (open/close, scroll to an option/group, set the search text), use
  `Keenmate.WebMultiselect.push_command/3`.

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

  attr :ready_event, :string,
    default: nil,
    doc: """
    Fires this event to LiveView once, when the picker has finished its first build
    (element upgraded, and with `defer`, released). Opt-in — when unset, no ready event
    is sent. Payload: `%{"id" => id}`. Use it as the reliable trigger for a
    `push_command/3` that drives the widget on page entry (open + scroll), since the
    element and the hook's listeners are guaranteed to exist by then. Requires
    `hook={true}`. The hook also replays it if the build finished before the hook
    mounted, so your handler always runs — treat it as a one-shot on the server.
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

  attr :selected_order, :string,
    default: nil,
    values: [nil, "as-selected", "label-asc", "label-desc", "member", "custom"],
    doc: """
    Order of the SELECTED items where they are displayed — badges, partial mode (which items sit
    behind the "+N more" badge), and the selected-items popover: `as-selected` (default),
    `label-asc` / `label-desc` (by badge label), `member` (by `selected_order_member`), or `custom`
    (JS `selectedOrderCompareCallback`). Display only — the submitted value keeps as-selected order,
    and the options dropdown is never reordered.
    """

  attr :selected_order_member, :string,
    default: nil,
    doc:
      "Property name used as the sort key when `selected_order=\"member\"` (selected-items display only)."

  attr :show_counter, :boolean,
    default: nil,
    doc: "Show a count of the selected items."

  attr :show_clear, :boolean,
    default: nil,
    doc: """
    Render an inline clear (✕) button inside the input, just left of the toggle chevron. It appears
    only while something is selected and the control is enabled; clicking it wipes the whole
    selection and any search text, fires a single `change`, and refocuses the input. Off by default
    upstream. Themeable via the `--ms-input-clear-*` CSS variables.
    """

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
    doc: """
    Turn the picker into an inline creation tool. When on and a search yields no matches, the
    empty dropdown shows a clickable **"Add new …"** prompt (label from `add_new_text` /
    the JS-only `getAddNewTextCallback`) instead of the plain `empty_message`; choosing it
    (click or <kbd>Enter</kbd>) commits the creation and fires a bubbling **`add`** event
    (forwarded to the server as `"web_multiselect:add"` when a hook is attached). Creation works
    **with or without** a JS-side `addNewCallback`: supply the callback to auto-create + select
    the option (it may return a rich option object and is **async + cancelable** — resolve to
    `null`/`undefined` to abort after a validation/confirm/server round-trip), or omit it and
    handle creation yourself off the `add` event. While an async `addNewCallback` is in flight the
    prompt shows a pending state (`add_new_pending_text`). Off by default.
    """

  attr :add_new_text, :string,
    default: nil,
    doc: """
    Template for the clickable "Add new …" prompt (see `allow_add_new`). The substring `{value}`
    is replaced with the (HTML-escaped) typed text. Defaults to `Add "{value}"` upstream. The
    JS-only `getAddNewTextCallback` takes precedence when set.
    """

  attr :add_new_pending_text, :string,
    default: nil,
    doc: """
    Template for the pending prompt (spinner + this text) shown while an async `addNewCallback`
    is in flight. `{value}` is replaced with the (HTML-escaped) typed text. Defaults to
    `Adding "{value}"…` upstream.
    """

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

  attr :overlay_group, :string,
    default: nil,
    doc: """
    Scope the "one overlay open at a time" coordination to a named group. Overlays (other
    multiselects, datepickers, or any external popover that dispatches the `km-overlay-activated`
    document event) that **share a group** dismiss each other when one opens; different groups are
    independent. Unset means the default (ungrouped) group, in which every ungrouped overlay
    coordinates. Outside-click dismissal is always on regardless — this only governs the
    open-broadcast between components.
    """

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

  attr :group_select_mode, :string,
    default: nil,
    values: [nil, "none", "cascade"],
    doc: """
    Group-header selection in a flat (non-tree) grouped, multi-select list. `"cascade"` puts
    a **tristate** checkbox on each group header that checks/unchecks all of that group's
    currently-visible members; the group itself is never a selected value (badges/form/value
    carry member values only). `"none"` (default) leaves headers inert. No effect in tree mode
    (use `checkbox_mode`) or single-select.
    """

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
    Tree checkbox interaction. `"cascade"` (default) checks a node's whole subtree and shows
    a **tristate** (checked / indeterminate / unchecked) box on partially-selected branches —
    what most tree-select UIs do. `"independent"` toggles only the clicked node. Tree +
    multiple only (no subtree to cascade otherwise). Pair with `cascade_select_policy` to
    control which values a cascade selection emits.
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

  attr :defer, :boolean,
    default: nil,
    doc: """
    Upstream's `defer` render gate (2.1.0+). When present the element builds **nothing** on
    upgrade — it only reserves space — so options, callbacks and shared styles can be wired
    *before* anything paints; the build then happens **once**, flash-free, when the gate is
    released (removing the attribute, or `el.ready()` from JS).

    Left unset, the wrapper emits `defer` **automatically whenever a release mechanism is
    guaranteed present** — i.e. when project-wide shared styles are configured
    (`config :keen_web_multiselect, :shadow_styles` — see
    `Keenmate.WebMultiselect.Components.shadow_styles/1`) **or** the element is wired with the
    bundled hook (`hook={true}`). In both cases the client registry adopts any shared sheet into
    the deferred shadow root and then releases the gate, so the picker (and themed badges) paint
    in one shot with no default-style flash. A **plain attribute-only** render — options via
    `data-options` / declarative `<option>` children, with neither shared styles nor the bundled
    hook — stays NON-deferred, since nothing would release the gate. Pass `defer={false}` to opt a
    single instance out, or `defer={true}` to force it with a custom hook / hand-released async
    wiring (marked `data-kwms-manual` so the registry adopts the shared sheet but leaves the
    `el.ready()` release to you).
    """

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
    assigns = assign(assigns, :defer?, resolve_defer(assigns.defer, assigns.hook))
    assigns = assign(assigns, :attributes, OptionHelpers.to_html_attributes(assigns))

    ~H"""
    <web-multiselect
      id={@id}
      name={@name}
      phx-hook={@hook}
      phx-update={@id && "ignore"}
      class={@class}
      style={@style}
      defer={@defer? != false}
      data-kwms-manual={@defer? == :manual}
      data-placeholder-ready=""
      data-search-event={@search_event}
      data-ready-event={@ready_event}
      {@attributes}
      {@rest}
    >
      {render_slot(@inner_block)}
    </web-multiselect>
    """
  end

  @doc """
  Renders the project-wide shared shadow-DOM styles once, so every `<web-multiselect>` on
  the page picks them up — configure the look in one place instead of on each instance.

  Reads the CSS from the `:shadow_styles` application config (see
  `Keenmate.WebMultiselect.shadow_styles_css/0` for the accepted shapes: inline string,
  `{:file, path}`, or a function/MFA), inlines it into a `<template>`, and emits the tiny
  client registry that compiles it into one Constructable Stylesheet and **adopts it into
  every element's shadow root** (`adoptedStyleSheets`). One shared sheet, applied
  deterministically, that survives the component's own re-renders and isn't duplicated per
  instance. Because the sheet lives in each shadow root, `:host(.your-class) .ms__badge`
  selectors work — a select opts into (or diverges from) the shared theme with a plain
  `class`, no per-instance JavaScript.

  Drop it **once** in your root layout (e.g. in `<head>`):

      <Keenmate.WebMultiselect.Components.shadow_styles />

  Renders nothing when `:shadow_styles` is unset. Under a strict Content-Security-Policy,
  pass a `nonce` for the inline `<script>`.

  > This handles arbitrary shadow-DOM CSS. For anything expressible as CSS custom
  > properties (`--base-*` / `--ms-*`), prefer plain global CSS at `:root` — those pierce
  > the shadow DOM with no JavaScript. See the theming guide.
  """
  attr :nonce, :string, default: nil, doc: "CSP nonce for the inline <script>, if your app sets one."

  def shadow_styles(assigns) do
    css = Keenmate.WebMultiselect.shadow_styles_css()

    # HEEx does not interpolate inside <script> (its body is raw text), so the whole
    # <script> element is built as a raw safe string and emitted at the top level. The
    # CSS goes in a <template> where HEEx escapes it (and the browser decodes it back on
    # `.textContent`) — so no fragile escaping of CSS into a JS string.
    assigns =
      assigns
      |> assign(:css, css)
      |> assign(:script_tag, css && Phoenix.HTML.raw(shadow_styles_script_tag(assigns[:nonce])))

    ~H"""
    <template :if={@css} id="kwms-shadow-styles">{@css}</template>{@script_tag}
    """
  end

  defp shadow_styles_script_tag(nonce) do
    "<script" <>
      nonce_attr(nonce) <>
      ">" <>
      Keenmate.WebMultiselect.defaults_js() <>
      ~s[\nwindow.KeenWebMultiselect&&window.KeenWebMultiselect.registerShadowStyles(document.getElementById("kwms-shadow-styles").content.textContent);\n] <>
      "</script>"
  end

  defp nonce_attr(nil), do: ""

  defp nonce_attr(nonce) do
    escaped = nonce |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()
    ~s( nonce="#{escaped}")
  end

  # `hook={true}` is sugar for the bundled hook name; a string names a custom hook.
  defp resolve_hook(true), do: "KeenWebMultiselectHook"
  defp resolve_hook(hook) when is_binary(hook), do: hook
  defp resolve_hook(_), do: nil

  # `defer` gate ownership:
  #   :auto   — wrapper-added by default (see below). The client registry (loaded by the
  #             bundled hook or `<.shadow_styles/>`) adopts any shared sheet then RELEASES
  #             the gate (removes `defer`), for a flash-free paint. Emits a bare `defer` —
  #             after the client removes it, LiveView's DOM patch on connect leaves it off,
  #             so the element settles with a clean DOM.
  #   :manual — the author asked for `defer={true}`. Marked with `data-kwms-manual` so the
  #             registry adopts the sheet but does NOT release; the author releases (their
  #             `hook`/`el.ready()`), e.g. after wiring async options.
  #   false   — no gate.
  defp resolve_defer(true, _hook), do: :manual
  defp resolve_defer(false, _hook), do: false

  # Always-on by default: defer whenever a release mechanism is GUARANTEED present, so a
  # flash-free build is the norm rather than opt-in. Two mechanisms load the client
  # registry that adopts shared styles and then releases the gate (removes `defer`):
  #   * configured shared styles — the `<.shadow_styles/>` registry, or
  #   * the bundled hook — `KeenWebMultiselectHook` side-imports the same registry.
  # A *plain attribute-only* render (options via `data-options` / `<option>` children, no
  # shared styles, and no bundled hook) has nothing to release the gate, so it stays
  # NON-deferred and can never be stranded blank. A custom-hook or hand-released instance
  # that wants the gate opts in explicitly with `defer={true}` (`:manual`) and releases it
  # itself. Opt a single instance out with `defer={false}`.
  defp resolve_defer(_, hook) do
    if Keenmate.WebMultiselect.shadow_styles_configured?() or hook == "KeenWebMultiselectHook",
      do: :auto,
      else: false
  end
end
