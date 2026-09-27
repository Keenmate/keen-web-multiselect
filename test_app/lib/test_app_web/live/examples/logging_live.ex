defmodule TestAppWeb.Examples.LoggingLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Logging & Debugging — keen_web_multiselect")}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🔍"
      title="Logging & Debugging"
      subtitle="Explore the categorized logging system with runtime controls"
    >
      <.note variant="warning">
        <strong>Note:</strong> Open your browser's Developer Console (F12) to see the log messages.
        By default, all logging is disabled in production.
      </.note>

      <style>
        .controls button { margin: 0.25rem; }

        .registry {
          display: grid;
          grid-template-columns: max-content 1fr;
          gap: 0.4rem 1rem;
        }
        .registry dt { color: #7dd3fc; white-space: nowrap; }
        .registry dd { margin: 0; color: #e2e8f0; word-break: break-word; }
        .registry .muted { color: #94a3b8; }
        .pill {
          display: inline-block;
          background: #1e293b;
          color: #7dd3fc;
          border: 1px solid #334155;
          border-radius: 999px;
          padding: 0.05rem 0.5rem;
          margin: 0 0.2rem 0.2rem 0;
          font-size: 0.78rem;
        }
        .pill.on { color: #86efac; border-color: #166534; background: #052e16; }
        .count-badge {
          display: inline-block;
          min-width: 1.4rem;
          text-align: center;
          background: #2563eb;
          color: #fff;
          border-radius: 999px;
          padding: 0.05rem 0.5rem;
          font-weight: 700;
        }
        #dynamic-hosts { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 0.75rem; }
        #dynamic-hosts:empty::after {
          content: "No dynamic instances yet — click \"Add a picker\".";
          color: #6b7280; font-style: italic;
        }
      </style>

      <.card title="LG01 · The registry entry">
        <.tip>
          Global registry (no wrapper attribute): the bundled <code>multiselect.js</code> auto-installs
          <code>window.components['web-multiselect']</code> via core's <code>registerComponent()</code>
        </.tip>
        <p>
          Every KeenMate component publishes one entry via core's
          <code>registerComponent()</code>. Below is a live view of
          <code>window.components['web-multiselect']</code>, refreshed automatically
          as instances connect and disconnect.
        </p>

        <div class="output">
          <div class="output-label">window.components['web-multiselect']</div>
          <dl class="log-panel log-panel--dark registry" id="registry-view"></dl>
        </div>

        <div class="controls">
          <button onclick="refreshRegistry()">Refresh</button>
          <button class="btn-outline" onclick="dumpToConsole()">console.log the entry</button>
        </div>
      </.card>

      <.card title="LG02 · Logging controls (via the .logging object)">
        <.tip>
          The <code>.logging</code> object is the flattened logger bundle:
          <code>{"reg().logging.setCategoryLevel('DATA', 'debug')"}</code>
        </.tip>
        <p>
          The <code>.logging</code> object is the flattened logger bundle. These
          buttons call it directly (e.g.
          <code>{"window.components['web-multiselect'].logging.setCategoryLevel('DATA','debug')"}</code>).
          The active category level is reflected in the registry panel above. Interact
          with the pickers to produce logs.
        </p>

        <div class="controls">
          <button onclick="reg().logging.enableLogging()">Enable all (debug)</button>
          <button class="secondary" onclick="reg().logging.disableLogging()">Disable all</button>
          <button class="btn-outline" onclick="reg().logging.setLogLevel('info')">All → info</button>
        </div>
        <div class="controls">
          <button onclick="onlyCategory('INIT')">Only INIT</button>
          <button onclick="onlyCategory('DATA')">Only DATA</button>
          <button onclick="onlyCategory('UI')">Only UI</button>
          <button onclick="onlyCategory('INTERACTION')">Only INTERACTION</button>
        </div>

        <.grid>
          <.form_group>
            <label>Fruits (basic)</label>
            <.web_multiselect
              id="registry-fruits"
              search_placeholder="Search fruits..."
              multiple={true}
            />
          </.form_group>
          <.form_group>
            <label>Colors (async search → DATA logs)</label>
            <.web_multiselect
              id="registry-colors"
              search_placeholder="Search colors..."
              multiple={true}
              close_on_select={false}
            />
          </.form_group>
        </.grid>
      </.card>

      <.card title="LG03 · Live instances (.getInstances())">
        <.tip>
          Global registry (no wrapper attribute): <code>{"reg().getInstances()"}</code>
          returns the connected <code>&lt;web-multiselect&gt;</code> elements
        </.tip>
        <p>
          <code>getInstances()</code> returns the connected elements of this tag —
          maintained automatically (added on connect, removed on disconnect). Add and
          remove pickers below and watch the count in the registry panel change; then
          fan a call out across every live instance.
        </p>

        <div class="controls">
          <button onclick="addPicker()">Add a picker</button>
          <button class="secondary" onclick="removePicker()">Remove last</button>
          <button class="btn-outline" onclick="logAllSelections()">Log every instance's selection</button>
        </div>

        <div id="dynamic-hosts"></div>
      </.card>

      <.card title="LG04 · Log categories">
        <ul>
          <li><strong>INIT</strong> - Component initialization, configuration parsing, RTL detection, destruction</li>
          <li><strong>DATA</strong> - Async data loading, option parsing, adding new options, errors</li>
          <li><strong>UI</strong> - Dropdown/popover/tooltip rendering, positioning, badges display</li>
          <li><strong>INTERACTION</strong> - Clicks, selections, keyboard events, closeOnSelect behavior</li>
        </ul>
      </.card>

      <.card title="LG05 · Usage">
        <p>Here's how to control logging programmatically:</p>

        <.code_block lang="js">{"// Import logging utilities\nimport { enableLogging, setLogLevel, setCategoryLevel, disableLogging }\n    from '@keenmate/web-multiselect';\n\n// Enable all logging at debug level\nenableLogging();\n\n// Set specific log level for all categories\nsetLogLevel('info');  // 'trace' | 'debug' | 'info' | 'warn' | 'error' | 'silent'\n\n// Enable/disable specific categories\ndisableLogging();  // First disable all\nsetCategoryLevel('UI', 'debug');  // Debug only UI operations\nsetCategoryLevel('DATA', 'info');  // Info level for data operations\nsetCategoryLevel('INTERACTION', 'silent');  // Disable interaction logs\n\n// Disable all logging (default for production)\ndisableLogging();"}</.code_block>
      </.card>

      <.card title="🧩 Wrapper-specific extras (not in upstream)">
        <.card title="Example 1: Basic Logging Control">
          <.tip>JS import (no attribute): call <code>enableLogging()</code> · <code>disableLogging()</code> · <code>setLogLevel("info")</code> from <code>@keenmate/web-multiselect</code></.tip>
          <p>Enable and disable logging at runtime. Watch the console as you interact with the multiselect.</p>

          <div class="controls">
            <button onclick="enableAllLogging()">Enable All Logging</button>
            <button onclick="disableAllLogging()" class="secondary">Disable All Logging</button>
            <button onclick="setInfoLevel()">Set to INFO level</button>
          </div>

          <.form_group>
            <.web_multiselect
              id="basic-example"
              search_placeholder="Search fruits..."
              multiple={true}
            />
          </.form_group>
        </.card>

        <.card title="Example 2: Category-Specific Logging">
          <.tip>JS import (no attribute): <code>setCategoryLevel("DATA", "debug")</code> per category · <code>{"close_on_select={false}"}</code> keeps the panel open while you watch logs</.tip>
          <p>
            Enable logging for specific categories only. This example has async search enabled - type to see DATA logs.
            Try enabling different categories to see different types of logs.
          </p>

          <div class="controls">
            <button onclick="enableInitLogging()">INIT Logs Only</button>
            <button onclick="enableDataLogging()">DATA Logs Only</button>
            <button onclick="enableUILogging()">UI Logs Only</button>
            <button onclick="enableInteractionLogging()">INTERACTION Logs Only</button>
          </div>

          <.form_group>
            <.web_multiselect
              id="category-example"
              search_placeholder="Search colors..."
              multiple={true}
              close_on_select={false}
            />
          </.form_group>
        </.card>

        <.card title="Example 3: Hybrid Static + Dynamic Search">
          <.tip><code>{"min_search_length={3}"}</code> gates the search · JS callback (no attribute): <code>el.beforeSearchCallback</code> strips accents before the query</.tip>
          <p>
            Show popular items initially, then switch to web service search. Demonstrates beforeSearchCallback for accent removal.
          </p>

          <div class="controls">
            <button onclick="enableDataLogging()">Enable DATA Logs</button>
            <button onclick="enableAllLogging()">Enable All Logs</button>
            <button onclick="disableAllLogging()" class="secondary">Disable All</button>
          </div>

          <.form_group>
            <.web_multiselect
              id="hybrid-example"
              search_placeholder="Search fruits (try 'açaí' or 'acai')..."
              multiple={true}
              min_search_length={3}
            />
            <small style="color: #6b7280; margin-top: 0.5rem; display: block;">
              Opens with 5 popular fruits. Type 3+ characters to search "database". Try "açaí" or "acai" to see accent removal working.
            </small>
          </.form_group>
        </.card>
      </.card>
    </.example_page>

    <script type="module">
      import { enableLogging, setLogLevel, setCategoryLevel, disableLogging } from '/keen_web_multiselect/multiselect.js';

      // ── Global registry (LG01–LG03) ──────────────────────────────────────
      // Importing the module above already ran registerComponent() →
      // window.components['web-multiselect'] is populated. Everything in the
      // LG01/LG02/LG03 cards goes through that global.
      const TAG = 'web-multiselect';
      const reg = () => window.components?.[TAG];
      window.reg = reg;

      const registryFruits = [
          { id: 1, name: 'Apple', emoji: '🍎' }, { id: 2, name: 'Banana', emoji: '🍌' },
          { id: 3, name: 'Cherry', emoji: '🍒' }, { id: 4, name: 'Grape', emoji: '🍇' },
          { id: 5, name: 'Orange', emoji: '🍊' }, { id: 6, name: 'Strawberry', emoji: '🍓' },
          { id: 7, name: 'Watermelon', emoji: '🍉' }
      ];
      const registryColors = [
          { id: 1, name: 'Red', hex: '#ef4444' }, { id: 2, name: 'Blue', hex: '#3b82f6' },
          { id: 3, name: 'Green', hex: '#10b981' }, { id: 4, name: 'Yellow', hex: '#f59e0b' },
          { id: 5, name: 'Purple', hex: '#8b5cf6' }, { id: 6, name: 'Pink', hex: '#ec4899' }
      ];
      const registryFruitCfg = (el) => {
          el.options = registryFruits;
          el.getValueCallback = (i) => i.id;
          el.getDisplayValueCallback = (i) => `${i.emoji} ${i.name}`;
      };

      // LG01 — registry inspector
      const registryEsc = (s) => String(s).replace(/[&<>]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]));

      window.refreshRegistry = () => {
          const view = document.getElementById('registry-view');
          if (!view) return;
          const r = reg();
          if (!r) { view.innerHTML = '<dt>status</dt><dd class="muted">not registered</dd>'; return; }

          const cfg = r.config || {};
          const cats = r.logging?.getCategories() ?? [];
          const instances = r.getInstances();
          const catPills = cats.map((c) => {
              const lvl = window.__catLevel?.[c];
              const on = lvl && lvl !== 'silent';
              return `<span class="pill ${on ? 'on' : ''}">${registryEsc(c.split(':')[1] || c)}${on ? ` · ${lvl}` : ''}</span>`;
          }).join('');
          const instPills = instances.length
              ? instances.map((el, i) => `<span class="pill">${registryEsc(el.id || `#${i}`)}</span>`).join('')
              : '<span class="muted">none connected</span>';

          view.innerHTML = `
              <dt>version()</dt><dd>${registryEsc(r.version())}</dd>
              <dt>config.name</dt><dd>${registryEsc(cfg.name ?? '—')}</dd>
              <dt>config.author</dt><dd>${registryEsc(cfg.author ?? '—')}</dd>
              <dt>config.license</dt><dd>${registryEsc(cfg.license ?? '—')}</dd>
              <dt>logging</dt><dd>${cats.length ? catPills : '<span class="muted">no bundle</span>'}</dd>
              <dt>getInstances()</dt><dd><span class="count-badge">${instances.length}</span> &nbsp; ${instPills}</dd>
          `;
      };

      window.dumpToConsole = () => {
          const r = reg();
          console.log('%cwindow.components[\'web-multiselect\']', 'color:#3b82f6;font-weight:bold;font-size:1.1rem;', r);
          console.log('config:', r?.config);
          console.log('getInstances():', r?.getInstances());
      };

      // LG02 — logging controls. Track category levels we set so the panel can
      // reflect them (the bundle has no getter for effective level).
      window.__catLevel = {};
      window.onlyCategory = (cat) => {
          const r = reg();
          r.logging.disableLogging();
          r.logging.setCategoryLevel(cat, 'debug');
          const cats = r.logging.getCategories();
          window.__catLevel = {};
          for (const c of cats) window.__catLevel[c] = 'silent';
          const full = cats.find((c) => c.endsWith(':' + cat)) ?? cat;
          window.__catLevel[full] = 'debug';
          console.log(`%c▶ only ${cat} → debug`, 'color:#8b5cf6;font-weight:bold;');
          refreshRegistry();
      };
      // Mirror the bulk controls too.
      const registryWrapLevels = () => {
          const r = reg(); if (!r?.logging) return;
          const l = r.logging;
          const cats = l.getCategories();
          const _enable = l.enableLogging.bind(l), _disable = l.disableLogging.bind(l), _set = l.setLogLevel.bind(l);
          l.enableLogging = (lvl = 'debug') => { _enable(lvl); cats.forEach((c) => (window.__catLevel[c] = lvl)); refreshRegistry(); };
          l.disableLogging = () => { _disable(); cats.forEach((c) => (window.__catLevel[c] = 'silent')); refreshRegistry(); };
          l.setLogLevel = (lvl) => { _set(lvl); cats.forEach((c) => (window.__catLevel[c] = lvl)); refreshRegistry(); };
      };

      // LG03 — live instances
      let registryDynN = 0;
      window.addPicker = () => {
          const host = document.getElementById('dynamic-hosts');
          const wrap = document.createElement('div');
          wrap.className = 'form-group';
          const label = document.createElement('label');
          label.textContent = `Dynamic picker #${++registryDynN}`;
          const el = document.createElement('web-multiselect');
          el.id = `dyn-${registryDynN}`;
          el.setAttribute('is-multiple-enabled', 'true');
          el.setAttribute('search-placeholder', 'Search fruits...');
          wrap.append(label, el);
          host.appendChild(wrap);
          registryFruitCfg(el); // connectedCallback already fired on append
          console.log(`%c＋ connected ${el.id} — getInstances(): ${reg().getInstances().length}`, 'color:#10b981;font-weight:bold;');
          refreshRegistry();
      };
      window.removePicker = () => {
          const host = document.getElementById('dynamic-hosts');
          const last = host.lastElementChild;
          if (!last) return;
          const id = last.querySelector('web-multiselect')?.id;
          host.removeChild(last);
          console.log(`%c－ disconnected ${id} — getInstances(): ${reg().getInstances().length}`, 'color:#ef4444;font-weight:bold;');
          refreshRegistry();
      };
      window.logAllSelections = () => {
          const rows = reg().getInstances().map((el) => ({ id: el.id, selected: el.getSelected().map((o) => o.name ?? o.value ?? o) }));
          console.log('%c🗂 selections across all live instances', 'color:#3b82f6;font-weight:bold;');
          console.table(rows);
      };

      // Sample data
      const fruits = [
          { id: 1, name: 'Apple', emoji: '🍎' },
          { id: 2, name: 'Banana', emoji: '🍌' },
          { id: 3, name: 'Cherry', emoji: '🍒' },
          { id: 4, name: 'Grape', emoji: '🍇' },
          { id: 5, name: 'Orange', emoji: '🍊' },
          { id: 6, name: 'Strawberry', emoji: '🍓' },
          { id: 7, name: 'Watermelon', emoji: '🍉' }
      ];

      const colors = [
          { id: 1, name: 'Red', hex: '#ef4444' },
          { id: 2, name: 'Blue', hex: '#3b82f6' },
          { id: 3, name: 'Green', hex: '#10b981' },
          { id: 4, name: 'Yellow', hex: '#f59e0b' },
          { id: 5, name: 'Purple', hex: '#8b5cf6' },
          { id: 6, name: 'Pink', hex: '#ec4899' }
      ];

      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // Wait for custom element to be defined, then initialize
      customElements.whenDefined('web-multiselect').then(async () => {
          // ── LG01–LG03 boot ───────────────────────────────────────────────
          registryWrapLevels();

          const registryFruitsEl = await wait('registry-fruits');
          registryFruitCfg(registryFruitsEl);

          const registryColorsEl = await wait('registry-colors');
          registryColorsEl.options = registryColors;
          registryColorsEl.getValueCallback = (i) => i.id;
          registryColorsEl.getDisplayValueCallback = (i) => i.name;
          registryColorsEl.getSubtitleCallback = (i) => i.hex;
          registryColorsEl.searchCallback = async (term) => {
              await new Promise((r) => setTimeout(r, 300));
              if (!term) return registryColors;
              const q = term.toLowerCase();
              return registryColors.filter((c) => c.name.toLowerCase().includes(q) || c.hex.includes(q));
          };

          // Start silent (production default), then paint the panel.
          reg().logging.disableLogging();
          refreshRegistry();

          console.log('%c🌐 window.components demo ready', 'color:#3b82f6;font-size:1.3rem;font-weight:bold;');
          console.log('Try: %cwindow.components[\'web-multiselect\']', 'font-family:monospace;background:#eef;padding:2px 4px;');

          // Keep the instance list honest even if instances change outside our buttons.
          setInterval(() => refreshRegistry(), 2000);

          // Initialize Example 1 - Basic multiselect with fruits
          const basicElement = await wait('basic-example');
          if (basicElement) {
              basicElement.options = fruits;
              basicElement.getValueCallback = (item) => item.id;
              basicElement.getDisplayValueCallback = (item) => `${item.emoji} ${item.name}`;
          }

          // Initialize Example 2 - Async search with colors
          const categoryElement = await wait('category-example');
          if (categoryElement) {
              categoryElement.options = colors;
              categoryElement.getValueCallback = (item) => item.id;
              categoryElement.getDisplayValueCallback = (item) => item.name;
              categoryElement.getSubtitleCallback = (item) => item.hex;

              // Add search callback to demonstrate DATA logging
              categoryElement.searchCallback = async (searchTerm) => {
                  // Simulate async search with delay
                  await new Promise(resolve => setTimeout(resolve, 300));

                  // Filter colors based on search term
                  if (!searchTerm) return colors;

                  const lowerSearch = searchTerm.toLowerCase();
                  return colors.filter(color =>
                      color.name.toLowerCase().includes(lowerSearch) ||
                      color.hex.includes(lowerSearch)
                  );
              };
          }

          // Initialize Example 3 - Hybrid static + dynamic search
          const hybridElement = await wait('hybrid-example');
          if (hybridElement) {
              // 5 popular fruits shown initially
              const popularFruits = [
                  { id: 1, name: 'Apple', emoji: '🍎' },
                  { id: 2, name: 'Banana', emoji: '🍌' },
                  { id: 3, name: 'Orange', emoji: '🍊' },
                  { id: 4, name: 'Strawberry', emoji: '🍓' },
                  { id: 5, name: 'Watermelon', emoji: '🍉' }
              ];

              // Helper function to normalize names for searching
              const normalizeForSearch = (text) => {
                  return text.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
              };

              // "Database" with all fruits for search (including accented names)
              const allFruitsRaw = [
                  ...popularFruits,
                  { id: 6, name: 'Cherry', emoji: '🍒' },
                  { id: 7, name: 'Grape', emoji: '🍇' },
                  { id: 8, name: 'Lemon', emoji: '🍋' },
                  { id: 9, name: 'Peach', emoji: '🍑' },
                  { id: 10, name: 'Pear', emoji: '🍐' },
                  { id: 11, name: 'Pineapple', emoji: '🍍' },
                  { id: 12, name: 'Mango', emoji: '🥭' },
                  { id: 13, name: 'Kiwi', emoji: '🥝' },
                  { id: 14, name: 'Coconut', emoji: '🥥' },
                  { id: 15, name: 'Avocado', emoji: '🥑' },
                  { id: 16, name: 'Açaí', emoji: '🫐' },
                  { id: 17, name: 'Açerola', emoji: '🍒' },
                  { id: 18, name: 'Papaya', emoji: '🟠' }
              ];

              // Add normalized search values to all fruits
              const allFruits = allFruitsRaw.map(fruit => ({
                  ...fruit,
                  searchValue: normalizeForSearch(fruit.name)
              }));

              // Log the database contents
              console.log('%c📊 Example 3: Fruit Database Contents', 'color: #3b82f6; font-size: 1.2rem; font-weight: bold;');
              console.log('%cPopular fruits (shown initially):', 'color: #10b981; font-weight: bold;');
              console.table(popularFruits);
              console.log('%cAll fruits (searchable via database):', 'color: #10b981; font-weight: bold;');
              console.table(allFruits);

              // Set initial popular fruits
              hybridElement.options = popularFruits;
              hybridElement.getValueCallback = (item) => item.id;
              hybridElement.getDisplayValueCallback = (item) => `${item.emoji} ${item.name}`;

              // beforeSearchCallback: Remove accents and validate
              hybridElement.beforeSearchCallback = (searchTerm) => {
                  // Remove accents (e.g., café → cafe)
                  const normalized = searchTerm.normalize('NFD').replace(/[̀-ͯ]/g, '');

                  // If different, log the transformation
                  if (normalized !== searchTerm) {
                      console.log(`%c🔄 beforeSearchCallback: "${searchTerm}" → "${normalized}"`,
                          'color: #8b5cf6; font-weight: bold;');
                  }

                  return normalized;
              };

              // searchCallback: Simulate database search
              hybridElement.searchCallback = async (searchTerm) => {
                  console.log(`%c🔍 Searching database for: "${searchTerm}"`,
                      'color: #3b82f6; font-weight: bold;');

                  // Simulate network delay
                  await new Promise(resolve => setTimeout(resolve, 500));

                  // Search in "database" using normalized searchValue field
                  const lowerSearch = searchTerm.toLowerCase();
                  console.log(`%c   Searching for "${lowerSearch}" in searchValues:`, 'color: #6b7280;',
                      allFruits.map(f => `${f.name} (${f.searchValue})`));

                  const results = allFruits.filter(fruit => {
                      const matches = fruit.searchValue.includes(lowerSearch);
                      if (matches) {
                          console.log(`%c   ✓ Match: "${fruit.name}" (searchValue: "${fruit.searchValue}")`, 'color: #10b981;');
                      }
                      return matches;
                  });

                  console.log(`%c✅ Database returned ${results.length} results`,
                      'color: #10b981; font-weight: bold;', results);

                  return results;
              };
          }
      });

      // Make logging functions globally available
      window.enableAllLogging = () => {
          enableLogging();
          console.log('%c✅ All logging enabled at DEBUG level', 'color: #10b981; font-weight: bold;');
      };

      window.disableAllLogging = () => {
          disableLogging();
          console.log('%c❌ All logging disabled', 'color: #ef4444; font-weight: bold;');
      };

      window.setInfoLevel = () => {
          setLogLevel('info');
          console.log('%cℹ️ Log level set to INFO', 'color: #3b82f6; font-weight: bold;');
      };

      window.enableInitLogging = () => {
          disableLogging();
          setCategoryLevel('INIT', 'debug');
          console.log('%c🚀 INIT logging enabled', 'color: #8b5cf6; font-weight: bold;');
      };

      window.enableDataLogging = () => {
          disableLogging();
          setCategoryLevel('DATA', 'debug');
          console.log('%c📦 DATA logging enabled', 'color: #8b5cf6; font-weight: bold;');
      };

      window.enableUILogging = () => {
          disableLogging();
          setCategoryLevel('UI', 'debug');
          console.log('%c🎨 UI logging enabled', 'color: #8b5cf6; font-weight: bold;');
      };

      window.enableInteractionLogging = () => {
          disableLogging();
          setCategoryLevel('INTERACTION', 'debug');
          console.log('%c👆 INTERACTION logging enabled', 'color: #8b5cf6; font-weight: bold;');
      };

      console.log('%c📊 MultiSelect Logging Examples', 'color: #3b82f6; font-size: 1.5rem; font-weight: bold;');
      console.log('%cBy default, logging is DISABLED. Use the buttons above to enable specific categories.', 'color: #6b7280;');
    </script>
    """
  end
end
