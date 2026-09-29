defmodule TestAppWeb.Examples.ActionButtonsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Mirrors upstream @keenmate/web-multiselect examples-action-buttons.html
  # (AB01–AB07): everything the action bar can do, each as ONE live picker you
  # configure with control switches — built-in & static props, the dynamic
  # callbacks (and their priority over statics), custom actions, icon buttons,
  # layout, and a device-adaptive toolbar. Action buttons are a JS-only property
  # (the onClick / get*Callback functions can't be serialized as attributes), so
  # options and config are assigned to the wrapper element by id in the trailing
  # inline script; the control switches are wired with document-delegated
  # listeners so they survive LiveView's DOM patch on connect.

  @code_static ~S"""
  multiselect.actionButtons = [
    { action: 'select-all', text: 'Select All',
      tooltip: 'Select all available colors',   // static tooltip
      cssClass: 'custom-select-btn' },          // needs customStylesCallback (Shadow DOM)
    { action: 'clear-all', text: 'Clear All' },
    { action: 'custom', text: 'Hidden Button',   isVisible: false,  onClick: (ms) => {} },
    { action: 'custom', text: 'Disabled Button', isDisabled: true,  onClick: (ms) => {} },
  ];
  """

  @code_custom ~S"""
  multiselect.actionButtons = [
    { action: 'custom', text: 'Select Popular',
      onClick: (ms) => ms.setSelected(['js', 'py', 'ts']) },
    { action: 'custom', text: 'Invert Selection',
      onClick: (ms) => {
        const all = ms.options.options.map(o => o[0]);
        const sel = ms.getValue();
        ms.setSelected(all.filter(v => !sel.includes(v)));
      } },
    { action: 'custom', text: 'Select Random',
      onClick: (ms) => {
        const shuffled = [...ms.options.options].sort(() => Math.random() - 0.5);
        ms.setSelected(shuffled.slice(0, 2).map(o => o[0]));
      } },
    { action: 'clear-all', text: 'Clear All' },
  ];
  """

  @code_adaptive ~S"""
  // Device + viewport signal, re-exported from the component package — one import,
  // one dependency, the same signal the component reacts to internally.
  import { observeViewport, classifyDevice } from '@keenmate/web-multiselect';

  observeViewport((env) => {
    const device = classifyDevice(env);           // 'mobile' | 'tablet' | 'desktop'
    if (device === 'mobile') {                     // phone: essentials, wrapped
      el.actionButtons = mobileActions;  el.actionsLayout = 'wrap';
    } else if (device === 'tablet') {              // tablet: full set, wrapped
      el.actionButtons = desktopActions; el.actionsLayout = 'wrap';
    } else {                                        // desktop: two rows once ≤ 600px, else one
      el.actionButtons = desktopActions;
      el.actionsLayout = env.viewportWidth <= 600 ? 'wrap' : 'nowrap';
    }
  });
  """

  @code_layout ~S"""
  // Default - buttons squeezed in single row
  <web-multiselect actions-layout="nowrap"></web-multiselect>

  // Wrap mode - buttons wrap to multiple rows
  <web-multiselect actions-layout="wrap"></web-multiselect>
  """

  @code_summary_static ~S"""
  action: 'select-all' | 'clear-all' | 'custom'  // Required
  text: string                                    // Required
  row?: number                                    // Optional (default: 1) — which button row
  tooltip?: string                                // Optional
  cssClass?: string                               // Optional
  isVisible?: boolean                             // Optional (default: true)
  isDisabled?: boolean                            // Optional (default: false)
  """

  @code_summary_dynamic ~S"""
  onClick?: (multiselect) => void | Promise<void>   // Required for 'custom' action
  getIsVisibleCallback?: (multiselect) => boolean      // Dynamic visibility
  getIsDisabledCallback?: (multiselect) => boolean     // Dynamic disabled state
  getTextCallback?: (multiselect) => string         // Dynamic text
  getClassCallback?: (multiselect) => string | string[]  // Dynamic CSS classes
  getTooltipCallback?: (multiselect) => string      // Dynamic tooltip
  """

  @code_summary_layout ~S"""
  actions-position  // 'top' (default) | 'bottom'
  actions-layout    // 'nowrap' (default) | 'wrap'
  actions-align     // 'stretch' (default) | 'left' | 'center' | 'right' | 'space-between'
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Action Buttons — keen_web_multiselect")
     # Font Awesome (AB04) is font-based: the @font-face must live at the document
     # level, not just inside the shadow DOM via customStylesCallback, or the glyphs
     # render as empty boxes. This flag adds the FA <link> to the layout <head>.
     |> assign(:font_awesome, true)
     |> assign(:code_static, @code_static)
     |> assign(:code_custom, @code_custom)
     |> assign(:code_adaptive, @code_adaptive)
     |> assign(:code_layout, @code_layout)
     |> assign(:code_summary_static, @code_summary_static)
     |> assign(:code_summary_dynamic, @code_summary_dynamic)
     |> assign(:code_summary_layout, @code_summary_layout)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🎛️"
      title="Action Buttons"
      subtitle="Everything the action bar can do, each as ONE live picker you configure with control switches — built-in & static props, the dynamic callbacks (and their priority over statics), custom actions, icon buttons, layout, and a device-adaptive toolbar."
    >
      <.note title="Why this page uses inline scripts">
        Action buttons are configured via the JS-side <code>.actionButtons</code>
        property — the callbacks (<code>onClick</code>, <code>getTextCallback</code>, …) can't be
        serialized as HTML attributes. Each demo below assigns its options and
        config to the wrapper element by id after the custom element upgrades.
      </.note>

      <.card title="AB01 · Built-in & Static Properties">
        <.tip>JS <code>el.actionButtons</code> · static per-button props: <code>tooltip</code> · <code>cssClass</code> · <code>isVisible</code> · <code>isDisabled</code></.tip>
        <p class="description">
          The two built-in actions — <code>select-all</code> and <code>clear-all</code> — plus the static
          per-button properties: <code>tooltip</code>, <code>cssClass</code>, <code>isVisible</code>, and
          <code>isDisabled</code>. Toggle the switches to rebuild the <code>actionButtons</code> array live.
        </p>
        <.note title="Built-in smart defaults:">
          With no static <code>isDisabled</code> (and no <code>getIsDisabledCallback</code>),
          <strong>Select All</strong> auto-disables once every option is selected and
          <strong>Clear All</strong> auto-disables while nothing is selected. Select all colors and watch
          Select All disable.
        </.note>

        <div class="controls">
          <label title="Include the built-in select-all button. It selects every option and auto-disables once all are selected."><input type="checkbox" id="st-selall" checked /> include <code>select-all</code></label>
          <label title="Include the built-in clear-all button. It clears the selection and auto-disables while nothing is selected."><input type="checkbox" id="st-clrall" checked /> include <code>clear-all</code></label>
          <label title="Add a static tooltip string to each button (shown on hover)."><input type="checkbox" id="st-tooltips" /> static <code>tooltip</code>s</label>
          <label title="Apply cssClass:'custom-select-btn' to Select All. The class is injected into the Shadow DOM via customStylesCallback (page CSS can't reach inside)."><input type="checkbox" id="st-style" /> <code>cssClass</code> on Select All</label>
        </div>
        <div class="controls">
          <label title="Add a custom button with isVisible:false — it stays in the config but is not rendered. Proof that isVisible hides a button."><input type="checkbox" id="st-hidden" /> add a hidden button (<code>isVisible:false</code>)</label>
          <label title="Add a custom button with isDisabled:true — rendered but greyed out and non-clickable."><input type="checkbox" id="st-disabled" /> add a disabled button (<code>isDisabled:true</code>)</label>
        </div>

        <.form_group>
          <label class="demo-label">Select Colors:</label>
          <.web_multiselect id="ab-static" multiple={true} />
          <.output_panel id="out-static" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_static}</.code_block>
      </.card>

      <.card title="AB02 · Dynamic Callbacks (& Priority)">
        <.tip>Per-button callbacks on <code>el.actionButtons</code>: <code>getIsVisibleCallback</code> · <code>getIsDisabledCallback</code> · <code>getTextCallback</code> · <code>getClassCallback</code> · <code>getTooltipCallback</code></.tip>
        <p class="description">
          Each button property has a dynamic twin that recomputes from the live component:
          <code>getIsVisibleCallback</code>, <code>getIsDisabledCallback</code>,
          <code>getTextCallback</code>, <code>getClassCallback</code>, and
          <code>getTooltipCallback</code>. Pick which one drives the buttons — or choose
          <strong>all (priority)</strong> to see every callback active at once, overriding the static
          <code>text</code> / <code>isVisible</code> / <code>isDisabled</code> that are also set.
        </p>

        <div class="controls">
          <span>callback:</span>
          <label title="No dynamic callbacks — the buttons use only their static text/tooltip. Baseline to compare against."><input type="radio" name="dyn-cb" value="none" checked /> none (static)</label>
          <label title="getIsVisibleCallback — show/hide buttons by selection state: Clear All appears once something is selected; Select All hides when everything is selected."><input type="radio" name="dyn-cb" value="visibility" /> visibility</label>
          <label title="getIsDisabledCallback — enable/disable by state: Select All disables when all are selected, Clear All while nothing is; plus a 'Select First 3' button disabled when fewer than 3 options exist."><input type="radio" name="dyn-cb" value="disabled" /> disabled</label>
          <label title="getTextCallback — the button label recomputes live, e.g. 'Select All (8)', 'Clear 3 Selected', and a Select/Deselect toggle."><input type="radio" name="dyn-cb" value="text" /> text</label>
          <label title="getClassCallback — swap CSS classes by state (green→amber Select All; red active Clear). The classes are injected into the Shadow DOM via customStylesCallback."><input type="radio" name="dyn-cb" value="class" /> class</label>
          <label title="getTooltipCallback — the hover text recomputes live (remaining count, how many will be cleared); plus a 'Random Select' button. Hover the buttons to see it."><input type="radio" name="dyn-cb" value="tooltip" /> tooltip</label>
          <label title="Every callback active at once on buttons that ALSO set static isVisible:false / isDisabled:true — the callbacks win over the statics. Selection caps at 5."><input type="radio" name="dyn-cb" value="all" /> all (priority)</label>
        </div>

        <.form_group>
          <label class="demo-label">Select Items (the <code>all</code> mode caps at 5):</label>
          <.web_multiselect id="ab-dynamic" multiple={true} />
          <.output_panel id="out-dynamic" label="Selected:" placeholder="[]" />
        </.form_group>

        <.note title="Priority:">
          When both a static property and its callback are set, the callback wins:
          <code>get*Callback</code> &gt; static &gt; default. Try <strong>all (priority)</strong> — the
          buttons carry <code>isVisible:false</code> / <code>isDisabled:true</code> yet the callbacks keep
          them visible and enabled.
        </.note>
      </.card>

      <.card title="AB03 · Custom Actions with onClick">
        <.tip>Per-button config on <code>el.actionButtons</code>: <code>action: 'custom'</code> + <code>onClick: (ms) => …</code></.tip>
        <p class="description">
          Build your own buttons with <code>action: 'custom'</code> and an <code>onClick(ms)</code> handler
          that drives the component imperatively (<code>setSelected</code>, <code>selectAll</code>,
          <code>getValue</code>, …). Here: pick popular languages, invert the selection, or pick two at
          random — plus the built-in Clear All.
        </p>
        <.form_group>
          <label class="demo-label">Select Programming Languages:</label>
          <.web_multiselect id="ab-custom" multiple={true} />
          <.output_panel id="out-custom" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_custom}</.code_block>
      </.card>

      <.card title="AB04 · Icon Buttons — Font Awesome vs Lucide (SVG)">
        <.tip>Icon HTML in a button's <code>text</code> · Lucide SVG needs zero setup · Font Awesome needs the font at document level + rules via <code>el.customStylesCallback</code></.tip>
        <p class="description">
          Button <code>text</code> accepts HTML, so icons work — but the two families need different setup
          in a Shadow DOM component. <strong>Font Awesome</strong> is font-based: the <code>@font-face</code>
          must live at document level (a <code>link</code> in the page <code>head</code>) <em>and</em>
          the <code>.fa-*</code> class rules must be injected into the shadow root via
          <code>customStylesCallback</code>. <strong>Lucide</strong> is inline SVG: it renders natively in
          Shadow DOM with <em>zero</em> setup and inherits the button color via
          <code>stroke="currentColor"</code>. Flip the switch to compare.
        </p>

        <div class="controls">
          <span>icon library:</span>
          <label title="Inline SVG icons (Lucide). Render natively in Shadow DOM — no font, no head link, no CSS injection — and inherit the button color via stroke='currentColor'. The recommended path."><input type="radio" name="ico-lib" value="lucide" checked /> Lucide (SVG · zero setup)</label>
          <label title="Font-based icons (Font Awesome). Need BOTH the @font-face at document level (the link in the page head) AND the .fa-* class rules injected into the shadow root via customStylesCallback, or glyphs render as empty boxes."><input type="radio" name="ico-lib" value="fa" /> Font Awesome (font)</label>
        </div>

        <.form_group>
          <label class="demo-label">Select Technologies:</label>
          <.web_multiselect id="ab-icons" multiple={true} />
          <.output_panel id="out-icons" label="Selected:" placeholder="[]" />
        </.form_group>

        <.note title="Prefer SVG in Shadow DOM:">
          Inline SVG needs no <code>@font-face</code>, no document-level link, and no CSS injection —
          the markup is self-contained and themes for free. Font icons work, but require both halves (font
          at document level + class rules in the shadow) or the glyphs render as empty <code>□</code> boxes.
          Icon-only buttons should always carry a descriptive <code>tooltip</code>.
        </.note>
      </.card>

      <.card title="AB05 · Positioning, Rows & Alignment">
        <.tip><code>actions_position="top | bottom"</code> · per-button <code>row</code> · <code>actions_align="stretch | left | center | right | space-between"</code></.tip>
        <p class="description">
          Place the actions block at the <code>top</code> (default) or <code>bottom</code> of the dropdown,
          flow buttons across multiple rows with the per-button <code>row</code> property, and set horizontal
          alignment with <code>actions-align</code>. Open the dropdown to see the bar move.
        </p>

        <div class="controls">
          <span><code>actions-position</code>:</span>
          <label title="Render the action bar above the options list (the default)."><input type="radio" name="lay-pos" value="top" checked /> top</label>
          <label title="Render the action bar below the options list."><input type="radio" name="lay-pos" value="bottom" /> bottom</label>
          <label style="margin-inline-start:1rem" title="Split the buttons across two rows using each button's per-button row property (row:1 / row:2). Off = a single row."><input type="checkbox" id="lay-rows" checked /> two rows (per-button <code>row</code>)</label>
        </div>
        <div class="controls">
          <span><code>actions-align</code>:</span>
          <label title="actions-align:'stretch' (default) — buttons stretch to fill the bar width."><input type="radio" name="lay-align" value="stretch" checked /> stretch</label>
          <label title="actions-align:'left' — buttons packed to the start of the bar."><input type="radio" name="lay-align" value="left" /> left</label>
          <label title="actions-align:'center' — buttons centered in the bar."><input type="radio" name="lay-align" value="center" /> center</label>
          <label title="actions-align:'right' — buttons packed to the end of the bar."><input type="radio" name="lay-align" value="right" /> right</label>
          <label title="actions-align:'space-between' — buttons pushed to the edges with the gap distributed between them."><input type="radio" name="lay-align" value="space-between" /> space-between</label>
        </div>

        <.form_group>
          <label class="demo-label">Open the dropdown to see the action bar:</label>
          <.web_multiselect id="ab-layout" multiple={true} />
        </.form_group>

        <.note title="Row ordering:">
          Row 1 always sits at the panel's outer edge; higher rows stack inward toward the options list.
          So <code>top</code> renders row 1 first (top), and <code>bottom</code> renders row 1 last (bottom).
        </.note>
      </.card>

      <.card title="AB06 · Device-Adaptive Actions">
        <.tip>JS: <code>import &lbrace; observeViewport, classifyDevice &rbrace;</code> → swap <code>el.actionButtons</code> + <code>el.actionsLayout</code> per device/width</.tip>
        <p class="description">
          Twelve action buttons fit one row on a wide desktop, but there's no room on a phone, a
          tablet, or a narrowed window. The fix isn't a CSS trick: define your action sets and pick the right
          one for the space. The library re-exports the same device/viewport signal the component uses
          internally, so you react to the <em>event that tells you the device and width</em> and choose
          accordingly — here, granularly:
        </p>
        <ul>
          <li><strong>Desktop, wide (&gt; 600px):</strong> all twelve buttons, one row (<code>nowrap</code>).</li>
          <li><strong>Desktop, narrowed (≤ 600px):</strong> all twelve, flowed onto two rows (<code>wrap</code>).</li>
          <li><strong>Tablet:</strong> all twelve wrapped — a single row would run beyond the edge.</li>
          <li><strong>Phone:</strong> the three essentials only, wrapped.</li>
        </ul>
        <.form_group>
          <label class="demo-label" id="adaptive-device-label" phx-update="ignore">
            <code id="adaptive-device">…</code>
            <span class="form-text" style="display:inline;">— resize the window (cross 600px) or toggle the device toolbar (DevTools) to see the toolbar re-shape.</span>
          </label>
          <.web_multiselect id="ab-adaptive" multiple={true} />
          <.output_panel id="out-adaptive" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_adaptive}</.code_block>
      </.card>

      <.card title="AB07 · Summary">
        <h3>Static Properties</h3>
        <.code_block lang="js">{@code_summary_static}</.code_block>

        <h3>Dynamic Callbacks</h3>
        <.code_block lang="js">{@code_summary_dynamic}</.code_block>

        <h3>Layout attributes</h3>
        <.code_block lang="js">{@code_summary_layout}</.code_block>

        <h3>Priority Rules</h3>
        <.note title="When both static and callback are defined:">
          <ul>
            <li><code>getIsVisibleCallback</code> &gt; <code>isVisible</code> &gt; default <code>true</code></li>
            <li><code>getIsDisabledCallback</code> &gt; <code>isDisabled</code> &gt; default <code>false</code></li>
            <li><code>getTextCallback</code> &gt; <code>text</code></li>
            <li><code>getClassCallback</code> &gt; <code>cssClass</code></li>
            <li><code>getTooltipCallback</code> &gt; <code>tooltip</code></li>
          </ul>
        </.note>
      </.card>

      <.keen_card title="🧩 Actions Layout — Wrap Mode (side-by-side)">
        <.tip><code>actions_layout="wrap"</code> · <code>actions_layout="nowrap"</code> (default)</.tip>
        <p class="description">
          When you have many action buttons, use <code>actions-layout="wrap"</code>
          to allow buttons to wrap to multiple rows instead of being squeezed into a
          single row. Compare the behavior with 12 buttons below.
        </p>
        <.grid_2>
          <div>
            <h3>Default (nowrap)</h3>
            <.form_group>
              <label class="demo-label">12 buttons squeezed into one row:</label>
              <.web_multiselect id="layout-nowrap" multiple={true} actions_layout="nowrap" />
              <.output_panel id="out-nowrap" label="Selected:" placeholder="[]" />
            </.form_group>
          </div>
          <div>
            <h3>Wrap Mode</h3>
            <.form_group>
              <label class="demo-label">12 buttons wrap naturally across rows:</label>
              <.web_multiselect id="layout-wrap" multiple={true} actions_layout="wrap" />
              <.output_panel id="out-wrap" label="Selected:" placeholder="[]" />
            </.form_group>
          </div>
        </.grid_2>
        <.code_block lang="html">{@code_layout}</.code_block>
        <.note title="Visual Difference:">
          With 12 buttons, the difference is clear: <strong>nowrap</strong> forces all
          buttons into one row (they become very narrow), while <strong>wrap</strong>
          allows them to flow naturally across multiple rows with comfortable sizing.
        </.note>
      </.keen_card>

      <script type="module">
        import { observeViewport, classifyDevice } from 'keen_web_multiselect';

        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        // ── Datasets (tuple [value, label]) ──────────────────────────────
        const languageOptions = [
          ['js', 'JavaScript'], ['ts', 'TypeScript'], ['py', 'Python'], ['java', 'Java'],
          ['go', 'Go'], ['rust', 'Rust'], ['cpp', 'C++'], ['ruby', 'Ruby']
        ];
        const colorOptions = [
          ['red', 'Red'], ['blue', 'Blue'], ['green', 'Green'], ['yellow', 'Yellow'], ['purple', 'Purple']
        ];
        const itemOptions = [
          ['item1', 'Item 1'], ['item2', 'Item 2'], ['item3', 'Item 3'], ['item4', 'Item 4'],
          ['item5', 'Item 5'], ['item6', 'Item 6'], ['item7', 'Item 7'], ['item8', 'Item 8']
        ];
        const techOptions = [
          ['js', 'JavaScript'], ['ts', 'TypeScript'], ['py', 'Python'], ['java', 'Java'],
          ['cpp', 'C++'], ['go', 'Go'], ['rust', 'Rust'], ['php', 'PHP'], ['ruby', 'Ruby'], ['swift', 'Swift']
        ];

        // Custom-button CSS lives in Shadow DOM — page CSS can't cross the boundary.
        const BTN_STYLES = `
          .custom-select-btn { background:#667eea !important; color:#fff !important; font-weight:600; }
          .success-btn  { background:#48bb78 !important; color:#fff !important; }
          .warning-btn  { background:#ed8936 !important; color:#fff !important; }
          .danger-btn   { background:#f56565 !important; color:#fff !important; }
          .active-state { border:2px solid #667eea !important; }
          .inactive-state { opacity:0.6; }
        `;

        const wireOutput = (el, preId) => {
          const pre = document.getElementById(preId);
          const render = () => { if (pre) pre.textContent = JSON.stringify(el.getValue(), null, 2); };
          el.addEventListener('change', render);
          render();
        };

        // ── AB01 · Built-in & static properties ──────────────────────────
        wait('ab-static').then((abStatic) => {
          abStatic.options = colorOptions;
          abStatic.customStylesCallback = () => BTN_STYLES;
          const chk = (id) => { const c = document.getElementById(id); return !!(c && c.checked); };
          const buildStatic = () => {
            const btns = [];
            if (chk('st-selall')) btns.push({
              action: 'select-all', text: 'Select All',
              ...(chk('st-tooltips') ? { tooltip: 'Select all available colors' } : {}),
              ...(chk('st-style') ? { cssClass: 'custom-select-btn' } : {})
            });
            if (chk('st-clrall')) btns.push({
              action: 'clear-all', text: 'Clear All',
              ...(chk('st-tooltips') ? { tooltip: 'Remove all selections' } : {})
            });
            if (chk('st-hidden')) btns.push({ action: 'custom', text: 'Hidden Button', isVisible: false, onClick: () => {} });
            if (chk('st-disabled')) btns.push({ action: 'custom', text: 'Disabled Button', tooltip: 'This button is always disabled', isDisabled: true, onClick: () => {} });
            abStatic.actionButtons = btns;
          };
          const STATIC_IDS = ['st-selall', 'st-clrall', 'st-tooltips', 'st-style', 'st-hidden', 'st-disabled'];
          document.addEventListener('change', (e) => {
            if (e.target && STATIC_IDS.includes(e.target.id)) buildStatic();
          });
          buildStatic();
          wireOutput(abStatic, 'out-static');
        });

        // ── AB02 · Dynamic callbacks ──────────────────────────────────────
        wait('ab-dynamic').then((abDyn) => {
          abDyn.options = itemOptions;
          abDyn.customStylesCallback = () => BTN_STYLES;
          const dynSets = {
            none: () => [
              { action: 'select-all', text: 'Select All', tooltip: 'Select all items' },
              { action: 'clear-all', text: 'Clear All', tooltip: 'Clear selection' }
            ],
            visibility: () => [
              { action: 'select-all', text: 'Select All', tooltip: 'Select all items',
                getIsVisibleCallback: (ms) => ms.getSelected().length < (ms.options.options?.length || 0) },
              { action: 'clear-all', text: 'Clear All', tooltip: 'Clear selection',
                getIsVisibleCallback: (ms) => ms.getSelected().length > 0 }
            ],
            disabled: () => [
              { action: 'select-all', text: 'Select All',
                getIsDisabledCallback: (ms) => ms.getSelected().length >= (ms.options.options?.length || 0) },
              { action: 'clear-all', text: 'Clear All',
                getIsDisabledCallback: (ms) => ms.getSelected().length === 0 },
              { action: 'custom', text: 'Select First 3',
                getIsDisabledCallback: (ms) => (ms.options.options?.length || 0) < 3,
                onClick: (ms) => ms.setSelected(ms.options.options.slice(0, 3).map((o) => o[0])) }
            ],
            text: () => [
              { action: 'select-all', text: 'Select All',
                getTextCallback: (ms) => `Select All (${ms.options.options?.length || 0})` },
              { action: 'clear-all', text: 'Clear All',
                getTextCallback: (ms) => { const c = ms.getSelected().length; return c > 0 ? `Clear ${c} Selected` : 'Clear All'; } },
              { action: 'custom', text: 'Toggle',
                getTextCallback: (ms) => ms.getSelected().length === (ms.options.options?.length || 0) ? 'Deselect All' : 'Select All',
                onClick: (ms) => ms.getSelected().length === (ms.options.options?.length || 0) ? ms.setSelected([]) : ms.selectAll() }
            ],
            class: () => [
              { action: 'select-all', text: 'Select All', cssClass: 'default-class',
                getClassCallback: (ms) => ms.getSelected().length === 0 ? 'success-btn' : 'warning-btn' },
              { action: 'clear-all', text: 'Clear All',
                getClassCallback: (ms) => ms.getSelected().length > 0 ? ['danger-btn', 'active-state'] : 'inactive-state' }
            ],
            tooltip: () => [
              { action: 'select-all', text: 'Select All', tooltip: 'Default tooltip',
                getTooltipCallback: (ms) => { const t = ms.options.options?.length || 0; const s = ms.getSelected().length; return `Select all ${t} items (${t - s} remaining)`; } },
              { action: 'clear-all', text: 'Clear All',
                getTooltipCallback: (ms) => { const c = ms.getSelected().length; return c > 0 ? `Remove ${c} selected item${c !== 1 ? 's' : ''}` : 'Nothing to clear'; } },
              { action: 'custom', text: 'Random Select',
                getTooltipCallback: (ms) => `Randomly select 3 items from ${ms.options.options?.length || 0} available`,
                onClick: (ms) => { const sh = [...(ms.options.options || [])].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 3).map((o) => o[0])); } }
            ],
            all: () => [
              { action: 'select-all',
                text: 'Static Text', tooltip: 'Static Tooltip', cssClass: 'static-class', isVisible: false, isDisabled: true,
                getTextCallback: (ms) => `Select All (${ms.getSelected().length}/${ms.options.options?.length || 0})`,
                getTooltipCallback: (ms) => ms.getSelected().length >= 5 ? 'Maximum 5 items allowed' : 'Click to select all items',
                getClassCallback: (ms) => ms.getSelected().length >= 5 ? 'danger-btn' : 'success-btn',
                getIsVisibleCallback: (ms) => ms.getSelected().length < (ms.options.options?.length || 0),
                getIsDisabledCallback: (ms) => ms.getSelected().length >= 5 },
              { action: 'clear-all', text: 'Clear',
                getTextCallback: (ms) => `Clear (${ms.getSelected().length})`,
                getClassCallback: (ms) => ms.getSelected().length > 0 ? ['danger-btn', 'active-state'] : 'inactive-state',
                getIsVisibleCallback: (ms) => ms.getSelected().length > 0,
                getIsDisabledCallback: (ms) => ms.getSelected().length === 0 }
            ]
          };
          document.addEventListener('change', (e) => {
            if (e.target && e.target.name === 'dyn-cb' && e.target.checked) abDyn.actionButtons = dynSets[e.target.value]();
          });
          abDyn.actionButtons = dynSets.none();
          wireOutput(abDyn, 'out-dynamic');
        });

        // ── AB03 · Custom actions ─────────────────────────────────────────
        wait('ab-custom').then((abCustom) => {
          abCustom.options = languageOptions;
          abCustom.actionButtons = [
            { action: 'custom', text: 'Select Popular', tooltip: 'Select JS, Python, and TypeScript',
              onClick: (ms) => ms.setSelected(['js', 'py', 'ts']) },
            { action: 'custom', text: 'Invert Selection', tooltip: 'Invert current selection',
              onClick: (ms) => { const all = (ms.options.options || []).map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } },
            { action: 'custom', text: 'Select Random', tooltip: 'Select 2 random languages',
              onClick: (ms) => { const sh = [...(ms.options.options || [])].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 2).map((o) => o[0])); } },
            { action: 'clear-all', text: 'Clear All' }
          ];
          wireOutput(abCustom, 'out-custom');
        });

        // ── AB04 · Icon buttons (Font Awesome vs Lucide) ──────────────────
        wait('ab-icons').then((abIcons) => {
          abIcons.options = techOptions;

          const faButtons = () => [
            { action: 'select-all', text: '<i class="fas fa-check-double"></i> Select All', tooltip: 'Select all available technologies' },
            { action: 'clear-all', text: '<i class="fas fa-times"></i> Clear', tooltip: 'Clear all selections' },
            { action: 'custom', text: '<i class="fas fa-random"></i> Random', tooltip: 'Select 3 random technologies',
              onClick: (ms) => { const sh = [...techOptions].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 3).map((o) => o[0])); } },
            { action: 'custom', text: '<i class="fas fa-sync-alt"></i>', tooltip: 'Invert Selection',
              onClick: (ms) => { const all = techOptions.map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } },
            { action: 'custom', text: 'Toggle',
              getTextCallback: (ms) => { const c = ms.getSelected().length; const t = techOptions.length; return `${c === t ? '<i class="fas fa-toggle-on"></i>' : '<i class="fas fa-toggle-off"></i>'} ${c}/${t}`; },
              getTooltipCallback: (ms) => ms.getSelected().length === techOptions.length ? 'Deselect all' : 'Select all',
              onClick: (ms) => ms.getSelected().length === techOptions.length ? ms.setSelected([]) : ms.selectAll() }
          ];

          const lucide = (paths) => `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" `
            + `viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" `
            + `stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-3px">${paths}</svg>`;
          const luCheck = lucide('<path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/>');
          const luX = lucide('<path d="M18 6 6 18"/><path d="m6 6 12 12"/>');
          const luShuffle = lucide('<path d="m18 14 4 4-4 4"/><path d="m18 2 4 4-4 4"/><path d="M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22"/><path d="M2 6h1.972a4 4 0 0 1 3.6 2.2"/><path d="M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45"/>');
          const luRefresh = lucide('<path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/>');
          const luToggleOn = lucide('<circle cx="15" cy="12" r="3"/><rect width="20" height="14" x="2" y="5" rx="7"/>');
          const luToggleOff = lucide('<circle cx="9" cy="12" r="3"/><rect width="20" height="14" x="2" y="5" rx="7"/>');
          const luButtons = () => [
            { action: 'select-all', text: `${luCheck} Select All`, tooltip: 'Select all available technologies' },
            { action: 'clear-all', text: `${luX} Clear`, tooltip: 'Clear all selections' },
            { action: 'custom', text: `${luShuffle} Random`, tooltip: 'Select 3 random technologies',
              onClick: (ms) => { const sh = [...techOptions].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 3).map((o) => o[0])); } },
            { action: 'custom', text: luRefresh, tooltip: 'Invert Selection',
              onClick: (ms) => { const all = techOptions.map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } },
            { action: 'custom', text: 'Toggle',
              getTextCallback: (ms) => { const c = ms.getSelected().length; const t = techOptions.length; return `${c === t ? luToggleOn : luToggleOff} ${c}/${t}`; },
              getTooltipCallback: (ms) => ms.getSelected().length === techOptions.length ? 'Deselect all' : 'Select all',
              onClick: (ms) => ms.getSelected().length === techOptions.length ? ms.setSelected([]) : ms.selectAll() }
          ];

          const applyIcons = (lib) => {
            if (lib === 'fa') {
              // Inject Font Awesome class rules into the Shadow DOM (the <link> in <head> provides the font).
              abIcons.customStylesCallback = () => `@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css'); .ms__action-btn i { margin-right:0.35rem; }`;
              abIcons.actionButtons = faButtons();
            } else {
              // Inline SVG needs no shadow-DOM style injection — clear it.
              abIcons.customStylesCallback = () => '';
              abIcons.actionButtons = luButtons();
            }
          };
          document.addEventListener('change', (e) => {
            if (e.target && e.target.name === 'ico-lib' && e.target.checked) applyIcons(e.target.value);
          });
          applyIcons('lucide');
          wireOutput(abIcons, 'out-icons');
        });

        // ── AB05 · Positioning, rows & alignment ──────────────────────────
        wait('ab-layout').then((abLayout) => {
          abLayout.options = itemOptions;
          const twoRowButtons = [
            { action: 'select-all', text: 'Select All', row: 1 },
            { action: 'clear-all', text: 'Clear All', row: 1 },
            { action: 'custom', text: 'First 3', row: 2, onClick: (ms) => ms.setSelected(itemOptions.slice(0, 3).map((o) => o[0])) },
            { action: 'custom', text: 'Invert', row: 2, onClick: (ms) => { const all = itemOptions.map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } }
          ];
          const oneRowButtons = [
            { action: 'select-all', text: 'Select All' },
            { action: 'clear-all', text: 'Clear All' }
          ];
          const applyLayout = () => {
            const rows = document.getElementById('lay-rows');
            abLayout.actionButtons = (rows && rows.checked) ? twoRowButtons : oneRowButtons;
          };
          document.addEventListener('change', (e) => {
            const t = e.target;
            if (!t) return;
            if (t.name === 'lay-pos' && t.checked) abLayout.setAttribute('actions-position', t.value);
            else if (t.name === 'lay-align' && t.checked) abLayout.setAttribute('actions-align', t.value);
            else if (t.id === 'lay-rows') applyLayout();
          });
          applyLayout();
        });

        // ── AB06 · Device-adaptive actions ────────────────────────────────
        const manyButtons = [
          { action: 'select-all', text: 'Select All Items' },
          { action: 'clear-all', text: 'Clear Selection' },
          { action: 'custom', text: 'First 3 Items', onClick: (ms) => ms.setSelected(itemOptions.slice(0, 3).map((o) => o[0])) },
          { action: 'custom', text: 'Last 3 Items', onClick: (ms) => ms.setSelected(itemOptions.slice(-3).map((o) => o[0])) },
          { action: 'custom', text: 'Even Positions', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 2 === 0).map((o) => o[0])) },
          { action: 'custom', text: 'Odd Positions', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 2 === 1).map((o) => o[0])) },
          { action: 'custom', text: 'Random Selection', onClick: (ms) => { const sh = [...itemOptions].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 3).map((o) => o[0])); } },
          { action: 'custom', text: 'First Half', onClick: (ms) => ms.setSelected(itemOptions.slice(0, Math.ceil(itemOptions.length / 2)).map((o) => o[0])) },
          { action: 'custom', text: 'Second Half', onClick: (ms) => ms.setSelected(itemOptions.slice(Math.ceil(itemOptions.length / 2)).map((o) => o[0])) },
          { action: 'custom', text: 'Invert', onClick: (ms) => { const all = itemOptions.map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } },
          { action: 'custom', text: 'Every Third', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 3 === 0).map((o) => o[0])) },
          { action: 'custom', text: 'Shuffle All', onClick: (ms) => { const sh = [...itemOptions].sort(() => Math.random() - 0.5); ms.setSelected(sh.slice(0, 5).map((o) => o[0])); } }
        ];
        const desktopActions = manyButtons;
        const mobileActions = [
          { action: 'select-all', text: 'All' },
          { action: 'clear-all', text: 'Clear' },
          { action: 'custom', text: 'Invert', onClick: (ms) => { const all = itemOptions.map((o) => o[0]); const sel = ms.getValue(); ms.setSelected(all.filter((v) => !sel.includes(v))); } }
        ];

        wait('ab-adaptive').then((abAdaptive) => {
          abAdaptive.options = itemOptions;
          wireOutput(abAdaptive, 'out-adaptive');

          const deviceReadout = document.getElementById('adaptive-device');
          let lastKey = '';
          observeViewport((env) => {
            const device = classifyDevice(env);
            let actions, layout;
            if (device === 'mobile') { actions = mobileActions; layout = 'wrap'; }
            else if (device === 'tablet') { actions = desktopActions; layout = 'wrap'; }
            else { actions = desktopActions; layout = env.viewportWidth <= 600 ? 'wrap' : 'nowrap'; }
            const key = `${device}|${layout}|${actions.length}`;
            if (key !== lastKey) {
              lastKey = key;
              abAdaptive.actionButtons = actions;
              abAdaptive.actionsLayout = layout;
            }
            if (deviceReadout) {
              const rows = layout === 'wrap' ? 'two rows' : 'one row';
              deviceReadout.textContent = `${device} · ${Math.round(env.viewportWidth)}px · ${actions.length} buttons · ${rows}`;
            }
          });
        });

        // ── Wrapper extra · nowrap vs wrap (12 buttons) ───────────────────
        wait('layout-nowrap').then((el) => {
          el.options = itemOptions;
          el.actionButtons = manyButtons;
          wireOutput(el, 'out-nowrap');
        });
        wait('layout-wrap').then((el) => {
          el.options = itemOptions;
          el.actionButtons = manyButtons;
          wireOutput(el, 'out-wrap');
        });
      </script>
    </.example_page>
    """
  end
end
