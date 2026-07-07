import { Placement } from '@floating-ui/dom';

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

declare const BaseElement: typeof HTMLElement;

export declare const dataLogger: any;

/**
 * Disable all logging (set to silent level)
 */
export declare function disableLogging(): void;

/**
 * Enable all logging (set to debug level)
 */
export declare function enableLogging(): void;

export declare interface GlobalMultiSelectAPI {
    version: () => string;
    config: {
        name: string;
        version: string;
        author: string;
        license: string;
        repository: string;
        homepage: string;
    };
    logging: {
        enableLogging: () => void;
        disableLogging: () => void;
        setLogLevel: (level: string) => void;
        setCategoryLevel: (category: string, level: string) => void;
        getCategories: () => string[];
    };
    register: () => void;
    getInstances: () => HTMLElement[];
}

export declare const initLogger: any;

export declare const interactionLogger: any;

/**
 * List of all logging categories for introspection
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
     * In `cascade` mode, which values a selection emits (badges / form / change):
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
    /** Format for value serialization (forms and callbacks) */
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
    /** Vertical alignment of checkboxes relative to option content */
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
    /** Display mode for selected items in badges area */
    badgesDisplayMode?: BadgesDisplayMode;
    /** Position of badges container */
    badgesPosition?: BadgesPosition;
    /** Threshold behavior mode: 'count' shows count badge, 'partial' shows limited badges + more badge */
    badgesThresholdMode?: BadgesThresholdMode;
    /** Maximum height for dropdown */
    maxHeight?: string;
    /** Message shown when no results found */
    emptyMessage?: string;
    /** Message shown while loading async data */
    loadingMessage?: string;
    /** Search input display mode */
    searchInputMode?: SearchInputMode;
    /** Search behavior mode: 'filter' (hide non-matches) or 'navigate' (jump to matches, keep all visible) */
    searchMode?: SearchMode;
    /** Layout mode for action buttons: 'nowrap' (default) or 'wrap' for multi-row */
    actionsLayout?: ActionsLayout;
    /** Where the action-buttons block sits in the dropdown: 'top' (default) or 'bottom' (sticky footer). */
    actionsPosition?: ActionsPosition;
    /** Horizontal arrangement of buttons within a row: 'stretch' (default, full-width), 'left', 'right', 'center', or 'space-between'. */
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
    /** Tooltip placement relative to badge */
    badgeTooltipPlacement?: Placement;
    /** Delay before showing tooltip in milliseconds */
    badgeTooltipDelay?: number;
    /** Offset distance for tooltip in pixels */
    badgeTooltipOffset?: number;
    /** Enable tooltips on dropdown options (internal: isOptionTooltipsEnabled) */
    isOptionTooltipsEnabled?: boolean;
    /** Callback to generate custom tooltip content for a dropdown option. Default: display value, plus subtitle on the next line when present. */
    getOptionTooltipCallback?: ((item: T) => string | HTMLElement) | null;
    /** Option tooltip placement. Default `'top-start'` (anchored to the row's start edge, so it doesn't center on a full-width row). Use `'left'`/`'right'` (start/end side) for a narrow multiselect. */
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

export declare class MultiSelectElement<T = any> extends BaseElement {
    static formAssociated: boolean;
    private picker?;
    private containerElement?;
    private shadow;
    private internals?;
    private _options?;
    private _hasDeclarativeOptions;
    private _valueMember?;
    private _getValueCallback?;
    private _displayValueMember?;
    private _getDisplayValueCallback?;
    private _getBadgeDisplayCallback?;
    private _getBadgeClassCallback?;
    private _customStylesCallback?;
    private _searchValueMember?;
    private _getSearchValueCallback?;
    private _iconMember?;
    private _getIconCallback?;
    private _subtitleMember?;
    private _getSubtitleCallback?;
    private _getFullTitleCallback?;
    private _groupMember?;
    private _getGroupCallback?;
    private _renderGroupLabelContentCallback?;
    private _disabledMember?;
    private _getDisabledCallback?;
    private _getPathCallback?;
    private _isTreeEnabled?;
    private _getIsSelectableCallback?;
    private _getValueFormatCallback?;
    private _getBadgeTooltipCallback?;
    private _getOptionTooltipCallback?;
    private _getRemoveButtonTooltipCallback?;
    private _renderOptionContentCallback?;
    private _renderBadgeContentCallback?;
    private _renderSelectedItemContentCallback?;
    private _getSelectedItemClassCallback?;
    private _renderSelectedContentCallback?;
    private _getCounterCallback?;
    private _actionButtons?;
    private _batchDepth;
    private _batchPartial;
    private _batchNeedsReinit;
    private _beforeSearchCallback?;
    private _beforeSelectCallback?;
    private _beforeDeselectCallback?;
    private _searchCallback?;
    private _addNewCallback?;
    private _onSelect?;
    private _onDeselect?;
    private _onChange?;
    static get observedAttributes(): string[];
    constructor();
    /**
     * Called by the browser when the surrounding <form> is reset. Clears the
     * picker's selection so the multiselect actually participates in the
     * standard reset lifecycle. (Before form-association, reset was a no-op
     * because the hidden inputs were re-stamped from internal state on every
     * render.)
     */
    formResetCallback(): void;
    connectedCallback(): void;
    disconnectedCallback(): void;
    attributeChangedCallback(name: string, oldValue: string | null, newValue: string | null): void;
    /**
     * Set several attributes in one in-place update — a single re-render instead of one per
     * attribute (and a single reinit at most if any change is structural). Keys are attribute
     * names in kebab-case, exactly as `setAttribute`. A value of `null`/`undefined`/`false`
     * removes the attribute; `true` sets it to an empty string; anything else is stringified.
     *
     * @example
     *   el.setAttributes({
     *     'search-placeholder': t('search'),
     *     'select-placeholder': t('pick'),
     *     'no-data-placeholder': t('noData'),
     *   });
     */
    setAttributes(attrs: Record<string, string | number | boolean | null | undefined>): void;
    private render;
    private renderDebugInfo;
    private updateDebugInfo;
    /**
     * Parse declarative <option> and <optgroup> elements from Light DOM
     * Returns array of options in the format expected by the picker
     */
    private parseDeclarativeOptions;
    private _declarativeSelectedValues?;
    /** Parse all observed attributes via ATTRIBUTE_TABLE into a partial config object. */
    private parseAttributesFromTable;
    private initializePicker;
    private reinitialize;
    /**
     * Apply a partial config update to the live picker. Falls back to a full reinit if the
     * picker can't apply the change in place (e.g. adding/removing the `searchHint` element).
     * No-op if the picker hasn't been initialized yet — the next `initializePicker` will pick
     * up the new programmatic state.
     */
    private updatePicker;
    /** Normalize the picker's getValue() return into the array form expected by event detail. */
    private collectSelectedValues;
    get options(): T[] | undefined;
    set options(value: T[] | undefined);
    set valueMember(value: string | null);
    get valueMember(): string | null;
    set displayValueMember(value: string | null);
    get displayValueMember(): string | null;
    set searchValueMember(value: string | null);
    get searchValueMember(): string | null;
    set iconMember(value: string | null);
    get iconMember(): string | null;
    set subtitleMember(value: string | null);
    get subtitleMember(): string | null;
    set fullTitleMember(value: string | null);
    get fullTitleMember(): string | null;
    set groupMember(value: string | null);
    get groupMember(): string | null;
    set disabledMember(value: string | null);
    get disabledMember(): string | null;
    set pathMember(value: string | null);
    get pathMember(): string | null;
    set parentPathMember(value: string | null);
    get parentPathMember(): string | null;
    set levelMember(value: string | null);
    get levelMember(): string | null;
    set hasChildrenMember(value: string | null);
    get hasChildrenMember(): string | null;
    set isSelectableMember(value: string | null);
    get isSelectableMember(): string | null;
    set treePathSeparator(value: string | null);
    get treePathSeparator(): string | null;
    set checkboxMode(value: 'independent' | 'cascade' | null);
    get checkboxMode(): 'independent' | 'cascade' | null;
    set cascadeSelectPolicy(value: 'rolled-up' | 'leaves' | 'all' | null);
    get cascadeSelectPolicy(): 'rolled-up' | 'leaves' | 'all' | null;
    set getValueCallback(callback: ((item: T) => string | number) | undefined);
    get getValueCallback(): ((item: T) => string | number) | undefined;
    set getDisplayValueCallback(callback: ((item: T) => string) | undefined);
    get getDisplayValueCallback(): ((item: T) => string) | undefined;
    set getBadgeDisplayCallback(callback: ((item: T) => string) | undefined);
    get getBadgeDisplayCallback(): ((item: T) => string) | undefined;
    set getBadgeClassCallback(callback: ((item: T) => string | string[]) | undefined);
    get getBadgeClassCallback(): ((item: T) => string | string[]) | undefined;
    set customStylesCallback(value: (() => string) | undefined);
    get customStylesCallback(): (() => string) | undefined;
    set getSearchValueCallback(callback: ((item: T) => string) | undefined);
    get getSearchValueCallback(): ((item: T) => string) | undefined;
    set getIconCallback(callback: ((item: T) => string) | undefined);
    get getIconCallback(): ((item: T) => string) | undefined;
    set getSubtitleCallback(callback: ((item: T) => string) | undefined);
    get getSubtitleCallback(): ((item: T) => string) | undefined;
    /** Callback returning an option's full title (used by badges when show-badge-full-title is on). */
    set getFullTitleCallback(callback: ((item: T) => string) | undefined);
    get getFullTitleCallback(): ((item: T) => string) | undefined;
    set getGroupCallback(callback: ((item: T) => string) | undefined);
    get getGroupCallback(): ((item: T) => string) | undefined;
    /** Callback returning an option's materialized dot-path (enables tree mode). */
    set getPathCallback(callback: ((item: T) => string) | undefined);
    get getPathCallback(): ((item: T) => string) | undefined;
    /** Force tree mode on/off. When unset, tree mode auto-enables if a path source is present. */
    set isTreeEnabled(value: boolean | undefined);
    get isTreeEnabled(): boolean | undefined;
    /**
     * Callback deciding whether a tree node is selectable (takes precedence over
     * `is-selectable-member`). Receives the built node — e.g.
     * `el.getIsSelectableCallback = (node) => !node.hasChildren` for leaves only.
     */
    set getIsSelectableCallback(callback: ((node: LTreeNode<T>) => boolean) | undefined);
    get getIsSelectableCallback(): ((node: LTreeNode<T>) => boolean) | undefined;
    set renderGroupLabelContentCallback(callback: ((groupName: string) => string | HTMLElement) | undefined);
    get renderGroupLabelContentCallback(): ((groupName: string) => string | HTMLElement) | undefined;
    set getDisabledCallback(callback: ((item: T) => boolean) | undefined);
    get getDisabledCallback(): ((item: T) => boolean) | undefined;
    set renderOptionContentCallback(callback: ((item: T, context: OptionContentRenderContext) => string | HTMLElement) | undefined);
    get renderOptionContentCallback(): ((item: T, context: OptionContentRenderContext) => string | HTMLElement) | undefined;
    set renderBadgeContentCallback(callback: ((item: T, context: BadgeContentRenderContext) => string | HTMLElement) | undefined);
    get renderBadgeContentCallback(): ((item: T, context: BadgeContentRenderContext) => string | HTMLElement) | undefined;
    set renderSelectedItemContentCallback(callback: ((item: T) => string | HTMLElement) | undefined);
    get renderSelectedItemContentCallback(): ((item: T) => string | HTMLElement) | undefined;
    set getSelectedItemClassCallback(callback: ((item: T) => string | string[]) | undefined);
    get getSelectedItemClassCallback(): ((item: T) => string | string[]) | undefined;
    set renderSelectedContentCallback(callback: ((item: T) => string) | undefined);
    get renderSelectedContentCallback(): ((item: T) => string) | undefined;
    set name(value: string | null);
    get name(): string | null;
    set valueFormat(value: 'json' | 'csv' | 'array' | null);
    get valueFormat(): string | null;
    set getValueFormatCallback(callback: ((values: (string | number)[]) => string) | undefined);
    get getValueFormatCallback(): ((values: (string | number)[]) => string) | undefined;
    set thresholdMode(value: 'count' | 'partial' | null);
    get thresholdMode(): string | null;
    set badgesMaxVisible(value: number | null);
    get badgesMaxVisible(): number | null;
    set checkboxAlign(value: 'top' | 'center' | 'bottom' | null);
    get checkboxAlign(): string | null;
    set enableBadgeTooltips(value: boolean);
    get enableBadgeTooltips(): boolean;
    set enableOptionTooltips(value: boolean);
    get enableOptionTooltips(): boolean;
    set getOptionTooltipCallback(callback: ((item: T) => string | HTMLElement) | undefined);
    get getOptionTooltipCallback(): ((item: T) => string | HTMLElement) | undefined;
    set optionTooltipPlacement(value: string | null);
    get optionTooltipPlacement(): string | null;
    set optionTooltipFollowCursor(value: boolean);
    get optionTooltipFollowCursor(): boolean;
    set actionsPosition(value: string | null);
    get actionsPosition(): string | null;
    set actionsAlign(value: string | null);
    get actionsAlign(): string | null;
    set badgeTooltipPlacement(value: string | null);
    get badgeTooltipPlacement(): string | null;
    set getBadgeTooltipCallback(callback: ((item: T) => string | HTMLElement) | undefined);
    get getBadgeTooltipCallback(): ((item: T) => string | HTMLElement) | undefined;
    set getRemoveButtonTooltipCallback(callback: ((item: T) => string) | undefined);
    get getRemoveButtonTooltipCallback(): ((item: T) => string) | undefined;
    set removeButtonTooltipText(value: string | null);
    get removeButtonTooltipText(): string | null;
    set getCounterCallback(callback: ((count: number, moreCount?: number) => string) | undefined);
    get getCounterCallback(): ((count: number, moreCount?: number) => string) | undefined;
    get beforeSearchCallback(): ((searchTerm: string) => string | null) | undefined;
    set beforeSearchCallback(callback: ((searchTerm: string) => string | null) | undefined);
    get beforeSelectCallback(): ((option: T, selectedOptions: T[]) => boolean | void) | undefined;
    set beforeSelectCallback(callback: ((option: T, selectedOptions: T[]) => boolean | void) | undefined);
    get beforeDeselectCallback(): ((option: T, selectedOptions: T[]) => boolean | void) | undefined;
    set beforeDeselectCallback(callback: ((option: T, selectedOptions: T[]) => boolean | void) | undefined);
    get searchCallback(): ((searchTerm: string, signal?: AbortSignal) => Promise<T[]>) | undefined;
    set searchCallback(callback: ((searchTerm: string, signal?: AbortSignal) => Promise<T[]>) | undefined);
    get addNewCallback(): ((value: string) => T | Promise<T>) | undefined;
    set addNewCallback(callback: ((value: string) => T | Promise<T>) | undefined);
    get onSelect(): ((option: T) => void) | undefined;
    set onSelect(callback: ((option: T) => void) | undefined);
    get onDeselect(): ((option: T) => void) | undefined;
    set onDeselect(callback: ((option: T) => void) | undefined);
    get onChange(): ((selectedOptions: T[]) => void) | undefined;
    set onChange(callback: ((selectedOptions: T[]) => void) | undefined);
    get actionButtons(): any[] | undefined;
    set actionButtons(value: any[] | undefined);
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
 * Set log level for a specific category. Accepts either the full prefixed name
 * (e.g. `MULTISELECT:UI`) or the bare suffix (`UI`) for convenience.
 * @param category Category logger name; bare names (UI/DATA/INIT/INTERACTION) are normalized to the prefixed form.
 * @param level Log level ('trace' | 'debug' | 'info' | 'warn' | 'error' | 'silent')
 */
export declare function setCategoryLevel(category: string, level: string): void;

/**
 * Set log level for all loggers
 * @param level Log level to set ('trace' | 'debug' | 'info' | 'warn' | 'error' | 'silent')
 */
export declare function setLogLevel(level: string): void;

export declare const uiLogger: any;

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
     * Sanity-check that the browser placed the panel where we told it to. With `position: fixed`
     * and no transformed/perspective/filter ancestor, `left: ${x}px` must render at viewport-x = x.
     * If the rendered position drifts, the consumer has an ancestor that establishes a fixed
     * containing block but isn't on our reliable-anchors list (likely `contain: paint|layout|strict`
     * or `container-type` — which the spec says creates a CB but the browser's actual behavior
     * varies across shadow-DOM scenarios). We can't fix it from inside the library, but we can
     * surface a clear warning so the developer knows where to look.
     *
     * Fires at most once per multiselect instance to avoid flooding the console during autoUpdate.
     */
    private verifyPanelLanded;
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
