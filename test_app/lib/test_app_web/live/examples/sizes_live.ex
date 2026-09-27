defmodule TestAppWeb.Examples.SizesLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  @options [
    %{value: "react", label: "React"},
    %{value: "vue", label: "Vue.js"},
    %{value: "angular", label: "Angular"},
    %{value: "svelte", label: "Svelte"},
    %{value: "typescript", label: "TypeScript"},
    %{value: "javascript", label: "JavaScript"},
    %{value: "python", label: "Python"},
    %{value: "nodejs", label: "Node.js"},
    %{value: "rust", label: "Rust"},
    %{value: "go", label: "Go"}
  ]

  @countries [
    %{code: "US", name: "United States", flag: "🇺🇸"},
    %{code: "CZ", name: "Czech Republic", flag: "🇨🇿"},
    %{code: "DE", name: "Germany", flag: "🇩🇪"},
    %{code: "GB", name: "United Kingdom", flag: "🇬🇧"},
    %{code: "FR", name: "France", flag: "🇫🇷"},
    %{code: "JP", name: "Japan", flag: "🇯🇵"},
    %{code: "CA", name: "Canada", flag: "🇨🇦"},
    %{code: "AU", name: "Australia", flag: "🇦🇺"}
  ]

  @currencies [
    %{code: "USD", name: "US Dollar", symbol: "$"},
    %{code: "EUR", name: "Euro", symbol: "€"},
    %{code: "GBP", name: "British Pound", symbol: "£"},
    %{code: "JPY", name: "Japanese Yen", symbol: "¥"},
    %{code: "CZK", name: "Czech Koruna", symbol: "Kč"},
    %{code: "CHF", name: "Swiss Franc", symbol: "Fr"}
  ]

  @priorities [
    %{code: "H", name: "High Priority", color: "🔴"},
    %{code: "M", name: "Medium Priority", color: "🟡"},
    %{code: "L", name: "Low Priority", color: "🟢"}
  ]

  @rem_code ~S"""
  <!-- Scale entire component by changing --ms-rem -->
  <web-multiselect style="--ms-rem: 8px;"></web-multiselect>  <!-- 80% size -->
  <web-multiselect style="--ms-rem: 12px;"></web-multiselect> <!-- 120% size -->

  <!-- Or via CSS class -->
  <style>
    web-multiselect.compact { --ms-rem: 8px; }
    web-multiselect.large { --ms-rem: 15px; }
  </style>
  """

  @fine_code ~S"""
  <style>
    #my-multiselect {
      --ms-input-font-size: 18px;
      --ms-input-padding: 12px 16px;
      --ms-option-title-font-size: 16px;
    }
  </style>
  """

  @narrow_code ~S"""
  <!-- Narrow input with wide dropdown -->
  <web-multiselect
    style="width: 4rem;"
    dropdown-min-width="20rem"
    multiple="false">
  </web-multiselect>

  <script>
    // Show just the code in the closed input
    select.renderSelectedContentCallback = (item) => item.code;
    // Show full label in dropdown
    select.getDisplayValueCallback = (item) => `${item.flag} ${item.name}`;
  </script>
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Sizes & Fonts — keen_web_multiselect")
     |> assign(:options, @options)
     |> assign(:countries, @countries)
     |> assign(:currencies, @currencies)
     |> assign(:priorities, @priorities)
     |> assign(:rem_code, @rem_code)
     |> assign(:fine_code, @fine_code)
     |> assign(:narrow_code, @narrow_code)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="📏"
      title="Sizes & Fonts"
      subtitle="Control input dimensions and typography with preset sizes, custom fonts, and REM-based scaling"
    >
      <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Montserrat:wght@400;500;600&family=Fira+Code:wght@400;500&family=Quicksand:wght@400;500;600&family=Lexend:wght@400;500;600&display=swap');
      </style>

      <.card title="TH12 · Global Scaling with --ms-rem">
        <.tip>Scale everything from one variable: <code>style="--ms-rem: 8px"</code> (default <code>10px</code>)</.tip>
        <p>
          The <code>--ms-rem</code>
          CSS variable (default: 10px) controls the base unit for all dimensions. Change it to scale the entire component proportionally.
        </p>

        <.code_block>{@rem_code}</.code_block>

        <.grid>
          <div :for={
            {id, title, desc, rem} <- [
              {"rem-compact", "Compact (--ms-rem: 8px)", "80% of default size - great for dense UIs", "8px"},
              {"rem-default", "Default (--ms-rem: 10px)", "Standard sizing - balanced for most uses", "10px"},
              {"rem-large", "Large (--ms-rem: 12px)", "120% of default - better touch targets", "12px"},
              {"rem-xl", "Extra Large (--ms-rem: 15px)", "150% of default - accessibility focused", "15px"}
            ]
          }>
            <label>{title}</label>
            <small class="form-text">{desc}</small>
            <.web_multiselect
              id={id}
              style={"--ms-rem: #{rem};"}
              placeholder={"#{String.replace(title, ~r/ \(.*/, "")} scaling..."}
              multiple={false}
              options={@options}
            />
          </div>
        </.grid>
      </.card>

      <.card title="TH13 · Fine-Grained Control">
        <.tip>Target one dimension at a time: <code>--ms-input-font-size</code> · <code>--ms-input-padding</code> · <code>--ms-option-title-font-size</code></.tip>
        <p>Override individual CSS variables for precise control over specific dimensions.</p>

        <.code_block>{@fine_code}</.code_block>

        <.grid>
          <div>
            <label>Custom Variables Override</label>
            <small class="form-text">Larger font, more padding</small>
            <.web_multiselect
              id="custom-vars"
              style="--ms-input-font-size: 18px; --ms-input-padding: 12px 16px; --ms-option-title-font-size: 16px;"
              placeholder="Custom sizing..."
              multiple={false}
              options={@options}
            />
          </div>
          <div>
            <label>Default for Comparison</label>
            <small class="form-text">Standard defaults</small>
            <.web_multiselect
              id="default-compare"
              placeholder="Default sizing..."
              multiple={false}
              options={@options}
            />
          </div>
        </.grid>
      </.card>

      <.card title="TH14 · Narrow Input, Wide Dropdown">
        <.tip><code>dropdown_min_width="18rem"</code> keeps the panel readable while <code>style="width: 6rem"</code> shrinks the input</.tip>
        <p>
          For dense forms where input space is limited: show just a code in the input, but use <code>dropdown-min-width</code>
          to ensure the dropdown is comfortable for selection.
        </p>

        <.code_block>{@narrow_code}</.code_block>

        <.grid>
          <div>
            <label>Country Selector</label>
            <small class="form-text">Input: 6rem, Dropdown: 18rem</small>
            <.web_multiselect
              id="narrow-country"
              style="width: 6rem;"
              dropdown_min_width="18rem"
              multiple={false}
              placeholder="--"
              options={@countries}
              value_member="code"
              display_value_member="name"
            />
          </div>

          <div>
            <label>Currency Selector</label>
            <small class="form-text">Input: 7rem, Dropdown: 16rem</small>
            <.web_multiselect
              id="narrow-currency"
              style="width: 7rem;"
              dropdown_min_width="16rem"
              multiple={false}
              placeholder="---"
              options={@currencies}
              value_member="code"
              display_value_member="name"
            />
          </div>

          <div>
            <label>Priority Selector</label>
            <small class="form-text">Input: 5rem, Dropdown: 14rem</small>
            <.web_multiselect
              id="narrow-priority"
              style="width: 5rem;"
              dropdown_min_width="14rem"
              multiple={false}
              placeholder="-"
              options={@priorities}
              value_member="code"
              display_value_member="name"
            />
          </div>
        </.grid>
      </.card>

      <.card title="TH15 · Scaled with Multiple Selection">
        <.tip><code>style="--ms-rem: 8px"</code> · <code>{"show_checkboxes={true}"}</code> · <code>badges_display_mode="badges | count"</code></.tip>
        <p>All component parts (badges, options, checkboxes) scale together.</p>

        <.grid>
          <div>
            <label>Compact with Badges</label>
            <small class="form-text"><code>--ms-rem: 8px</code></small>
            <.web_multiselect
              id="multi-compact"
              style="--ms-rem: 8px;"
              placeholder="Select items..."
              show_checkboxes={true}
              badges_display_mode="badges"
              options={@options}
              value={~w(react typescript)}
            />
          </div>

          <div>
            <label>Default with Badges</label>
            <small class="form-text"><code>--ms-rem: 10px</code></small>
            <.web_multiselect
              id="multi-default"
              placeholder="Select items..."
              show_checkboxes={true}
              badges_display_mode="badges"
              options={@options}
              value={~w(react typescript)}
            />
          </div>

          <div>
            <label>Large with Badges</label>
            <small class="form-text"><code>--ms-rem: 12px</code></small>
            <.web_multiselect
              id="multi-large"
              style="--ms-rem: 12px;"
              placeholder="Select items..."
              show_checkboxes={true}
              badges_display_mode="badges"
              options={@options}
              value={~w(react typescript)}
            />
          </div>

          <div>
            <label>XL with Count Display</label>
            <small class="form-text"><code>--ms-rem: 15px</code></small>
            <.web_multiselect
              id="multi-xl"
              style="--ms-rem: 15px;"
              placeholder="Select items..."
              show_checkboxes={true}
              badges_display_mode="count"
              options={@options}
              value={~w(react typescript)}
            />
          </div>
        </.grid>
      </.card>

      <.card title="TH16 · Font Families">
        <.tip><code>style="--base-font-family: 'Inter', sans-serif"</code> — any CSS font stack works</.tip>
        <p>
          Set <code>--base-font-family</code>
          on the element to change the font. Works with any CSS font stack.
        </p>

        <.grid>
          <div :for={
            {id, title, stack, placeholder} <- [
              {"font-system", "System UI (Default)", "system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, sans-serif",
               "System font stack..."},
              {"font-inter", "Inter", "\"Inter\", sans-serif", "Modern, clean typeface..."},
              {"font-montserrat", "Montserrat", "\"Montserrat\", sans-serif", "Geometric elegance..."},
              {"font-quicksand", "Quicksand", "\"Quicksand\", sans-serif", "Rounded and friendly..."},
              {"font-lexend", "Lexend", "\"Lexend\", sans-serif", "Optimized for readability..."},
              {"font-mono", "Fira Code (Monospace)", "\"Fira Code\", monospace", "For code-like UIs..."}
            ]
          }>
            <label>{title}</label>
            <small class="form-text"><code>--base-font-family: {stack}</code></small>
            <.web_multiselect
              id={id}
              style={"--base-font-family: #{stack};"}
              placeholder={placeholder}
              multiple={false}
              options={@options}
            />
          </div>
        </.grid>
      </.card>

      <.card title="TH17 · Key CSS Variables">
        <p>Important variables for sizing and typography:</p>

        <table class="reference-table">
          <thead>
            <tr>
              <th>Variable</th>
              <th>Default</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><code>--ms-rem</code></td>
              <td>10px</td>
              <td>Base unit - scales everything proportionally</td>
            </tr>
            <tr>
              <td><code>--ms-input-font-size</code></td>
              <td>calc(1.4 * var(--ms-rem))</td>
              <td>Input text size (14px default)</td>
            </tr>
            <tr>
              <td><code>--ms-input-padding</code></td>
              <td>calc(0.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem))</td>
              <td>Input padding</td>
            </tr>
            <tr>
              <td><code>--ms-option-title-font-size</code></td>
              <td>calc(1.4 * var(--ms-rem))</td>
              <td>Option text size</td>
            </tr>
            <tr>
              <td><code>--ms-badge-font-size</code></td>
              <td>calc(1.2 * var(--ms-rem))</td>
              <td>Badge text size</td>
            </tr>
          </tbody>
        </table>

        <p style="font-size: 0.875rem; color: #6b7280; margin-top: 1rem;">
          <strong>Note:</strong>
          CSS variables must be set on the <code>&lt;web-multiselect&gt;</code>
          element itself (or via inherited CSS), not on wrapper divs, due to Shadow DOM encapsulation.
        </p>
      </.card>

      <.card title="TH18 · Typography Variables">
        <p>All typography variables with their theme-designer integration:</p>

        <table class="reference-table">
          <thead>
            <tr>
              <th>Variable</th>
              <th>Default</th>
              <th>Theme Designer Source</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><code>--ms-font-size-2xs</code></td>
              <td>10px</td>
              <td><code>--base-font-size-2xs</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-size-xs</code></td>
              <td>12px</td>
              <td><code>--base-font-size-xs</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-size-sm</code></td>
              <td>14px</td>
              <td><code>--base-font-size-sm</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-size-base</code></td>
              <td>16px</td>
              <td><code>--base-font-size-base</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-size-lg</code></td>
              <td>18px</td>
              <td><code>--base-font-size-lg</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-weight-normal</code></td>
              <td>400</td>
              <td><code>--base-font-weight-normal</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-weight-medium</code></td>
              <td>500</td>
              <td><code>--base-font-weight-medium</code></td>
            </tr>
            <tr>
              <td><code>--ms-font-weight-semibold</code></td>
              <td>600</td>
              <td><code>--base-font-weight-semibold</code></td>
            </tr>
            <tr>
              <td><code>--ms-line-height-tight</code></td>
              <td>1.25</td>
              <td><code>--base-line-height-tight</code></td>
            </tr>
            <tr>
              <td><code>--ms-line-height-normal</code></td>
              <td>1.5</td>
              <td><code>--base-line-height-normal</code></td>
            </tr>
            <tr>
              <td><code>--ms-line-height-relaxed</code></td>
              <td>1.75</td>
              <td><code>--base-line-height-relaxed</code></td>
            </tr>
          </tbody>
        </table>
      </.card>
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

      const googleFontsImport = `
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Montserrat:wght@400;500;600&family=Fira+Code:wght@400;500&family=Quicksand:wght@400;500;600&family=Lexend:wght@400;500;600&display=swap');
      `;

      // Inject Google Fonts into the Shadow DOM of every multiselect on the page
      document.querySelectorAll('web-multiselect').forEach((el) => {
        const apply = (node) => { node.customStylesCallback = () => googleFontsImport; };
        if (el.tagName.toLowerCase() === 'web-multiselect' && 'customStylesCallback' in el) apply(el);
        else wait(el.id).then(apply);
      });

      // Narrow country selector: flag + name in dropdown, code in closed input
      wait('narrow-country').then((el) => {
        el.getDisplayValueCallback = (item) => `${item.flag} ${item.name}`;
        el.renderSelectedContentCallback = (item) => item.code;
        el.value = 'US';
      });

      // Narrow currency selector: symbol + code + name in dropdown, code in input
      wait('narrow-currency').then((el) => {
        el.getDisplayValueCallback = (item) => `${item.symbol} ${item.code} - ${item.name}`;
        el.renderSelectedContentCallback = (item) => item.code;
        el.value = 'USD';
      });

      // Narrow priority selector: color + name in dropdown, code in input
      wait('narrow-priority').then((el) => {
        el.getDisplayValueCallback = (item) => `${item.color} ${item.name}`;
        el.renderSelectedContentCallback = (item) => item.code;
        el.value = 'M';
      });
    </script>
    """
  end
end
