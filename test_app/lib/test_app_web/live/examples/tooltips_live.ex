defmodule TestAppWeb.Examples.TooltipsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Mirrors upstream @keenmate/web-multiselect examples-tooltips.html (TT01–TT04):
  # each behaviour is ONE live picker you configure with control switches. The
  # declarative tooltip attributes seed the initial state on the wrapper element;
  # the control switches and the JS-only callbacks (getOptionTooltipCallback /
  # getBadgeTooltipCallback) are wired in the trailing inline script after the
  # custom element upgrades. Controls are wired with document-delegated listeners
  # so they survive LiveView's DOM patch on connect.

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
     |> assign(:code_summary_option, @code_summary_option)
     |> assign(:code_summary_badge, @code_summary_badge)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="💬"
      title="Tooltips"
      subtitle="Hover tooltips on dropdown options and selected badges — each as ONE live picker you configure with control switches: enable, placement, follow-cursor, delay, custom content, independent styling, and badge tooltips."
    >
      <.card title="TT01 · Option Tooltips">
        <.tip><code>enable_option_tooltips</code> · <code>option_tooltip_placement</code> · <code>option_tooltip_follow_cursor</code></.tip>
        <p class="description">
          Enable hover tooltips on the dropdown rows with <code>enable-option-tooltips</code>. With no
          callback the tooltip shows the option's display value (plus its subtitle on a second line when
          present); turn on <strong>custom content</strong> to drive it from
          <code>getOptionTooltipCallback</code> instead. On a <strong>wide</strong> control a row-centered
          tooltip lands mid-screen, so option tooltips default to <code>top-start</code> (anchored to the
          row's start edge) — or set <code>follow-cursor</code> to track the pointer. On a
          <strong>narrow</strong> control, place the tooltip to the <code>right</code> / <code>left</code>
          side (Floating UI auto-flips if there's no room). Tooltips re-attach as rows recycle, so they work
          seamlessly with the virtual-scrolled list too.
        </p>

        <div class="controls">
          <label title="Turn hover tooltips on the dropdown rows on/off (the enable-option-tooltips attribute)."><input type="checkbox" id="opt-enable" checked /> <code>enable-option-tooltips</code></label>
          <label title="Anchor the tooltip to the mouse pointer and track it as it moves along the row, instead of anchoring to the row edge."><input type="checkbox" id="opt-follow" /> <code>option-tooltip-follow-cursor</code></label>
          <label title="Drive the tooltip content from getOptionTooltipCallback (here 'label — description') instead of the default display value + subtitle."><input type="checkbox" id="opt-custom" /> custom content (<code>getOptionTooltipCallback</code>)</label>
        </div>
        <div class="controls">
          <span><code>option-tooltip-placement</code>:</span>
          <label title="Anchored to the row's start edge (the default) — best for wide controls, so the tooltip doesn't land mid-screen."><input type="radio" name="opt-place" value="top-start" checked /> top-start</label>
          <label title="Centered above the row."><input type="radio" name="opt-place" value="top" /> top</label>
          <label title="Centered below the row."><input type="radio" name="opt-place" value="bottom" /> bottom</label>
          <label title="To the end (right) side of the row — good for narrow controls. Floating UI auto-flips if there's no room."><input type="radio" name="opt-place" value="right" /> right</label>
          <label title="To the start (left) side of the row — good for narrow controls. Floating UI auto-flips if there's no room."><input type="radio" name="opt-place" value="left" /> left</label>
        </div>
        <div class="controls">
          <label title="Milliseconds to hover before the tooltip appears (option-tooltip-delay). Default 100."><code>option-tooltip-delay</code> (ms):
            <input type="number" id="opt-delay" min="0" max="2000" step="50" value="100" style="width:4.5rem" />
          </label>
        </div>
        <div class="controls">
          <span title="Resize the demo control to see how placement behaves at different widths — not a component attribute, just the demo's own width.">control width:</span>
          <label title="The control's natural width."><input type="radio" name="opt-width" value="default" checked /> default</label>
          <label title="Stretch the control to 100% width — where a row-centered ('top') tooltip would land mid-screen, so 'top-start' or follow-cursor helps."><input type="radio" name="opt-width" value="full" /> full-width</label>
          <label title="Constrain the control to 200px — where side placement ('right'/'left') reads best."><input type="radio" name="opt-width" value="narrow" /> narrow (200px)</label>
          <label style="margin-inline-start:1rem" title="Swap in 1,000 options so the list virtualizes. Tooltips re-attach as rows recycle into view."><input type="checkbox" id="opt-large" /> large list (1,000 · virtual scroll)</label>
        </div>

        <.form_group>
          <label class="demo-label">Open the dropdown and hover a row:</label>
          <.web_multiselect
            id="tt-option"
            multiple={true}
            enable_option_tooltips={true}
            option_tooltip_placement="top-start"
          />
        </.form_group>
      </.card>

      <.card title="TT02 · Independent Styling (--ms-option-tooltip-*)">
        <.tip><code>{"style=\"--ms-option-tooltip-bg: #4338ca\""}</code> — style option tooltips independently of badge tooltips</.tip>
        <p class="description">
          Option tooltips render with class <code>.ms__option-tooltip</code> and read their own
          <code>--ms-option-tooltip-*</code> variables, which default to the shared
          <code>--ms-tooltip-*</code> surface. Override them (set on the element) to style option tooltips
          independently of badge tooltips — drag the controls and hover a row to see it live.
        </p>

        <div class="controls">
          <label title="Background color of the option tooltip (--ms-option-tooltip-bg). Defaults to the shared --ms-tooltip surface when unset."><code>--ms-option-tooltip-bg</code>:
            <input type="color" id="sty-bg" value="#4338ca" /></label>
          <label title="Text color of the option tooltip (--ms-option-tooltip-text-color)."><code>--ms-option-tooltip-text-color</code>:
            <input type="color" id="sty-fg" value="#ffffff" /></label>
        </div>
        <div class="controls">
          <label title="Corner rounding of the tooltip bubble in px (--ms-option-tooltip-border-radius)."><code>--ms-option-tooltip-border-radius</code> (px):
            <input type="number" id="sty-radius" min="0" max="24" step="1" value="2" style="width:4rem" /></label>
          <label title="Maximum width of the tooltip in px before its text wraps (--ms-option-tooltip-max-width)."><code>--ms-option-tooltip-max-width</code> (px):
            <input type="number" id="sty-maxw" min="80" max="480" step="10" value="160" style="width:4.5rem" /></label>
        </div>

        <.form_group>
          <label class="demo-label">Custom-styled option tooltips:</label>
          <.web_multiselect
            id="tt-styled"
            multiple={true}
            enable_option_tooltips={true}
            style="display:block; max-width:320px; --ms-option-tooltip-bg:#4338ca; --ms-option-tooltip-text-color:#fff; --ms-option-tooltip-border-radius:2px; --ms-option-tooltip-max-width:160px;"
          />
        </.form_group>
      </.card>

      <.card title="TT03 · Badge Tooltips">
        <.tip><code>enable_badge_tooltips</code> · <code>badge_tooltip_placement</code> · <code>{~S(remove_button_tooltip_text="Remove {0}")}</code></.tip>
        <p class="description">
          The same tooltip engine drives the selected-badge tooltips. Enable with
          <code>enable-badge-tooltips</code>; place them with <code>badge-tooltip-placement</code>, customize
          content with <code>getBadgeTooltipCallback</code> (the <strong>custom content</strong> toggle), and
          set the remove-button text with <code>remove-button-tooltip-text</code> (<code>{"{0}"}</code> = the
          item name).
        </p>

        <div class="controls">
          <label title="Turn hover tooltips on the selected badges on/off (the enable-badge-tooltips attribute)."><input type="checkbox" id="bdg-enable" checked /> <code>enable-badge-tooltips</code></label>
          <label title="Drive the badge tooltip content from getBadgeTooltipCallback (here 'label: description') instead of the default."><input type="checkbox" id="bdg-custom" /> custom content (<code>getBadgeTooltipCallback</code>)</label>
        </div>
        <div class="controls">
          <span><code>badge-tooltip-placement</code>:</span>
          <label title="Tooltip above the badge (the default)."><input type="radio" name="bdg-place" value="top" checked /> top</label>
          <label title="Tooltip below the badge."><input type="radio" name="bdg-place" value="bottom" /> bottom</label>
          <label title="Tooltip to the start (left) side of the badge."><input type="radio" name="bdg-place" value="left" /> left</label>
          <label title="Tooltip to the end (right) side of the badge."><input type="radio" name="bdg-place" value="right" /> right</label>
        </div>
        <div class="controls">
          <label title={"Template for the × remove-button's own tooltip; {0} is replaced with the item name (remove-button-tooltip-text)."}><code>remove-button-tooltip-text</code>:
            <input type="text" id="bdg-remove" value={"Remove {0}"} style="width:12rem" /></label>
        </div>

        <.form_group>
          <label class="demo-label">Hover a badge (or its × button):</label>
          <.web_multiselect
            id="tt-badge"
            multiple={true}
            enable_badge_tooltips={true}
            remove_button_tooltip_text={"Remove {0}"}
          />
        </.form_group>
      </.card>

      <.card title="TT04 · Summary">
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

        // ── Datasets ─────────────────────────────────────────────────────
        const fruitOptions = [
          { value: 'apple',      label: 'Apple',      description: 'A crisp red or green fruit' },
          { value: 'banana',     label: 'Banana',     description: 'A soft yellow tropical fruit' },
          { value: 'cherry',     label: 'Cherry',     description: 'A small, sweet red stone fruit' },
          { value: 'date',       label: 'Date',       description: 'A sweet, chewy dried fruit' },
          { value: 'elderberry', label: 'Elderberry', description: 'A tart dark-purple berry' },
          { value: 'fig',        label: 'Fig',        description: 'A soft fruit full of tiny seeds' },
          { value: 'grape',      label: 'Grape',      description: 'A juicy berry that grows in clusters' }
        ];

        // 1,000 items for the virtual-scrolling toggle.
        const manyOptions = Array.from({ length: 1000 }, (_, i) => ({
          value: `opt-${i + 1}`,
          label: `Option ${i + 1}`,
          description: `Generated row number ${i + 1}`
        }));

        // Toggle a boolean (presence) attribute.
        const boolAttr = (el, name, on) => on ? el.setAttribute(name, 'true') : el.removeAttribute(name);

        // ── TT01 · Option tooltips ─────────────────────────────────────────
        wait('tt-option').then((optTt) => {
          optTt.valueMember = 'value';
          optTt.displayValueMember = 'label';
          optTt.subtitleMember = 'description';
          optTt.options = fruitOptions;
          const optCustomCb = (item) => `${item.label} — ${item.description}`;

          // Document-delegated so the controls keep working after LiveView patches
          // the DOM on connect (the wrapper element itself is phx-update="ignore").
          document.addEventListener('change', (e) => {
            const t = e.target;
            if (!t) return;
            if (t.id === 'opt-enable') boolAttr(optTt, 'enable-option-tooltips', t.checked);
            else if (t.id === 'opt-follow') boolAttr(optTt, 'option-tooltip-follow-cursor', t.checked);
            else if (t.id === 'opt-custom') optTt.getOptionTooltipCallback = t.checked ? optCustomCb : null;
            else if (t.name === 'opt-place' && t.checked) optTt.setAttribute('option-tooltip-placement', t.value);
            else if (t.name === 'opt-width' && t.checked) {
              optTt.style.display = t.value === 'default' ? '' : 'block';
              optTt.style.width = t.value === 'full' ? '100%' : '';
              optTt.style.maxWidth = t.value === 'narrow' ? '200px' : '';
            }
            else if (t.id === 'opt-large') optTt.options = t.checked ? manyOptions : fruitOptions;
          });
          document.addEventListener('input', (e) => {
            const t = e.target;
            if (t && t.id === 'opt-delay') {
              const n = parseInt(t.value, 10);
              if (n >= 0) optTt.setAttribute('option-tooltip-delay', String(n));
            }
          });
        });

        // ── TT02 · Independent styling ─────────────────────────────────────
        wait('tt-styled').then((styTt) => {
          styTt.valueMember = 'value';
          styTt.displayValueMember = 'label';
          styTt.options = fruitOptions;
          styTt.getOptionTooltipCallback = (item) => item.description;

          const setVar = (name, value) => styTt.style.setProperty(name, value);
          document.addEventListener('input', (e) => {
            const t = e.target;
            if (!t) return;
            if (t.id === 'sty-bg') setVar('--ms-option-tooltip-bg', t.value);
            else if (t.id === 'sty-fg') setVar('--ms-option-tooltip-text-color', t.value);
            else if (t.id === 'sty-radius') setVar('--ms-option-tooltip-border-radius', `${t.value}px`);
            else if (t.id === 'sty-maxw') setVar('--ms-option-tooltip-max-width', `${t.value}px`);
          });
        });

        // ── TT03 · Badge tooltips ──────────────────────────────────────────
        wait('tt-badge').then((bdgTt) => {
          bdgTt.valueMember = 'value';
          bdgTt.displayValueMember = 'label';
          bdgTt.subtitleMember = 'description';
          bdgTt.options = fruitOptions;
          bdgTt.setSelected(['apple', 'banana', 'cherry']);
          const bdgCustomCb = (item) => `${item.label}: ${item.description}`;

          document.addEventListener('change', (e) => {
            const t = e.target;
            if (!t) return;
            if (t.id === 'bdg-enable') boolAttr(bdgTt, 'enable-badge-tooltips', t.checked);
            else if (t.id === 'bdg-custom') bdgTt.getBadgeTooltipCallback = t.checked ? bdgCustomCb : null;
            else if (t.name === 'bdg-place' && t.checked) bdgTt.setAttribute('badge-tooltip-placement', t.value);
          });
          document.addEventListener('input', (e) => {
            const t = e.target;
            if (t && t.id === 'bdg-remove') bdgTt.setAttribute('remove-button-tooltip-text', t.value);
          });
        });
      </script>
    </.example_page>
    """
  end
end
