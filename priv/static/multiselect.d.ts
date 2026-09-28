import { BlissElement } from '@keenmate/web-components-core';
import { BreakpointMap } from '@keenmate/web-components-core';
import { classifyDevice } from '@keenmate/web-components-core';
import { configureBreakpoints } from '@keenmate/web-components-core';
import { DeviceClass } from '@keenmate/web-components-core';
import { ElementSize } from '@keenmate/web-components-core';
import { EnvironmentSnapshot } from '@keenmate/web-components-core';
import { getEnvironment } from '@keenmate/web-components-core';
import { InputDef } from '@keenmate/web-components-core';
import { Logger } from '@keenmate/web-components-core';
import { LogLevelDesc } from '@keenmate/web-components-core';
import { observeEnvironment } from '@keenmate/web-components-core';
import { observeViewport } from '@keenmate/web-components-core';
import { Orientation } from '@keenmate/web-components-core';
import { OS } from '@keenmate/web-components-core';
import { Placement } from '@keenmate/web-components-core/positioning';
import { PointerType } from '@keenmate/web-components-core';
import { PresentationContext } from '@keenmate/web-components-core';
import { TABLET_MIN_SHORT_SIDE } from '@keenmate/web-components-core';

/**
 * Action button configuration for dropdown actions (Select All, Clear All, custom actions)
 * @template T The type of data items
 */
declare interface ActionButton<T = any> {
    /** Action identifier ('select-all', 'clear-all', or 'custom' for custom actions) */
    action: 'select-all' | 'clear-all' | 'custom';
    /** Button text label */
    text: string;
    /** Optional CSS class(es) to add to the button */
    cssClass?: string;
    /**
     * 1-based row this button belongs to (default `1`). Buttons sharing a `row` render on the same
     * horizontal line; different values stack into multiple rows. Row 1 sits at the panel's outer edge
     * and higher rows stack inward toward the options list — so with `actions-position="top"` row 1 is
     * the topmost line, and with `actions-position="bottom"` row 1 is the bottommost line.
     */
    row?: number;
    /** Optional tooltip text */
    tooltip?: string;
    /** Static visibility - set to false to hide button */
    isVisible?: boolean;
    /** Static disabled state - set to true to disable button */
    isDisabled?: boolean;
    /** Custom click handler (required for 'custom' action) */
    onClick?: (multiselect: any) => void | Promise<void>;
    /** Dynamic visibility callback - return false to hide button (takes priority over isVisible) */
    getIsVisibleCallback?: (multiselect: any) => boolean;
    /** Dynamic disabled state callback - return true to disable button (takes priority over isDisabled) */
    getIsDisabledCallback?: (multiselect: any) => boolean;
    /** Dynamic text callback - return button text (takes priority over text) */
    getTextCallback?: (multiselect: any) => string;
    /** Dynamic CSS class callback - return class name(s) (takes priority over cssClass) */
    getClassCallback?: (multiselect: any) => string | string[];
    /** Dynamic tooltip callback - return tooltip text (takes priority over tooltip) */
    getTooltipCallback?: (multiselect: any) => string;
}

/** Horizontal arrangement of buttons within an action row. `stretch` = full-width (default). */
declare type ActionsAlign = 'stretch' | 'left' | 'right' | 'center' | 'space-between';

/**
 * Layout mode for action buttons container
 * - 'nowrap': Buttons stay in single row (default)
 * - 'wrap': Buttons wrap to multiple rows when needed
 */
declare type ActionsLayout = 'nowrap' | 'wrap';

/** Where the action-buttons block sits in the dropdown panel. */
declare type ActionsPosition = 'top' | 'bottom';

/**
 * Context provided to renderBadgeContentCallback
 */
export declare interface BadgeContentRenderContext extends PresentationContext {
    /** Current badges display mode */
    displayMode: BadgesDisplayMode;
    /** Whether the badge is being rendered in the selected items popover */
    isInPopover: boolean;
}

/**
 * Display mode for selected items (badges area)
 */
export declare type BadgesDisplayMode = 'badges' | 'count' | 'compact' | 'partial' | 'none';

/**
 * Position of the badges container relative to the input
 */
export declare type BadgesPosition = 'top' | 'bottom' | 'left' | 'right';

/**
 * Threshold behavior mode when badges exceed threshold
 */
export declare type BadgesThresholdMode = 'count' | 'partial';

export { BreakpointMap }

export { classifyDevice }

export { configureBreakpoints }

export declare const dataLogger: Logger;

export { DeviceClass }

/** Disable all logging (silent). */
export declare function disableLogging(): void;

/** Enable all logging (debug level). */
export declare function enableLogging(): void;

export { EnvironmentSnapshot }

export { getEnvironment }

/**
 * Context handed to `renderGroupLabelContentCallback` as its second argument, so a custom group
 * header can reflect the selection — e.g. render a "3 / 8" count next to the title. The fields are
 * populated for every group header; the selection fields are meaningful mainly under
 * `groupSelectMode: 'cascade'` (a flat multi-select grouped list). Under the default rendering
 * (no callback) the component draws the count itself; with a callback, YOU own the content and can
 * render the count however you like from these fields.
 *
 * Like {@link OptionContentRenderContext} / {@link BadgeContentRenderContext}, it extends the
 * shared {@link PresentationContext} (`presentation` / `isFullscreen` / `isModal`), so a group
 * header can also render leaner in the phone fullscreen overlay.
 */
export declare interface GroupLabelRenderContext<T = any> extends PresentationContext {
    /** The group name (identical to the callback's first argument). */
    groupName: string;
    /** The group's currently-visible (filtered) members, in render order. */
    members: T[];
    /** The subset of `members` that are currently selected (includes disabled-but-selected). */
    selectedMembers: T[];
    /** `selectedMembers.length` — the number to show "behind the group title". */
    selectedCount: number;
    /** `members.length` — total visible members in the group. */
    memberCount: number;
    /** Visible, non-disabled members — the cascade "select-all" denominator. */
    selectableCount: number;
    /** Tristate roll-up of the group under cascade selection. */
    checkState: 'checked' | 'indeterminate' | 'unchecked';
}

export declare const initLogger: Logger;

export declare const interactionLogger: Logger;

/**
 * Full (namespaced) category names, kept for the `getCategories()` global API
 * and any consumer that introspected the list.
 */
export declare const LOGGING_CATEGORIES: string[];

declare interface LTreeNode<T> {
    treeId: string;
    id: NodeId;
    /** Materialized dot-path, e.g. "1.2.3". */
    path: string;
    /** This node's own segment relative to its parent. */
    pathSegment: string;
    parentPath: string | null | undefined;
    /** Depth in the tree (1-based; root children are level 1). */
    level: number | null | undefined;
    /** Children keyed by prefixed segment (see `segmentPrefix` in ltree.ts). */
    children: Record<string, LTreeNode<T>>;
    hasChildren: boolean;
    /**
     * Whether this node may be selected. Defaults to `true`; set `false` (via
     * `isSelectableMember`/`getIsSelectableCallback`) to make a node non-interactive
     * — it renders normally (no grey/disabled styling) but has no checkbox, is
     * skipped by keyboard focus, and cannot be toggled or selected by Select-All.
     * This is distinct from `disabled` (which greys the row out).
     */
    isSelectable: boolean;
    /** The original option object this node was built from. */
    data: T | null | undefined;
}

/**
 * Options for `showMessage()` — the transient toast the component can surface on top of
 * itself. It exists mainly so a veto (or any consumer feedback) is visible in the
 * fullscreen overlay, where page-level UI is covered by the sheet.
 */
declare interface MessageOptions {
    /** Visual tone. Default `'info'`. */
    variant?: MessageVariant;
    /** Auto-dismiss after this many ms. `0` keeps it until replaced, tapped, or the panel closes. Default `3000`. */
    duration?: number;
    /**
     * Where the message anchors relative to the control in the **floating/anchored** case
     * (a floating-ui `Placement`, e.g. `'top'`, `'bottom-start'`, `'right'`). Default
     * `'bottom'`. Ignored when a fullscreen overlay is open — there the message is pinned
     * to the bottom-centre of the viewport.
     */
    placement?: Placement;
}

/**
 * Visual tone of a transient message shown via `showMessage()` (or a veto callback's
 * returned reason string). Each maps to a `.ms__message--{variant}` theming hook.
 */
declare type MessageVariant = 'info' | 'warning' | 'error' | 'success';

/**
 * Generic configuration options for the MultiSelect component
 * @template T The type of data items
 */
declare interface MultiSelectConfig<T = any> {
    /** Options array - can be objects or [key, value] tuples */
    options?: T[];
    /** Member property name for value/ID extraction */
    valueMember?: string;
    /** Callback to extract value/ID from item */
    getValueCallback?: (item: T) => string | number;
    /** Member property name for display value extraction */
    displayValueMember?: string;
    /** Callback to extract display value from item */
    getDisplayValueCallback?: (item: T) => string;
    /** Callback to customize badge display text (defaults to display value if not provided) */
    getBadgeDisplayCallback?: (item: T) => string;
    /**
     * Order of the CURRENTLY-SELECTED items *where they are displayed* — badges, partial mode
     * (i.e. which items sit behind the "+N more" badge), and the selected-items popover. This is a
     * display concern only: `getValue()`, the form output, and `getSelected()` always keep
     * as-selected (insertion) order regardless of this setting, and the options dropdown is never
     * reordered.
     * - `as-selected` (default) — the order items were picked.
     * - `label-asc` / `label-desc` — by the badge label, A→Z / Z→A (locale-aware).
     * - `member` — by the `selectedOrderMember` property (or `getSelectedOrderCallback`); numeric
     *   keys sort numerically, everything else with a locale string compare.
     * - `custom` — delegate to `selectedOrderCompareCallback`.
     */
    selectedOrder?: 'as-selected' | 'label-asc' | 'label-desc' | 'member' | 'custom';
    /** Property name used as the sort key when `selectedOrder === 'member'` (selected-items display only). */
    selectedOrderMember?: string;
    /** Extract the sort key when `selectedOrder === 'member'` (overrides `selectedOrderMember`). */
    getSelectedOrderCallback?: (item: T) => string | number;
    /** Comparator used when `selectedOrder === 'custom'`; standard `(a,b) => number` contract. */
    selectedOrderCompareCallback?: (a: T, b: T) => number;
    /**
     * Member property name for a "full title" — a fully-qualified label that ships with the
     * data (e.g. a breadcrumb like "Fruit / Pome fruit / Apple"). It is never computed by the
     * component. When `isBadgeFullTitleShown` is on, badges display this instead of the display
     * value (falling back to the display value when an option has none).
     */
    fullTitleMember?: string;
    /** Callback to extract the full title from an item (takes precedence over `fullTitleMember`). */
    getFullTitleCallback?: (item: T) => string;
    /** Callback to add custom CSS classes to badges - return string or array of class names */
    getBadgeClassCallback?: (item: T) => string | string[];
    /** Callback to inject custom CSS into Shadow DOM - return CSS string for styling custom classes */
    customStylesCallback?: () => string;
    /**
     * Static CSS string injected into the Shadow DOM (attribute alternative to
     * `customStylesCallback`, via the `custom-styles` attribute). The value is a
     * raw stylesheet — selectors and all — dropped verbatim into the same
     * replaceable style slot. `customStylesCallback` wins when both are set.
     */
    customStyles?: string;
    /** Member property name for search value extraction */
    searchValueMember?: string;
    /** Callback to extract search value from item */
    getSearchValueCallback?: (item: T) => string;
    /** Member property name for icon extraction */
    iconMember?: string;
    /** Callback to extract icon from item */
    getIconCallback?: (item: T) => string;
    /** Member property name for subtitle extraction */
    subtitleMember?: string;
    /** Callback to extract subtitle from item */
    getSubtitleCallback?: (item: T) => string;
    /**
     * Enable tree mode: options are rendered as a hierarchy, indented by depth.
     * Auto-enabled when a path source (`pathMember`/`getPathCallback`) is set;
     * pass `false` to force it off. The tree is always fully expanded — there is
     * no collapse (use @keenmate/web-treeview if you need expand/collapse).
     */
    isTreeEnabled?: boolean;
    /** Member property name holding each option's materialized dot-path (e.g. "1.2.3"). */
    pathMember?: string;
    /** Callback returning an option's materialized dot-path (takes precedence over pathMember). */
    getPathCallback?: (item: T) => string;
    /** Member holding an option's parent path (otherwise derived from its path). */
    parentPathMember?: string;
    /** Member holding an option's depth/level (otherwise derived from its path). */
    levelMember?: string;
    /** Member holding a precomputed hasChildren flag (otherwise derived from the tree). */
    hasChildrenMember?: string;
    /** Path separator for tree paths. Default: "." */
    treePathSeparator?: string;
    /**
     * Member holding a per-option `isSelectable` flag for tree mode. A node with a
     * falsy value renders normally (NOT greyed like `disabled`) but has no checkbox,
     * is skipped by keyboard focus, and cannot be toggled or picked by Select-All.
     * Options default to selectable. Tree mode only.
     */
    isSelectableMember?: string;
    /**
     * Callback deciding whether a tree node is selectable (takes precedence over
     * `isSelectableMember`). Receives the built tree node, so `node.hasChildren` /
     * `node.level` are available — e.g. `(node) => !node.hasChildren` for a
     * leaves-only tree. Tree mode only.
     */
    getIsSelectableCallback?: (node: LTreeNode<T>) => boolean;
    /**
     * Tree checkbox interaction. `cascade` (default) checks a node's whole subtree
     * and shows a tristate (checked / indeterminate / unchecked) box on branches —
     * what most tree-select UIs do. `independent` toggles only the clicked node.
     * Tree + multiple only (no subtree to cascade otherwise). Unset → cascade.
     */
    checkboxMode?: 'independent' | 'cascade';
    /**
     * In `cascade` mode, which values a selection emits (badges / form / change).
     *
     *   - `rolled-up` (default) — minimal cover: a fully-selected subtree collapses
     *     to its root ("complete node"); partially-selected branches emit their
     *     individually-checked descendants. Rolls to the nearest selectable
     *     descendant when the complete node itself is non-selectable.
     *   - `leaves` — only the checked leaf-level nodes.
     *   - `all` — every fully-checked node (branches and leaves), like web-treeview.
     */
    cascadeSelectPolicy?: 'rolled-up' | 'leaves' | 'all';
    /** Member property name for group extraction */
    groupMember?: string;
    /** Callback to extract group from item */
    getGroupCallback?: (item: T) => string;
    /**
     * Callback to customize group label content (can return HTML). Receives the group name and a
     * {@link GroupLabelRenderContext} with the group's members and selection (e.g. `selectedCount`),
     * so a custom header can show a per-group count. The second argument is additive — existing
     * one-argument callbacks keep working.
     */
    renderGroupLabelContentCallback?: (groupName: string, context: GroupLabelRenderContext<T>) => string | HTMLElement;
    /**
     * Group-header selection in a flat (non-tree) grouped, multi-select list.
     * - `none` (default) — group headers are inert labels.
     * - `cascade` — each header shows a **tristate** checkbox that checks/unchecks
     *   all of that group's currently-visible members. The group itself is never a
     *   selected value (`getValue()`/badges/form carry member values only); a
     *   partially-selected group reads indeterminate. Flat + multiple only — no
     *   effect in tree mode (use `checkboxMode`) or single-select.
     */
    groupSelectMode?: 'none' | 'cascade';
    /** Member property name for disabled state extraction */
    disabledMember?: string;
    /** Callback to extract disabled state from item */
    getDisabledCallback?: (item: T) => boolean;
    /** Custom renderer for dropdown option content - return HTML string or HTMLElement */
    renderOptionContentCallback?: (item: T, context: OptionContentRenderContext) => string | HTMLElement;
    /** Custom renderer for badge content (main badges area) - return HTML string or HTMLElement */
    renderBadgeContentCallback?: (item: T, context: BadgeContentRenderContext) => string | HTMLElement;
    /**
     * Custom renderer for the WHOLE badge (main badges area) — return HTML string or HTMLElement
     * for the entire pill/card, not just its content. Unlike renderBadgeContentCallback (which fills
     * the built-in pill), this replaces the badge markup entirely. The component wraps your output in
     * a `.ms__badge.ms__badge--custom` element carrying `data-value`, and delegates removal to any
     * element inside it with `data-action="remove"` (or the built-in `.ms__badge-remove` class) — so
     * put a remove control in your markup and the component handles the deselect. Falls back to the
     * default pill for a given item if the callback returns null/empty. Main badges area only (the
     * selected-items popover keeps using renderSelectedItemContentCallback).
     */
    renderBadgeCallback?: (item: T, context: BadgeContentRenderContext) => string | HTMLElement | null | undefined;
    /**
     * Custom renderer for selected item content in the selected-items popover — return HTML string
     * or HTMLElement. Receives a {@link BadgeContentRenderContext} (2nd arg) since a popover item
     * is rendered through the same badge path: `isInPopover` is `true`, plus the shared
     * presentation fields. The second argument is additive; one-argument callbacks keep working.
     */
    renderSelectedItemContentCallback?: (item: T, context: BadgeContentRenderContext) => string | HTMLElement;
    /** Callback to add custom CSS classes to selected items in popover - return string or array of class names */
    getSelectedItemClassCallback?: (item: T) => string | string[];
    /**
     * Custom renderer for the selected item display in single-select mode — return plain text (it
     * becomes the input value). Receives a {@link SelectedContentRenderContext} (2nd arg) carrying
     * the shared presentation fields. The second argument is additive; one-argument callbacks keep
     * working.
     */
    renderSelectedContentCallback?: (item: T, context: SelectedContentRenderContext) => string;
    /** HTML form field ID/name for hidden input */
    formFieldId?: string;
    /**
     * Format for value serialization (hidden form inputs and callbacks). Default: `json`.
     *
     * - `json` — a JSON array string, e.g. `["a","b"]`
     * - `csv` — comma-separated values, e.g. `a,b`
     * - `array` — one hidden input per value (`name[]` entries)
     */
    valueFormat?: ValueFormat;
    /** Custom callback to format value */
    getValueFormatCallback?: (selectedValues: (string | number)[]) => string;
    /** Allow multiple selections (internal: isMultipleEnabled) */
    isMultipleEnabled?: boolean;
    /** Enable search/filtering (internal: isSearchEnabled) */
    isSearchEnabled?: boolean;
    /** Allow grouping of options (internal: isGroupsAllowed) */
    isGroupsAllowed?: boolean;
    /** Action buttons configuration (Select All, Clear All, custom actions) */
    actionButtons?: ActionButton<T>[];
    /** Show checkboxes next to options (internal: isCheckboxesShown) */
    isCheckboxesShown?: boolean;
    /** Keep Select All/Clear All buttons fixed at top while scrolling (internal: isActionsSticky) */
    isActionsSticky?: boolean;
    /** Close dropdown after selecting an option (internal: isCloseOnSelect) */
    isCloseOnSelect?: boolean;
    /**
     * In the phone fullscreen overlay, auto-focus the search field when it opens — which
     * pops the soft keyboard immediately. Default `false`: the sheet opens showing the list
     * (keyboard closed), and the keyboard appears only when the user taps the search. Set
     * `true` to type-to-filter right away (matches native pickers). No effect in the floating
     * presentation. (internal: fullscreenAutofocus) */
    fullscreenAutofocus?: boolean;
    /** Lock dropdown placement after first open (internal: isPlacementLocked) */
    isPlacementLocked?: boolean;
    /**
     * Allow adding new options not in the list (internal: isAddNewAllowed).
     * When on and a search yields no matches, the empty dropdown shows a clickable
     * "add new" prompt (text from `addNewText` / `getAddNewTextCallback`) instead of
     * the `emptyMessage`; choosing it (click or Enter) fires the `add` event and, if
     * `addNewCallback` is set, materializes + selects the created option.
     */
    isAddNewAllowed?: boolean;
    /**
     * Template for the clickable "add new" prompt (see `isAddNewAllowed`). The substring
     * `{value}` is replaced with the (HTML-escaped) typed text. Default: `Add "{value}"`.
     * `getAddNewTextCallback` takes precedence. (internal: addNewText)
     */
    addNewText?: string;
    /**
     * Dynamically compute the "add new" prompt label from the typed text. Takes precedence
     * over `addNewText`. Returns plain text (inserted as text, not HTML). Use it for i18n or
     * context-aware wording, e.g. `(v) => \`Add new member: ${v}\``.
     */
    getAddNewTextCallback?: ((value: string) => string) | null;
    /**
     * Template for the pending prompt shown (spinner + this text) while an async `addNewCallback`
     * is in flight. `{value}` is replaced with the (HTML-escaped) typed text. Default:
     * `Adding "{value}"…`. (internal: addNewPendingText)
     */
    addNewPendingText?: string;
    /** Show count badge next to toggle icon (internal: isCounterShown) */
    isCounterShown?: boolean;
    /**
     * Show an inline clear (✕) button inside the input that wipes the whole selection.
     * Appears only while something is selected (and the control is enabled). Clicking it
     * clears the selection and any search text, fires `change`, and refocuses the input.
     * Default `false`. (internal: isClearShown)
     */
    isClearShown?: boolean;
    /**
     * Scope the "one overlay open at a time" coordination to a named group. Overlays
     * (multiselects, datepickers, external popovers) sharing a group dismiss each other
     * when one opens; different groups are independent. Unset = the default (ungrouped)
     * group, in which every ungrouped overlay coordinates. (internal: overlayGroup)
     */
    overlayGroup?: string;
    /**
     * Allow the selected-items popover to open. Defaults to `true`. The popover is triggered by
     * the count / compact / "+X more" badge and by the in-input counter (`isCounterShown`). Set
     * to `false` when you render your own selection UI (e.g. an external container fed by the
     * `change` event) — the badge and counter still show the count, but clicking them does nothing
     * and they lose the pointer cursor. (internal: isSelectedPopoverEnabled)
     */
    isSelectedPopoverEnabled?: boolean;
    /**
     * Make badges display each option's `fullTitleMember` / `getFullTitleCallback` value
     * instead of its display value. Falls back to the display value for options without a
     * full title. An explicit `getBadgeDisplayCallback` still takes precedence. Off by default.
     */
    isBadgeFullTitleShown?: boolean;
    /** Keep initial options visible when searchCallback is active and search term is empty/short (internal: isKeepOptionsOnSearch) */
    isKeepOptionsOnSearch?: boolean;
    /** Keep search text and filtered results when dropdown closes (default: true) */
    shouldKeepSearchOnClose?: boolean;
    /** Enable virtual scrolling for large datasets (internal: isVirtualScrollEnabled) */
    isVirtualScrollEnabled?: boolean;
    /**
     * Vertical alignment of checkboxes relative to option content. Default: `center`.
     *
     * - `top` — align to the top of the row
     * - `center` — vertically centered
     * - `bottom` — align to the bottom of the row
     */
    checkboxAlign?: 'top' | 'center' | 'bottom';
    /** Hint text shown above the input while the dropdown is open. */
    searchHint?: string;
    /** Placeholder text for the search input (shown while search is usable) */
    searchPlaceholder?: string;
    /**
     * Placeholder shown when search is disabled (input acts as a picker rather than a search box).
     * Applies when `isSearchEnabled` is false or `searchInputMode` is 'readonly'/'hidden'.
     * Default: "Pick an option..."
     */
    selectPlaceholder?: string;
    /**
     * Placeholder shown when there are no options to choose from (e.g. an unresolved cascade parent).
     * Opt-in: when unset, the normal search/select placeholder is used even with an empty list.
     * Lets users see there is no data without opening the dropdown.
     */
    noDataPlaceholder?: string;
    /** Minimum width for the dropdown (e.g., '20rem', '300px') */
    dropdownMinWidth?: string | null;
    /** Maximum width for the dropdown (e.g., '40rem', '500px') */
    dropdownMaxWidth?: string | null;
    /**
     * Display mode for selected items in the badges area. Default: `badges`.
     *
     * - `badges` — one removable badge per selected option
     * - `count` — a single "N selected" count badge
     * - `compact` — condensed badges (first few, tighter spacing)
     * - `partial` — a limited number of badges plus a "+X more" badge
     * - `none` — hide the badges area entirely
     */
    badgesDisplayMode?: BadgesDisplayMode;
    /**
     * Position of the badges container relative to the input. Default: `bottom`.
     *
     * - `top` — above the input
     * - `bottom` — below the input
     * - `left` — to the left of the input
     * - `right` — to the right of the input
     */
    badgesPosition?: BadgesPosition;
    /**
     * How the display switches once `badgesThreshold` is exceeded. Default: `count`.
     *
     * - `count` — collapse all selections into a single count badge
     * - `partial` — keep up to `badgesMaxVisible` badges and add a "+X more" badge
     */
    badgesThresholdMode?: BadgesThresholdMode;
    /** Maximum height for dropdown */
    maxHeight?: string;
    /** Message shown when no results found */
    emptyMessage?: string;
    /** Message shown while loading async data */
    loadingMessage?: string;
    /**
     * How the search input behaves. Default: `normal`.
     *
     * - `normal` — editable search box
     * - `readonly` — visible but not editable (acts as a picker; uses `selectPlaceholder`)
     * - `hidden` — no search box at all
     */
    searchInputMode?: SearchInputMode;
    /**
     * Search behavior mode. Default: `filter`.
     *
     * - `filter` — hide options that don't match
     * - `navigate` — keep all options visible and jump focus to matches
     */
    searchMode?: SearchMode;
    /**
     * Show a clickable mode toggle in the phone fullscreen overlay's search header that
     * flips `searchMode` between `filter` and `navigate` live (no reopen). Default `false`.
     *
     * The overlay has room for the affordance and touch users can't reach the desktop
     * `Ctrl`+`Arrow` match-stepping, so this exposes both modes on the device where it
     * matters most. The toggle sits at the leading edge of the search field; its icon
     * reflects the current mode (magnifier = navigate, funnel = filter). No effect in the
     * floating presentation or when search is disabled/hidden.
     */
    isSearchModeToggleShown?: boolean;
    /**
     * Layout mode for the action buttons. Default: `nowrap`.
     *
     * - `nowrap` — buttons stay on a single row
     * - `wrap` — buttons wrap onto multiple rows
     */
    actionsLayout?: ActionsLayout;
    /**
     * Where the action-buttons block sits in the dropdown. Default: `top`.
     *
     * - `top` — above the options list
     * - `bottom` — sticky footer below the options list
     */
    actionsPosition?: ActionsPosition;
    /**
     * Horizontal arrangement of buttons within a row. Default: `stretch`.
     *
     * - `stretch` — full-width, evenly divided
     * - `left` — packed to the start
     * - `right` — packed to the end
     * - `center` — centered
     * - `space-between` — spread to the edges with gaps between
     */
    actionsAlign?: ActionsAlign;
    /** Auto-switch from badges to count when threshold is exceeded */
    badgesThreshold?: number | null;
    /** Maximum number of badges to show in partial mode (used with thresholdMode='partial') */
    badgesMaxVisible?: number | null;
    /** Minimum search length before loading data */
    minSearchLength?: number;
    /**
     * Debounce delay in milliseconds before the async `searchCallback` is invoked.
     * Each keystroke resets the timer, so only the last input in a burst fires a request.
     * Applies to the async `searchCallback` path only — local in-memory filtering stays instant.
     * Default: 0 (no debounce — callback runs on every keystroke).
     */
    searchDebounce?: number;
    /** Minimum items before virtual scroll activates (default: 100) */
    virtualScrollThreshold?: number;
    /** Fixed height for each option in pixels (required for virtual scroll, default: 50) */
    optionHeight?: number;
    /** Fixed height for each badge in selected items popover in pixels (required for virtual scroll, default: 36) */
    badgeHeight?: number;
    /** Buffer size for virtual scroll - items above/below viewport (default: 10) */
    virtualScrollBuffer?: number;
    /** Pre-process search term before calling searchCallback. Return null to prevent search. Use for accent removal, validation, etc. */
    beforeSearchCallback?: ((searchTerm: string) => string | null) | null;
    /**
     * Interceptor: runs before an option is selected via user interaction.
     * Receives the option about to be added and the current selection (before the change).
     * Return `false` to block the selection; return `true`/`undefined` to allow. Return a
     * **string** to block AND surface it as a message (see `showMessage`) — the touch-safe
     * way to explain a veto in the fullscreen overlay, where page-level UI is hidden behind
     * it. Silent otherwise — a blocked action fires no event. Bypassed by programmatic
     * `setSelected` and the Select-All action button.
     */
    beforeSelectCallback?: ((option: T, selectedOptions: T[]) => boolean | string | void) | null;
    /**
     * Interceptor: runs before an option is deselected via user interaction — the dropdown
     * option toggle, a badge's remove (×) button, the selected-items popover's remove button,
     * and the "remove hidden" badge (checked per item). Receives the option about to be
     * removed and the current selection (before the change). Return `false` to block the
     * deselection; return `true`/`undefined` to allow. Return a **string** to block AND
     * surface it as a message (see `showMessage`). Silent otherwise — a blocked action fires
     * no event. Bypassed by programmatic `setSelected` and the Clear-All action button.
     */
    beforeDeselectCallback?: ((option: T, selectedOptions: T[]) => boolean | string | void) | null;
    /**
     * Async function to load data: `(searchTerm, signal) => Promise<options[]>`.
     * The optional second argument is an `AbortSignal` that fires when a newer search
     * supersedes this one (or the component is destroyed). Wire it into your `fetch`
     * to cancel the in-flight request; ignoring it is fine — stale results are discarded.
     */
    searchCallback?: ((searchTerm: string, signal?: AbortSignal) => Promise<T[]>) | null;
    /**
     * Callback to create the new option object from the typed text when `isAddNewAllowed` is on.
     * Return (or resolve to) the new option — it is appended to the list and auto-selected. The
     * returned `T` can be a rich option object (icon/subtitle/custom-render fields and all): it flows
     * through the same `get*` / `render*` callbacks as any other option, so the created row and its
     * badge render exactly like the rest.
     *
     * **Cancelable (async):** return `null` or `undefined` (or a Promise of either) to abort — nothing
     * is added or selected, the search is left intact, and the `add` event does NOT fire. Use it for
     * async validation, a confirm dialog, or a server round-trip that may say no. The cancel sentinel
     * is strictly `null`/`undefined` (checked with `== null`), so a falsy-but-valid option in
     * primitive mode (`0`, `false`, `""`) still creates normally.
     *
     * Omit the callback entirely to handle creation yourself via the `add` event / `onAddNew` (e.g.
     * open a modal, POST to a server, then add the option imperatively).
     */
    addNewCallback?: ((value: string) => T | null | undefined | Promise<T | null | undefined>) | null;
    /**
     * Event handler: the user chose to create a new option from the typed text (via the "add new"
     * row or Enter). `value` is the typed text; `option` is the created item when `addNewCallback`
     * produced one (absent otherwise). Mirrors the bubbling `add` CustomEvent on the element.
     */
    onAddNew?: ((detail: {
        value: string;
        option?: T;
    }) => void) | null;
    /**
     * Intercept keyboard input before the built-in handling. Runs on every keydown (open or
     * closed) with a {@link MultiSelectKeydownContext} carrying the event, current state, and a
     * {@link MultiSelectKeyboardController}. Return `true` to mark the key fully handled — the
     * component then runs none of its own key logic (you own `preventDefault`); return
     * `false`/`undefined` to fall through to the defaults. Use it to remap keys (Vim `j`/`k`),
     * add shortcuts (Ctrl+A → select all), or suppress a default. Property-only.
     */
    keydownCallback?: ((context: MultiSelectKeydownContext<T>) => boolean | void) | null;
    /** Event handler: an option was selected (fire-and-forget; return value ignored). Mirrors the bubbling `select` CustomEvent on the element. */
    onSelect?: ((option: T) => void) | null;
    /** Event handler: an option was deselected (fire-and-forget). Mirrors the bubbling `deselect` CustomEvent on the element. */
    onDeselect?: ((option: T) => void) | null;
    /** Event handler: the selection set changed (fire-and-forget). Mirrors the bubbling `change` CustomEvent on the element. */
    onChange?: ((selectedOptions: T[]) => void) | null;
    /**
     * Formats the badges-area count/summary text: the `count` mode badge ("N selected") and the
     * partial-mode "+X more" badge (when `moreCount` is provided). NOT the small `[N]` chip — that's
     * {@link getCountLabelCallback}. For i18n/pluralization.
     */
    getCounterCallback?: ((count: number, moreCount?: number) => string) | null;
    /**
     * Formats the small count CHIP shared by the in-input counter (`show-counter`) and each group
     * header's per-group count. Distinct from {@link getCounterCallback}, which formats the
     * badges-area "N selected" / "+X more" text. Receives `selected` and `total`: for the in-input
     * counter `total` is the whole option list; for a group header it's that group's member count.
     * Return the label as plain text. Default `[selected]` (e.g. `[3]`). Set it to
     * `` (s, t) => `${s}/${t}` `` for an "x / y" style. One callback drives both so they always
     * read the same way.
     */
    getCountLabelCallback?: ((selected: number, total: number) => string) | null;
    /** Enable tooltips on selected item badges (internal: isBadgeTooltipsEnabled) */
    isBadgeTooltipsEnabled?: boolean;
    /** Callback to generate custom tooltip content for a badge */
    getBadgeTooltipCallback?: ((item: T) => string | HTMLElement) | null;
    /** Callback to generate custom tooltip text for a remove button */
    getRemoveButtonTooltipCallback?: ((item: T) => string) | null;
    /** Format string for remove button tooltip text. Use {0} as placeholder for item name. Default: "Remove {0}" */
    removeButtonTooltipText?: string;
    /**
     * Tooltip placement relative to the badge (Floating UI `Placement`). Default: `top`.
     *
     * One of: `top`, `top-start`, `top-end`, `bottom`, `bottom-start`, `bottom-end`,
     * `left`, `left-start`, `left-end`, `right`, `right-start`, `right-end`.
     */
    badgeTooltipPlacement?: Placement;
    /** Delay before showing tooltip in milliseconds */
    badgeTooltipDelay?: number;
    /** Offset distance for tooltip in pixels */
    badgeTooltipOffset?: number;
    /** Enable tooltips on dropdown options (internal: isOptionTooltipsEnabled) */
    isOptionTooltipsEnabled?: boolean;
    /** Callback to generate custom tooltip content for a dropdown option. Default: display value, plus subtitle on the next line when present. */
    getOptionTooltipCallback?: ((item: T) => string | HTMLElement) | null;
    /**
     * Option tooltip placement (Floating UI `Placement`). Default `top-start`
     * (anchored to the row's start edge, so it doesn't center on a full-width row).
     * Use `left`/`right` (or their start/end variants) for a narrow multiselect.
     *
     * One of: `top`, `top-start`, `top-end`, `bottom`, `bottom-start`, `bottom-end`,
     * `left`, `left-start`, `left-end`, `right`, `right-start`, `right-end`.
     */
    optionTooltipPlacement?: Placement;
    /** Delay before showing an option tooltip (ms). Falls back to `badgeTooltipDelay`, then `100`. */
    optionTooltipDelay?: number;
    /** Offset distance for an option tooltip (px). Falls back to `badgeTooltipOffset`, then `8`. */
    optionTooltipOffset?: number;
    /** Anchor the option tooltip to the mouse pointer and follow it across the row (best for full-width rows). Default `false`. */
    isOptionTooltipFollowCursor?: boolean;
    /** Container element for dropdown/hint/popover (for Shadow DOM support) */
    container?: HTMLElement | null;
    /** Host element for appending hidden inputs (for form integration with shadow DOM) */
    hostElement?: HTMLElement;
}

export declare class MultiSelectElement<T = any> extends BlissElement<MultiSelectEvents> {
    #private;
    static formAssociated: boolean;
    protected static inputs: readonly InputDef<unknown>[];
    protected static events: readonly [{
        readonly name: "select";
        readonly description: "An option was selected. `detail.option` is the selected option; `detail.selectedOptions`/`detail.selectedValues` are the full selection.";
    }, {
        readonly name: "deselect";
        readonly description: "An option was removed from the selection. `detail.option` is that option.";
    }, {
        readonly name: "change";
        readonly description: "The selection changed. `detail.selectedOptions`/`detail.selectedValues` are the full selection.";
    }, {
        readonly name: "add";
        readonly description: "The user chose to create a new option from the typed text (via the \"add new\" prompt or Enter) — requires `allow-add-new`. `detail.value` is the typed text; `detail.option` is the created item when `addNewCallback` produced one.";
    }, {
        readonly name: "ready";
        readonly description: "The picker was built and painted for the first time (once per element lifetime). Fires right after the first build — synchronously during upgrade for a normal element, or when the render gate is released (`el.ready()` / removing `defer`) for a deferred one. No detail.";
    }];
    onSelect: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onDeselect: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onChange: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onAdd: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onReady: ((e: CustomEvent<undefined>) => void) | null;
    constructor();
    /**
     * Called by the browser when the surrounding <form> is reset. Clears the
     * picker's selection so the control participates in the standard reset.
     */
    formResetCallback(): void;
    /** Runtime writing-direction switch (core observes `dir`): re-mirror the live
     *  picker. Layout mostly follows the inherited `direction` (logical properties);
     *  refreshDirection() fixes the parts pinned at build time (the `.ms--rtl` class
     *  and the panels' explicit `dir`). The initial direction is read by the build. */
    protected directionChanged(_isRTL: boolean): void;
    /** Structural change (or first connect): mirror CSS vars, then (re)build the picker. */
    protected reinit(): void;
    /** Cosmetic change: mirror CSS vars / custom styles / debug, patch the picker in place. */
    protected update(partial: Record<string, unknown>): void;
    /** Activate: ensure the picker exists (a DOM move destroyed it in disconnect()). */
    protected connect(): void;
    /** Deactivate: tear the picker down (rebuilt on the next connect). */
    protected disconnect(): void;
    /**
     * Device/viewport/orientation changed (core §12.9). Overriding this opts the
     * element into the shared environment observable — core subscribes on connect
     * (firing immediately with the current snapshot) and unsubscribes on disconnect.
     * We map it to the picker's floating/fullscreen presentation; the immediate fire
     * lands right after `connect()` builds the picker, so the initial presentation is
     * set before the dropdown can open.
     */
    protected environmentChanged(env: EnvironmentSnapshot): void;
    /**
     * This element's own border box changed (core §12.9 `resized`). Overriding the
     * hook opts us into a shared page-wide ResizeObserver, subscribed on connect and
     * dropped on disconnect. Unlike `environmentChanged`/`viewportChanged` (the
     * WINDOW), this is our OWN box — a picker in a 400px sidebar on a 2560px monitor
     * reflows on its width, not the viewport's. We only act when `collapse-badges-
     * below` is set; otherwise it's a cheap no-op.
     */
    protected resized({ width }: ElementSize): void;
    /** Form field name (mirrors the `name` attribute → `formFieldId`). */
    get name(): string | null;
    set name(value: string | null);
    get selectedValue(): string | number | (string | number)[] | null;
    get selectedItem(): T | null;
    getSelected(): T[];
    setSelected(values: (string | number)[], opts?: {
        notify?: boolean;
    }): void;
    getValue(): string | number | (string | number)[] | null;
    /**
     * Surface a transient message ("toast") on top of the component — visible even in the
     * fullscreen overlay, where page-level UI is hidden behind the sheet. Content is text or
     * an element; `opts.variant` sets the tone and `opts.duration` the auto-dismiss (0 =
     * sticky). Also reached automatically when a `beforeSelect`/`beforeDeselect` callback
     * returns a reason string.
     */
    showMessage(content: string | HTMLElement, opts?: MessageOptions): void;
    /** Dismiss the transient message shown by {@link showMessage}, if any. */
    hideMessage(): void;
    /**
     * Clear the search box and restore the full option list (does not touch the selection — use
     * {@link clearAll} for that). Pair with {@link scrollToValue} to reveal then scroll to an option
     * a search had filtered out: `el.clearSearch(); el.scrollToValue(v)`.
     */
    clearSearch(): void;
    /** The current search box text (empty string when nothing is typed). Read via this getter, write with {@link search}. */
    get searchText(): string;
    /**
     * Programmatically set the search text and filter, as if the user typed it (runs
     * `beforeSearchCallback` / `minSearchLength` / async `searchCallback`). Does not open the dropdown
     * — call {@link open} if you want it visible. Pass `''` to clear (same as {@link clearSearch}).
     */
    search(term: string): void;
    /**
     * Scroll the open dropdown to the option at `index` (into the current filtered list). Returns
     * false if closed or out of range. Deferred internally so `el.open(); el.scrollToIndex(i)` works.
     */
    scrollToIndex(index: number, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /**
     * Scroll the open dropdown to the option with this `value`. Returns false if it isn't in the
     * currently visible list (filtered out by search, or under a collapsed tree branch) — call
     * {@link clearSearch} / expand first.
     */
    scrollToValue(value: string | number, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /**
     * Scroll to a group: its header in standard rendering, or the group's first option in
     * virtual-scroll mode (no headers there). Returns false in tree mode or if the group is empty
     * in the current filtered list.
     */
    scrollToGroup(name: string, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /** Open the dropdown. */
    open(): void;
    /** Close the dropdown. */
    close(): void;
    /** Toggle the dropdown open/closed. */
    toggle(): void;
    /** Whether the dropdown is currently open. Assigning opens/closes it. */
    get isOpen(): boolean;
    set isOpen(value: boolean);
    destroy(): void;
    /**
     * Release the `defer` render gate: build the picker now (once), with every
     * option, callback and listener wired while deferred already in place. No-op
     * when the element wasn't deferred or is already built. `flush()` first so a
     * synchronous `el.options = …; el.customStylesCallback = …; el.ready()` lands
     * those pending writes in the single build rather than after it. Latched — the
     * gate never re-closes. Fires the `ready` event on the first build.
     */
    ready(): void;
    /** Whether the picker has been built (the `ready` event has fired). False while a `defer` gate is still held. */
    get isReady(): boolean;
}

/**
 * Event detail structure for multiselect events
 * @template T The type of data items
 */
export declare interface MultiSelectEventDetail<T = any> {
    /** Currently selected options */
    selectedOptions: T[];
    /** Selected values array */
    selectedValues: (string | number)[];
    /** The option that triggered the event (for select/deselect/add) */
    option?: T;
    /** The typed text that triggered the `add` event (add only) */
    value?: string;
}

declare type MultiSelectEvents = {
    select: MultiSelectEventDetail;
    deselect: MultiSelectEventDetail;
    change: MultiSelectEventDetail;
    add: MultiSelectEventDetail;
    ready: undefined;
};

/**
 * Imperative facade handed to `keydownCallback` so a consumer can drive the picker without
 * reaching into internals. Every method mirrors a built-in keyboard action.
 */
declare interface MultiSelectKeyboardController<T = any> {
    /** Move focus to the next / previous option. */
    focusNext(): void;
    focusPrevious(): void;
    /** Move focus to the first / last option. */
    focusFirst(): void;
    focusLast(): void;
    /** Move focus by a page (10 rows). */
    focusPageUp(): void;
    focusPageDown(): void;
    /** Navigate-mode only: jump focus to the next / previous match. */
    focusNextMatch(): void;
    focusPreviousMatch(): void;
    /** Focus a specific index in the filtered list (ignored if out of range). */
    focusIndex(index: number): void;
    /** Toggle the currently focused option (no-op if nothing is focused). */
    toggleFocused(): void;
    /** Toggle a specific option by its value (select ⇄ deselect). */
    toggleValue(value: string | number): void;
    /** Select a specific option by its value (no-op if already selected). */
    selectValue(value: string | number): void;
    /** Deselect a specific option by its value (no-op if not selected). */
    deselectValue(value: string | number): void;
    /** Open / close the dropdown. */
    open(): void;
    close(): void;
    /** Set the search box text (runs the search). */
    setSearch(term: string): void;
    /** Clear the search box and reset the visible list. */
    clearSearch(): void;
}

/**
 * Context passed to `keydownCallback`, which runs before all built-in keyboard handling.
 * Return `true` to mark the key fully handled (the component then runs none of its own
 * key logic — you own `preventDefault`); return `false`/`undefined` to fall through to the
 * defaults. Mirrors the veto-hook shape used across KM components.
 */
declare interface MultiSelectKeydownContext<T = any> {
    /** The raw keyboard event — call `preventDefault()` yourself if you handle the key. */
    event: KeyboardEvent;
    /** `event.key`, for convenience. */
    key: string;
    /** Whether the dropdown is currently open. */
    isOpen: boolean;
    /** How the open panel is presented (`floating` / `fullscreen`). */
    presentation: 'floating' | 'fullscreen';
    /** The current search term. */
    searchTerm: string;
    /** Index of the focused option in the filtered list (`-1` when nothing is focused). */
    focusedIndex: number;
    /** The focused option object, or `null`. */
    focusedOption: T | null;
    /** The options currently visible (after filtering). */
    filteredOptions: ReadonlyArray<T>;
    /** The currently selected values. */
    selectedValues: ReadonlyArray<string>;
    /** Imperative actions mirroring the built-in keyboard behavior. */
    controller: MultiSelectKeyboardController<T>;
}

/**
 * Legacy interface for backward reference
 * Note: New code should use generic types with member/callback properties
 * @deprecated Use generic types with valueMember/displayValueMember instead
 */
export declare interface MultiSelectOption {
    /** Unique identifier for the option */
    value: string;
    /** Display label */
    label: string;
    /** Optional icon or emoji */
    icon?: string;
    /** Optional subtitle/description */
    subtitle?: string;
    /** Optional group name */
    group?: string;
    /** Whether the option is disabled */
    disabled?: boolean;
}

/**
 * Legacy options interface
 * @deprecated Use MultiSelectConfig<T> instead
 */
export declare interface MultiSelectOptions extends MultiSelectConfig<MultiSelectOption> {
    options?: MultiSelectOption[];
    searchCallback?: ((searchTerm: string, signal?: AbortSignal) => Promise<MultiSelectOption[]>) | null;
    addNewCallback?: ((value: string) => MultiSelectOption | Promise<MultiSelectOption>) | null;
    onSelect?: ((option: MultiSelectOption) => void) | null;
    onDeselect?: ((option: MultiSelectOption) => void) | null;
    onChange?: ((selectedOptions: MultiSelectOption[]) => void) | null;
}

/**
 * LTreeNode — a single node in the option tree.
 *
 * Trimmed lift of web-treeview's `ltree/ltree-node.ts`. The multiselect renders
 * every node expanded (no collapse), so this keeps only the structural fields
 * needed to order nodes and indent them: path/parent/level/children/hasChildren
 * plus the original option `data`. Expand state, drag-drop, checkbox, selection
 * and drop-position fields are all thrown out.
 */
declare type NodeId = string | number;

export { observeEnvironment }

export { observeViewport }

/**
 * Context provided to renderOptionContentCallback.
 *
 * Extends the shared {@link PresentationContext} from `@keenmate/web-components-core`, so it
 * also carries `presentation` (`'floating' | 'modal' | 'fullscreen'` — this component only ever
 * emits `floating`/`fullscreen`), `isFullscreen`, and `isModal`. Branch on `isFullscreen` to
 * render leaner content in the phone overlay. Reactive: swapping presentation re-renders and
 * re-invokes the callback with the new value.
 */
export declare interface OptionContentRenderContext extends PresentationContext {
    /** Index of the option in the filtered list */
    index: number;
    /** Whether the option is currently selected */
    isSelected: boolean;
    /** Whether the option is currently focused (keyboard navigation) */
    isFocused: boolean;
    /** Whether the option matches the current search term (navigate mode only) */
    isMatched: boolean;
    /** Whether the option is disabled */
    isDisabled: boolean;
    /** True when this row is a tree node (path-member / tree mode). Absent/false for flat options. */
    isTreeNode?: boolean;
    /** Tree only: the node has children (a branch). */
    isBranch?: boolean;
    /** Tree only: the node has no children (a leaf). */
    isLeaf?: boolean;
    /** Tree only: number of direct children (0 for a leaf). */
    childCount?: number;
    /** Tree only: 1-based depth level as derived from the path (top level = 1). */
    level?: number;
    /** Tree only: 0-based indentation depth (`level - 1`), matching `--ms-tree-depth`. */
    depth?: number;
    /** Tree only: the node's materialized path (e.g. "1.1.2"). */
    path?: string;
    /** Tree only: the node is selectable (branches marked non-selectable are `false`). */
    isSelectable?: boolean;
    /** Tree only: cascade tristate — a partially-checked branch (some but not all descendants). */
    isIndeterminate?: boolean;
}

/**
 * `data-options` payload parsers. The `data-options-format` attribute selects
 * one; each turns the raw attribute string into an options array the picker
 * understands. Pure + total (never throws) so they unit-test in isolation and a
 * malformed payload degrades to `[]` with a describable error rather than
 * breaking reinit.
 */
export declare const OPTIONS_FORMATS: readonly ["json", "csv", "plain"];

export declare type OptionsFormat = (typeof OPTIONS_FORMATS)[number];

export { Orientation }

export { OS }

export declare interface ParsedOptions {
    /** Parsed options: objects for `json`/`csv`, `[value, label]` tuples for `plain`. */
    options: unknown[];
    /** A human-readable reason when the payload was malformed (`options` is then `[]`). */
    error?: string;
}

/**
 * Parse a `data-options` payload per `format`:
 *  - `json`  — a JSON array of option objects or `[value, label]` tuples.
 *              (`splitter`/`rowSplitter` do not apply.)
 *  - `csv`   — rows split on `rowSplitter`, cells on `splitter`; the first row is a
 *              header and each later row becomes an object keyed by the header cells
 *              (map columns via `*-member`). RFC-4180-ish quoting on the cell splitter.
 *  - `plain` — bare values split on `splitter` and `rowSplitter` -> `[value, label]`
 *              tuples (value === label), so it renders with no member config.
 */
export declare function parseOptionsData(raw: string | null | undefined, format: OptionsFormat, opts?: ParseOptionsOptions): ParsedOptions;

declare interface ParseOptionsOptions {
    /** Field/cell delimiter for `csv` and `plain` (default `,`). Escapes `\t \n \r \\` are honoured. */
    splitter?: string;
    /** Row/record delimiter for `csv` and `plain` (default newline). Escapes honoured. */
    rowSplitter?: string;
}

export { PointerType }

/**
 * Search input display mode
 */
export declare type SearchInputMode = 'normal' | 'readonly' | 'hidden';

/**
 * Search behavior mode
 * - 'filter': Hide non-matching options (default)
 * - 'navigate': Keep all options visible, jump to matches
 */
export declare type SearchMode = 'filter' | 'navigate';

/**
 * Context handed to `renderSelectedContentCallback` (single-select selected-value display). Carries
 * only the shared {@link PresentationContext} fields (`presentation` / `isFullscreen` / `isModal`),
 * so the single-select label can render leaner in the phone fullscreen overlay.
 */
export declare type SelectedContentRenderContext = PresentationContext;

/**
 * Set the level of one category. Accepts the full prefixed name
 * (`MULTISELECT:UI`) or the bare suffix (`UI`) — both normalize to the category
 * key the core bundle expects.
 */
export declare function setCategoryLevel(category: string, level: LogLevelDesc): void;

/** Set the same level on every category. */
export declare function setLogLevel(level: LogLevelDesc): void;

export { TABLET_MIN_SHORT_SIDE }

export declare const uiLogger: Logger;

/**
 * Value format for serialization (forms and callbacks)
 */
export declare type ValueFormat = 'json' | 'csv' | 'array';

export declare class WebMultiSelect<T = any> {
    #private;
    private element;
    private instanceId;
    private options;
    private selectedValues;
    private selectedOptions;
    private allOptions;
    private filteredOptions;
    private tree;
    private treeNodes;
    private cascadeIndex;
    private cascadeCheckedAtoms;
    private hiddenInputs;
    private focusedIndex;
    private keyboardController;
    private matchingIndices;
    private searchTerm;
    /** Keyboard focus sits on the empty-state "add new" prompt (arrow-navigated). */
    private addNewFocused;
    /** An async addNewCallback is in flight — the prompt shows a spinner + pending text. */
    private addNewPending;
    private isLoading;
    private searchDebounceTimer?;
    private searchAbortController?;
    private showSelectedPopover;
    private selectedPopoverPlacement;
    private dropdownPlacement;
    private isRTL;
    private effectiveBadgesPosition;
    private justClosedViaClick;
    private justOpenedViaClick;
    private positioningDriftWarned;
    private fullscreenContainingBlockWarned;
    private presentationMode;
    private fullscreenHeader;
    private fullscreenSearchInput;
    private fullscreenSearchClear;
    private fullscreenModeToggle;
    private fullscreenNav;
    private fullscreenNavCount;
    private fullscreenNavPrev;
    private fullscreenNavNext;
    private bodyScrollUnlock;
    private overflowXClamp;
    private keyboardInsetCleanup;
    private overlayHistoryActive;
    private readonly onOverlayPopstate;
    private dropdownCleanup;
    private hintCleanup;
    private selectedPopoverCleanup;
    private tooltips;
    private labelRevealTrigger;
    private labelRevealPanel;
    private labelRevealPopover;
    private messageEl;
    private messageCleanup;
    private messageTimer;
    private readonly onDropdownScroll;
    private virtualScroll;
    private optionsContainer;
    private selectedPopoverVirtualScroll;
    private selectedPopoverContainer;
    private input;
    private inputWrapper;
    private dropdown;
    private dropdownInner;
    private badgesContainer;
    private counter;
    private clearButton;
    private hint?;
    private selectedPopover;
    private documentKeydownHandler;
    private documentClickHandler;
    private overlayCoord;
    /**
     * Generic field extractor with the precedence:
     *   tuple short-circuit -> member property -> callback -> fallback
     *
     * Tuple handling:
     *   - `tupleIndex` (0 | 1): for `[key, value]` items, return that slot.
     *   - `tupleSkip: true`: for any tuple, skip directly to fallback (used for icon/subtitle/group/disabled —
     *     fields that don't make sense on a 2-element array).
     *   - neither: tuples flow through the member/callback/fallback chain as if they were objects.
     *
     * `transform` is applied to tuple-slot and member-property reads (not to callback returns or the fallback),
     * so e.g. you can pass `String` to coerce numeric members to strings while letting a typed callback return its
     * own type unchanged.
     */
    private extractField;
    private getItemValue;
    private getItemDisplayValue;
    /**
     * Badge display falls back to the regular display value rather than '[N/A]', so consumers can override badge
     * text independently. Doesn't fit the extractField shape (no tuple/member layer of its own).
     */
    private getItemBadgeDisplayValue;
    /**
     * Full title — a fully-qualified label supplied with the data (never computed here). Used by
     * badges when `isBadgeFullTitleShown` is on. Returns undefined when the option has none.
     */
    private getItemFullTitle;
    private getItemSearchValue;
    /** Sort key for `selectedOrder === 'member'` (member/callback pattern). */
    private getItemSortKey;
    /**
     * Selected options in the order they should be DISPLAYED (badges / partial "+N more" / popover).
     * Never mutates state — always returns a fresh array. Display concern only: getValue()/form
     * output/getSelected() keep as-selected (insertion) order. See `selectedOrder`.
     */
    private getOrderedSelectedOptions;
    private getItemIcon;
    private getItemSubtitle;
    private getItemGroup;
    private getItemDisabled;
    /**
     * Tree mode: whether the visible node at `index` may be selected. Non-selectable
     * nodes (see `isSelectableMember`/`getIsSelectableCallback`) still render — just
     * without a checkbox — but are skipped by focus and cannot be toggled. Always
     * true outside tree mode. `treeNodes` is index-aligned with `filteredOptions`.
     */
    private isIndexSelectable;
    /** Whether an option may be selected. Always true outside tree mode. */
    private isOptionSelectable;
    constructor(element: HTMLElement, options?: Partial<MultiSelectConfig<T>>);
    private init;
    private parseOptions;
    /** Whether options should be rendered as an (always-expanded) tree. */
    private isTreeMode;
    /** (Re)build the ltree from `allOptions` and derive the visible flat list. */
    private buildTree;
    /**
     * Whether cascade checkbox mode is active: a multi-select tree with
     * `checkbox-mode` NOT set to `independent`. Checking a node then toggles its
     * whole subtree and branches show a tristate box. Cascade is the DEFAULT
     * (unset → cascade); opt out per-instance with `checkbox-mode="independent"`.
     * Only ever active in tree + multiple — no subtree to cascade otherwise.
     */
    private isCascadeMode;
    private cascadePolicy;
    /** Refresh the derived checked-atom set from the emitted `selectedValues`. */
    private refreshCascadeAtoms;
    /**
     * Toggle a tree node in cascade mode: flip its whole subtree, re-project the
     * checked atoms to emitted values under the active policy, and commit the diff
     * so badges / form / change events reflect the policy (rolled-up branches, etc.).
     */
    private toggleTreeCascade;
    /**
     * Given a checked-atom set, project it to emitted values under the active
     * policy, diff it against the current selection, and commit. Shared by every
     * cascade entry point (node toggle, Select All) so they all emit the same
     * policy-projected shape (e.g. a full subtree rolls up to one value).
     */
    private commitCascadeAtoms;
    /**
     * The "meaningful selection" list used by the counter chip — the rolled-up
     * minimal cover, regardless of the active emit policy. In cascade mode
     * `leaves`/`all` emit many values for a single branch pick, which made the
     * counter read e.g. `[5]` for what a person experiences as two selections.
     * The counter should count the branches actually chosen, and stay stable when
     * the policy knob flips. Outside cascade this is just the selected options.
     */
    private counterSelection;
    /** Native `title` for the counter chip: the picked items, capped so it can't grow unbounded. */
    private buildCounterTooltip;
    /**
     * Derive `treeNodes` + `filteredOptions` from the full tree, applying the
     * current search term. Matching nodes keep all their ancestors visible so
     * indentation stays coherent (the tree is always fully expanded).
     */
    private rebuildTreeVisible;
    /**
     * Reset the visible list to "everything". **Tree-aware**: in tree mode it
     * rebuilds `treeNodes` (kept index-aligned with `filteredOptions`) from the
     * full tree, so the two never drift. A raw `filteredOptions = [...allOptions]`
     * would leave `treeNodes` stale after clearing a search — the virtual list
     * then reserves height for every option but renders blank rows because
     * `treeNodes[index]` is undefined. Always use this to clear the visible list.
     */
    private resetVisibleToAll;
    /**
     * Tree mode: derive the visible list from an **external** set of matched
     * options — e.g. the results returned by `searchCallback` — keeping each
     * match's ancestors so indentation stays coherent. This is the async-search
     * analogue of `rebuildTreeVisible`: the matching is done by the caller (their
     * own index/engine) instead of a local substring test, but ancestor
     * preservation and `treeNodes`/`filteredOptions` index-alignment still happen
     * here. Pass all options to show the whole tree.
     */
    private rebuildTreeVisibleFromMatches;
    /**
     * Tree + `search-mode="navigate"`: keep the ENTIRE tree visible (the tree is always
     * fully expanded, so `flatNodes` is the whole thing) and record which visible rows
     * match the term in `matchingIndices` — the flat-list navigate behavior, but over
     * `treeNodes`. Filter mode collapses the hierarchy to matches + ancestors; navigate
     * mode instead leaves the structure intact so the user can jump between matches
     * (Ctrl+Arrow on desktop, the fullscreen navigator on touch). Returns the index of
     * the first match, or -1 (no term / no matches), so the caller can set focus.
     */
    private rebuildTreeVisibleForNavigate;
    /**
     * (Re)compute `isRTL` from the host's `dir` (or an RTL ancestor) and derive the
     * direction-mirrored badges position. Pure state — callers apply the DOM effects
     * (class toggle, panel `dir`, badge re-render). In Shadow DOM the `dir` lives on
     * the host element, not the shadow content, so we resolve the host first.
     */
    private detectRTL;
    /**
     * Re-read `dir` and re-apply RTL mirroring live. The web-component calls this when
     * its `dir` attribute changes at runtime (e.g. an app-wide language/direction
     * switch). Most layout follows the inherited CSS `direction` automatically (the
     * component is authored with logical properties); this fixes the parts pinned at
     * build time — the `.ms--rtl` class (badges/count-display placement) and the
     * explicit `dir` on the shadow-root-appended panels (which don't sit under the
     * `.ms--rtl` element, so they'd otherwise keep a stale build-time direction).
     */
    refreshDirection(): void;
    private buildHTML;
    /**
     * Check if virtual scroll should be used
     */
    private shouldUseVirtualScroll;
    /**
     * Check if any options have groups
     */
    private hasGroups;
    /**
     * Whether the flat-group cascade checkbox is active: a multi-select, grouped,
     * non-tree list with `group-select-mode="cascade"`. When on, each group header
     * gets a tristate checkbox that toggles all of that group's visible members.
     * Tree mode has its own `checkbox-mode` cascade, so this stays flat-only.
     */
    private isGroupCascadeActive;
    /**
     * Tristate check-state of a group from its members: `checked` if every
     * non-disabled member is selected, `unchecked` if none are, else
     * `indeterminate`. Disabled members are excluded from the denominator so a
     * group with a stuck-disabled member can still read fully checked. An empty
     * (or all-disabled) group reads `unchecked`.
     */
    private groupCheckState;
    /**
     * Selection roll-up for a flat group's (visible) members: which are selected, how many, and
     * the tristate check-state. `selectedCount` counts every selected member (including a
     * disabled-but-selected one) — it's the "N behind the group title". `checkState` excludes
     * disabled members from its denominator (mirrors the select-all), so a group with a stuck
     * disabled member can still read fully `checked`. Shared by the header count, the tristate
     * checkbox, and the `renderGroupLabelContentCallback` context.
     */
    private groupSelectionInfo;
    /**
     * Formats the small count chip shared by the in-input counter and the per-group header count.
     * Default `[selected]` (matches the historical in-input `[N]`); a `getCountLabelCallback` can
     * switch both to e.g. `selected/total`.
     */
    private formatCountLabel;
    /** Trailing count chip for a group header — any grouped list (rendered only when >0 selected). */
    private groupCountHtml;
    /**
     * Shared markup for a `.ms__checkbox` input — the single source of truth for option rows, tree
     * nodes, and group headers. Indeterminate is a pure CSS state (the box is `appearance: none`, so
     * no native `input.indeterminate` is needed — virtual-scroll-safe) plus `aria-checked="mixed"`.
     */
    private checkboxHtml;
    /** Group-header tristate checkbox (maps the group's roll-up state onto `checkboxHtml`). */
    private groupCheckboxHtml;
    private renderDropdown;
    /**
     * Round the OUTER corners of the row at the very top and the row at the very
     * bottom of the list so a focused/selected row's background — and crucially its
     * focus `outline`, which traces the row's OWN box and follows its border-radius
     * but NOT an ancestor's overflow clip — curves with the panel instead of poking a
     * square corner past it.
     *
     * Keyed off DOM order, not option index, so grouping works: when grouped the top
     * row is a `.ms__group-label` (not the first option, which sits below it), so we
     * round whichever element is physically first/last. VirtualScroll renders rows in
     * index order into one innerHTML, so DOM order == visual order there too.
     *
     * Logical corners (`border-start-*` / `border-end-*`) so it mirrors in RTL. A
     * space-taking vertical scrollbar occupies the inline-END gutter, so the END-side
     * corners stay square then (the panel's rounded end corner is the scrollbar
     * track's). The radius is 0 in the fullscreen sheet (that scope zeroes the var).
     */
    private applyEdgeOptionRadii;
    /**
     * Render dropdown with virtual scrolling
     */
    private renderDropdownVirtual;
    /**
     * Render the Select All / Clear All / custom action buttons row.
     * Returns the empty string if multiple-select is off or no buttons are configured.
     */
    /**
     * Default enabled/disabled state for the built-in actions, applied only when the consumer hasn't
     * set an explicit `isDisabled` / `getIsDisabledCallback`:
     * - `select-all` is disabled when it would add nothing (every selectable, non-disabled filtered
     *   option is already selected — this also covers an empty list).
     * - `clear-all` is disabled when nothing is selected.
     */
    private getBuiltInActionDisabled;
    private renderActionsHTML;
    private renderOption;
    /**
     * Trailing info affordance for an option row, emitted only for the fullscreen
     * overlay. CSS keeps it hidden until `markTruncatedOptions()` tags the row
     * `.ms__option--truncated`, so it appears only when the label is actually clipped.
     * Tapping it reveals the full label — the touch substitute for the hover option
     * tooltip, which never fires on touch (the very devices that get fullscreen).
     * `tabindex="-1"` keeps it out of the tab order; the search input owns keyboarding.
     */
    private renderOptionInfoButton;
    /**
     * Render a single tree-mode row. Separate from `renderOption`: a tree row is
     * indented by its depth (via the `--ms-tree-depth` custom property) and
     * tagged branch/leaf, but otherwise carries the same selection/checkbox/
     * icon/subtitle content. The tree is always fully expanded, so there is no
     * chevron/toggle — every node is just a normal, selectable option.
     */
    private renderTreeNode;
    /**
     * Empty-dropdown content. When "add new" is enabled (isAddNewAllowed) AND the user has typed
     * a non-empty search term, show a clickable "add new" prompt instead of the plain emptyMessage —
     * choosing it (click via handleDropdownClick, or Enter via the keydown handler) runs handleAddNew.
     * Otherwise fall back to the emptyMessage.
     */
    private renderEmptyStateHTML;
    /** True when the empty dropdown is currently showing the clickable "add new" prompt. */
    private isAddNewPromptShown;
    /**
     * Resolve the "add new" prompt label for the typed text. Priority: getAddNewTextCallback
     * (returns plain text — fully escaped here) → addNewText template (trusted config string;
     * only the `{value}` substitution is escaped) → the default `Add "{value}"`.
     */
    private getAddNewText;
    /** Pending-prompt label shown (with a spinner) while an async addNewCallback runs. */
    private getAddNewPendingText;
    /** Minimal HTML entity escape for untrusted text spliced into an innerHTML string. */
    private escapeHtml;
    private highlightMatch;
    private groupOptions;
    /** Whether the input currently functions as a usable search field (drives placeholder wording). */
    private get isSearchUsable();
    /**
     * Resolve the closed-state input placeholder for the current data/search state.
     * Priority: explicit no-data placeholder (when the list is empty) → "pick" prompt when
     * search is unusable → the search placeholder.
     */
    private getPlaceholderText;
    /**
     * The search field placeholder. An explicit `searchPlaceholder` always wins and stays
     * fixed. Otherwise the default is "Search..." — except when the in-overlay mode toggle
     * is enabled (`isSearchModeToggleShown`), where it becomes mode-aware so the field labels
     * the current behavior: "Search…" in navigate mode, "Filter…" in filter mode. Refreshed
     * on a live mode switch (see setSearchModeLive → refreshSearchPlaceholder).
     */
    private getSearchPlaceholder;
    /** Re-apply the (possibly mode-aware) placeholder to the live inputs after a mode switch. */
    private refreshSearchPlaceholder;
    private renderBadges;
    private attachEvents;
    private handleSearch;
    /** Abort the search request currently in flight, if any. The aborted request's results
     *  are then ignored (and the consumer's `searchCallback` can short-circuit its fetch via
     *  the `AbortSignal` it was handed). */
    private abortInFlightSearch;
    /**
     * Invoke the async `searchCallback` and apply its results. Split out of `handleSearch`
     * so it can be called immediately or after the debounce timer.
     *
     * Any request still in flight is aborted before a new one starts, so a slow earlier
     * request can't overwrite a newer one — and consumers that wire the passed `AbortSignal`
     * into their fetch get the request actually cancelled, not just ignored. The
     * `aborted` / `searchTerm === value` guards drop superseded or out-of-order responses.
     */
    private performAsyncSearch;
    private handleKeydown;
    private handleDropdownClick;
    private handleBadgeClick;
    private handleClickOutside;
    /**
     * Move focus by computing a new index from (current, total).
     * Returning -1 from `compute` is a no-op (used for empty list / no match).
     */
    private focusBy;
    /**
     * Given a target index and a preferred direction, return the nearest index
     * whose node is selectable (skipping non-selectable tree nodes). Falls back to
     * the opposite direction, then to -1 if nothing is selectable. No-op outside
     * tree mode.
     */
    private resolveSelectableIndex;
    private focusNext;
    private focusPrevious;
    private focusFirst;
    private focusLast;
    private focusPageUp;
    private focusPageDown;
    /** Move keyboard focus onto the empty-state "add new" prompt (the only actionable row). */
    private focusAddNewPrompt;
    private focusNextMatch;
    private focusPreviousMatch;
    /** Lazily build (and cache) the imperative facade passed to `keydownCallback`. Bound to the
     *  same private actions the built-in key handling uses, so consumer shortcuts behave identically. */
    private getKeyboardController;
    /** Clear the search box (both the main input and the fullscreen search) and reset the visible
     *  list. Shared by Escape and the keyboard controller. */
    /**
     * Clear the search box and restore the full option list (resets the visible/matched sets and
     * drops keyboard focus). Public building block: pair it with `scrollToValue()` to reveal then
     * scroll to an option the current search had filtered out — `el.clearSearch(); el.scrollToValue(v)`.
     * Does not touch the selection (use `clearAll()` for that).
     */
    clearSearch(): void;
    /**
     * Programmatically set the search text and filter — exactly as if the user typed it, so
     * `beforeSearchCallback`, `minSearchLength` and async `searchCallback` all apply the same way.
     * Reflects into the search box (and the fullscreen sheet's field). Does NOT open the dropdown —
     * call `open()` if you want it visible. Passing `''` clears (equivalent to `clearSearch()`).
     */
    search(term: string): void;
    private scrollToFocused;
    /**
     * scrollIntoView with the fullscreen-safe default. In the fullscreen sheet the soft keyboard
     * covers the lower viewport, so `block:'nearest'` can bottom-align a match BEHIND the keyboard;
     * centre it instead and scroll INSTANTLY (a smooth animation kicked off per-keystroke is torn
     * down by the next re-render and never settles — the "list jumps every letter" bug). Floating
     * scrolls the nearest edge smoothly. The caller may override `block`.
     */
    private applyScrollIntoView;
    /**
     * Scroll the open dropdown so the option at `index` (into the current `filteredOptions`) is
     * visible. Works in floating, fullscreen (mobile), virtual-scroll and tree modes. Returns
     * false if the dropdown is closed or the index is out of range. The scroll is deferred a frame
     * when the list isn't rendered yet (e.g. right after `open()` in virtual mode / the fullscreen
     * sheet build), so `el.open(); el.scrollToIndex(i)` works.
     */
    scrollToIndex(index: number, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /**
     * Scroll to the option whose value matches `value` (resolved within the current
     * `filteredOptions`). Returns false if it isn't in the currently visible list — e.g. filtered
     * out by a search, or (tree) under a collapsed ancestor. Call `clearSearch()` (or expand the
     * branch) first to reveal it, then scroll.
     */
    scrollToValue(value: string | number, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /**
     * Scroll to a group. In standard rendering the group's header (`.ms__group-label`) is brought
     * into view; in virtual-scroll mode (which renders no headers) it scrolls to the group's FIRST
     * option instead. Returns false in tree mode (groups don't apply) or if the group has no
     * options in the current filtered list.
     */
    scrollToGroup(name: string, opts?: {
        block?: ScrollLogicalPosition;
    }): boolean;
    /**
     * Shared scroll worker for the public scrollTo* methods. Virtual mode uses the fixed-height
     * math (works even if the row isn't currently rendered); otherwise scrolls the
     * `.ms__option[data-index]` element into view. Defers one frame if the list isn't ready yet
     * (post-open virtual init / fullscreen sheet build), then retries once.
     */
    private scrollToRenderedIndex;
    private toggleOption;
    /**
     * The single funnel for an interactive (user-initiated) selection. Consults
     * `beforeSelectCallback` and only mutates state if allowed, so the veto can
     * never be bypassed by a new UI entry point. Programmatic `setSelected` and
     * the Select-All button deliberately do not route through here.
     * Returns true if the option was selected, false if the veto blocked it.
     */
    private interactiveSelect;
    /**
     * The single funnel for an interactive (user-initiated) deselection. Every
     * removal affordance — dropdown toggle, badge × button, selected-items
     * popover × button, and the "remove hidden" badge — routes through here so
     * the `beforeDeselectCallback` veto applies uniformly. Programmatic
     * `setSelected` and the Clear-All button deliberately bypass it.
     * Returns true if the option was deselected, false if the veto blocked it.
     */
    private interactiveDeselect;
    /**
     * Commit the "add new" affordance for the typed text. Two modes:
     *  - `addNewCallback` set → create the option, append it, select it, clear the search.
     *  - no callback → the consumer owns creation; we only notify (via the `add` event) so they
     *    can open a modal / POST / add the option imperatively.
     * The `add` event fires in BOTH modes (with `option` present only when one was created).
     */
    private handleAddNew;
    private selectOption;
    private deselectOption;
    private selectAll;
    clearAll(): void;
    /**
     * Flat-group cascade toggle: check or uncheck every (visible) member of a group
     * in one shot. If the group is fully checked → deselect all its members; else →
     * select all its non-disabled members. Operates on the currently-filtered
     * members (same scope as Select-All) and, like Select-All / Clear-All,
     * batch-mutates then fires a single `commit` — so one render and one `change`
     * event, and it deliberately bypasses the per-item beforeSelect/beforeDeselect
     * veto. The group name itself is never added to the selection.
     */
    private toggleGroup;
    /**
     * Inline clear (✕) handler: wipe the whole selection and any search text, then
     * restore focus to the input. clearAll() → commit() → renderBadges() already
     * refreshes this button's visibility (it hides once nothing is selected).
     */
    private clearClick;
    /**
     * Show the inline clear (✕) only when it is opted in (isClearShown), something is
     * selected, and the control is enabled. Called from renderBadges() so it tracks
     * every selection change. Uses inline display like the counter / fullscreen clear.
     */
    private updateClearButton;
    /**
     * Re-render and fire callbacks after a selection state change.
     * `added` / `removed` drive per-item select/deselect callbacks.
     * `onChange` fires once if anything actually changed.
     */
    private commit;
    /**
     * Shield the trailing document `click` for one tick. A consumer that drives the
     * dropdown from their OWN button's click handler (`el.open()` / `el.toggle()`, or a
     * scrollTo* command re-driving the already-open panel) would otherwise have that
     * same click bubble to our document-level outside-click listener and immediately
     * close it. Centralizing it here means every entry point — open(), the internal
     * pointer path, and the public scrollTo* API — is covered. Cleared next tick, so a
     * genuine later outside-click still closes as normal. Harmless for non-click
     * callers (typing, programmatic-on-load, server-driven): no trailing click arrives
     * before it clears.
     */
    private armClickGuard;
    /** Open the dropdown (no-op if already open, or if there is nothing to show). */
    open(): void;
    /** Close the dropdown (no-op if already closed). */
    close(): void;
    /** Toggle the dropdown open/closed. */
    toggle(): void;
    /** Whether the dropdown is currently open. Assigning opens/closes it. */
    get isOpen(): boolean;
    set isOpen(value: boolean);
    /**
     * Anchor a floating panel (dropdown or selected-items popover) below/above the input with
     * placement-locking and width-syncing. Returns the `autoUpdate` cleanup.
     *
     * Both panels share: anchor on input, sync width, default to 'bottom-start', flip on first
     * compute then lock the resulting placement, optionally clamp by dropdownMin/MaxWidth.
     */
    private anchorFloatingPanel;
    /**
     * Surface a multiselect-branded, once-per-instance warning when core's drift check
     * (`anchor`'s `onDrift`) reports the panel didn't land where it was positioned. The
     * consumer has an ancestor that establishes a fixed containing block but isn't on the
     * reliable-anchors list (likely `contain: paint|layout|strict` or `container-type`).
     * We can't fix it from inside the library, but we point at the likely culprit. Core
     * owns the measurement + culprit-finding + CB-CSS diagnostic (`detectFixedDrift`).
     */
    private warnDrift;
    /**
     * Fullscreen counterpart of {@link warnDrift}. The overlay is a `position: fixed`,
     * full-viewport sheet — but if an ancestor of the host establishes a fixed-positioning
     * containing block (`transform` / `perspective` / `filter` / `backdrop-filter` / a
     * qualifying `will-change`), the browser anchors the sheet to THAT ancestor's box instead
     * of the viewport, so it no longer covers the screen (offset, clipped, or mis-sized).
     *
     * Unlike the floating path — where core measures real drift after positioning — nothing
     * anchors the sheet, so there's no drift to observe. Instead we ask core's shared
     * heuristic (`getFixedPositionOffsetParent`, the same one that feeds the floating platform)
     * whether the sheet's true offset parent is the viewport (`window`) or an element. An
     * element means it WILL be mis-anchored; warn once, pointing at the culprit. We only check
     * the reliably-honoured properties core lists (transform family) — `contain` /
     * `container-type` are omitted because browsers don't honour them for fixed positioning,
     * so they don't actually break the sheet.
     */
    private warnFullscreenContainingBlock;
    /**
     * Re-anchor an already-open floating dropdown from scratch so a frozen placement
     * is re-evaluated against the panel's CURRENT height.
     *
     * Why it's needed: an async `searchCallback` opens the panel while it's still
     * empty / showing the loader — short, so it fits below the input and (with the
     * default `lock-placement`) freezes to `bottom`. When results arrive the panel
     * grows to full height, but the frozen placement pins it below the input, so it
     * overflows the viewport bottom instead of flipping above into the free space.
     * `renderDropdown()` only rewrites the inner HTML; it never re-anchors. Tearing
     * down and recreating the anchor re-runs core's flip-on-first-compute against the
     * new height (picking the side that fits), then re-freezes — so `lock-placement`
     * still holds for the common case (panels that open already-populated, e.g. local
     * filtering, never hit this path). No-op unless a floating dropdown is open.
     */
    private repositionDropdown;
    private positionDropdown;
    /**
     * Switch how the open panels are presented. 'floating' anchors them to the input
     * (the default); 'fullscreen' renders them as full-viewport overlays (the phone
     * pattern) — the dropdown with its own search header + close, the selected-items
     * popover with its existing header + close. Driven by the element's
     * `environmentChanged` hook (auto → fullscreen on phones). A no-op when unchanged;
     * when a panel is already open it re-applies live so an orientation flip / viewport
     * resize can swap presentation without a reopen.
     */
    setPresentation(mode: 'floating' | 'fullscreen'): void;
    /**
     * Lock page scroll behind a fullscreen overlay via the core ref-counted helper.
     * Idempotent per instance: the dropdown and the selected-items popover are mutually
     * exclusive (opening one closes the other), so we hold at most one lock at a time,
     * and a redundant call is a no-op rather than acquiring a second.
     */
    private lockBodyScroll;
    /** Restore page scroll (no-op if it wasn't locked). */
    private unlockBodyScroll;
    /**
     * Clip the host document's horizontal overflow while a fullscreen sheet is open.
     *
     * A page that overflows horizontally (e.g. an unbreakable-wide token in a heading)
     * makes the mobile browser SHRINK-TO-FIT: it zooms the page out so the overflow fits,
     * which desyncs the visual viewport from the layout viewport. Our fullscreen sheet is
     * `position: fixed` — anchored to the LAYOUT viewport — so under that zoom it no longer
     * lands flush against the physical screen edges, and the top slips under the system bar
     * (looks like "the bar covers the sheet"). This is NOT a safe-area problem; safe-area
     * insets are 0 in that state. Clamping `overflow-x: hidden` on <html>/<body> removes the
     * overflow, so the browser drops the zoom and the sheet sits flush. Complements
     * lockBodyScroll() (vertical axis); the saved inline value is restored on close.
     *
     * Only <html> is touched (not <body>): clipping the root's horizontal overflow is
     * enough to collapse the scrollWidth and cancel the shrink-to-fit, and it avoids
     * conflicting with core's lockBodyScroll(), which owns <body>'s `overflow`. Idempotent.
     */
    private clampDocumentOverflowX;
    /** Restore the <html> `overflow-x` clamped by clampDocumentOverflowX() (no-op if unset). */
    private releaseDocumentOverflowX;
    /**
     * While the fullscreen dropdown is open, keep it sitting above the soft keyboard.
     * Delegates to core's `observeKeyboardInset` (which tracks `window.visualViewport`
     * and pins the panel's height/top so its flex column reflows above the keyboard);
     * we just hold the returned cleanup. No-op where `visualViewport` is unavailable.
     */
    private observeKeyboardInset;
    /** Detach keyboard-inset tracking and restore the panel's CSS-driven geometry. */
    private unobserveKeyboardInset;
    /**
     * The fullscreen size multiplier = `--ms-fullscreen-rem ÷ --ms-rem` (both read off
     * the host). CSS scales itself — every size is `calc(N × --ms-rem)` and the panel
     * overrides `--ms-rem` — so this exists only for the JS-driven pixel heights that
     * CSS can't reach: the virtual/fixed option rows and the popover's virtual badges.
     * Returns 1 when floating (or when computed styles aren't readable, e.g. jsdom).
     */
    private fullscreenScale;
    /** Virtual/fixed row height (px), scaled up in the fullscreen phone view. */
    private scaledOptionHeight;
    /**
     * Size the virtual options scroll container for the current presentation. Applied on
     * every render (the container itself is built once), so a floating⇄fullscreen switch
     * re-sizes it: floating = a fixed maxHeight scroll box; fullscreen = flex-fill the
     * panel's flex column (no fixed height). Also refreshes --ms-option-height to the
     * scaled row height so the CSS row height matches the virtual scroller's itemHeight.
     */
    private applyVirtualOptionsSizing;
    /**
     * Virtual popover badge row height (px). In the fullscreen phone view the rows are
     * scaled up AND given extra height so a selected item is a comfortable, dropdown-like
     * touch target (the default 36px pill is short for touch). Mirrors the CSS
     * `--ms-badge-height` override for the fullscreen popover (floating.css) so the
     * virtual list's fixed height agrees with the non-virtual pills.
     */
    private scaledBadgeHeight;
    /**
     * Clear the inline geometry that floating-ui's `anchor` writes on a panel
     * (position/left/top plus our composed max-width/min-width). Inline styles beat
     * the stylesheet, so a panel left over from a floating cycle would otherwise pin
     * itself where it last anchored and ignore the fullscreen CSS (position: fixed;
     * inset: 0; width: 100vw). Must run when switching a panel floating → fullscreen.
     */
    private clearFloatingInlineGeometry;
    /** Stand up the fullscreen dropdown overlay: modifier class, header, scroll lock, focus. */
    private enterFullscreen;
    /** Tear down the fullscreen dropdown chrome and restore page scroll (no-op if floating). */
    private exitFullscreen;
    /**
     * Back-gesture handling for the fullscreen sheet. On open we push a history entry
     * (same URL) and listen for `popstate`; the phone Back gesture/button then pops that
     * entry — which we treat as "close the sheet" — instead of navigating away from the
     * page. A programmatic close (✕, selection, Escape) consumes the entry via
     * `history.back()` so the stack is left as it was found.
     */
    private pushOverlayHistory;
    /** Back gesture/button fired: our pushed entry is already gone, so just close the
     *  sheet — WITHOUT popping history again (popOverlayHistory becomes a no-op). */
    private handleOverlayPopstate;
    /** Programmatic close: remove the listener and pop the entry we pushed (so the
     *  history stack returns to its pre-open state). No-op if a Back gesture already
     *  consumed it (overlayHistoryActive is false by then). */
    private popOverlayHistory;
    /**
     * Build the fullscreen overlay header: a search field (proxying to the same
     * `handleSearch`/`handleKeydown` path as the main input, since the overlay covers
     * it) plus a close button. Inserted before the scrolling list so it pins to the
     * top of the fixed panel. `renderDropdown()` only rewrites `dropdownInner`, so the
     * header survives re-renders.
     */
    private buildFullscreenHeader;
    /** Build the navigate-mode match navigator (count + prev/next) and append it to the
     *  fullscreen header, once. No-op if already built or the header isn't present. The
     *  nav wraps onto its own full-width row under the search box (header is flex-wrap;
     *  the nav takes 100% basis). */
    private ensureFullscreenNav;
    /** Remove the match navigator (switching to filter mode, which has no jump UI). */
    private removeFullscreenNav;
    /** Flip searchMode filter<->navigate from the in-overlay toggle. */
    private toggleSearchModeLive;
    /**
     * Switch searchMode in place — the overlay's toggle path. The `search-mode` attribute
     * is reinit-on-change (it rebuilds and closes the overlay); this instead mutates the
     * live config, adds/removes the match navigator to match, and re-projects the current
     * term under the new mode (filter narrows the list / navigate keeps all + highlights),
     * all without tearing the open sheet down. Focus stays on the search field.
     */
    private setSearchModeLive;
    /** Sync the mode toggle's icon (via data-mode) and labels with the current searchMode.
     *  No-op when the toggle isn't built (opt-out, floating panel, or search hidden). */
    private updateFullscreenModeToggle;
    /**
     * Sync the fullscreen match navigator (navigate mode only) with the current search
     * state: hide it until there's a term, then show "N of M" while a match is focused
     * (or "M matches" / "No matches"), and disable the prev/next buttons when there's
     * nothing to step through. No-op when the navigator isn't built (floating panel,
     * filter mode, or search disabled).
     */
    private updateFullscreenNav;
    /**
     * Show the fullscreen search's inline clear (✕) only while the field has text.
     * No-op when the button isn't built (floating panel, readonly/hidden search).
     */
    private updateFullscreenSearchClear;
    /**
     * Clear the fullscreen search term via the same path a keystroke takes, then
     * refocus the field so the user can keep typing. Touch has no keyboard Escape,
     * so this button is the on-screen way to reset a search.
     */
    private clearFullscreenSearch;
    private positionHint;
    private parseInitialSelection;
    /**
     * Resolve any `selectedValues` entries that don't yet have a matching
     * `selectedOptions` object by looking them up in the current `allOptions`.
     * Idempotent; safe to call after init *and* after `options` is replaced
     * (e.g., async fetch, `searchCallback` result, or late `element.options =`
     * assignment). Without this, `initial-values` declared before options
     * arrive ends up with phantom values that `getValue()` can never report.
     */
    private reconcileSelectedOptions;
    private toggleSelectedPopover;
    private showPopover;
    private hideSelectedPopover;
    private renderSelectedPopover;
    private renderSelectedPopoverVirtual;
    /**
     * Coerce a render-callback result to an HTML string. Callbacks may return a string
     * (HTML) or an HTMLElement (serialized via `outerHTML`); null/undefined → ''. Used by
     * every "return string | HTMLElement" content callback that builds into an innerHTML
     * string. (DOM sinks that hold a live node instead — the reveal/message panels — use
     * textContent/appendChild directly and intentionally don't go through here.)
     */
    private toHtml;
    /**
     * Normalize a class callback result (`string | string[] | null`) to a single
     * space-joined string with falsy entries dropped — e.g. `['a', '', 'b'] → "a b"`,
     * `null → ""`. Callers add their own leading space / base class as needed.
     */
    private classSuffix;
    /**
     * Render a removable badge for a selected option (used by the badges/partial display modes
     * and by the selected-items popover).
     *
     * - In the popover, `renderSelectedItemContentCallback` and `getSelectedItemClassCallback` win
     *   over the regular badge callbacks; that's how consumers customize popover items independently.
     * - The `data-value` and aria-label both go through `getItemBadgeDisplayValue` so badge text and
     *   accessible name stay in sync.
     */
    private renderBadgeHTML;
    private handleSelectedPopoverClick;
    private positionSelectedPopover;
    private updateHiddenInput;
    private getFormValue;
    getSelected(): T[];
    /**
     * Set the selection programmatically. **Silent by default** — it does not fire
     * `select`/`deselect`/`change` (so restoring saved state, cascade resets, or a
     * server-authoritative correction can't loop back or trip "user changed it"
     * handlers). Pass `{ notify: true }` to announce the result as a **single
     * aggregate `change`** — for a deliberate user gesture (e.g. an action button)
     * that should reach the same listeners a manual pick does, without the per-item
     * `select`/`deselect` flood a bulk change would otherwise cause.
     */
    setSelected(values: (string | number)[], opts?: {
        notify?: boolean;
    }): void;
    /**
     * Merge a partial config update into the live picker without tearing down the DOM.
     *
     * Handles the cheap structural toggles inline (no-checkboxes class, badges-position class,
     * input placeholder, search-input mode) and re-renders dropdown + badges + hidden inputs.
     *
     * Returns `true` if the change could be applied in place. Returns `false` for changes that
     * truly require rebuilding the DOM scaffolding (currently: adding/removing the `searchHint`
     * element, since it's only created in `buildHTML` if a hint string was provided). The caller
     * should fall back to destroy + re-init in that case.
     */
    updateOptions(partial: Partial<MultiSelectConfig<T>>): boolean;
    get selectedItem(): T | null;
    /** The current search box text (empty string when nothing is typed). Read-only; clear it with `clearSearch()`. */
    get searchText(): string;
    get selectedValue(): string | number | (string | number)[] | null;
    getValue(): string | number | (string | number)[] | null;
    /**
     * Create or replace a tracked tooltip with the given id. Replacing destroys the old one,
     * which is the normal flow when re-rendering badges/actions.
     */
    private spawnTooltip;
    private destroyAllTooltips;
    /** Build the badge-text tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
    private buildBadgeTooltipContent;
    /** Build the remove-button tooltip text (callback > format string with {0} > "Remove {name}"). */
    private buildRemoveButtonTooltipText;
    private attachBadgeTooltips;
    /** Build the option tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
    private buildOptionTooltipContent;
    /**
     * Attach hover tooltips to the currently rendered dropdown options. Prunes existing option
     * tooltips first, so it's safe to call on every render and on every virtual-scroll range change
     * (where option DOM is recycled). Each option resolves its source object via `data-index` into
     * `filteredOptions`, the same global index `renderOption` was given.
     */
    private attachOptionTooltips;
    /**
     * Tag each currently-rendered fullscreen option row whose title is horizontally
     * clipped with `.ms__option--truncated`, so CSS reveals its info affordance.
     * Runs per virtual-scroll render (rows recycle) and on the non-virtual render.
     * Horizontal (ellipsis) overflow only — the truncation mode this pairs with;
     * a wrapping title isn't "cut", it grows vertically. No-op unless fullscreen.
     */
    private markTruncatedOptions;
    /**
     * Reveal (or dismiss) the full label of a clipped fullscreen row when its info
     * affordance is tapped — hover tooltips don't fire on touch, and a hover tooltip's
     * synthetic mouseleave (from the tap itself, under devtools touch emulation) would
     * flash it away. So this is a manually-controlled `createPopover` panel, mounted in
     * the shadow root for component styling, that stays until explicitly dismissed:
     * a second tap on the same button, a list scroll, a re-render, an outside tap, or
     * closing the panel (see hideLabelReveal + its call sites). Tapping the same button
     * while it's shown toggles it off.
     */
    private toggleLabelReveal;
    /** Dismiss the full-label reveal popover, if shown. Idempotent. */
    private hideLabelReveal;
    /**
     * Show a transient message ("toast") on top of the component. Its reason for existing:
     * in the fullscreen overlay the sheet covers the whole page, so a consumer can't surface
     * feedback (a blocked veto, a hint) where the user can see it. This renders above the
     * panel in BOTH presentations — anchored under the control when floating, pinned to the
     * bottom of the viewport (over the overlay) when fullscreen.
     *
     * Content is a string (plain text) or an HTMLElement (rich markup). `opts.variant`
     * (info | warning | error | success) picks the tone; `opts.duration` sets auto-dismiss
     * (0 = sticky). Tapping the message dismisses it. Only one shows at a time — a new call
     * replaces the previous. Also reached automatically when a veto callback returns a string.
     */
    showMessage(content: string | HTMLElement, opts?: MessageOptions): void;
    /** Dismiss the transient message, if shown. Idempotent. */
    hideMessage(): void;
    /**
     * Hide (don't destroy) every currently-shown option tooltip immediately,
     * ignoring the hide delay. Wired to dropdown scroll so a tooltip can't trail
     * its recycling/scrolling anchor row. Handles stay in the map; a fresh hover
     * re-shows them.
     */
    private hideOptionTooltips;
    /**
     * Destroy only the option tooltips (prefixed `option-`). Called before re-rendering or
     * recycling the options list so per-option tooltip state doesn't leak.
     */
    private destroyAllOptionTooltips;
    private attachActionButtonTooltips;
    /**
     * Destroy only the action-button tooltips. Called from `renderDropdown`/`renderDropdownVirtual`
     * before rebuilding the actions row, so per-button tooltip state doesn't leak.
     */
    private destroyAllActionButtonTooltips;
    /**
     * Destroy main-badges-container tooltips. Called before re-rendering the badges container.
     * Popover tooltips (prefixed `popover-`) survive — they're owned by the popover lifecycle and
     * cleaned up in `hideSelectedPopover`. Action-button tooltips (prefixed `action-`) survive too.
     */
    private destroyAllBadgeTooltips;
    destroy(): void;
}

export { }
