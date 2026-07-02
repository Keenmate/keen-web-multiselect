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
  """

  # -- Form integration ------------------------------------------------------

  attr :id, :string, default: nil, doc: "DOM id; required when used with a LV hook."
  attr :field, FormField, default: nil, doc: "A `Phoenix.HTML.FormField` to bind to."
  attr :name, :string, default: nil, doc: "Form field name (overridden by `:field` if set)."

  attr :value, :any,
    default: nil,
    doc: "Initial selected value(s). Strings, numbers, list, or nil."

  attr :options, :any,
    default: nil,
    doc: """
    Option list. Accepts:
      * a list of maps with `:value`/`:label` (and optional `:icon`, `:subtitle`, `:group`, `:disabled`)
      * a list of `{value, label}` tuples
      * a list of arbitrary maps when paired with `*_member` or `get_*_callback` props (JS side)
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

  attr :multiple, :boolean, default: nil
  attr :search_placeholder, :string, default: nil
  attr :search_hint, :string, default: nil
  attr :allow_groups, :boolean, default: nil
  attr :show_checkboxes, :boolean, default: nil

  attr :show_select_all, :boolean,
    default: nil,
    doc: """
    Shows upstream's built-in "Select All" action button above the option list
    (internal: `isSelectAllShown`). Pairs naturally with `show_checkboxes`. For
    finer control over the button row use the `action_buttons` API instead.
    """

  attr :checkbox_align, :string, default: nil, values: [nil, "top", "center", "bottom"]
  attr :close_on_select, :boolean, default: nil
  attr :dropdown_min_width, :string, default: nil
  attr :dropdown_max_width, :string, default: nil
  attr :max_height, :string, default: nil
  attr :empty_message, :string, default: nil
  attr :loading_message, :string, default: nil

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
    values: [nil, "badges", "count", "compact", "partial", "none"]

  attr :badges_threshold, :integer, default: nil
  attr :badges_threshold_mode, :string, default: nil, values: [nil, "count", "partial"]
  attr :badges_max_visible, :integer, default: nil

  attr :badges_position, :string,
    default: nil,
    values: [nil, "top", "bottom", "left", "right"]

  attr :show_counter, :boolean, default: nil
  attr :enable_badge_tooltips, :boolean, default: nil

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
    ]

  attr :badge_tooltip_delay, :integer, default: nil
  attr :badge_tooltip_offset, :integer, default: nil

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

  attr :enable_search, :boolean, default: nil
  attr :search_input_mode, :string, default: nil, values: [nil, "normal", "readonly", "hidden"]
  attr :search_mode, :string, default: nil, values: [nil, "filter", "navigate"]
  attr :min_search_length, :integer, default: nil
  attr :keep_options_on_search, :boolean, default: nil
  attr :should_keep_search_on_close, :boolean, default: nil
  attr :allow_add_new, :boolean, default: nil

  attr :search_debounce, :integer,
    default: nil,
    doc: """
    Debounce delay in milliseconds before the async `searchCallback` fires. A burst of
    keystrokes collapses into a single request instead of one per character. Applies to
    the async path only — local in-memory filtering stays instant. Defaults to `0`
    (no debounce) upstream.
    """

  # -- Actions / placement --------------------------------------------------

  attr :sticky_actions, :boolean, default: nil
  attr :actions_layout, :string, default: nil, values: [nil, "nowrap", "wrap"]

  attr :actions_position, :string,
    default: nil,
    values: [nil, "top", "bottom"],
    doc: ~s(Render the action-buttons block as a sticky header \(`"top"`, default\) or footer \(`"bottom"`\).)

  attr :actions_align, :string,
    default: nil,
    values: [nil, "stretch", "left", "right", "center", "space-between"],
    doc:
      ~s(Horizontal arrangement of buttons within a row. `"stretch"` \(default\) keeps full-width; the others size buttons to content and distribute them.)

  attr :lock_placement, :boolean, default: nil

  # -- Data extraction members ----------------------------------------------

  attr :value_member, :string, default: nil
  attr :display_value_member, :string, default: nil
  attr :search_value_member, :string, default: nil
  attr :icon_member, :string, default: nil
  attr :subtitle_member, :string, default: nil
  attr :group_member, :string, default: nil
  attr :disabled_member, :string, default: nil

  # -- Form value serialization ---------------------------------------------

  attr :value_format, :string, default: nil, values: [nil, "json", "csv", "array"]

  attr :initial_values, :any,
    default: nil,
    doc: "Pre-selected values. List/term; encoded as JSON for the underlying attribute."

  # -- Virtual scroll -------------------------------------------------------

  attr :enable_virtual_scroll, :boolean, default: nil
  attr :virtual_scroll_threshold, :integer, default: nil
  attr :option_height, :integer, default: nil

  attr :badge_height, :integer,
    default: nil,
    doc: "Pixel height per badge row in the popover virtual-scroll list. Defaults to `36` upstream."

  attr :virtual_scroll_buffer, :integer, default: nil

  # -- Passthrough ----------------------------------------------------------

  attr :placeholder, :string,
    default: nil,
    doc: "Placeholder shown when no item is selected (passthrough)."

  attr :class, :string, default: nil
  attr :style, :string, default: nil

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
