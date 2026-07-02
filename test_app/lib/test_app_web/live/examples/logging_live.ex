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

      <.card title="Example 1: Basic Logging Control">
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

      <.card title="📝 Available Log Categories">
        <ul>
          <li><strong>INIT</strong> - Component initialization, configuration parsing, RTL detection, destruction</li>
          <li><strong>DATA</strong> - Async data loading, option parsing, adding new options, errors</li>
          <li><strong>UI</strong> - Dropdown/popover/tooltip rendering, positioning, badges display</li>
          <li><strong>INTERACTION</strong> - Clicks, selections, keyboard events, closeOnSelect behavior</li>
        </ul>
      </.card>

      <.card title="💡 Usage in Your Code">
        <p>Here's how to control logging programmatically:</p>

        <.code_block lang="js">{"// Import logging utilities\nimport { enableLogging, setLogLevel, setCategoryLevel, disableLogging }\n    from '@keenmate/web-multiselect';\n\n// Enable all logging at debug level\nenableLogging();\n\n// Set specific log level for all categories\nsetLogLevel('info');  // 'trace' | 'debug' | 'info' | 'warn' | 'error' | 'silent'\n\n// Enable/disable specific categories\ndisableLogging();  // First disable all\nsetCategoryLevel('UI', 'debug');  // Debug only UI operations\nsetCategoryLevel('DATA', 'info');  // Info level for data operations\nsetCategoryLevel('INTERACTION', 'silent');  // Disable interaction logs\n\n// Disable all logging (default for production)\ndisableLogging();"}</.code_block>
      </.card>
    </.example_page>

    <script type="module">
      import { enableLogging, setLogLevel, setCategoryLevel, disableLogging } from '/keen_web_multiselect/multiselect.js';

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
