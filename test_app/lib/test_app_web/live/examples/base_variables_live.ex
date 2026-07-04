defmodule TestAppWeb.Examples.BaseVariablesLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  @frameworks [
    %{value: "react", label: "React", subtitle: "Meta"},
    %{value: "vue", label: "Vue.js", subtitle: "Evan You"},
    %{value: "angular", label: "Angular", subtitle: "Google"},
    %{value: "svelte", label: "Svelte", subtitle: "Rich Harris"},
    %{value: "solid", label: "SolidJS", subtitle: "Ryan Carniato"}
  ]

  @languages [
    %{value: "typescript", label: "TypeScript"},
    %{value: "javascript", label: "JavaScript"},
    %{value: "python", label: "Python"},
    %{value: "rust", label: "Rust"},
    %{value: "go", label: "Go"}
  ]

  @grouped [
    %{value: "react", label: "React", group: "Frontend"},
    %{value: "vue", label: "Vue.js", group: "Frontend"},
    %{value: "angular", label: "Angular", group: "Frontend"},
    %{value: "nodejs", label: "Node.js", group: "Backend"},
    %{value: "django", label: "Django", group: "Backend"},
    %{value: "rails", label: "Ruby on Rails", group: "Backend"},
    %{value: "postgres", label: "PostgreSQL", group: "Database"},
    %{value: "mongodb", label: "MongoDB", group: "Database"},
    %{value: "redis", label: "Redis", group: "Database"}
  ]

  @default_values_text ":root {\n  /* No overrides set - using component defaults */\n}"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Base Variables — keen_web_multiselect")
     |> assign(:default_values_text, @default_values_text)
     |> assign(:frameworks, @frameworks)
     |> assign(:languages, @languages)
     |> assign(:grouped, @grouped)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🎨"
      title="Base Variables"
      subtitle="Theme-designer typography integration with --base-* variables for fonts, sizes, and weights"
    >
      <style>
        .controls { background: white; border-radius: 0.5rem; padding: 1.5rem; margin-bottom: 2rem; box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1); }
        .controls-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
        .controls-header h2 { margin: 0; font-size: 1.25rem; border: none; padding: 0; }
        .reset-btn { background: #e53e3e; color: #fff; border: none; padding: 0.5rem 1rem; border-radius: 0.375rem; cursor: pointer; }
        .reset-btn:hover { background: #c53030; }
        .control-section { margin-bottom: 1.5rem; }
        .control-section:last-child { margin-bottom: 0; }
        .control-section h3 { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; color: #6b7280; margin: 0 0 0.75rem 0; border-bottom: 1px solid #e5e7eb; padding-bottom: 0.5rem; }
        .section-desc { font-size: 0.75rem; color: #6b7280; margin: 0 0 0.75rem 0; line-height: 1.4; }
        .section-desc strong { color: #374151; }
        .control-row { display: flex; flex-wrap: wrap; gap: 1rem; align-items: flex-end; }
        .control-group { display: flex; flex-direction: column; gap: 0.25rem; }
        .control-group label { font-size: 0.75rem; color: #374151; font-weight: 500; }
        .control-group input { padding: 0.5rem; border: 1px solid #d1d5db; border-radius: 0.375rem; font-size: 0.875rem; }
        .control-group input[type="text"] { width: 250px; }
        .control-group input[type="number"] { width: 80px; }
        .font-link-input { width: 500px !important; }

        .current-values { background: #1f2937; color: #a5d6a7; border-radius: 0.5rem; padding: 1rem; margin-top: 2rem; font-family: 'Courier New', Consolas, Monaco, monospace; font-size: 0.75rem; line-height: 1.6; white-space: pre-wrap; max-height: 300px; overflow-y: auto; }
        .current-values-header { color: #93c5fd; font-weight: bold; margin-bottom: 0.5rem; }
      </style>

      <.card title="Typography Controls">
        <div class="controls">
          <div class="controls-header">
            <h2>Typography Controls</h2>
            <button class="reset-btn" id="resetBtn">Reset All</button>
          </div>

          <div class="control-section">
            <h3>Font Link (Google Fonts, etc.)</h3>
            <div class="control-row">
              <div class="control-group">
                <label for="fontLink">Paste &lt;link&gt; tag or URL</label>
                <input
                  type="text"
                  id="fontLink"
                  class="font-link-input"
                  placeholder="e.g., https://fonts.googleapis.com/css2?family=Lexend..."
                />
              </div>
              <button id="loadFontBtn" class="btn-outline">Load Font</button>
            </div>
          </div>

          <div class="control-section">
            <h3>Font Family</h3>
            <div class="control-row">
              <div class="control-group">
                <label for="fontFamily">--base-font-family</label>
                <input type="text" id="fontFamily" placeholder="e.g., 'Lexend', sans-serif" />
              </div>
            </div>
          </div>

          <div class="control-section">
            <h3>Font Sizes (unitless multipliers)</h3>
            <p class="section-desc">
              <strong>2xs:</strong> tiny labels &bull; <strong>xs:</strong>
              group labels, hints &bull; <strong>sm:</strong>
              option text, badges &bull; <strong>base:</strong>
              input text &bull; <strong>lg:</strong> large displays
            </p>
            <div class="control-row">
              <div class="control-group">
                <label for="fontSize2xs">2xs</label>
                <input type="number" id="fontSize2xs" value="1" step="0.1" />
              </div>
              <div class="control-group">
                <label for="fontSizeXs">xs</label>
                <input type="number" id="fontSizeXs" value="1.2" step="0.1" />
              </div>
              <div class="control-group">
                <label for="fontSizeSm">sm</label>
                <input type="number" id="fontSizeSm" value="1.4" step="0.1" />
              </div>
              <div class="control-group">
                <label for="fontSizeBase">base</label>
                <input type="number" id="fontSizeBase" value="1.6" step="0.1" />
              </div>
              <div class="control-group">
                <label for="fontSizeLg">lg</label>
                <input type="number" id="fontSizeLg" value="1.8" step="0.1" />
              </div>
            </div>
          </div>

          <div class="control-section">
            <h3>Font Weights</h3>
            <div class="control-row">
              <div class="control-group">
                <label for="fontWeightNormal">normal</label>
                <input type="number" id="fontWeightNormal" value="400" step="100" min="100" max="900" />
              </div>
              <div class="control-group">
                <label for="fontWeightMedium">medium</label>
                <input type="number" id="fontWeightMedium" value="500" step="100" min="100" max="900" />
              </div>
              <div class="control-group">
                <label for="fontWeightSemibold">semibold</label>
                <input
                  type="number"
                  id="fontWeightSemibold"
                  value="600"
                  step="100"
                  min="100"
                  max="900"
                />
              </div>
            </div>
          </div>

          <div class="control-section">
            <h3>Line Heights</h3>
            <div class="control-row">
              <div class="control-group">
                <label for="lineHeightTight">tight</label>
                <input type="number" id="lineHeightTight" value="1.25" step="0.05" min="1" max="3" />
              </div>
              <div class="control-group">
                <label for="lineHeightNormal">normal</label>
                <input type="number" id="lineHeightNormal" value="1.5" step="0.05" min="1" max="3" />
              </div>
              <div class="control-group">
                <label for="lineHeightRelaxed">relaxed</label>
                <input
                  type="number"
                  id="lineHeightRelaxed"
                  value="1.75"
                  step="0.05"
                  min="1"
                  max="3"
                />
              </div>
            </div>
          </div>
        </div>
      </.card>

      <.grid>
        <.card title="Single Select">
          <.tip><code>{"multiple={false}"}</code> — one value, no badges</.tip>
          <p>Basic single selection. Tests input styling and dropdown typography.</p>
          <.web_multiselect
            id="singleSelect"
            placeholder="Select a framework..."
            multiple={false}
            options={@frameworks}
          />
        </.card>

        <.card title="Multi Select with Badges">
          <.tip><code>badges_display_mode="badges"</code> · <code>{"show_checkboxes={true}"}</code></.tip>
          <p>Multiple selection with badge display. Tests badge typography and sizing.</p>
          <.web_multiselect
            id="multiBadges"
            placeholder="Select frameworks..."
            badges_display_mode="badges"
            show_checkboxes={true}
            options={@frameworks}
            value={~w(react vue)}
          />
        </.card>

        <.card title="Multi Select with Count">
          <.tip><code>badges_display_mode="count"</code> collapses badges into a counter</.tip>
          <p>Count display mode. Tests counter typography.</p>
          <.web_multiselect
            id="multiCount"
            placeholder="Select languages..."
            badges_display_mode="count"
            show_checkboxes={true}
            options={@languages}
            value={~w(typescript javascript rust)}
          />
        </.card>

        <.card title="Grouped Options">
          <.tip><code>{"allow_groups={true}"}</code> renders <code>group</code>-keyed option headers</.tip>
          <p>Tests group label typography and styling.</p>
          <.web_multiselect
            id="grouped"
            placeholder="Select technologies..."
            show_checkboxes={true}
            allow_groups={true}
            options={@grouped}
            value={~w(react nodejs)}
          />
        </.card>
      </.grid>

      <div class="current-values">
        <div class="current-values-header">/* Current --base-* CSS Variables */</div>
        <div id="currentValues" phx-update="ignore">{@default_values_text}</div>
      </div>
    </.example_page>

    <script type="module">
      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // Variable mappings
      const variableMap = {
        fontFamily: '--base-font-family',
        fontSize2xs: '--base-font-size-2xs',
        fontSizeXs: '--base-font-size-xs',
        fontSizeSm: '--base-font-size-sm',
        fontSizeBase: '--base-font-size-base',
        fontSizeLg: '--base-font-size-lg',
        fontWeightNormal: '--base-font-weight-normal',
        fontWeightMedium: '--base-font-weight-medium',
        fontWeightSemibold: '--base-font-weight-semibold',
        lineHeightTight: '--base-line-height-tight',
        lineHeightNormal: '--base-line-height-normal',
        lineHeightRelaxed: '--base-line-height-relaxed'
      };

      // Track current values
      const currentValues = {};

      // Current font URL for Shadow DOM injection
      let currentFontUrl = '';

      // Update CSS variable
      function updateVariable(inputId, value) {
        const varName = variableMap[inputId];
        if (!varName) return;

        if (value === '' || value === null || value === undefined) {
          // Remove the variable
          document.documentElement.style.removeProperty(varName);
          delete currentValues[varName];
        } else {
          // Set the variable
          // Font sizes are unitless multipliers (component multiplies by --ms-rem)
          document.documentElement.style.setProperty(varName, value);
          currentValues[varName] = value;
        }

        updateDisplay();
      }

      // Update the display of current values
      function updateDisplay() {
        const display = document.getElementById('currentValues');
        const keys = Object.keys(currentValues);

        if (keys.length === 0) {
          display.textContent = `:root {
      /* No overrides set - using component defaults */
    }`;
        } else {
          const lines = keys.map(k => `  ${k}: ${currentValues[k]};`).join('\n');
          display.textContent = `:root {\n${lines}\n}`;
        }
      }

      // Reset all variables
      function resetAll() {
        // Clear all inputs
        Object.keys(variableMap).forEach(inputId => {
          const input = document.getElementById(inputId);
          if (input) {
            input.value = '';
          }
          const varName = variableMap[inputId];
          document.documentElement.style.removeProperty(varName);
        });

        // Clear font link
        document.getElementById('fontLink').value = '';
        currentFontUrl = '';
        const existingLink = document.getElementById('customFontLink');
        if (existingLink) {
          existingLink.remove();
        }

        // Clear tracking
        Object.keys(currentValues).forEach(k => delete currentValues[k]);
        updateDisplay();

        // Re-initialize multiselects to refresh custom styles
        initMultiselects();
      }

      // Set up event listeners
      Object.keys(variableMap).forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
          input.addEventListener('input', (e) => {
            updateVariable(inputId, e.target.value);
          });
        }
      });

      // Reset button
      document.getElementById('resetBtn').addEventListener('click', resetAll);

      // Load font button
      document.getElementById('loadFontBtn').addEventListener('click', () => {
        const input = document.getElementById('fontLink');
        let value = input.value.trim();

        if (!value) return;

        // Extract URL if it's a full <link> tag
        const hrefMatch = value.match(/href=["']([^"']+)["']/);
        if (hrefMatch) {
          value = hrefMatch[1];
        }

        currentFontUrl = value;

        // Remove existing font link if present
        const existingLink = document.getElementById('customFontLink');
        if (existingLink) {
          existingLink.remove();
        }

        // Create and add new link
        const link = document.createElement('link');
        link.id = 'customFontLink';
        link.rel = 'stylesheet';
        link.href = value;
        document.head.appendChild(link);

        // Try to extract font family name from URL
        const familyMatch = value.match(/family=([^:&]+)/);
        if (familyMatch) {
          const fontName = decodeURIComponent(familyMatch[1].replace(/\+/g, ' '));
          const fontFamilyInput = document.getElementById('fontFamily');
          fontFamilyInput.value = `'${fontName}', sans-serif`;
          updateVariable('fontFamily', fontFamilyInput.value);
        }

        // Re-initialize multiselects to inject fonts into Shadow DOM
        initMultiselects();
      });

      async function initMultiselects() {
        // Generate custom styles callback with current font URL
        const customStylesCallback = () => {
          if (currentFontUrl) {
            return `@import url('${currentFontUrl}');`;
          }
          return '';
        };

        // Single select
        const singleSelect = await wait('singleSelect');
        singleSelect.customStylesCallback = customStylesCallback;

        // Multi select with badges
        const multiBadges = await wait('multiBadges');
        multiBadges.customStylesCallback = customStylesCallback;

        // Multi select with count
        const multiCount = await wait('multiCount');
        multiCount.customStylesCallback = customStylesCallback;

        // Grouped
        const groupedEl = await wait('grouped');
        groupedEl.customStylesCallback = customStylesCallback;
      }

      // Apply initial values on page load
      Object.keys(variableMap).forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input && input.value) {
          updateVariable(inputId, input.value);
        }
      });

      // Wait for custom element to be defined
      customElements.whenDefined('web-multiselect').then(() => {
        initMultiselects();
      });
    </script>
    """
  end
end
