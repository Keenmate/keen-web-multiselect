defmodule TestAppWeb.Examples.TooltipsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # 1:1 mirror of upstream examples-tooltips.html. Declarative tooltip attributes
  # ride on the wrapper elements; the JS-only callbacks (getOptionTooltipCallback /
  # getBadgeTooltipCallback) and the option data are wired in the trailing inline
  # script after the custom element upgrades.

  @code_default ~S"""
  <web-multiselect enable-option-tooltips="true"></web-multiselect>
  """

  @code_custom ~S"""
  multiselect.getOptionTooltipCallback = (item) =>
    `${item.label} — ${item.description}`;
  """

  @code_virtual ~S"""
  // No extra config — virtual scrolling is automatic past ~100 items.
  multiselect.getOptionTooltipCallback = (item) => `Value: ${item.value}`;
  """

  @code_placement ~S"""
  <!-- anchored to the row start (default) -->
  <web-multiselect enable-option-tooltips="true"
                   option-tooltip-placement="top-start"></web-multiselect>

  <!-- or follow the pointer -->
  <web-multiselect enable-option-tooltips="true"
                   option-tooltip-follow-cursor="true"></web-multiselect>
  """

  @code_side ~S"""
  <web-multiselect enable-option-tooltips="true"
                   option-tooltip-placement="right">  <!-- or "left" -->
  </web-multiselect>
  """

  @code_styling ~S"""
  web-multiselect {
    --ms-option-tooltip-bg: #4338ca;
    --ms-option-tooltip-text-color: #fff;
    --ms-option-tooltip-border-radius: 2px;
    --ms-option-tooltip-max-width: 160px;
  }
  """

  @code_badge ~S"""
  <web-multiselect
    enable-badge-tooltips="true"
    remove-button-tooltip-text="Remove {0}">
  </web-multiselect>

  multiselect.getBadgeTooltipCallback = (item) =>
    `${item.label}: ${item.description}`;
  """

  @code_summary_option ~S"""
  enable-option-tooltips        // boolean, default false
  option-tooltip-placement      // 'top' | 'top-start' | ... | 'left' | 'right' (default 'top-start')
  option-tooltip-delay          // ms before show (falls back to badge-tooltip-delay, then 100)
  option-tooltip-offset         // px gap (falls back to badge-tooltip-offset, then 8)
  option-tooltip-follow-cursor  // boolean, default false — anchor to & track the pointer

  el.enableOptionTooltips
  el.optionTooltipPlacement
  el.optionTooltipFollowCursor
  el.getOptionTooltipCallback = (item) => string | HTMLElement

  // Independent styling (default to the shared --ms-tooltip-* surface):
  --ms-option-tooltip-bg | -text-color | -padding | -border-radius
  --ms-option-tooltip-font-size | -max-width | -shadow | -z-index
  """

  @code_summary_badge ~S"""
  enable-badge-tooltips      // attribute (boolean, default false)
  badge-tooltip-placement    // 'top' | 'bottom' | 'left' | 'right' (default 'top')
  badge-tooltip-delay        // ms before show (default 100)
  badge-tooltip-offset       // px gap (default 8)
  remove-button-tooltip-text // {0} = item name
  el.getBadgeTooltipCallback        = (item) => string | HTMLElement
  el.getRemoveButtonTooltipCallback = (item) => string
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Tooltips — keen_web_multiselect")
     |> assign(:code_default, @code_default)
     |> assign(:code_custom, @code_custom)
     |> assign(:code_virtual, @code_virtual)
     |> assign(:code_placement, @code_placement)
     |> assign(:code_side, @code_side)
     |> assign(:code_styling, @code_styling)
     |> assign(:code_badge, @code_badge)
     |> assign(:code_summary_option, @code_summary_option)
     |> assign(:code_summary_badge, @code_summary_badge)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="💬"
      title="Tooltips"
      subtitle="Hover tooltips on dropdown options and selected badges"
    >
      <.card title="1. Option Tooltips (default content)">
        <p class="description">
          Enable hover tooltips on the dropdown rows with <code>enable_option_tooltips</code>. With no
          callback, the tooltip shows the option's display value, plus its subtitle on a second line
          when present (here mapped from each option's <code>description</code>).
        </p>
        <.form_group>
          <label class="demo-label">Open the dropdown and hover a row:</label>
          <.web_multiselect
            id="option-default"
            multiple={true}
            enable_option_tooltips={true}
            subtitle_member="description"
          />
        </.form_group>
        <.code_block lang="html">{@code_default}</.code_block>
        <.note title="Try it:">
          Click to open the list, then hover over a row. The tooltip appears after the default 100&nbsp;ms delay.
        </.note>
      </.card>

      <.card title="2. Option Tooltips (custom getOptionTooltipCallback)">
        <p class="description">
          Build rich, per-option tooltip content with <code>getOptionTooltipCallback</code>. It receives
          the option object and returns a <code>string</code> or an <code>HTMLElement</code>. This is a
          JS-only callback, set on the element in the inline script.
        </p>
        <.form_group>
          <label class="demo-label">Hover a row to see its description:</label>
          <.web_multiselect id="option-custom" multiple={true} enable_option_tooltips={true} />
        </.form_group>
        <.code_block lang="js">{@code_custom}</.code_block>
      </.card>

      <.card title="3. Option Tooltips with Virtual Scrolling">
        <p class="description">
          Tooltips re-attach as rows recycle into view, so they work seamlessly with the
          virtual-scrolled list (this one holds 1,000 options).
        </p>
        <.form_group>
          <label class="demo-label">Scroll the list, then hover any row:</label>
          <.web_multiselect id="option-virtual" multiple={true} enable_option_tooltips={true} />
        </.form_group>
        <.code_block lang="js">{@code_virtual}</.code_block>
      </.card>

      <.card title="4. Full-Width Rows — Placement & Follow-Cursor">
        <p class="description">
          On a wide multiselect, a row-centered tooltip lands in the middle of the screen. Two fixes:
          option tooltips default to <code>option_tooltip_placement="top-start"</code> (anchored to the
          row's start edge), or set <code>option_tooltip_follow_cursor={true}</code> so the tooltip
          tracks the pointer.
        </p>
        <.form_group>
          <label class="demo-label">Full-width, default <code>top-start</code> anchoring:</label>
          <.web_multiselect
            id="wide-anchored"
            multiple={true}
            enable_option_tooltips={true}
            style="display:block; width:100%;"
          />
        </.form_group>
        <.form_group>
          <label class="demo-label">Full-width, <code>follow-cursor</code> — move the mouse along a row:</label>
          <.web_multiselect
            id="wide-follow"
            multiple={true}
            enable_option_tooltips={true}
            option_tooltip_follow_cursor={true}
            style="display:block; width:100%;"
          />
        </.form_group>
        <.code_block lang="html">{@code_placement}</.code_block>
      </.card>

      <.card title="5. Narrow Multiselect — Side (start/end) Placement">
        <p class="description">
          For a small/narrow multiselect, show the tooltip on the side of the row instead of above it.
          Use <code>option_tooltip_placement="right"</code> (end side) or <code>"left"</code> (start
          side). Floating UI auto-flips to the opposite side if there isn't room.
        </p>
        <.form_group>
          <label class="demo-label">Narrow control, tooltip on the <code>right</code> (end) side:</label>
          <.web_multiselect
            id="narrow-side"
            multiple={true}
            enable_option_tooltips={true}
            option_tooltip_placement="right"
            style="display:block; max-width:200px;"
          />
        </.form_group>
        <.code_block lang="html">{@code_side}</.code_block>
      </.card>

      <.card title="6. Independent Styling (--ms-option-tooltip-*)">
        <p class="description">
          Option tooltips render with class <code>.ms__option-tooltip</code> and read their own
          <code>--ms-option-tooltip-*</code> variables, which default to the shared
          <code>--ms-tooltip-*</code> surface. Override them to style option tooltips independently of
          badge tooltips.
        </p>
        <.form_group>
          <label class="demo-label">Custom-styled option tooltips (set on the element):</label>
          <.web_multiselect
            id="styled-option"
            multiple={true}
            enable_option_tooltips={true}
            style="display:block; max-width:320px; --ms-option-tooltip-bg:#4338ca; --ms-option-tooltip-text-color:#fff; --ms-option-tooltip-border-radius:2px; --ms-option-tooltip-max-width:160px;"
          />
        </.form_group>
        <.code_block lang="css">{@code_styling}</.code_block>
      </.card>

      <.card title="7. Badge Tooltips">
        <p class="description">
          The same tooltip engine drives the selected-badge tooltips. Enable with
          <code>enable_badge_tooltips</code>; customize content with <code>getBadgeTooltipCallback</code>
          and the remove-button text with <code>remove_button_tooltip_text</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select a few items, then hover a badge (or its × button):</label>
          <.web_multiselect
            id="badge-tt"
            multiple={true}
            enable_badge_tooltips={true}
            remove_button_tooltip_text={"Remove {0}"}
          />
        </.form_group>
        <.code_block lang="html">{@code_badge}</.code_block>
      </.card>

      <.card title="📋 Summary">
        <h3>Option tooltips</h3>
        <.code_block lang="js">{@code_summary_option}</.code_block>

        <h3>Badge tooltips</h3>
        <.code_block lang="js">{@code_summary_badge}</.code_block>

        <.note title="Shared styling:">
          Option and badge tooltips render with the same <code>--ms-tooltip-*</code> CSS variables and
          share the badge tooltip's placement / delay / offset settings.
        </.note>
      </.card>

      <script type="module">
        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        const fruitOptions = [
          { value: 'apple',      label: 'Apple',      description: 'A crisp red or green fruit' },
          { value: 'banana',     label: 'Banana',     description: 'A soft yellow tropical fruit' },
          { value: 'cherry',     label: 'Cherry',     description: 'A small, sweet red stone fruit' },
          { value: 'date',       label: 'Date',       description: 'A sweet, chewy dried fruit' },
          { value: 'elderberry', label: 'Elderberry', description: 'A tart dark-purple berry' },
          { value: 'fig',        label: 'Fig',        description: 'A soft fruit full of tiny seeds' },
          { value: 'grape',      label: 'Grape',      description: 'A juicy berry that grows in clusters' }
        ];

        // 1,000 items for the virtual-scrolling demo.
        const manyOptions = Array.from({ length: 1000 }, (_, i) => ({
          value: `opt-${i + 1}`,
          label: `Option ${i + 1}`,
          description: `Generated row number ${i + 1}`
        }));

        // 1 — default content (subtitle mapped from description via subtitle_member)
        wait('option-default').then((el) => { el.options = fruitOptions; });

        // 2 — custom callback
        wait('option-custom').then((el) => {
          el.options = fruitOptions;
          el.getOptionTooltipCallback = (item) => `${item.label} — ${item.description}`;
        });

        // 3 — virtual scrolling
        wait('option-virtual').then((el) => {
          el.options = manyOptions;
          el.getOptionTooltipCallback = (item) => `Value: ${item.value}`;
        });

        // 4 — full-width: anchored (default) + follow-cursor
        for (const id of ['wide-anchored', 'wide-follow']) {
          wait(id).then((el) => {
            el.options = fruitOptions;
            el.getOptionTooltipCallback = (item) => `${item.label} — ${item.description}`;
          });
        }

        // 5 — narrow: side placement
        wait('narrow-side').then((el) => {
          el.options = fruitOptions;
          el.getOptionTooltipCallback = (item) => item.description;
        });

        // 6 — independent styling
        wait('styled-option').then((el) => {
          el.options = fruitOptions;
          el.getOptionTooltipCallback = (item) => item.description;
        });

        // 7 — badge tooltips
        wait('badge-tt').then((el) => {
          el.options = fruitOptions;
          el.getBadgeTooltipCallback = (item) => `${item.label}: ${item.description}`;
        });
      </script>
    </.example_page>
    """
  end
end
