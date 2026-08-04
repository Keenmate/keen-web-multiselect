import { BlissElement } from '@keenmate/web-components-core';
import { InputDef } from '@keenmate/web-components-core';
import { Logger } from '@keenmate/web-components-core';
import { LogLevelDesc } from '@keenmate/web-components-core';
import { Placement } from '@keenmate/web-components-core/positioning';

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
declare interface BadgeContentRenderContext {
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

export declare const dataLogger: Logger;

/** Disable all logging (silent). */
export declare function disableLogging(): void;

/** Enable all logging (debug level). */
export declare function enableLogging(): void;

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
     * Tree checkbox interaction. `independent` (default) toggles only the clicked
     * node. `cascade` checks a node's whole subtree and shows a tristate
     * (checked / indeterminate / unchecked) box on branches. Tree + multiple only.
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
    /** Callback to customize group label content (can return HTML) */
    renderGroupLabelContentCallback?: (groupName: string) => string | HTMLElement;
    /** Member property name for disabled state extraction */
    disabledMember?: string;
    /** Callback to extract disabled state from item */
    getDisabledCallback?: (item: T) => boolean;
    /** Custom renderer for dropdown option content - return HTML string or HTMLElement */
    renderOptionContentCallback?: (item: T, context: OptionContentRenderContext) => string | HTMLElement;
    /** Custom renderer for badge content (main badges area) - return HTML string or HTMLElement */
    renderBadgeContentCallback?: (item: T, context: BadgeContentRenderContext) => string | HTMLElement;
    /** Custom renderer for selected item content in popover - return HTML string or HTMLElement */
    renderSelectedItemContentCallback?: (item: T) => string | HTMLElement;
    /** Callback to add custom CSS classes to selected items in popover - return string or array of class names */
    getSelectedItemClassCallback?: (item: T) => string | string[];
    /** Custom renderer for selected item display in single-select mode - return plain text */
    renderSelectedContentCallback?: (item: T) => string;
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
    /** Lock dropdown placement after first open (internal: isPlacementLocked) */
    isPlacementLocked?: boolean;
    /** Allow adding new options not in the list (internal: isAddNewAllowed) */
    isAddNewAllowed?: boolean;
    /** Show count badge next to toggle icon (internal: isCounterShown) */
    isCounterShown?: boolean;
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
     * Return `false` to block the selection; return `true`/`undefined` to allow.
     * Silent — a blocked action fires no event. Bypassed by programmatic `setSelected`
     * and the Select-All action button.
     */
    beforeSelectCallback?: ((option: T, selectedOptions: T[]) => boolean | void) | null;
    /**
     * Interceptor: runs before an option is deselected via user interaction — the dropdown
     * option toggle, a badge's remove (×) button, the selected-items popover's remove button,
     * and the "remove hidden" badge (checked per item). Receives the option about to be
     * removed and the current selection (before the change). Return `false` to block the
     * deselection; return `true`/`undefined` to allow. Silent — a blocked action fires no
     * event. Bypassed by programmatic `setSelected` and the Clear-All action button.
     */
    beforeDeselectCallback?: ((option: T, selectedOptions: T[]) => boolean | void) | null;
    /**
     * Async function to load data: `(searchTerm, signal) => Promise<options[]>`.
     * The optional second argument is an `AbortSignal` that fires when a newer search
     * supersedes this one (or the component is destroyed). Wire it into your `fetch`
     * to cancel the in-flight request; ignoring it is fine — stale results are discarded.
     */
    searchCallback?: ((searchTerm: string, signal?: AbortSignal) => Promise<T[]>) | null;
    /** Callback to add a new option when isAddNewAllowed is true */
    addNewCallback?: ((value: string) => T | Promise<T>) | null;
    /** Event handler: an option was selected (fire-and-forget; return value ignored). Mirrors the bubbling `select` CustomEvent on the element. */
    onSelect?: ((option: T) => void) | null;
    /** Event handler: an option was deselected (fire-and-forget). Mirrors the bubbling `deselect` CustomEvent on the element. */
    onDeselect?: ((option: T) => void) | null;
    /** Event handler: the selection set changed (fire-and-forget). Mirrors the bubbling `change` CustomEvent on the element. */
    onChange?: ((selectedOptions: T[]) => void) | null;
    /** Callback to format count badge text (for i18n/pluralization). When moreCount is provided, it's for the "+X more" badge in partial mode. */
    getCounterCallback?: ((count: number, moreCount?: number) => string) | null;
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
    }];
    onSelect: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onDeselect: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    onChange: ((e: CustomEvent<MultiSelectEventDetail<T>>) => void) | null;
    constructor();
    /**
     * Called by the browser when the surrounding <form> is reset. Clears the
     * picker's selection so the control participates in the standard reset.
     */
    formResetCallback(): void;
    /** Structural change (or first connect): mirror CSS vars, then (re)build the picker. */
    protected reinit(): void;
    /** Cosmetic change: mirror CSS vars / custom styles / debug, patch the picker in place. */
    protected update(partial: Record<string, unknown>): void;
    /** Activate: ensure the picker exists (a DOM move destroyed it in disconnect()). */
    protected connect(): void;
    /** Deactivate: tear the picker down (rebuilt on the next connect). */
    protected disconnect(): void;
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
    destroy(): void;
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
    /** The option that triggered the event (for select/deselect) */
    option?: T;
}

declare type MultiSelectEvents = {
    select: MultiSelectEventDetail;
    deselect: MultiSelectEventDetail;
    change: MultiSelectEventDetail;
};

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

/**
 * Context provided to renderOptionContentCallback
 */
declare interface OptionContentRenderContext {
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
 * Set the level of one category. Accepts the full prefixed name
 * (`MULTISELECT:UI`) or the bare suffix (`UI`) — both normalize to the category
 * key the core bundle expects.
 */
export declare function setCategoryLevel(category: string, level: LogLevelDesc): void;

/** Set the same level on every category. */
export declare function setLogLevel(level: LogLevelDesc): void;

export declare const uiLogger: Logger;

/**
 * Value format for serialization (forms and callbacks)
 */
export declare type ValueFormat = 'json' | 'csv' | 'array';

export declare class WebMultiSelect<T = any> {
    private element;
    private instanceId;
    private options;
    private isOpen;
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
    private matchingIndices;
    private searchTerm;
    private isLoading;
    private searchDebounceTimer?;
    private searchAbortController?;
    private showSelectedPopover;
    private selectedPopoverPlacement;
    private dropdownPlacement;
    private isRTL;
    private effectiveBadgesPosition;
    private justClosedViaClick;
    private positioningDriftWarned;
    private dropdownCleanup;
    private hintCleanup;
    private selectedPopoverCleanup;
    private tooltips;
    private readonly onDropdownScroll;
    private virtualScroll;
    private optionsContainer;
    private selectedPopoverVirtualScroll;
    private selectedPopoverContainer;
    private input;
    private dropdown;
    private dropdownInner;
    private badgesContainer;
    private counter;
    private hint?;
    private selectedPopover;
    private documentKeydownHandler;
    private documentClickHandler;
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
     * `checkbox-mode="cascade"`. Checking a node then toggles its whole subtree
     * and branches show a tristate box.
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
    private buildHTML;
    /**
     * Check if virtual scroll should be used
     */
    private shouldUseVirtualScroll;
    /**
     * Check if any options have groups
     */
    private hasGroups;
    private renderDropdown;
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
     * Render a single tree-mode row. Separate from `renderOption`: a tree row is
     * indented by its depth (via the `--ms-tree-depth` custom property) and
     * tagged branch/leaf, but otherwise carries the same selection/checkbox/
     * icon/subtitle content. The tree is always fully expanded, so there is no
     * chevron/toggle — every node is just a normal, selectable option.
     */
    private renderTreeNode;
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
    private focusNextMatch;
    private focusPreviousMatch;
    private scrollToFocused;
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
    private handleAddNew;
    private selectOption;
    private deselectOption;
    private selectAll;
    clearAll(): void;
    /**
     * Re-render and fire callbacks after a selection state change.
     * `added` / `removed` drive per-item select/deselect callbacks.
     * `onChange` fires once if anything actually changed.
     */
    private commit;
    private open;
    private close;
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
    private positionDropdown;
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
