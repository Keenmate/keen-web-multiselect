defmodule TestAppWeb.Examples.ActionButtonsLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  @code_basic ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All'
    },
    {
      action: 'clear-all',
      text: 'Clear All'
    }
  ];
  """

  @code_static ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',
      tooltip: 'Select all available colors',
      cssClass: 'custom-select-btn',
      isVisible: true,
      isDisabled: false
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      tooltip: 'Remove all selections',
      isVisible: true,
      isDisabled: false
    },
    {
      action: 'custom',
      text: 'Hidden Button',
      isVisible: false,  // This button is hidden
      onClick: (ms) => console.log('Clicked')
    },
    {
      action: 'custom',
      text: 'Disabled Button',
      tooltip: 'This button is always disabled',
      isDisabled: true,  // This button is disabled
      onClick: (ms) => console.log('Clicked')
    }
  ];
  """

  @code_visibility ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',
      tooltip: 'Select all numbers',
      // Only show when not all items are selected
      getIsVisibleCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        const selected = ms.getSelected().length;
        return selected < total;
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      tooltip: 'Clear selection',
      // Only show when at least one item is selected
      getIsVisibleCallback: (ms) => ms.getSelected().length > 0
    }
  ];
  """

  @code_disabled ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',
      tooltip: 'Select all fruits',
      // Disabled when all items are selected
      getIsDisabledCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        return ms.getSelected().length >= total;
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      tooltip: 'Clear selection',
      // Disabled when nothing is selected
      getIsDisabledCallback: (ms) => ms.getSelected().length === 0
    },
    {
      action: 'custom',
      text: 'Select First 3',
      tooltip: 'Select first 3 items',
      // Disabled when less than 3 items available
      getIsDisabledCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        return total < 3;
      },
      onClick: (ms) => {
        const firstThree = ms.options.options.slice(0, 3).map(opt => opt[0]);
        ms.setSelected(firstThree);
      }
    }
  ];
  """

  @code_text ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',  // Fallback text
      // Show count in button text
      getTextCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        return `Select All (${total})`;
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      // Show selected count in button text
      getTextCallback: (ms) => {
        const count = ms.getSelected().length;
        return count > 0 ? `Clear ${count} Selected` : 'Clear All';
      }
    },
    {
      action: 'custom',
      text: 'Toggle',
      // Toggle text based on state
      getTextCallback: (ms) => {
        const selected = ms.getSelected().length;
        const total = ms.options.options?.length || 0;
        return selected === total ? 'Deselect All' : 'Select All';
      },
      onClick: (ms) => {
        const selected = ms.getSelected().length;
        const total = ms.options.options?.length || 0;
        if (selected === total) {
          ms.setSelected([]);
        } else {
          ms.selectAll();
        }
      }
    }
  ];
  """

  @code_classes ~S"""
  // Inject custom CSS into Shadow DOM
  multiselect.customStylesCallback = () => `
    .success-btn { background: #48bb78 !important; color: white !important; }
    .warning-btn { background: #ed8936 !important; color: white !important; }
    .danger-btn { background: #f56565 !important; color: white !important; }
    .active-state { border: 2px solid #667eea !important; }
    .inactive-state { opacity: 0.6; }
  `;

  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',
      cssClass: 'default-class',  // Fallback
      // Return single class name as string
      getClassCallback: (ms) => {
        const selected = ms.getSelected().length;
        return selected === 0 ? 'success-btn' : 'warning-btn';
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      // Return array of class names
      getClassCallback: (ms) => {
        const selected = ms.getSelected().length;
        const classes = [];
        if (selected > 0) {
          classes.push('danger-btn', 'active-state');
        } else {
          classes.push('inactive-state');
        }
        return classes;
      }
    }
  ];
  """

  @code_tooltip ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: 'Select All',
      tooltip: 'Default tooltip',  // Fallback
      // Dynamic tooltip showing current state
      getTooltipCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        const selected = ms.getSelected().length;
        const remaining = total - selected;
        return `Select all ${total} items (${remaining} remaining)`;
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All',
      // Show what will be cleared
      getTooltipCallback: (ms) => {
        const count = ms.getSelected().length;
        return count > 0
          ? `Remove ${count} selected item${count !== 1 ? 's' : ''}`
          : 'Nothing to clear';
      }
    },
    {
      action: 'custom',
      text: 'Random Select',
      // Contextual help in tooltip
      getTooltipCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        return `Randomly select 3 items from ${total} available`;
      },
      onClick: (ms) => {
        const allOptions = ms.options.options || [];
        const shuffled = [...allOptions].sort(() => Math.random() - 0.5);
        const randomThree = shuffled.slice(0, 3).map(opt => opt[0]);
        ms.setSelected(randomThree);
      }
    }
  ];
  """

  @code_custom ~S"""
  multiselect.actionButtons = [
    {
      action: 'custom',
      text: 'Select Popular',
      tooltip: 'Select JS, Python, and TypeScript',
      onClick: (ms) => {
        ms.setSelected(['js', 'py', 'ts']);
      }
    },
    {
      action: 'custom',
      text: 'Invert Selection',
      tooltip: 'Invert current selection',
      onClick: (ms) => {
        const allOptions = ms.options.options || [];
        const allValues = allOptions.map(opt => opt[0]);
        const selectedValues = ms.getValue();
        const inverted = allValues.filter(v => !selectedValues.includes(v));
        ms.setSelected(inverted);
      }
    },
    {
      action: 'custom',
      text: 'Select Random',
      tooltip: 'Select 2 random languages',
      onClick: (ms) => {
        const allOptions = ms.options.options || [];
        const shuffled = [...allOptions].sort(() => Math.random() - 0.5);
        const random = shuffled.slice(0, 2).map(opt => opt[0]);
        ms.setSelected(random);
      }
    },
    {
      action: 'clear-all',
      text: 'Clear All'
    }
  ];
  """

  @code_combined ~S"""
  multiselect.actionButtons = [
    {
      action: 'select-all',
      // Static properties (will be OVERRIDDEN by callbacks)
      text: 'Static Text',
      tooltip: 'Static Tooltip',
      cssClass: 'static-class',
      isVisible: false,  // Would hide, but callback overrides
      isDisabled: true,  // Would disable, but callback overrides

      // Dynamic callbacks (TAKE PRIORITY)
      getTextCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        const selected = ms.getSelected().length;
        return `Select All (${selected}/${total})`;
      },
      getTooltipCallback: (ms) => {
        const selected = ms.getSelected().length;
        return selected >= 5
          ? 'Maximum 5 items allowed'
          : 'Click to select all items';
      },
      getClassCallback: (ms) => {
        const selected = ms.getSelected().length;
        return selected >= 5 ? 'danger-btn' : 'success-btn';
      },
      getIsVisibleCallback: (ms) => {
        const total = ms.options.options?.length || 0;
        const selected = ms.getSelected().length;
        return selected < total;  // Always visible when not all selected
      },
      getIsDisabledCallback: (ms) => {
        return ms.getSelected().length >= 5;  // Disabled at max
      }
    },
    {
      action: 'clear-all',
      text: 'Clear',
      getTextCallback: (ms) => {
        const count = ms.getSelected().length;
        return `Clear (${count})`;
      },
      getClassCallback: (ms) => {
        return ms.getSelected().length > 0 ? ['danger-btn', 'active-state'] : 'inactive-state';
      },
      getIsVisibleCallback: (ms) => ms.getSelected().length > 0,
      getIsDisabledCallback: (ms) => ms.getSelected().length === 0
    }
  ];
  """

  @code_layout ~S"""
  // Example with 12 action buttons
  multiselect.actionButtons = [
    { action: 'select-all', text: 'Select All Items' },
    { action: 'clear-all', text: 'Clear Selection' },
    { action: 'custom', text: 'First 3 Items', onClick: ... },
    { action: 'custom', text: 'Last 3 Items', onClick: ... },
    { action: 'custom', text: 'Even Positions', onClick: ... },
    { action: 'custom', text: 'Odd Positions', onClick: ... },
    { action: 'custom', text: 'Random Selection', onClick: ... },
    { action: 'custom', text: 'First Half', onClick: ... },
    { action: 'custom', text: 'Second Half', onClick: ... },
    { action: 'custom', text: 'Invert', onClick: ... },
    { action: 'custom', text: 'Every Third', onClick: ... },
    { action: 'custom', text: 'Shuffle All', onClick: ... }
  ];

  // Default - buttons squeezed in single row
  <web-multiselect actions-layout="nowrap"></web-multiselect>

  // Wrap mode - buttons wrap to multiple rows
  <web-multiselect actions-layout="wrap"></web-multiselect>
  """

  @code_fa ~S"""
  // STEP 0: Register the FONT at document level (page <head>), once:
  //   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/.../font-awesome/6.5.1/css/all.min.css">
  // A shadow-scoped @font-face is ignored, so this is what makes the glyphs render.

  // STEP 1: Inject the icon CLASS RULES into the Shadow DOM
  multiselect.customStylesCallback = () => `
    @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css');

    /* Optional: Style the icons */
    .ms__action-btn i {
      margin-right: 0.35rem;
    }
  `;

  // STEP 2: Use Font Awesome icons in buttons
  multiselect.actionButtons = [
    {
      action: 'select-all',
      text: '<i class="fas fa-check-double"></i> Select All',
      tooltip: 'Select all available items'
    },
    {
      action: 'clear-all',
      text: '<i class="fas fa-times"></i> Clear',
      tooltip: 'Clear selection'
    },
    {
      action: 'custom',
      text: '<i class="fas fa-random"></i> Random',
      tooltip: 'Select 3 random items',
      onClick: (ms) => {
        const shuffled = [...options].sort(() => Math.random() - 0.5);
        ms.setSelected(shuffled.slice(0, 3).map(o => o[0]));
      }
    },
    // Icon-only button
    {
      action: 'custom',
      text: '<i class="fas fa-sync-alt"></i>',
      tooltip: 'Invert Selection',  // Essential for accessibility
      onClick: (ms) => { /* ... */ }
    },
    // Dynamic icon with getTextCallback
    {
      action: 'custom',
      text: 'Toggle',  // Fallback
      getTextCallback: (ms) => {
        const count = ms.getSelected().length;
        const total = ms.options.options?.length || 0;
        const icon = count === total
          ? '<i class="fas fa-toggle-on"></i>'
          : '<i class="fas fa-toggle-off"></i>';
        return `${icon} ${count}/${total}`;
      },
      onClick: (ms) => { /* ... */ }
    }
  ];
  """

  @code_lucide ~S"""
  // No setup needed — SVG just works in Shadow DOM.
  // Lucide SVGs use stroke="currentColor" so they inherit the button color.
  const check = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none"
    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
    style="vertical-align:-3px"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg>`;

  multiselect.actionButtons = [
    { action: 'select-all', text: `${check} Select All`, tooltip: 'Select all' },
    { action: 'clear-all',  text: `${xIcon} Clear`,      tooltip: 'Clear selection' },
    // ...custom buttons with shuffle / refresh / toggle SVGs
  ];
  """

  @code_positioning ~S"""
  <web-multiselect actions-position="bottom" actions-align="right"></web-multiselect>

  multiselect.actionButtons = [
    { action: 'select-all', text: 'Select All', row: 1 },
    { action: 'clear-all',  text: 'Clear All',  row: 1 },
    { action: 'custom', text: 'First 3', row: 2, onClick: ... },
    { action: 'custom', text: 'Invert',  row: 2, onClick: ... },
  ];
  """

  @code_summary_static ~S"""
  action: 'select-all' | 'clear-all' | 'custom'  // Required
  text: string                                    // Required
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

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Action Buttons — keen_web_multiselect")
     # Font Awesome (§11) is font-based: the @font-face must live at the document
     # level, not just inside the shadow DOM via customStylesCallback, or the glyphs
     # render as empty boxes. This flag adds the FA <link> to the layout <head>.
     |> assign(:font_awesome, true)
     |> assign(:code_basic, @code_basic)
     |> assign(:code_static, @code_static)
     |> assign(:code_visibility, @code_visibility)
     |> assign(:code_disabled, @code_disabled)
     |> assign(:code_text, @code_text)
     |> assign(:code_classes, @code_classes)
     |> assign(:code_tooltip, @code_tooltip)
     |> assign(:code_custom, @code_custom)
     |> assign(:code_combined, @code_combined)
     |> assign(:code_layout, @code_layout)
     |> assign(:code_fa, @code_fa)
     |> assign(:code_lucide, @code_lucide)
     |> assign(:code_positioning, @code_positioning)
     |> assign(:code_summary_static, @code_summary_static)
     |> assign(:code_summary_dynamic, @code_summary_dynamic)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🎛️"
      title="Action Buttons"
      subtitle="Comprehensive guide to all action button configuration options"
    >
      <.note title="Why this page uses inline scripts">
        Action buttons are configured via the JS-side <code>.actionButtons</code>
        property — the callbacks (<code>onClick</code>, <code>getTextCallback</code>, …) can't be
        serialized as HTML attributes. Each demo below assigns its options and
        config to the wrapper element by id after the custom element upgrades.
      </.note>

      <.card title="1. Basic Built-in Actions">
        <p class="description">
          Simple select-all and clear-all buttons with default settings.
        </p>
        <.form_group>
          <label class="demo-label">Select Languages:</label>
          <.web_multiselect id="basic-actions" multiple={true} />
          <.output_panel id="output-basic" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_basic}</.code_block>
      </.card>

      <.card title="2. Static Properties">
        <p class="description">
          Using static properties: <code>isVisible</code>, <code>isDisabled</code>,
          <code>cssClass</code>, and <code>tooltip</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select Colors:</label>
          <.web_multiselect id="static-props" multiple={true} />
          <.output_panel id="output-static" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_static}</.code_block>
      </.card>

      <.card title="3. Dynamic Visibility (getIsVisibleCallback)">
        <p class="description">
          Show/hide buttons based on current selection state using
          <code>getIsVisibleCallback</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select Numbers:</label>
          <.web_multiselect id="dynamic-visibility" multiple={true} />
          <.output_panel id="output-visibility" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_visibility}</.code_block>
        <.note title="Try it:">
          Select some items to see "Clear All" appear. Select all items to see "Select All" disappear.
        </.note>
      </.card>

      <.card title="4. Dynamic Disabled State (getIsDisabledCallback)">
        <p class="description">
          Enable/disable buttons based on conditions using <code>getIsDisabledCallback</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select Fruits:</label>
          <.web_multiselect id="dynamic-disabled" multiple={true} />
          <.output_panel id="output-disabled" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_disabled}</.code_block>
      </.card>

      <.card title="5. Dynamic Text (getTextCallback)">
        <p class="description">
          Change button text based on current state using <code>getTextCallback</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select Items:</label>
          <.web_multiselect id="dynamic-text" multiple={true} />
          <.output_panel id="output-text" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_text}</.code_block>
        <.note title="Try it:">
          Watch the button text change as you select/deselect items.
        </.note>
      </.card>

      <.card title="6. Dynamic CSS Classes (getClassCallback)">
        <p class="description">
          Apply CSS classes dynamically based on state using <code>getClassCallback</code>.
          Custom styles are injected via <code>customStylesCallback</code> into the Shadow DOM.
        </p>
        <.form_group>
          <label class="demo-label">Select Options:</label>
          <.web_multiselect id="dynamic-classes" multiple={true} />
          <.output_panel id="output-classes" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_classes}</.code_block>
        <.note title="Important:">
          Custom CSS classes must be injected via <code>customStylesCallback</code>
          because the component uses Shadow DOM. Regular page styles won't affect
          elements inside the shadow root. The callback can return a string or array of strings.
        </.note>
      </.card>

      <.card title="7. Dynamic Tooltip (getTooltipCallback)">
        <p class="description">
          Show contextual information in tooltips using <code>getTooltipCallback</code>.
        </p>
        <.form_group>
          <label class="demo-label">Select Items:</label>
          <.web_multiselect id="dynamic-tooltip" multiple={true} />
          <.output_panel id="output-tooltip" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_tooltip}</.code_block>
        <.note title="Try it:">
          Hover over the buttons to see dynamic tooltips that change based on the current state.
        </.note>
      </.card>

      <.card title="8. Custom Actions with onClick">
        <p class="description">
          Create custom buttons with <code>action: 'custom'</code> and custom
          <code>onClick</code> handlers.
        </p>
        <.form_group>
          <label class="demo-label">Select Programming Languages:</label>
          <.web_multiselect id="custom-actions" multiple={true} />
          <.output_panel id="output-custom" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_custom}</.code_block>
      </.card>

      <.card title="9. Combined Features & Callback Priority">
        <p class="description">
          Demonstrating multiple callbacks working together and callback priority
          over static properties.
        </p>
        <.form_group>
          <label class="demo-label">Select Items (max 5):</label>
          <.web_multiselect id="combined" multiple={true} />
          <.output_panel id="output-combined" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_combined}</.code_block>
        <.note title="Callback Priority:">
          Notice how the callbacks override the static properties. Even though
          <code>isVisible: false</code> and <code>isDisabled: true</code> are set,
          the callbacks take priority and determine the actual state.
        </.note>
      </.card>

      <.card title="10. Actions Layout - Wrap Mode">
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
              <.output_panel id="output-nowrap" label="Selected:" placeholder="[]" />
            </.form_group>
          </div>
          <div>
            <h3>Wrap Mode</h3>
            <.form_group>
              <label class="demo-label">12 buttons wrap naturally across rows:</label>
              <.web_multiselect id="layout-wrap" multiple={true} actions_layout="wrap" />
              <.output_panel id="output-wrap" label="Selected:" placeholder="[]" />
            </.form_group>
          </div>
        </.grid_2>
        <.code_block lang="js">{@code_layout}</.code_block>
        <.note title="Visual Difference:">
          With 12 buttons, the difference is clear: <strong>nowrap</strong> forces all
          buttons into one row (they become very narrow), while <strong>wrap</strong>
          allows them to flow naturally across multiple rows with comfortable sizing.
        </.note>
      </.card>

      <.card title="11. Font Awesome Icons in Buttons">
        <p class="description">
          Action buttons accept HTML, so Font Awesome icons work — but Font Awesome is
          <strong>font-based</strong>, which needs <strong>two</strong> things in a
          Shadow DOM component: <strong>(1)</strong> the <code>@font-face</code> must be
          registered at the <em>document</em> level (a normal <code>&lt;link&gt;</code>
          in the page <code>&lt;head&gt;</code>) — a shadow-scoped <code>@font-face</code>
          is ignored by browsers, so the glyphs would render as empty boxes; and
          <strong>(2)</strong> the icon <em>class rules</em>
          (<code>.fas</code>, <code>.fa-*::before</code>) must be injected <em>into</em>
          the Shadow DOM via <code>customStylesCallback</code>, because page CSS can't
          cross the shadow boundary. Prefer SVG icons (§12) when you want zero setup.
        </p>
        <.form_group>
          <label class="demo-label">Select Technologies:</label>
          <.web_multiselect id="icon-buttons" multiple={true} />
          <.output_panel id="output-icons" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_fa}</.code_block>
        <.note title="⚠️ Shadow DOM + font icons — you need both halves:">
          <ul>
            <li>
              <strong>Font at document level (required):</strong>
              Keep the Font Awesome <code>&lt;link&gt;</code> in the page
              <code>&lt;head&gt;</code>. The <code>@font-face</code> must live in the
              document — a browser will <em>not</em> apply a <code>@font-face</code>
              declared inside a shadow root, so loading FA only via
              <code>customStylesCallback</code> renders the glyphs as empty
              <code>□</code> boxes.
            </li>
            <li>
              <strong>Class rules in the shadow (required):</strong>
              The <code>.fas</code> / <code>.fa-*::before</code> rules must be injected
              into the Shadow DOM with <code>customStylesCallback</code>, because page
              CSS doesn't cross the shadow boundary. The <code>@import</code> above does
              this (or inject just the few <code>::before &lbrace; content &rbrace;</code> rules you
              use to avoid the async fetch).
            </li>
            <li>
              <strong>Prefer SVG icons (zero setup):</strong>
              Inline SVG (e.g. Lucide — see §12) renders natively in Shadow DOM with no
              <code>@font-face</code> and no CSS injection at all.
            </li>
            <li>
              <strong>HTML is supported:</strong>
              The <code>text</code> property and <code>getTextCallback</code> both
              accept HTML strings.
            </li>
            <li>
              <strong>Accessibility:</strong>
              Icon-only buttons should always include descriptive tooltips for screen readers.
            </li>
            <li>
              <strong>Any font-icon library works the same way:</strong>
              Material Icons, Bootstrap Icons, etc. — font at document level, class
              rules in the shadow.
            </li>
          </ul>
        </.note>
      </.card>

      <.card title="12. Lucide (SVG) Icons in Buttons">
        <p class="description">
          Unlike font icons, <strong>inline SVG icons render natively inside Shadow DOM</strong>
          — no <code>@font-face</code>, no <code>&lt;head&gt;</code> link, no
          <code>customStylesCallback</code>. You just put the SVG markup in the button
          <code>text</code>. These are Lucide icons; they use
          <code>stroke="currentColor"</code>, so they automatically match the button's
          text color (including dark mode).
        </p>
        <.form_group>
          <label class="demo-label">Select Technologies:</label>
          <.web_multiselect id="lucide-buttons" multiple={true} />
          <.output_panel id="output-lucide" label="Selected:" placeholder="[]" />
        </.form_group>
        <.code_block lang="js">{@code_lucide}</.code_block>
        <.note title="✅ Why SVG is the easy path in Shadow DOM:">
          <ul>
            <li>
              <strong>Zero setup:</strong>
              No font registration, no CSS injection, no async <code>@import</code>
              race — the markup is self-contained.
            </li>
            <li>
              <strong>Themes for free:</strong>
              <code>stroke="currentColor"</code> (Lucide) / <code>fill="currentColor"</code>
              means the icon follows the button's text color, so dark mode and custom
              <code>--ms-*</code> colors just work.
            </li>
            <li>
              <strong>Sizing:</strong>
              Set <code>width</code>/<code>height</code> on the <code>&lt;svg&gt;</code>
              (here <code>16</code>) and a small <code>vertical-align</code> to sit it on
              the text baseline.
            </li>
            <li>
              <strong>Security:</strong>
              <code>text</code>/<code>getTextCallback</code> render raw HTML — only
              inline SVG you control, never untrusted strings.
            </li>
          </ul>
        </.note>
      </.card>

      <.card title="13. Positioning, Rows & Alignment">
        <p class="description">
          Place the actions block at the <code>top</code> (default) or <code>bottom</code> of the
          dropdown, arrange buttons across multiple rows with the per-button <code>row</code>
          property, and control horizontal alignment with <code>actions_align</code>.
        </p>

        <div class="grid-2">
          <div>
            <h3><code>actions_position="top"</code> — 2 rows</h3>
            <p class="description">Row 1 is the topmost line, row 2 below it.</p>
            <div class="demo-area">
              <.web_multiselect id="pos-top-rows" multiple={true} actions_position="top" />
            </div>
          </div>

          <div>
            <h3><code>actions_position="bottom"</code> — 2 rows</h3>
            <p class="description">Row 1 is the bottommost line, row 2 above it.</p>
            <div class="demo-area">
              <.web_multiselect id="pos-bottom-rows" multiple={true} actions_position="bottom" />
            </div>
          </div>
        </div>

        <h3 style="margin-top:1.5rem;">Alignment (<code>actions_align</code>)</h3>
        <div class="grid-2">
          <div>
            <div class="demo-area">
              <label class="demo-label"><code>actions_align="right"</code></label>
              <.web_multiselect id="align-right" multiple={true} actions_align="right" />
            </div>
          </div>
          <div>
            <div class="demo-area">
              <label class="demo-label"><code>actions_align="space-between"</code></label>
              <.web_multiselect id="align-between" multiple={true} actions_align="space-between" />
            </div>
          </div>
        </div>

        <.code_block lang="js">{@code_positioning}</.code_block>
        <.note title="Row ordering:">
          Row 1 always sits at the panel's outer edge; higher rows stack inward toward the options
          list. So <code>top</code> renders row 1 first (top), and <code>bottom</code> renders row 1
          last (bottom).
        </.note>
      </.card>

      <.card title="📋 Summary">
        <h3>Static Properties</h3>
        <.code_block lang="js">{@code_summary_static}</.code_block>

        <h3>Dynamic Callbacks</h3>
        <.code_block lang="js">{@code_summary_dynamic}</.code_block>

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

      <script type="module">
        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        const languageOptions = [
          ['js', 'JavaScript'],
          ['ts', 'TypeScript'],
          ['py', 'Python'],
          ['java', 'Java'],
          ['go', 'Go'],
          ['rust', 'Rust'],
          ['cpp', 'C++'],
          ['ruby', 'Ruby']
        ];

        const colorOptions = [
          ['red', 'Red'],
          ['blue', 'Blue'],
          ['green', 'Green'],
          ['yellow', 'Yellow'],
          ['purple', 'Purple']
        ];

        const numberOptions = [
          ['1', 'One'],
          ['2', 'Two'],
          ['3', 'Three'],
          ['4', 'Four'],
          ['5', 'Five'],
          ['6', 'Six']
        ];

        const fruitOptions = [
          ['apple', 'Apple'],
          ['banana', 'Banana'],
          ['orange', 'Orange'],
          ['grape', 'Grape'],
          ['mango', 'Mango']
        ];

        const itemOptions = [
          ['item1', 'Item 1'],
          ['item2', 'Item 2'],
          ['item3', 'Item 3'],
          ['item4', 'Item 4'],
          ['item5', 'Item 5'],
          ['item6', 'Item 6'],
          ['item7', 'Item 7'],
          ['item8', 'Item 8']
        ];

        // Example 1: Basic Built-in Actions
        wait('basic-actions').then((basicActions) => {
          basicActions.options = languageOptions;
          basicActions.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All'
            },
            {
              action: 'clear-all',
              text: 'Clear All'
            }
          ];
          basicActions.addEventListener('change', () => {
            document.getElementById('output-basic').textContent = JSON.stringify(basicActions.getValue(), null, 2);
          });
        });

        // Example 2: Static Properties
        wait('static-props').then((staticProps) => {
          staticProps.options = colorOptions;

          // Inject custom CSS for custom-select-btn class
          staticProps.customStylesCallback = () => `
            .custom-select-btn {
              background: #667eea !important;
              color: white !important;
              font-weight: 600;
            }
          `;

          staticProps.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              tooltip: 'Select all available colors',
              cssClass: 'custom-select-btn',
              isVisible: true,
              isDisabled: false
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              tooltip: 'Remove all selections',
              isVisible: true,
              isDisabled: false
            },
            {
              action: 'custom',
              text: 'Hidden Button',
              isVisible: false,
              onClick: (ms) => console.log('Hidden button clicked')
            },
            {
              action: 'custom',
              text: 'Disabled Button',
              tooltip: 'This button is always disabled',
              isDisabled: true,
              onClick: (ms) => console.log('Disabled button clicked')
            }
          ];
          staticProps.addEventListener('change', () => {
            document.getElementById('output-static').textContent = JSON.stringify(staticProps.getValue(), null, 2);
          });
        });

        // Example 3: Dynamic Visibility
        wait('dynamic-visibility').then((dynamicVisibility) => {
          dynamicVisibility.options = numberOptions;
          dynamicVisibility.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              tooltip: 'Select all numbers',
              getIsVisibleCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                const selected = ms.getSelected().length;
                return selected < total;
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              tooltip: 'Clear selection',
              getIsVisibleCallback: (ms) => ms.getSelected().length > 0
            }
          ];
          dynamicVisibility.addEventListener('change', () => {
            document.getElementById('output-visibility').textContent = JSON.stringify(dynamicVisibility.getValue(), null, 2);
          });
        });

        // Example 4: Dynamic Disabled State
        wait('dynamic-disabled').then((dynamicDisabled) => {
          dynamicDisabled.options = fruitOptions;
          dynamicDisabled.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              tooltip: 'Select all fruits',
              getIsDisabledCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                return ms.getSelected().length >= total;
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              tooltip: 'Clear selection',
              getIsDisabledCallback: (ms) => ms.getSelected().length === 0
            },
            {
              action: 'custom',
              text: 'Select First 3',
              tooltip: 'Select first 3 items',
              getIsDisabledCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                return total < 3;
              },
              onClick: (ms) => {
                const firstThree = ms.options.options.slice(0, 3).map(opt => opt[0]);
                ms.setSelected(firstThree);
              }
            }
          ];
          dynamicDisabled.addEventListener('change', () => {
            document.getElementById('output-disabled').textContent = JSON.stringify(dynamicDisabled.getValue(), null, 2);
          });
        });

        // Example 5: Dynamic Text
        wait('dynamic-text').then((dynamicText) => {
          dynamicText.options = itemOptions;
          dynamicText.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              getTextCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                return `Select All (${total})`;
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              getTextCallback: (ms) => {
                const count = ms.getSelected().length;
                return count > 0 ? `Clear ${count} Selected` : 'Clear All';
              }
            },
            {
              action: 'custom',
              text: 'Toggle',
              getTextCallback: (ms) => {
                const selected = ms.getSelected().length;
                const total = ms.options.options?.length || 0;
                return selected === total ? 'Deselect All' : 'Select All';
              },
              onClick: (ms) => {
                const selected = ms.getSelected().length;
                const total = ms.options.options?.length || 0;
                if (selected === total) {
                  ms.setSelected([]);
                } else {
                  ms.selectAll();
                }
              }
            }
          ];
          dynamicText.addEventListener('change', () => {
            document.getElementById('output-text').textContent = JSON.stringify(dynamicText.getValue(), null, 2);
          });
        });

        // Example 6: Dynamic CSS Classes
        wait('dynamic-classes').then((dynamicClasses) => {
          dynamicClasses.options = itemOptions;
          dynamicClasses.customStylesCallback = () => `
            .success-btn { background: #48bb78 !important; color: white !important; }
            .warning-btn { background: #ed8936 !important; color: white !important; }
            .danger-btn { background: #f56565 !important; color: white !important; }
            .active-state { border: 2px solid #667eea !important; }
            .inactive-state { opacity: 0.6; }
          `;
          dynamicClasses.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              cssClass: 'default-class',
              getClassCallback: (ms) => {
                const selected = ms.getSelected().length;
                return selected === 0 ? 'success-btn' : 'warning-btn';
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              getClassCallback: (ms) => {
                const selected = ms.getSelected().length;
                const classes = [];
                if (selected > 0) {
                  classes.push('danger-btn', 'active-state');
                } else {
                  classes.push('inactive-state');
                }
                return classes;
              }
            }
          ];
          dynamicClasses.addEventListener('change', () => {
            document.getElementById('output-classes').textContent = JSON.stringify(dynamicClasses.getValue(), null, 2);
          });
        });

        // Example 7: Dynamic Tooltip
        wait('dynamic-tooltip').then((dynamicTooltip) => {
          dynamicTooltip.options = itemOptions;
          dynamicTooltip.actionButtons = [
            {
              action: 'select-all',
              text: 'Select All',
              tooltip: 'Default tooltip',
              getTooltipCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                const selected = ms.getSelected().length;
                const remaining = total - selected;
                return `Select all ${total} items (${remaining} remaining)`;
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All',
              getTooltipCallback: (ms) => {
                const count = ms.getSelected().length;
                return count > 0
                  ? `Remove ${count} selected item${count !== 1 ? 's' : ''}`
                  : 'Nothing to clear';
              }
            },
            {
              action: 'custom',
              text: 'Random Select',
              getTooltipCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                return `Randomly select 3 items from ${total} available`;
              },
              onClick: (ms) => {
                const allOptions = ms.options.options || [];
                const shuffled = [...allOptions].sort(() => Math.random() - 0.5);
                const randomThree = shuffled.slice(0, 3).map(opt => opt[0]);
                ms.setSelected(randomThree);
              }
            }
          ];
          dynamicTooltip.addEventListener('change', () => {
            document.getElementById('output-tooltip').textContent = JSON.stringify(dynamicTooltip.getValue(), null, 2);
          });
        });

        // Example 8: Custom Actions
        wait('custom-actions').then((customActions) => {
          customActions.options = languageOptions;
          customActions.actionButtons = [
            {
              action: 'custom',
              text: 'Select Popular',
              tooltip: 'Select JS, Python, and TypeScript',
              onClick: (ms) => {
                ms.setSelected(['js', 'py', 'ts']);
              }
            },
            {
              action: 'custom',
              text: 'Invert Selection',
              tooltip: 'Invert current selection',
              onClick: (ms) => {
                const allOptions = ms.options.options || [];
                const allValues = allOptions.map(opt => opt[0]);
                const selectedValues = ms.getValue();
                const inverted = allValues.filter(v => !selectedValues.includes(v));
                ms.setSelected(inverted);
              }
            },
            {
              action: 'custom',
              text: 'Select Random',
              tooltip: 'Select 2 random languages',
              onClick: (ms) => {
                const allOptions = ms.options.options || [];
                const shuffled = [...allOptions].sort(() => Math.random() - 0.5);
                const random = shuffled.slice(0, 2).map(opt => opt[0]);
                ms.setSelected(random);
              }
            },
            {
              action: 'clear-all',
              text: 'Clear All'
            }
          ];
          customActions.addEventListener('change', () => {
            document.getElementById('output-custom').textContent = JSON.stringify(customActions.getValue(), null, 2);
          });
        });

        // Example 9: Combined Features
        wait('combined').then((combined) => {
          combined.options = itemOptions;
          combined.actionButtons = [
            {
              action: 'select-all',
              // Static properties (will be overridden by callbacks)
              text: 'Static Text',
              tooltip: 'Static Tooltip',
              cssClass: 'static-class',
              isVisible: false,
              isDisabled: true,
              // Dynamic callbacks (take priority)
              getTextCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                const selected = ms.getSelected().length;
                return `Select All (${selected}/${total})`;
              },
              getTooltipCallback: (ms) => {
                const selected = ms.getSelected().length;
                return selected >= 5
                  ? 'Maximum 5 items allowed'
                  : 'Click to select all items';
              },
              getClassCallback: (ms) => {
                const selected = ms.getSelected().length;
                return selected >= 5 ? 'danger-btn' : 'success-btn';
              },
              getIsVisibleCallback: (ms) => {
                const total = ms.options.options?.length || 0;
                const selected = ms.getSelected().length;
                return selected < total;
              },
              getIsDisabledCallback: (ms) => {
                return ms.getSelected().length >= 5;
              }
            },
            {
              action: 'clear-all',
              text: 'Clear',
              getTextCallback: (ms) => {
                const count = ms.getSelected().length;
                return `Clear (${count})`;
              },
              getClassCallback: (ms) => {
                return ms.getSelected().length > 0 ? ['danger-btn', 'active-state'] : 'inactive-state';
              },
              getIsVisibleCallback: (ms) => ms.getSelected().length > 0,
              getIsDisabledCallback: (ms) => ms.getSelected().length === 0
            }
          ];
          combined.addEventListener('change', () => {
            document.getElementById('output-combined').textContent = JSON.stringify(combined.getValue(), null, 2);
          });
        });

        // Example 10: Actions Layout - Wrap Mode
        const manyButtons = [
          { action: 'select-all', text: 'Select All Items' },
          { action: 'clear-all', text: 'Clear Selection' },
          { action: 'custom', text: 'First 3 Items', onClick: (ms) => ms.setSelected(itemOptions.slice(0, 3).map(o => o[0])) },
          { action: 'custom', text: 'Last 3 Items', onClick: (ms) => ms.setSelected(itemOptions.slice(-3).map(o => o[0])) },
          { action: 'custom', text: 'Even Positions', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 2 === 0).map(o => o[0])) },
          { action: 'custom', text: 'Odd Positions', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 2 === 1).map(o => o[0])) },
          { action: 'custom', text: 'Random Selection', onClick: (ms) => {
            const shuffled = [...itemOptions].sort(() => Math.random() - 0.5);
            ms.setSelected(shuffled.slice(0, 3).map(o => o[0]));
          }},
          { action: 'custom', text: 'First Half', onClick: (ms) => ms.setSelected(itemOptions.slice(0, Math.ceil(itemOptions.length / 2)).map(o => o[0])) },
          { action: 'custom', text: 'Second Half', onClick: (ms) => ms.setSelected(itemOptions.slice(Math.ceil(itemOptions.length / 2)).map(o => o[0])) },
          { action: 'custom', text: 'Invert', onClick: (ms) => {
            const allValues = itemOptions.map(o => o[0]);
            const selectedValues = ms.getValue();
            const inverted = allValues.filter(v => !selectedValues.includes(v));
            ms.setSelected(inverted);
          }},
          { action: 'custom', text: 'Every Third', onClick: (ms) => ms.setSelected(itemOptions.filter((o, i) => i % 3 === 0).map(o => o[0])) },
          { action: 'custom', text: 'Shuffle All', onClick: (ms) => {
            const shuffled = [...itemOptions].sort(() => Math.random() - 0.5);
            ms.setSelected(shuffled.slice(0, 5).map(o => o[0]));
          }}
        ];

        wait('layout-nowrap').then((layoutNowrap) => {
          layoutNowrap.options = itemOptions;
          layoutNowrap.actionButtons = manyButtons;
          layoutNowrap.addEventListener('change', () => {
            document.getElementById('output-nowrap').textContent = JSON.stringify(layoutNowrap.getValue(), null, 2);
          });
        });

        wait('layout-wrap').then((layoutWrap) => {
          layoutWrap.options = itemOptions;
          layoutWrap.actionButtons = manyButtons;
          layoutWrap.addEventListener('change', () => {
            document.getElementById('output-wrap').textContent = JSON.stringify(layoutWrap.getValue(), null, 2);
          });
        });

        // Example 11: Font Awesome Icons
        const techOptions = [
          ['js', 'JavaScript'],
          ['ts', 'TypeScript'],
          ['py', 'Python'],
          ['java', 'Java'],
          ['cpp', 'C++'],
          ['go', 'Go'],
          ['rust', 'Rust'],
          ['php', 'PHP'],
          ['ruby', 'Ruby'],
          ['swift', 'Swift']
        ];

        wait('icon-buttons').then((iconButtons) => {
          iconButtons.options = techOptions;

          // CRITICAL: Inject Font Awesome into Shadow DOM
          iconButtons.customStylesCallback = () => `
            @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css');

            /* Optional: Style the icons */
            .ms__action-btn i {
              margin-right: 0.35rem;
            }
          `;

          iconButtons.actionButtons = [
            {
              action: 'select-all',
              text: '<i class="fas fa-check-double"></i> Select All',
              tooltip: 'Select all available technologies'
            },
            {
              action: 'clear-all',
              text: '<i class="fas fa-times"></i> Clear',
              tooltip: 'Clear all selections'
            },
            {
              action: 'custom',
              text: '<i class="fas fa-random"></i> Random',
              tooltip: 'Select 3 random technologies',
              onClick: (ms) => {
                const shuffled = [...techOptions].sort(() => Math.random() - 0.5);
                ms.setSelected(shuffled.slice(0, 3).map(o => o[0]));
              }
            },
            {
              action: 'custom',
              text: '<i class="fas fa-sync-alt"></i>',
              tooltip: 'Invert Selection',
              onClick: (ms) => {
                const allValues = techOptions.map(o => o[0]);
                const selectedValues = ms.getValue();
                const inverted = allValues.filter(v => !selectedValues.includes(v));
                ms.setSelected(inverted);
              }
            },
            {
              action: 'custom',
              text: 'Toggle',  // Fallback text
              getTextCallback: (ms) => {
                const count = ms.getSelected().length;
                const total = techOptions.length;
                const icon = count === total
                  ? '<i class="fas fa-toggle-on"></i>'
                  : '<i class="fas fa-toggle-off"></i>';
                return `${icon} ${count}/${total}`;
              },
              getTooltipCallback: (ms) => {
                const count = ms.getSelected().length;
                const total = techOptions.length;
                return count === total ? 'Deselect all' : 'Select all';
              },
              onClick: (ms) => {
                const count = ms.getSelected().length;
                const total = techOptions.length;
                if (count === total) {
                  ms.setSelected([]);
                } else {
                  ms.selectAll();
                }
              }
            }
          ];
          iconButtons.addEventListener('change', () => {
            document.getElementById('output-icons').textContent = JSON.stringify(iconButtons.getValue(), null, 2);
          });
        });

        // Example 12: Lucide (SVG) Icons — no font, no @font-face, no CSS injection.
        // Lucide SVGs use stroke="currentColor", so they inherit the button's text color.
        const lucide = (paths) => `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" `
          + `viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" `
          + `stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-3px">${paths}</svg>`;
        const luCheck   = lucide('<path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/>');
        const luX       = lucide('<path d="M18 6 6 18"/><path d="m6 6 12 12"/>');
        const luShuffle = lucide('<path d="m18 14 4 4-4 4"/><path d="m18 2 4 4-4 4"/><path d="M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22"/><path d="M2 6h1.972a4 4 0 0 1 3.6 2.2"/><path d="M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45"/>');
        const luRefresh = lucide('<path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/>');
        const luToggleOn  = lucide('<circle cx="15" cy="12" r="3"/><rect width="20" height="14" x="2" y="5" rx="7"/>');
        const luToggleOff = lucide('<circle cx="9" cy="12" r="3"/><rect width="20" height="14" x="2" y="5" rx="7"/>');

        wait('lucide-buttons').then((lucideButtons) => {
          lucideButtons.options = techOptions;
          // NOTE: no customStylesCallback — inline SVG needs no Shadow DOM style injection.
          lucideButtons.actionButtons = [
            {
              action: 'select-all',
              text: `${luCheck} Select All`,
              tooltip: 'Select all available technologies'
            },
            {
              action: 'clear-all',
              text: `${luX} Clear`,
              tooltip: 'Clear all selections'
            },
            {
              action: 'custom',
              text: `${luShuffle} Random`,
              tooltip: 'Select 3 random technologies',
              onClick: (ms) => {
                const shuffled = [...techOptions].sort(() => Math.random() - 0.5);
                ms.setSelected(shuffled.slice(0, 3).map(o => o[0]));
              }
            },
            {
              action: 'custom',
              text: luRefresh, // icon-only
              tooltip: 'Invert Selection',
              onClick: (ms) => {
                const allValues = techOptions.map(o => o[0]);
                const selectedValues = ms.getValue();
                const inverted = allValues.filter(v => !selectedValues.includes(v));
                ms.setSelected(inverted);
              }
            },
            {
              action: 'custom',
              text: 'Toggle',
              getTextCallback: (ms) => {
                const count = ms.getSelected().length;
                const total = techOptions.length;
                const icon = count === total ? luToggleOn : luToggleOff;
                return `${icon} ${count}/${total}`;
              },
              getTooltipCallback: (ms) => {
                const count = ms.getSelected().length;
                return count === techOptions.length ? 'Deselect all' : 'Select all';
              },
              onClick: (ms) => {
                const count = ms.getSelected().length;
                if (count === techOptions.length) {
                  ms.setSelected([]);
                } else {
                  ms.selectAll();
                }
              }
            }
          ];
          lucideButtons.addEventListener('change', () => {
            document.getElementById('output-lucide').textContent = JSON.stringify(lucideButtons.getValue(), null, 2);
          });
        });

        // Example 13: Positioning, Rows & Alignment
        const rowButtons = [
          { action: 'select-all', text: 'Select All', row: 1 },
          { action: 'clear-all',  text: 'Clear All',  row: 1 },
          { action: 'custom', text: 'First 3', row: 2, onClick: (ms) => ms.setSelected(itemOptions.slice(0, 3).map(o => o[0])) },
          { action: 'custom', text: 'Invert',  row: 2, onClick: (ms) => {
            const allValues = itemOptions.map(o => o[0]);
            const selectedValues = ms.getValue();
            ms.setSelected(allValues.filter(v => !selectedValues.includes(v)));
          }}
        ];

        wait('pos-top-rows').then((el) => {
          el.options = itemOptions;
          el.actionButtons = rowButtons;
        });

        wait('pos-bottom-rows').then((el) => {
          el.options = itemOptions;
          el.actionButtons = rowButtons;
        });

        const alignButtons = [
          { action: 'select-all', text: 'Select All' },
          { action: 'clear-all', text: 'Clear All' }
        ];

        wait('align-right').then((el) => {
          el.options = itemOptions;
          el.actionButtons = alignButtons;
        });

        wait('align-between').then((el) => {
          el.options = itemOptions;
          el.actionButtons = alignButtons;
        });
      </script>
    </.example_page>
    """
  end
end
