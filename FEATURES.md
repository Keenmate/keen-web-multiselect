# Feature inventory — `keen_web_multiselect` wrapper

Mirrors the upstream `@keenmate/web-multiselect` `FEATURES.md` (v1.12.0-rc05) with two columns
filled in for this wrapper: **Wrapped?** = how the wrapper exposes the feature to a Phoenix /
LiveView consumer, and **E2E?** = whether a Playwright spec under `e2e/` exercises it.

## Column legend (extended)

- ✅ — explicit typed `attr/3` in `Keenmate.WebMultiselect.Components.web_multiselect/1`, OR explicit hook plumbing (`KeenWebMultiselectHook` in `priv/static/keen_web_multiselect_hook.js`).
- ⚠️ — reachable, but **not declaratively wrapped**: pass through `:rest` (`:global`) as a kebab-cased key, or assign on the element from a consumer `<script>` block (`el.someProp = ...`). Works, but no compile-time check / no docs in the component module.
- ❌ — no path from HEEx or LV to the feature without forking the wrapper.
- n/a — emergent from upstream; nothing for the wrapper to do.

## Audit fixes (2026-06-25)

This pass also produced two bug fixes and four newly typed attrs:

- **`badges_display_mode` enum had `"pills"` instead of `"badges"`.** Upstream rejects `"pills"` (silent fallback to default `"badges"`); the wrapper rejected the legitimate value `"badges"` at compile time. Now `["badges", "count", "compact", "partial", "none"]`. Downstream callsites in `attributes_live.ex`, `attributes.spec.ts`, and `classic_live.ex` updated to match.
- **`badge_tooltip_placement` enum was incomplete.** Was 4 values; upstream accepts 12 (`top`/`bottom`/`left`/`right` plus `-start`/`-end` variants). Now declares all 12.
- **Four upstream attrs newly declared as typed `attr/3`** — `checkbox_align` (enum), `dropdown_max_width` (string), `remove_button_tooltip_text` (string), `badge_height` (integer). All were reachable via `:rest` before; now they're first-class with the same `nil`-default-means-omit semantics as the rest.
- **Mirrored upstream's FEATURES additions** — new rows added for the selected-items overflow popover (§4), disabled-option behavior (§8), Floating-UI auto-positioning (§10), and a brand-new §15 *Developer tooling — debug & logging* section covering `show-debug-info`, the four logging module exports, the `LOGGING_CATEGORIES` constant, and the `window.components['web-multiselect']` global. `show_debug_info` is the fifth newly-typed `attr/3` (boolean) — every other developer-tooling feature is consumer-imported JS from `priv/static/multiselect.js`. Accessibility renumbered to §16.
- **`OptionHelpers` member-attr defaults are now unconditional.** Previously the auto-default only fired when `:options` was set in HEEx — but the async-search demos (`search-js`, `search-lv`) load options at runtime, so `:options` is unset at mount and the defaults never emitted. Result: `[N/A]` rows once results arrived. Now the wrapper unconditionally emits all six canonical-shape member attrs (`value-member`, `display-value-member`, `icon-member`, `subtitle-member`, `group-member`, `disabled-member`) on every render. Safe across all option-loading paths: declarative `<option>` parsing produces objects with the same key names, and JSON / JS-side assignments use them too. Explicit `*_member` overrides still win. Surfaced first as the silently-dropped icons/subtitles/groups on the *Rich Content* card.

## rc05 visual-parity pass (2026-07-01)

A page-by-page diff of every `/examples/*` LiveView against its upstream `examples-*.html` mirror (scoped to the five pages upstream changed since rc04) surfaced one wrapper-surface gap and completed the demo mirror:

- **`show_select_all` newly typed `attr/3` (boolean).** Exposes upstream's built-in *Select All* action button (`show-select-all` → internal `isSelectAllShown`; see §7). It was reachable via **neither** the typed surface nor `:rest` — not a valid HTML global, so Phoenix dropped `show_select_all` silently (it reached neither the assigns nor `@rest`, so `OptionHelpers` never saw it). Now first-class with the usual `nil`-default-means-omit semantics.
- **Demo-only mirror completions** (no wrapper-surface change): ported upstream's new action-buttons §13 *Positioning, Rows & Alignment* demo (exercises the rc05 `actions_position` / `actions_align` typed attrs + JS-only `ActionButton.row`), fixed the §11 Font Awesome demo by shipping the required document-level `@font-face` `<link>` (a shadow-scoped `@import` alone leaves glyphs as `□`), and mirrored the classic→events cross-link note.

## Known wrapper-level gaps

These remain as follow-ups after the fixes above:

1. **Live attribute reactivity is partly blocked.** Upstream's `attributeChangedCallback` is great for cascading multiselects, but the wrapper renders `phx-update="ignore"` on the element (necessary to keep morphdom out of the shadow DOM children), which also blocks LV from morphing attribute changes. The wrapper's answer is the `web_multiselect:update` push_event channel — that's the canonical way to mutate `options` / `value` from a LV process. Plain `data-options` changes from a re-render will not propagate.
2. **Callbacks are JS-only by design** — render callbacks, member callbacks, badge tooltips, action-button click handlers all live on `el.xCallback = ...`. The wrapper does not (and probably should not) try to wrap them as HEEx attrs, but **only one callback has a declarative shortcut**: `searchCallback` via `search_event="..."` + hook installer.
3. **E2E now covers the wrapper-specific surface and the headline upstream behaviors.** 41 specs across 10 files: the wrapper-specific channel (`search_event`, `push_update`, `declarative`, hook event forwarding, `phx-update="ignore"`/`data-ready=""`, FormField) plus the behavior-level specs added in this revision (`virtual_scroll`, `badges_popover`, `add_new`, declarative icon/subtitle, the audit-added typed attrs, event dedup/order). Coverage is still spot-check for JS-only callbacks (one per family by design — see §6/§7).

---

## 1. Data & options

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Static declarative options | markup | `<option value="..">Label</option>` | — | ✅ via `:inner_block` slot | ✅ `declarative.spec` |
| Declarative groups | markup | `<optgroup label="..">` | — | ✅ via `:inner_block` slot | ✅ `declarative.spec` |
| Declarative per-option extras | markup | `data-icon`, `data-subtitle`, `disabled`, `selected` | — | ✅ via `:inner_block` slot | ✅ `declarative.spec` (all four — `data-icon`/`data-subtitle` render `.ms__option-icon`/`.ms__option-subtitle`) |
| Dynamic list assignment | prop | `options` | — | ✅ HEEx `options={...}` → `data-options` JSON; or JS `el.options = [...]` | ✅ `selection.spec`, `form.spec` |
| Tuple options | prop | `[{value, label}, ...]` | — | ✅ `OptionHelpers.normalize_option/1` | ❌ |
| Arbitrary custom objects | prop | `options` + members | — | ✅ JSON-encoded as-is | ❌ |
| Value member | attr/prop | `value-member` | — | ✅ `value_member` typed attr | ✅ `attributes.spec` |
| Display value member | attr/prop | `display-value-member` | — | ✅ `display_value_member` typed attr | ✅ `attributes.spec` |
| Search value member | attr/prop | `search-value-member` | — | ✅ `search_value_member` typed attr | ❌ |
| Icon member | attr/prop | `icon-member` | — | ✅ `icon_member` typed attr | ❌ |
| Subtitle member | attr/prop | `subtitle-member` | — | ✅ `subtitle_member` typed attr | ❌ |
| Group member | attr/prop | `group-member` | — | ✅ `group_member` typed attr | ❌ |
| Disabled member | attr/prop | `disabled-member` | — | ✅ `disabled_member` typed attr | ❌ |
| Value extraction callback | callback | `getValueCallback` | — | ⚠️ JS-only (`el.getValueCallback = ...`) | ❌ |
| Display value callback | callback | `getDisplayValueCallback` | — | ⚠️ JS-only | ❌ |
| Search value callback | callback | `getSearchValueCallback` | — | ⚠️ JS-only | ❌ |
| Icon callback | callback | `getIconCallback` | — | ⚠️ JS-only | ❌ |
| Subtitle callback | callback | `getSubtitleCallback` | — | ⚠️ JS-only | ❌ |
| Group callback | callback | `getGroupCallback` | — | ⚠️ JS-only | ❌ |
| Disabled callback | callback | `getDisabledCallback` | — | ⚠️ JS-only | ❌ |
| Initial / pre-selected values | attr | `initial-values` (JSON) | — | ✅ `initial_values` typed attr, or `value=` / `field=` (via `FormHelpers`) | ✅ `selection.spec`, `form.spec` |
| Add-new (tag creation) | attr + callback | `allow-add-new` + `addNewCallback` | `bool(false)` | ⚠️ `allow_add_new` typed attr ✅; `addNewCallback` is JS-only | ✅ `add_new.spec` (type unknown term + Enter → created & selected) |

## 2. Async / hybrid search

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Async search callback | callback | `searchCallback(term, signal)` | — | ✅ `search_event="..."` attr + hook installer (LV-tunneled); or ⚠️ JS-only assignment | ✅ `search_event.spec` |
| In-flight cancellation | callback arg | `AbortSignal` on `searchCallback` | — | ✅ honored in hook (late LV replies dropped) | ✅ `search_event.spec` |
| Search debounce | attr/prop | `search-debounce` | `0` | ✅ `search_debounce` typed attr | ❌ |
| Minimum search length | attr/prop | `min-search-length` | `0` | ✅ `min_search_length` typed attr | ✅ `attributes.spec` |
| Pre-process search term | callback | `beforeSearchCallback(term)` | — | ⚠️ JS-only | ❌ |
| Hybrid (keep options on search) | attr/prop | `keep-options-on-search` | `bool(true)` | ✅ `keep_options_on_search` typed attr | ❌ |
| Loading message | attr/prop | `loading-message` | `'Loading...'` | ✅ `loading_message` typed attr | ❌ |
| Empty / no-results message | attr/prop | `empty-message` | `'No results found'` | ✅ `empty_message` typed attr | ❌ |

## 3. Search input & behavior

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Enable / disable search | attr/prop | `enable-search` | `bool(true)` | ✅ `enable_search` typed attr | ✅ `attributes.spec` |
| Search input mode | attr/prop | `search-input-mode` | `'normal'` | ✅ `search_input_mode` typed attr (enum constrained) | ❌ |
| Search mode | attr/prop | `search-mode` | `'filter'` | ✅ `search_mode` typed attr (enum constrained) | ✅ `attributes.spec` |
| Search placeholder | attr/prop | `search-placeholder` | `'Search...'` | ✅ `search_placeholder` typed attr | ✅ `attributes.spec` |
| Select placeholder | attr/prop | `select-placeholder` | `'Pick an option...'` | ✅ `select_placeholder` typed attr | ❌ |
| No-data placeholder | attr/prop | `no-data-placeholder` | — | ✅ `no_data_placeholder` typed attr | ❌ |
| Search hint | attr/prop | `search-hint` | — | ✅ `search_hint` typed attr | ❌ |

## 4. Selection / display modes

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Multiple vs single select | attr/prop | `multiple` | `bool(true)` | ✅ `multiple` typed attr | ✅ `selection.spec`, `attributes.spec` |
| Badges display mode | attr/prop | `badges-display-mode` | `'badges'` | ✅ `badges_display_mode` typed attr (enum constrained) | ✅ `attributes.spec` |
| Badges position | attr/prop | `badges-position` | `'bottom'` | ✅ `badges_position` typed attr (enum constrained) | ✅ `attributes.spec` |
| Badges threshold | attr/prop | `badges-threshold` | — | ✅ `badges_threshold` typed attr | ✅ `attributes.spec` |
| Badges threshold mode | attr/prop | `badges-threshold-mode` | `'count'` | ✅ `badges_threshold_mode` typed attr (enum constrained) | ❌ |
| Max visible badges (partial) | attr/prop | `badges-max-visible` | — | ✅ `badges_max_visible` typed attr | ✅ `attributes.spec`, `badges_popover.spec` (only N visible + overflow) |
| In-input counter badge | attr/prop | `show-counter` | `bool(false)` | ✅ `show_counter` typed attr | ❌ |
| Counter text callback (i18n) | callback | `getCounterCallback` | — | ⚠️ JS-only | ❌ |
| Read selected options | method | `getSelected()` | — | ⚠️ JS-only | ❌ |
| Read selected value(s) | method | `getValue()` | — | ⚠️ JS-only | ✅ `selection.spec` (called via `el.evaluate`) |
| Read selectedValue (single) | prop (get) | `selectedValue` | — | ⚠️ JS-only | ❌ |
| Read selectedItem (single) | prop (get) | `selectedItem` | — | ⚠️ JS-only | ❌ |
| Set selection programmatically | method | `setSelected(values[])` | — | ✅ via `push_event("web_multiselect:update", %{value: ...})` (hook calls `el.setSelected/1`) | ✅ `push_update.spec` |
| Selected-items popover | behavior | "show selected" overflow popover | — | n/a — upstream auto-opens it when badges overflow / in `count`/`compact` modes | ✅ `badges_popover.spec` (partial mode `+N more` → `.ms__selected-popover--visible`) |

## 5. Tooltips

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Enable badge tooltips | attr/prop | `enable-badge-tooltips` | `bool(false)` | ✅ `enable_badge_tooltips` typed attr | ❌ |
| Custom badge tooltip content | callback | `getBadgeTooltipCallback(item)` | — | ⚠️ JS-only | ❌ |
| Custom remove-button tooltip | callback | `getRemoveButtonTooltipCallback(item)` | — | ⚠️ JS-only | ❌ |
| Remove-button tooltip format | attr/prop | `remove-button-tooltip-text` | `'Remove {0}'` | ✅ `remove_button_tooltip_text` typed attr | ✅ `attributes.spec` |
| Tooltip placement | attr/prop | `badge-tooltip-placement` | `'top'` | ✅ `badge_tooltip_placement` typed attr (enum constrained) | ❌ |
| Tooltip delay | attr/prop | `badge-tooltip-delay` | `100` | ✅ `badge_tooltip_delay` typed attr | ❌ |
| Tooltip offset | attr/prop | `badge-tooltip-offset` | `8` | ✅ `badge_tooltip_offset` typed attr | ❌ |
| Enable option tooltips (rc05) | attr/prop | `enable-option-tooltips` | `bool(false)` | ✅ `enable_option_tooltips` typed attr | ❌ |
| Custom option tooltip content (rc05) | callback | `getOptionTooltipCallback(item)` | — | ⚠️ JS-only | ❌ |
| Option tooltip placement (rc05) | attr/prop | `option-tooltip-placement` | `'top-start'` | ✅ `option_tooltip_placement` typed attr (enum constrained) | ❌ |
| Option tooltip follow cursor (rc05) | attr/prop | `option-tooltip-follow-cursor` | `bool(false)` | ✅ `option_tooltip_follow_cursor` typed attr | ❌ |
| Option tooltip delay (rc05) | attr/prop | `option-tooltip-delay` | falls back to `badge-tooltip-delay`, then `100` | ✅ `option_tooltip_delay` typed attr | ❌ |
| Option tooltip offset (rc05) | attr/prop | `option-tooltip-offset` | falls back to `badge-tooltip-offset`, then `8` | ✅ `option_tooltip_offset` typed attr | ❌ |

## 6. Custom rendering

| Feature | Surface | Identifier | Wrapped? | E2E? |
|---|---|---|---|---|
| Custom dropdown option content | callback | `renderOptionContentCallback` | ⚠️ JS-only | ❌ |
| Custom badge content | callback | `renderBadgeContentCallback` | ⚠️ JS-only | ❌ |
| Custom selected-item content (popover) | callback | `renderSelectedItemContentCallback` | ⚠️ JS-only | ❌ |
| Custom single-select display | callback | `renderSelectedContentCallback` | ⚠️ JS-only (returns plain string — goes into `<input>.value`) | ❌ |
| Custom group label content | callback | `renderGroupLabelContentCallback` | ⚠️ JS-only | ❌ |
| Custom badge display text | callback | `getBadgeDisplayCallback` | ⚠️ JS-only | ❌ |
| Custom badge CSS class | callback | `getBadgeClassCallback` | ⚠️ JS-only | ❌ |
| Custom selected-item CSS class | callback | `getSelectedItemClassCallback` | ⚠️ JS-only | ❌ |
| Inject custom CSS into Shadow DOM | callback | `customStylesCallback()` | ⚠️ JS-only | ❌ |

> ⚠️ Rendering callbacks accept **raw HTML** — the consumer must sanitize user-generated content.

## 7. Action buttons

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Action buttons config | prop | `actionButtons: ActionButton[]` | — | ⚠️ JS-only (`el.actionButtons = [...]`) | ❌ |
| Custom action onClick | callback | `ActionButton.onClick(ms)` | — | ⚠️ JS-only | ❌ |
| Dynamic visibility (rc05 rename) | callback | `ActionButton.getIsVisibleCallback(ms)` | — | ⚠️ JS-only | ❌ |
| Dynamic disabled (rc05 rename) | callback | `ActionButton.getIsDisabledCallback(ms)` | — | ⚠️ JS-only | ❌ |
| Dynamic text | callback | `ActionButton.getTextCallback(ms)` | — | ⚠️ JS-only | ❌ |
| Dynamic class | callback | `ActionButton.getClassCallback(ms)` | — | ⚠️ JS-only | ❌ |
| Dynamic tooltip | callback | `ActionButton.getTooltipCallback(ms)` | — | ⚠️ JS-only | ❌ |
| Multi-row buttons (rc05) | prop | `ActionButton.row` (1-based) | `1` | ⚠️ JS-only | ❌ |
| Smart built-in disabled defaults (rc05) | behavior | `select-all`/`clear-all` auto-disable when no-op | — | n/a — automatic, no wrapper surface | ❌ |
| Built-in Select All button | attr/prop | `show-select-all` (internal `isSelectAllShown`) | `bool(false)` | ✅ `show_select_all` typed attr | ❌ |
| Sticky actions | attr/prop | `sticky-actions` | `bool(true)` | ✅ `sticky_actions` typed attr | ❌ |
| Actions layout | attr/prop | `actions-layout` | `'nowrap'` | ✅ `actions_layout` typed attr (enum constrained) | ❌ |
| Actions position (rc05) | attr/prop | `actions-position` | `'top'` | ✅ `actions_position` typed attr (enum `top`/`bottom`) | ❌ |
| Actions alignment (rc05) | attr/prop | `actions-align` | `'stretch'` | ✅ `actions_align` typed attr (enum constrained) | ❌ |

## 8. Grouping & checkboxes

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Enable grouping | attr/prop | `allow-groups` | `bool(true)` | ✅ `allow_groups` typed attr | ❌ |
| Show checkboxes | attr/prop | `show-checkboxes` | `bool(true)` | ✅ `show_checkboxes` typed attr | ❌ |
| Checkbox alignment | attr/prop | `checkbox-align` | `'center'` | ✅ `checkbox_align` typed attr (enum constrained) | ✅ `attributes.spec` |
| Disabled-option behavior | behavior | `disabled-member` / `getDisabledCallback` / `<option disabled>` | — | ✅ `disabled_member` typed attr; declarative `<option disabled>` flows through `:inner_block`; `getDisabledCallback` is ⚠️ JS-only | ⚠️ partial — `declarative.spec` asserts `<option disabled>` gets `.ms__option--disabled` |

## 9. Virtual scrolling

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Enable virtual scroll | attr/prop | `enable-virtual-scroll` | `bool(false)` | ✅ `enable_virtual_scroll` typed attr | ✅ `attributes.spec`, `virtual_scroll.spec` (DOM actually windows; scroll recycles rows) |
| Virtual scroll threshold | attr/prop | `virtual-scroll-threshold` | `100` | ✅ `virtual_scroll_threshold` typed attr | ✅ `attributes.spec`, `virtual_scroll.spec` |
| Option height | attr/prop | `option-height` | `50` | ✅ `option_height` typed attr | ✅ `attributes.spec`, `virtual_scroll.spec` |
| Badge height (popover) | attr/prop | `badge-height` | `36` | ✅ `badge_height` typed attr (upstream FEATURES marks this prop-only, but the attribute table at `multiselect.js:2644` declares it as an attr) | ✅ `attributes.spec` |
| Virtual scroll buffer | attr/prop | `virtual-scroll-buffer` | `10` | ✅ `virtual_scroll_buffer` typed attr | ❌ |

## 10. Dropdown layout & behavior

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Close on select | attr/prop | `close-on-select` | `bool(false)` | ✅ `close_on_select` typed attr | ✅ `selection.spec` |
| Auto-positioning (Floating UI) | behavior | dropdown / popover / tooltip placement | — | n/a — upstream auto-flip + overflow-escape, no wrapper surface | ❌ |
| Lock placement | attr/prop | `lock-placement` | `bool(true)` | ✅ `lock_placement` typed attr | ❌ |
| Keep search on close | attr/prop | `should-keep-search-on-close` | `bool(true)` | ✅ `should_keep_search_on_close` typed attr | ❌ |
| Dropdown min width | attr/prop | `dropdown-min-width` | — | ✅ `dropdown_min_width` typed attr | ❌ |
| Dropdown max width | attr/prop | `dropdown-max-width` | — | ✅ `dropdown_max_width` typed attr | ✅ `attributes.spec` |
| Dropdown max height | attr/prop | `max-height` | `'20rem'` | ✅ `max_height` typed attr | ❌ |

## 11. Form integration

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Form field name | attr/prop | `name` | — | ✅ `:name` assign, or auto from `:field` (`Phoenix.HTML.FormField`) | ✅ `form.spec` |
| Value format | attr/prop | `value-format` | `'json'` | ✅ `value_format` typed attr (enum constrained) | ✅ `attributes.spec` |
| Custom value format | callback | `getValueFormatCallback(values)` | — | ⚠️ JS-only | ❌ |

## 12. Events

| Feature | Surface | Identifier | Detail | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Select event | event | `select` | `{ option, selectedOptions, selectedValues }` | ✅ hook forwards as `"web_multiselect:select"` with `%{id, value, values}` | ✅ `events.spec` |
| Deselect event | event | `deselect` | same | ✅ hook forwards as `"web_multiselect:deselect"` | ✅ `events.spec` |
| Change event | event | `change` | `{ selectedOptions, selectedValues }` | ✅ hook forwards as `"web_multiselect:change"` with `%{id, values}` | ✅ `events.spec` (one click → select+change exactly once each, no double-fire; select-before-change order) |
| Select handler (rc05 rename) | event/prop | `onSelect` (was `selectCallback`) | — | ⚠️ JS-only (`on*` property twin of the DOM event) | ❌ |
| Deselect handler (rc05 rename) | event/prop | `onDeselect` (was `deselectCallback`) | — | ⚠️ JS-only | ❌ |
| Change handler (rc05 rename) | event/prop | `onChange` (was `changeCallback`) | — | ⚠️ JS-only | ❌ |
| Before-select interceptor (rc05) | callback | `beforeSelectCallback(option, selected)` → `false` vetoes | — | ⚠️ JS-only (interactive paths only; `setSelected`/select-all bypass) | ❌ |
| Before-deselect interceptor (rc05) | callback | `beforeDeselectCallback(option, selected)` → `false` vetoes | — | ⚠️ JS-only (covers dropdown toggle, badge ×, popover ×, remove-hidden) | ❌ |

## 13. Public methods & lifecycle

| Feature | Surface | Identifier | Wrapped? | E2E? |
|---|---|---|---|---|
| Batch attribute update | method | `setAttributes(attrs)` | ⚠️ JS-only (not driven from LV by the wrapper) | ❌ |
| Get selected options | method | `getSelected()` | ⚠️ JS-only | ❌ |
| Set selected | method | `setSelected(values[])` | ✅ via `push_event("web_multiselect:update", %{value: ...})` (hook calls `el.setSelected/1`); also accepts `options:` to replace the option list | ✅ `push_update.spec` |
| Get value | method | `getValue()` | ⚠️ JS-only | ✅ `selection.spec` (via `el.evaluate`) |
| Destroy | method | `destroy()` | n/a — LV teardown handles unmount | ❌ |
| Live attribute reactivity | behavior | `attributeChangedCallback` | ⚠️ **blocked** by the wrapper's `phx-update="ignore"`; use `web_multiselect:update` push_event channel instead | ❌ |

## 14. Theming, styling & i18n

| Feature | Surface | Identifier | Wrapped? | E2E? |
|---|---|---|---|---|
| CSS custom properties | css | `--ms-*` | ✅ via `:style` assign or external stylesheet | ❌ |
| Global scaling | css | `--ms-rem` | ✅ same | ❌ |
| Theme-designer integration | css | `--base-*` | ✅ inherited from page-level styles | ❌ |
| Dark mode — `.dark` class on host | css | `:host(.dark)` | ✅ via `:class` assign | ❌ |
| Dark mode — ancestor theme class | css | `:host-context([data-theme="dark"])` | ✅ — automatic | ❌ |
| Dark mode — per-instance attribute | attr/css | `data-theme="dark"` | ⚠️ via `:rest` global passthrough | ❌ |
| RTL support | attr | `dir="rtl"` | ⚠️ via `:rest` global passthrough | ❌ |
| Empty/loading state min-height | css | `--ms-state-min-height` | ✅ via CSS | ❌ |
| i18n of user-facing strings | attr | placeholders, messages | ✅ all are typed attrs in the relevant sections | partial (via attribute spec for `search-placeholder`) |

## 15. Developer tooling — debug & logging

| Feature | Surface | Identifier | Default | Wrapped? | E2E? |
|---|---|---|---|---|---|
| Debug info panel | attr | `show-debug-info` | `false` | ✅ `show_debug_info` typed attr (out-of-table upstream attr; reactive — toggles `.ms__debug-info` without reinit) | ✅ `attributes.spec` (attr + `.ms__debug-info` renders) |
| Enable all logging | module export | `enableLogging()` | silent | ⚠️ JS-import from `priv/static/multiselect.js` — no LV bridge | ❌ |
| Disable all logging | module export | `disableLogging()` | — | ⚠️ JS-import | ❌ |
| Set global log level | module export | `setLogLevel(level)` | `'silent'` | ⚠️ JS-import; `trace`\|`debug`\|`info`\|`warn`\|`error`\|`silent` | ❌ |
| Per-category log level | module export | `setCategoryLevel(category, level)` | — | ⚠️ JS-import; categories: `INIT`, `DATA`, `UI`, `INTERACTION` (bare or `MULTISELECT:`-prefixed) | ❌ |
| Categories constant | module export | `LOGGING_CATEGORIES` | — | ⚠️ JS-import (array of the 4 names) | ❌ |
| Global logging API exposure | global | `window.components['web-multiselect']` | — | ✅ auto-installed by bundled `multiselect.js` at module load — exposes `version()`, `config`, `logging.{enableLogging,disableLogging,setLogLevel,setCategoryLevel,getCategories}`, `register()`, `getInstances()` | ❌ |

> The logging functions are **module exports**, not element methods. Default level is `silent`, persisted in `localStorage` via `loglevel`, so a wrapper consumer can flip it at runtime without a reload. To use from a host app, import directly from the bundled file:
>
> ```js
> import { enableLogging, setCategoryLevel } from ".../priv/static/multiselect.js";
> ```
>
> The wrapper does not currently expose a Phoenix-side helper to call these from LiveView (no use case yet — they're consumer-side dev affordances).

## 16. Accessibility

| Feature | Surface | Identifier | Wrapped? | E2E? |
|---|---|---|---|---|
| Full keyboard navigation | behavior | Arrow/Enter/Esc/Ctrl+A | n/a — inherited from upstream | ❌ |
| ARIA labels on controls | behavior | `aria-label` on remove/close/clear | n/a — inherited from upstream | ❌ |
| See accessibility doc | reference | upstream `docs/accessibility.md` | n/a | n/a |

---

## Wrapper-only features (not in upstream FEATURES.md)

These exist purely in `keen_web_multiselect` and have no upstream row:

| Feature | Surface | Identifier | Notes | E2E? |
|---|---|---|---|---|
| LV hook attribute | attr | `hook={true}` (or `hook="Custom"`) | Sets `phx-hook` to enable event forwarding + server→client mutation. `true` resolves to the bundled `"KeenWebMultiselectHook"`; a string names a custom hook; `false`/`nil` render none. | ✅ `events.spec`, unit tests |
| Server→client mutation helper | function | `Keenmate.WebMultiselect.push_update(socket, id, options?/value?)` | Ergonomic wrapper over the `web_multiselect:update` push_event; only the keys passed are sent | ✅ unit tests (payload shaping) |
| Installer | mix task | `mix keen_web_multiselect.install` | Idempotently wires app.js imports + `LiveSocket` hooks and app.css import on esbuild apps; conservative fallback-to-manual; `--dry-run` | ✅ unit tests (pure transforms) |
| `phx-update="ignore"` auto-emission | behavior | rendered automatically when `:id` is set | Protects upstream's internally-managed shadow-DOM children from morphdom | ✅ `selection.spec` |
| `data-ready=""` pre-emission | behavior | rendered on element | Avoids placeholder flash by satisfying upstream's `:host([data-ready])` CSS rule before `requestAnimationFrame` fires | ✅ `selection.spec` |
| `.form` getter polyfill | behavior | `customElements.whenDefined("web-multiselect")` patches the prototype | Without this, Phoenix LV's `phx-change` delegation drops the CustomEvent because `e.target.form === undefined`. Polyfill runs once at module load even if no element opts into the hook. | ✅ `form.spec` (implicit — phx-change shape would fail without it) |
| Declarative server-side search | attr + hook | `search_event="my_event"` + `KeenWebMultiselectHook` | Hook installs a `searchCallback` that does `pushEventTo(el, "my_event", %{id, query}, replyCallback)` and resolves with `reply.results`. AbortSignal-aware. | ✅ `search_event.spec` |
| Server→client option/value mutation | push_event | `push_event(socket, "web_multiselect:update", %{id, options?, value?})` | Bridges the `phx-update="ignore"` boundary. Filters by `payload.id`. | ✅ `push_update.spec` |
| `FormField` integration | helper | `<.web_multiselect field={@form[:tags]} />` | `Keenmate.WebMultiselect.FormHelpers.assign_from_field/1` fills `id`/`name`/value→`initial-values`. Explicit assigns win. | ✅ `form.spec` |
| Tuple option list | helper | `[{value, label}, ...]` | `OptionHelpers.normalize_option/1` accepts the tuple shape and converts to maps before JSON encoding | ❌ |
| Auto-default member attrs | helper | unconditionally emits `value-member="value"`, `display-value-member="label"`, `icon-member="icon"`, `subtitle-member="subtitle"`, `group-member="group"`, `disabled-member="disabled"` on every render | Upstream's own member fallback (`Is` array in `multiselect.js`) only fires on the declarative `<option>` path; the data-options JSON path, the JS-side `el.options = [...]` path, and async `searchCallback` results all leave `valueMember` etc. as `undefined` and rows fall through to `[N/A]`. We emit the canonical-shape defaults once per render so consumers never need to spell them out — explicit `*_member` assigns still win. Missing keys on the data side are harmless (upstream renders without that field). `search-value-member` is intentionally not defaulted. | ✅ `attributes.spec` (value/label), `declarative.spec` (full set), unit tests |
| `upstream_version/0` | function | `Keenmate.WebMultiselect.upstream_version()` | Returns the bundled `@keenmate/web-multiselect` version (currently `"1.12.0-rc05"`) | n/a |
| `asset_path/1` | function | `Keenmate.WebMultiselect.asset_path("multiselect.js")` | Absolute path into `priv/static/` for asset-copy setup tasks | n/a |

---

## E2E coverage — what's left

The six priorities from the previous revision are now all covered (41 specs across 10 files):

1. **Declarative per-option `data-icon` / `data-subtitle` extras** — `declarative.spec` asserts `.ms__option-icon` / `.ms__option-subtitle` render from the light-DOM data attributes.
2. **The four newly-typed attrs + `show-debug-info`** — `attributes.spec` spot-checks `checkbox-align`, `dropdown-max-width`, `remove-button-tooltip-text`, `badge-height`, and confirms `show-debug-info="true"` renders `.ms__debug-info`. A future enum/typo regression in `components.ex` now fails CI.
3. **Virtual scrolling actually virtualizes** — `virtual_scroll.spec` opens a 500-option picker, asserts `.ms__options--virtual`, fewer than 100 materialized `.ms__option` nodes while `el.picker.allOptions.length === 500`, scroll recycles early rows out / late rows in, and a non-virtual control renders all 500.
4. **Badges overflow popover** — `badges_popover.spec` drives partial mode (2 visible + 4 selected), clicks the `+2 more` badge, and asserts `.ms__selected-popover--visible` with all four items, plus the close button.
5. **`change` vs `select`/`deselect` dedup + order** — `events.spec` asserts one click fires `select` and `change` exactly once each (no double-fire), zero `deselect`, and `select`-before-`change` ordering.
6. **Add-new (`allow_add_new`) flow** — `add_new.spec` types an unknown term + Enter through a JS `addNewCallback`, asserts the value is created, selected, badge-rendered, input cleared, and the option joins `el.picker.allOptions`.

Two pre-existing spec bugs were caught and fixed while landing the above:

- **`push_update.spec` read `el.allOptions`** (always `undefined` → `[]`), so its first assertion passed trivially and the real ones timed out. The option array lives on the internal picker; switched to `el.picker.allOptions`.
- **`form.spec` matched `page.locator('web-multiselect')`** which became a strict-mode violation once the `#prefilled` form was added to the page. Scoped to `#basket_fruits`.

Remaining lower-priority gaps (callbacks are JS-only by design and out of scope for wrapper e2e): per-family callback rows in §1/§6/§7, theming/i18n (§14), and accessibility (§16) stay spot-check or inherited-from-upstream.
