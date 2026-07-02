defmodule TestAppWeb.Examples.ClassicLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Datasets below mirror upstream's examples-classic.0.js verbatim so this page
  # can be diffed card-for-card against the upstream demo.

  @technologies [
    %{value: "js", label: "JavaScript"},
    %{value: "ts", label: "TypeScript"},
    %{value: "python", label: "Python"},
    %{value: "java", label: "Java"},
    %{value: "csharp", label: "C#"},
    %{value: "php", label: "PHP"},
    %{value: "ruby", label: "Ruby"},
    %{value: "go", label: "Go"}
  ]

  @countries [
    %{value: "us", label: "United States"},
    %{value: "uk", label: "United Kingdom"},
    %{value: "de", label: "Germany"},
    %{value: "fr", label: "France"},
    %{value: "es", label: "Spain"},
    %{value: "it", label: "Italy"},
    %{value: "jp", label: "Japan"},
    %{value: "cn", label: "China"}
  ]

  @languages [
    %{value: "js", label: "JavaScript", icon: "🟨"},
    %{value: "ts", label: "TypeScript", icon: "🔷"},
    %{value: "python", label: "Python", icon: "🐍"},
    %{value: "java", label: "Java", icon: "☕"},
    %{value: "csharp", label: "C#", icon: "💜"},
    %{value: "php", label: "PHP", icon: "🐘"},
    %{value: "ruby", label: "Ruby", icon: "💎"},
    %{value: "go", label: "Go", icon: "🐹"}
  ]

  @frameworks [
    %{value: "react", label: "React", icon: "⚛️", subtitle: "A JavaScript library for building user interfaces"},
    %{value: "vue", label: "Vue.js", icon: "🖖", subtitle: "The Progressive JavaScript Framework"},
    %{value: "angular", label: "Angular", icon: "🅰️", subtitle: "Platform for building web applications"},
    %{value: "svelte", label: "Svelte", icon: "🔥", subtitle: "Cybernetically enhanced web apps"},
    %{value: "solid", label: "Solid", icon: "💎", subtitle: "Simple and performant reactivity"}
  ]

  @categories [
    %{value: "cat1", label: "Category 1"},
    %{value: "cat2", label: "Category 2"},
    %{value: "cat3", label: "Category 3"},
    %{value: "cat4", label: "Category 4"},
    %{value: "cat5", label: "Category 5"},
    %{value: "cat6", label: "Category 6"}
  ]

  @cities [
    %{value: "nyc", label: "New York", icon: "🗽"},
    %{value: "lon", label: "London", icon: "🇬🇧"},
    %{value: "par", label: "Paris", icon: "🇫🇷"},
    %{value: "tok", label: "Tokyo", icon: "🇯🇵"},
    %{value: "syd", label: "Sydney", icon: "🇦🇺"},
    %{value: "ber", label: "Berlin", icon: "🇩🇪"},
    %{value: "rom", label: "Rome", icon: "🇮🇹"},
    %{value: "bar", label: "Barcelona", icon: "🇪🇸"},
    %{value: "ams", label: "Amsterdam", icon: "🇳🇱"},
    %{value: "dub", label: "Dubai", icon: "🇦🇪"}
  ]

  @grouped_techs [
    %{value: "react", label: "React", icon: "⚛️", group: "frontend"},
    %{value: "vue", label: "Vue.js", icon: "🖖", group: "frontend"},
    %{value: "svelte", label: "Svelte", icon: "🔥", group: "frontend"},
    %{value: "angular", label: "Angular", icon: "🅰️", group: "frontend"},
    %{value: "nodejs", label: "Node.js", icon: "🟢", group: "backend"},
    %{value: "django", label: "Django", icon: "🐍", group: "backend"},
    %{value: "rails", label: "Ruby on Rails", icon: "💎", group: "backend"},
    %{value: "express", label: "Express", icon: "🚂", group: "backend"},
    %{value: "postgres", label: "PostgreSQL", icon: "🐘", group: "database"},
    %{value: "mongodb", label: "MongoDB", icon: "🍃", group: "database"},
    %{value: "redis", label: "Redis", icon: "🔴", group: "database"}
  ]

  # Tech stack used across the Display Modes / Tooltip demos.
  @tech_stack [
    %{value: "js", label: "JavaScript", icon: "🟨"},
    %{value: "ts", label: "TypeScript", icon: "🔷"},
    %{value: "py", label: "Python", icon: "🐍"},
    %{value: "java", label: "Java", icon: "☕"},
    %{value: "cpp", label: "C++", icon: "⚡"},
    %{value: "rust", label: "Rust", icon: "🦀"},
    %{value: "go", label: "Go", icon: "🔵"},
    %{value: "ruby", label: "Ruby", icon: "💎"},
    %{value: "php", label: "PHP", icon: "🐘"},
    %{value: "swift", label: "Swift", icon: "🍎"}
  ]

  @arabic_langs [
    %{value: "js", label: "جافا سكريبت", icon: "🟨"},
    %{value: "ts", label: "تايب سكريبت", icon: "🔷"},
    %{value: "python", label: "بايثون", icon: "🐍"},
    %{value: "java", label: "جافا", icon: "☕"},
    %{value: "react", label: "ري أكت", icon: "⚛️"},
    %{value: "vue", label: "فيو", icon: "💚"}
  ]

  @all_countries [
    %{value: "af", label: "Afghanistan"},
    %{value: "al", label: "Albania"},
    %{value: "dz", label: "Algeria"},
    %{value: "ar", label: "Argentina"},
    %{value: "am", label: "Armenia"},
    %{value: "au", label: "Australia"},
    %{value: "at", label: "Austria"},
    %{value: "az", label: "Azerbaijan"},
    %{value: "bh", label: "Bahrain"},
    %{value: "bd", label: "Bangladesh"},
    %{value: "by", label: "Belarus"},
    %{value: "be", label: "Belgium"},
    %{value: "bz", label: "Belize"},
    %{value: "bo", label: "Bolivia"},
    %{value: "br", label: "Brazil"},
    %{value: "bg", label: "Bulgaria"},
    %{value: "kh", label: "Cambodia"},
    %{value: "cm", label: "Cameroon"},
    %{value: "ca", label: "Canada"},
    %{value: "cl", label: "Chile"},
    %{value: "cn", label: "China"},
    %{value: "co", label: "Colombia"},
    %{value: "cr", label: "Costa Rica"},
    %{value: "hr", label: "Croatia"},
    %{value: "cu", label: "Cuba"},
    %{value: "cy", label: "Cyprus"},
    %{value: "cz", label: "Czech Republic"},
    %{value: "dk", label: "Denmark"},
    %{value: "ec", label: "Ecuador"},
    %{value: "eg", label: "Egypt"},
    %{value: "sv", label: "El Salvador"},
    %{value: "ee", label: "Estonia"},
    %{value: "et", label: "Ethiopia"},
    %{value: "fi", label: "Finland"},
    %{value: "fr", label: "France"},
    %{value: "ge", label: "Georgia"},
    %{value: "de", label: "Germany"},
    %{value: "gh", label: "Ghana"},
    %{value: "gr", label: "Greece"},
    %{value: "gt", label: "Guatemala"},
    %{value: "hn", label: "Honduras"},
    %{value: "hk", label: "Hong Kong"},
    %{value: "hu", label: "Hungary"},
    %{value: "is", label: "Iceland"},
    %{value: "in", label: "India"},
    %{value: "id", label: "Indonesia"},
    %{value: "ir", label: "Iran"},
    %{value: "iq", label: "Iraq"},
    %{value: "ie", label: "Ireland"},
    %{value: "il", label: "Israel"},
    %{value: "it", label: "Italy"},
    %{value: "jm", label: "Jamaica"},
    %{value: "jp", label: "Japan"},
    %{value: "jo", label: "Jordan"},
    %{value: "kz", label: "Kazakhstan"},
    %{value: "ke", label: "Kenya"},
    %{value: "kw", label: "Kuwait"},
    %{value: "lv", label: "Latvia"},
    %{value: "lb", label: "Lebanon"},
    %{value: "lt", label: "Lithuania"},
    %{value: "lu", label: "Luxembourg"},
    %{value: "my", label: "Malaysia"},
    %{value: "mt", label: "Malta"},
    %{value: "mx", label: "Mexico"},
    %{value: "ma", label: "Morocco"},
    %{value: "np", label: "Nepal"},
    %{value: "nl", label: "Netherlands"},
    %{value: "nz", label: "New Zealand"},
    %{value: "ng", label: "Nigeria"},
    %{value: "no", label: "Norway"},
    %{value: "om", label: "Oman"},
    %{value: "pk", label: "Pakistan"},
    %{value: "pa", label: "Panama"},
    %{value: "py", label: "Paraguay"},
    %{value: "pe", label: "Peru"},
    %{value: "ph", label: "Philippines"},
    %{value: "pl", label: "Poland"},
    %{value: "pt", label: "Portugal"},
    %{value: "qa", label: "Qatar"},
    %{value: "ro", label: "Romania"},
    %{value: "ru", label: "Russia"},
    %{value: "sa", label: "Saudi Arabia"},
    %{value: "rs", label: "Serbia"},
    %{value: "sg", label: "Singapore"},
    %{value: "sk", label: "Slovakia"},
    %{value: "si", label: "Slovenia"},
    %{value: "za", label: "South Africa"},
    %{value: "kr", label: "South Korea"},
    %{value: "es", label: "Spain"},
    %{value: "lk", label: "Sri Lanka"},
    %{value: "se", label: "Sweden"},
    %{value: "ch", label: "Switzerland"},
    %{value: "tw", label: "Taiwan"},
    %{value: "th", label: "Thailand"},
    %{value: "tr", label: "Turkey"},
    %{value: "ua", label: "Ukraine"},
    %{value: "ae", label: "United Arab Emirates"},
    %{value: "uk", label: "United Kingdom"},
    %{value: "us", label: "United States"},
    %{value: "uy", label: "Uruguay"},
    %{value: "ve", label: "Venezuela"},
    %{value: "vn", label: "Vietnam"}
  ]

  # Search Modes demo data — non-canonical keys (id/name/flag), so *_member attrs
  # are passed explicitly on those controls.
  @countries_with_flags [
    %{id: 1, name: "Canada", flag: "🇨🇦"},
    %{id: 2, name: "United States", flag: "🇺🇸"},
    %{id: 3, name: "Mexico", flag: "🇲🇽"},
    %{id: 4, name: "United Kingdom", flag: "🇬🇧"},
    %{id: 5, name: "France", flag: "🇫🇷"},
    %{id: 6, name: "Germany", flag: "🇩🇪"},
    %{id: 7, name: "Italy", flag: "🇮🇹"},
    %{id: 8, name: "Spain", flag: "🇪🇸"},
    %{id: 9, name: "Japan", flag: "🇯🇵"},
    %{id: 10, name: "China", flag: "🇨🇳"},
    %{id: 11, name: "India", flag: "🇮🇳"},
    %{id: 12, name: "Brazil", flag: "🇧🇷"},
    %{id: 13, name: "Argentina", flag: "🇦🇷"},
    %{id: 14, name: "Australia", flag: "🇦🇺"},
    %{id: 15, name: "New Zealand", flag: "🇳🇿"},
    %{id: 16, name: "South Africa", flag: "🇿🇦"},
    %{id: 17, name: "Egypt", flag: "🇪🇬"},
    %{id: 18, name: "Nigeria", flag: "🇳🇬"},
    %{id: 19, name: "Russia", flag: "🇷🇺"},
    %{id: 20, name: "Poland", flag: "🇵🇱"},
    %{id: 21, name: "Sweden", flag: "🇸🇪"},
    %{id: 22, name: "Norway", flag: "🇳🇴"},
    %{id: 23, name: "Denmark", flag: "🇩🇰"},
    %{id: 24, name: "Finland", flag: "🇫🇮"},
    %{id: 25, name: "Netherlands", flag: "🇳🇱"},
    %{id: 26, name: "Belgium", flag: "🇧🇪"},
    %{id: 27, name: "Switzerland", flag: "🇨🇭"},
    %{id: 28, name: "Austria", flag: "🇦🇹"},
    %{id: 29, name: "Portugal", flag: "🇵🇹"},
    %{id: 30, name: "Greece", flag: "🇬🇷"},
    %{id: 31, name: "Turkey", flag: "🇹🇷"},
    %{id: 32, name: "South Korea", flag: "🇰🇷"},
    %{id: 33, name: "Thailand", flag: "🇹🇭"},
    %{id: 34, name: "Vietnam", flag: "🇻🇳"},
    %{id: 35, name: "Indonesia", flag: "🇮🇩"},
    %{id: 36, name: "Philippines", flag: "🇵🇭"},
    %{id: 37, name: "Singapore", flag: "🇸🇬"},
    %{id: 38, name: "Malaysia", flag: "🇲🇾"},
    %{id: 39, name: "Pakistan", flag: "🇵🇰"},
    %{id: 40, name: "Bangladesh", flag: "🇧🇩"},
    %{id: 41, name: "Colombia", flag: "🇨🇴"},
    %{id: 42, name: "Chile", flag: "🇨🇱"},
    %{id: 43, name: "Peru", flag: "🇵🇪"},
    %{id: 44, name: "Venezuela", flag: "🇻🇪"},
    %{id: 45, name: "Saudi Arabia", flag: "🇸🇦"},
    %{id: 46, name: "United Arab Emirates", flag: "🇦🇪"},
    %{id: 47, name: "Israel", flag: "🇮🇱"},
    %{id: 48, name: "Iran", flag: "🇮🇷"},
    %{id: 49, name: "Iraq", flag: "🇮🇶"},
    %{id: 50, name: "Ukraine", flag: "🇺🇦"}
  ]

  # Initial 5 security groups (non-canonical id/name/description keys). The full
  # async search list lives in the inline script as a searchCallback.
  @security_groups [
    %{id: "sg-001", name: "Web Servers", description: "HTTP/HTTPS access (80, 443)", icon: "🌐"},
    %{id: "sg-002", name: "Database Servers", description: "MySQL/PostgreSQL (3306, 5432)", icon: "🗄️"},
    %{id: "sg-003", name: "Application Servers", description: "Internal API access (8080)", icon: "⚙️"},
    %{id: "sg-004", name: "Load Balancers", description: "ALB/NLB traffic", icon: "⚖️"},
    %{id: "sg-005", name: "Cache Servers", description: "Redis/Memcached (6379, 11211)", icon: "💾"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Classic Examples — keen_web_multiselect")
     |> assign(:technologies, @technologies)
     |> assign(:countries, @countries)
     |> assign(:languages, @languages)
     |> assign(:frameworks, @frameworks)
     |> assign(:categories, @categories)
     |> assign(:cities, @cities)
     |> assign(:grouped_techs, @grouped_techs)
     |> assign(:tech_stack, @tech_stack)
     |> assign(:arabic_langs, @arabic_langs)
     |> assign(:all_countries, @all_countries)
     |> assign(:countries_with_flags, @countries_with_flags)
     |> assign(:security_groups, @security_groups)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="📦"
      title="Classic Examples"
      subtitle="Traditional multiselect demos showing basic functionality and common use cases."
    >
      <.card title="✨ Declarative Usage (No JavaScript Required!)">
        <p>
          Use standard HTML <code>&lt;option&gt;</code>
          elements - no JavaScript needed for simple cases! The component reads <code>value</code>, <code>selected</code>, and <code>data-*</code> attributes from each option.
        </p>

        <.grid>
          <.form_group>
            <label>Simple Choice</label>
            <.web_multiselect
              id="declarative-single"
              multiple={false}
              search_placeholder="Select your answer..."
            >
              <option value="yes">Yes</option>
              <option value="no">No</option>
              <option value="maybe" selected>Maybe / I don't know</option>
            </.web_multiselect>
            <small class="form-text">No JavaScript required - pure HTML!</small>
          </.form_group>

          <.form_group>
            <label>Multiple Fruits</label>
            <.web_multiselect id="declarative-fruits" search_placeholder="Select fruits...">
              <option value="apple" data-icon="🍎">Apple</option>
              <option value="banana" data-icon="🍌" selected>Banana</option>
              <option value="orange" data-icon="🍊">Orange</option>
              <option value="grape" data-icon="🍇" selected>Grape</option>
              <option value="strawberry" data-icon="🍓">Strawberry</option>
            </.web_multiselect>
            <small class="form-text">Icons via <code>data-icon</code> attribute</small>
          </.form_group>
        </.grid>

        <.grid style="margin-top: 1.5rem;">
          <.form_group>
            <label>Grouped Options</label>
            <.web_multiselect
              id="declarative-grouped"
              search_placeholder="Select programming languages..."
            >
              <optgroup label="Frontend">
                <option value="js" data-icon="🟨">JavaScript</option>
                <option value="ts" data-icon="🔷">TypeScript</option>
                <option value="html" data-icon="📄">HTML</option>
              </optgroup>
              <optgroup label="Backend">
                <option value="python" data-icon="🐍" selected>Python</option>
                <option value="java" data-icon="☕">Java</option>
                <option value="go" data-icon="🐹">Go</option>
              </optgroup>
            </.web_multiselect>
            <small class="form-text">Use <code>&lt;optgroup&gt;</code> for grouping</small>
          </.form_group>

          <.form_group>
            <label>With Subtitles</label>
            <.web_multiselect id="declarative-subtitles" search_placeholder="Select framework...">
              <option
                value="react"
                data-icon="⚛️"
                data-subtitle="A JavaScript library for building UIs"
              >
                React
              </option>
              <option
                value="vue"
                data-icon="🖖"
                data-subtitle="The Progressive JavaScript Framework"
              >
                Vue.js
              </option>
              <option
                value="svelte"
                data-icon="🔥"
                data-subtitle="Cybernetically enhanced web apps"
                selected
              >
                Svelte
              </option>
            </.web_multiselect>
            <small class="form-text">Use <code>data-subtitle</code> for descriptions</small>
          </.form_group>

          <.form_group>
            <label>Custom Group Labels</label>
            <.web_multiselect
              id="custom-groups-classic"
              options={@grouped_techs}
              allow_groups={true}
              value={~w(react nodejs)}
            />
            <small class="form-text">
              Using <code>renderGroupLabelContentCallback</code>
              to customize group headers
            </small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Single-Select Mode">
        <p>
          Only one item can be selected at a time. Use <code>{"multiple={false}"}</code>
        </p>

        <.grid>
          <.form_group>
            <label>Select Programming Language</label>
            <.web_multiselect
              id="single-select"
              multiple={false}
              search_placeholder="Select language..."
              options={@languages}
              value={["python"]}
            />
            <small class="form-text">Only one language can be selected</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Single-Select: Keyboard Navigation Only">
        <p>
          No search - use arrow keys, PageUp/PageDown, Home/End to navigate. Press Enter to select.
        </p>

        <.grid>
          <.form_group>
            <label>Select Country (No Search)</label>
            <.web_multiselect
              id="keyboard-nav-select"
              multiple={false}
              enable_search={false}
              search_input_mode="readonly"
              search_placeholder="Use arrow keys to navigate..."
              options={@all_countries}
              value={["us"]}
            />
            <small class="form-text">
              Try: ↑/↓ arrows, PageUp/Down (10 items), Home/End, Enter to select
            </small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Basic MultiSelect">
        <p>Simple multiselect with basic options</p>

        <.grid>
          <.form_group>
            <label>Select Technologies</label>
            <.web_multiselect
              id="basic-select"
              search_placeholder="Search technologies..."
              options={@technologies}
              value={["js", "ts"]}
            />
            <small class="form-text">Select multiple programming languages</small>
          </.form_group>

          <.form_group>
            <label>Select Countries</label>
            <.web_multiselect
              id="countries-select"
              search_placeholder="Search countries..."
              options={@countries}
            />
            <small class="form-text">Start typing to filter options</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Rich Content with Icons">
        <p>Options with icons, subtitles, and multiline content</p>

        <.grid>
          <.form_group>
            <label>Select Frameworks</label>
            <.web_multiselect
              id="frameworks-select"
              search_placeholder="Search frameworks..."
              options={@frameworks}
            />
            <small class="form-text">Options with icons and descriptions</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Search Hint">
        <p>Display helpful text above the input to guide users</p>

        <.grid>
          <.form_group>
            <label>With Search Hint</label>
            <.web_multiselect
              id="hint-select"
              search_hint="💡 Start typing to filter options"
              search_placeholder="Search cities..."
              options={@cities}
            />
            <small class="form-text">Open the dropdown to see the hint above the input</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Display Modes">
        <p>Different ways to display selected items</p>

        <h3 style="margin-top: 1.5rem; margin-bottom: 1rem; font-size: 1.2rem; color: #667eea;">
          Basic Display Modes
        </h3>
        <.grid>
          <.form_group>
            <label>Badges Mode (Default)</label>
            <.web_multiselect
              id="badges-mode"
              badges_display_mode="badges"
              search_placeholder="Select technologies..."
              options={@tech_stack}
              value={~w(js ts py)}
            />
            <small class="form-text">Shows each selection as a removable badge</small>
          </.form_group>

          <.form_group>
            <label>Count Mode</label>
            <.web_multiselect
              id="count-mode"
              badges_display_mode="count"
              search_placeholder="Select technologies..."
              options={@tech_stack}
              value={~w(js ts py java)}
            />
            <small class="form-text">Shows "X selected" text with clear button</small>
          </.form_group>

          <.form_group>
            <label>Compact Mode</label>
            <.web_multiselect
              id="compact-mode"
              badges_display_mode="compact"
              search_placeholder="Select technologies..."
              options={@tech_stack}
              value={~w(js ts py)}
            />
            <small class="form-text">First item + count in single badge: "JavaScript (+2 more)"</small>
          </.form_group>

          <.form_group>
            <label>Partial Mode</label>
            <.web_multiselect
              id="partial-mode"
              badges_threshold={5}
              badges_threshold_mode="partial"
              badges_max_visible={3}
              search_placeholder="Select technologies..."
              options={@tech_stack}
              value={~w(js ts py java cpp rust)}
            />
            <small class="form-text">Shows first 3 badges + "+X more" badge (when >5 selected)</small>
          </.form_group>

          <.form_group>
            <label>None Mode (Minimal)</label>
            <.web_multiselect
              id="none-mode"
              badges_display_mode="none"
              show_counter={true}
              search_placeholder="Select technologies..."
              options={@tech_stack}
              value={~w(js ts py java cpp)}
            />
            <small class="form-text">No badges shown - only [X] badge next to toggle</small>
          </.form_group>
        </.grid>

        <h3 style="margin-top: 2rem; margin-bottom: 1rem; font-size: 1.2rem; color: #667eea;">
          Display Mode + Counter Combinations
        </h3>
        <.grid>
          <.form_group>
            <label>Badges + Counter</label>
            <.web_multiselect
              id="badges-badge"
              badges_display_mode="badges"
              show_counter={true}
              search_placeholder="Select..."
              options={@tech_stack}
              value={~w(js ts)}
            />
            <small class="form-text">Individual badges + [X] badge</small>
          </.form_group>

          <.form_group>
            <label>Count + Counter</label>
            <.web_multiselect
              id="count-badge"
              badges_display_mode="count"
              show_counter={true}
              search_placeholder="Select..."
              options={@tech_stack}
              value={~w(js ts py)}
            />
            <small class="form-text">"X selected" text + [X] badge (double count display)</small>
          </.form_group>

          <.form_group>
            <label>Compact + Counter</label>
            <.web_multiselect
              id="compact-badge"
              badges_display_mode="compact"
              show_counter={true}
              search_placeholder="Select..."
              options={@tech_stack}
              value={~w(js ts py)}
            />
            <small class="form-text">First item + count badge + [X] badge</small>
          </.form_group>
        </.grid>

        <h3 style="margin-top: 2rem; margin-bottom: 1rem; font-size: 1.2rem; color: #667eea;">
          Threshold Auto-Switching
        </h3>
        <.grid>
          <.form_group>
            <label>Badges → Count at 3</label>
            <.web_multiselect
              id="threshold-count"
              badges_display_mode="badges"
              badges_threshold={3}
              badges_threshold_mode="count"
              show_counter={true}
              search_placeholder="Select..."
              options={@tech_stack}
              value={~w(js)}
            />
            <small class="form-text">Badges when ≤3, switches to count when >3</small>
          </.form_group>

          <.form_group>
            <label>Badges → Partial at 5</label>
            <.web_multiselect
              id="threshold-partial"
              badges_threshold={5}
              badges_threshold_mode="partial"
              badges_max_visible={3}
              search_placeholder="Select..."
              options={@tech_stack}
              value={~w(js ts)}
            />
            <small class="form-text">Badges when ≤5, shows 3 badges + "+X more" when >5</small>
          </.form_group>
        </.grid>

        <h3 style="margin-top: 2rem; margin-bottom: 1rem; font-size: 1.2rem; color: #667eea;">
          Internationalization (i18n)
        </h3>
        <.grid>
          <.form_group>
            <label>English Pluralization</label>
            <.web_multiselect
              id="i18n-english"
              badges_display_mode="count"
              search_placeholder="Select..."
              options={@categories}
              value={~w(cat1 cat2 cat3)}
            />
            <small class="form-text">"1 item selected" vs "3 items selected"</small>
          </.form_group>

          <.form_group>
            <label>Czech Pluralization</label>
            <.web_multiselect
              id="i18n-czech"
              badges_display_mode="count"
              search_placeholder="Vyberte..."
              options={@categories}
              value={~w(cat1 cat2)}
            />
            <small class="form-text">1 položka | 2-4 položky | 5+ položek</small>
          </.form_group>

          <.form_group>
            <label>Spanish Partial Mode</label>
            <.web_multiselect
              id="i18n-partial"
              badges_threshold={5}
              badges_threshold_mode="partial"
              badges_max_visible={3}
              search_placeholder="Seleccionar..."
              options={@tech_stack}
              value={~w(js ts py java cpp rust)}
            />
            <small class="form-text">Shows "+X más" instead of "+X more"</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Badge Tooltips">
        <p>Display helpful tooltips when hovering over selected item badges</p>

        <.grid>
          <.form_group>
            <label>Basic Tooltips</label>
            <.web_multiselect
              id="tooltip-basic"
              enable_badge_tooltips={true}
              badge_tooltip_placement="top"
              search_placeholder="Select frameworks..."
              options={@frameworks}
              value={~w(react vue svelte)}
            />
            <small class="form-text">Hover over badges to see default tooltip</small>
          </.form_group>

          <.form_group>
            <label>Custom Tooltip Content</label>
            <.web_multiselect
              id="tooltip-custom"
              enable_badge_tooltips={true}
              badge_tooltip_placement="top"
              search_placeholder="Select frameworks..."
              options={@frameworks}
              value={~w(react vue)}
            />
            <small class="form-text">Shows custom tooltip with description</small>
          </.form_group>

          <.form_group>
            <label>Tooltip Placement: Bottom</label>
            <.web_multiselect
              id="tooltip-bottom"
              enable_badge_tooltips={true}
              badge_tooltip_placement="bottom"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Tooltip appears below the badge</small>
          </.form_group>

          <.form_group>
            <label>Custom Delay (100ms)</label>
            <.web_multiselect
              id="tooltip-fast"
              enable_badge_tooltips={true}
              badge_tooltip_delay={100}
              search_placeholder="Select frameworks..."
              options={@frameworks}
              value={~w(react vue)}
            />
            <small class="form-text">Faster tooltip appearance (default is 300ms)</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Badge Positioning">
        <p>
          Control where selected badges appear relative to the input: <code>badges-position</code>
        </p>

        <.grid>
          <.form_group>
            <label>Badge Position: Bottom (Default)</label>
            <.web_multiselect
              id="badges-bottom"
              badges_position="bottom"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Badges appear below the input (default)</small>
          </.form_group>

          <.form_group>
            <label>Badge Position: Top</label>
            <.web_multiselect
              id="badges-top"
              badges_position="top"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Badges appear above the input</small>
          </.form_group>

          <.form_group>
            <label>Badge Position: Left</label>
            <.web_multiselect
              id="badges-left"
              badges_position="left"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts)}
            />
            <small class="form-text">Badges appear inline to the left of input</small>
          </.form_group>

          <.form_group>
            <label>Badge Position: Right</label>
            <.web_multiselect
              id="badges-right"
              badges_position="right"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts)}
            />
            <small class="form-text">Badges appear inline to the right of input</small>
          </.form_group>
        </.grid>

        <h3 style="margin-top: 2rem; margin-bottom: 1rem; font-size: 1.2rem; color: #667eea;">
          Inline Vertical Alignment
        </h3>
        <p>
          Control vertical alignment for left/right badge positions with <code>--ms-inline-align</code>
        </p>
        <.grid>
          <.form_group>
            <label>Right + Center Align (Default)</label>
            <.web_multiselect
              id="badges-right-center"
              badges_position="right"
              style="--ms-inline-align: center;"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python java)}
            />
            <small class="form-text"><code>--ms-inline-align: center</code></small>
          </.form_group>

          <.form_group>
            <label>Right + Top Align</label>
            <.web_multiselect
              id="badges-right-top"
              badges_position="right"
              style="--ms-inline-align: flex-start;"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python java)}
            />
            <small class="form-text"><code>--ms-inline-align: flex-start</code></small>
          </.form_group>

          <.form_group>
            <label>Left + Center Align (Default)</label>
            <.web_multiselect
              id="badges-left-center"
              badges_position="left"
              style="--ms-inline-align: center;"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python java)}
            />
            <small class="form-text"><code>--ms-inline-align: center</code></small>
          </.form_group>

          <.form_group>
            <label>Left + Top Align</label>
            <.web_multiselect
              id="badges-left-top"
              badges_position="left"
              style="--ms-inline-align: flex-start;"
              search_placeholder="Select technologies..."
              options={@languages}
              value={~w(js ts python java)}
            />
            <small class="form-text"><code>--ms-inline-align: flex-start</code></small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="RTL (Right-to-Left) Support">
        <p>
          Full support for RTL languages (Arabic, Hebrew, Persian, etc.) with automatic detection from <code>dir="rtl"</code>
        </p>

        <.grid>
          <.form_group>
            <label>Basic RTL Example</label>
            <.web_multiselect
              id="rtl-basic"
              dir="rtl"
              search_placeholder="...بحث"
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Toggle on left, text right-aligned, badges flow right-to-left</small>
          </.form_group>

          <.form_group>
            <label>RTL with Arabic Text</label>
            <.web_multiselect
              id="rtl-arabic"
              dir="rtl"
              search_placeholder="البحث عن التقنيات..."
              options={@arabic_langs}
              value={~w(js react)}
            />
            <small class="form-text">Real Arabic technology terms</small>
          </.form_group>

          <.form_group>
            <label>RTL Count Mode</label>
            <.web_multiselect
              id="rtl-count"
              dir="rtl"
              badges_display_mode="count"
              show_counter={true}
              search_placeholder="...بحث"
              options={@languages}
              value={~w(js ts python java)}
            />
            <small class="form-text">Count badge on left side in RTL mode</small>
          </.form_group>

          <.form_group>
            <label>LTR vs RTL Comparison</label>
            <div style="display: flex; gap: 1rem; flex-direction: column;">
              <div>
                <small style="display: block; margin-bottom: 0.25rem;">LTR (Left-to-Right)</small>
                <.web_multiselect
                  id="rtl-comparison-ltr"
                  search_placeholder="Search..."
                  options={@languages}
                  value={~w(js ts)}
                />
              </div>
              <div>
                <small style="display: block; margin-bottom: 0.25rem;">RTL (Right-to-Left)</small>
                <.web_multiselect
                  id="rtl-comparison-rtl"
                  dir="rtl"
                  search_placeholder="...بحث"
                  options={@languages}
                  value={~w(js ts)}
                />
              </div>
            </div>
            <small class="form-text">
              Notice toggle position, text alignment, and badge layout differences
            </small>
          </.form_group>

          <.form_group>
            <label>RTL + Badges Position: Right</label>
            <.web_multiselect
              id="rtl-badges-right"
              dir="rtl"
              badges_position="right"
              search_placeholder="...بحث"
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Badges inline on left (visually) with proper margin</small>
          </.form_group>

          <.form_group>
            <label>RTL + Badges Position: Left</label>
            <.web_multiselect
              id="rtl-badges-left"
              dir="rtl"
              badges_position="left"
              search_placeholder="...بحث"
              options={@languages}
              value={~w(js ts python)}
            />
            <small class="form-text">Badges inline on right (visually) with proper margin</small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="Async Search / Lookup">
        <p>
          Load options dynamically as users type. Perfect for large datasets, API searches, or real-time filtering.
        </p>

        <.grid>
          <.form_group>
            <label>Search GitHub Users</label>
            <.web_multiselect
              id="github-search"
              min_search_length={2}
              subtitle_member="subtitle"
              search_placeholder="Type to search GitHub users..."
              search_hint="💡 Type at least 2 characters to search"
            />
            <small class="form-text">Tries GitHub API, uses mock data if rate-limited</small>
          </.form_group>

          <.form_group>
            <label>Search Products</label>
            <.web_multiselect
              id="product-search-classic"
              min_search_length={1}
              subtitle_member="subtitle"
              search_placeholder="Search products..."
            />
            <small class="form-text">Simulated product database search</small>
          </.form_group>

          <.form_group>
            <label>Security Groups (Initial + Async)</label>
            <.web_multiselect
              id="security-groups-search"
              min_search_length={2}
              keep_options_on_search={true}
              value_member="id"
              display_value_member="name"
              subtitle_member="description"
              search_placeholder="Type to search all security groups..."
              search_hint="💡 Shows 5 most used groups initially, type to search all"
              options={@security_groups}
              value={~w(sg-001 sg-002)}
            />
            <small class="form-text">
              Initial favorites + full search on typing (type at least 2 characters)
            </small>
          </.form_group>
        </.grid>

        <.note>
          <p><strong>Initial Options + Async Search Pattern:</strong></p>
          <p>The Security Groups example demonstrates a common UX pattern:</p>
          <ul>
            <li>
              <strong>Initial State:</strong>
              Shows 5 most frequently used security groups when dropdown opens
            </li>
            <li>
              <strong>On Typing:</strong>
              Calls server API to search ALL security groups (after 2+ characters)
            </li>
            <li><strong>On Clear:</strong> Returns to showing the 5 initial favorites</li>
            <li>
              <strong>Configuration:</strong>
              <code>options</code>
              (initial data) + <code>searchCallback</code>
              (async) + <code>keep-options-on-search="true"</code>
              + <code>min-search-length="2"</code>
            </li>
          </ul>
        </.note>
      </.card>

      <.card title="Search Modes: Filter vs Navigate">
        <p>
          Choose between <strong>filter</strong>
          mode (hide non-matches) or <strong>navigate</strong>
          mode (jump to matches while keeping all visible)
        </p>

        <.grid>
          <.form_group>
            <label>Filter Mode (Default)</label>
            <.web_multiselect
              id="filter-mode-example"
              search_mode="filter"
              value_member="id"
              display_value_member="name"
              icon_member="flag"
              search_placeholder="Type to filter countries..."
              options={@countries_with_flags}
            />
            <small class="form-text">Hides non-matching options (standard behavior)</small>
          </.form_group>

          <.form_group>
            <label>Navigate Mode</label>
            <.web_multiselect
              id="navigate-mode-example"
              search_mode="navigate"
              value_member="id"
              display_value_member="name"
              icon_member="flag"
              search_hint="Ctrl/Cmd + ↓ / ↑ to jump between matches · Enter to select · Esc to clear"
              search_placeholder="Type to jump to country..."
              options={@countries_with_flags}
            />
            <small class="form-text">
              Keeps all options visible, jumps to matches (highlighted with left border)
            </small>
          </.form_group>
        </.grid>

        <.note>
          <p><strong>When to use each mode:</strong></p>
          <ul>
            <li>
              <strong>Filter Mode</strong>: Large lists where you want to narrow down options (e.g., product catalogs, user lists)
            </li>
            <li>
              <strong>Navigate Mode</strong>: Quick selection from known lists (e.g., country/state selectors)
            </li>
          </ul>
          <p><strong>Navigate-mode keyboard shortcuts:</strong></p>
          <ul>
            <li>
              <kbd>type</kbd> — first match becomes focused; all matches keep a left-border highlight
            </li>
            <li><kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>↓</kbd> — jump to next match</li>
            <li><kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>↑</kbd> — jump to previous match</li>
            <li><kbd>↑</kbd> / <kbd>↓</kbd> — move focus one option at a time</li>
            <li><kbd>Home</kbd> / <kbd>End</kbd> — jump to first / last option</li>
            <li><kbd>PageUp</kbd> / <kbd>PageDown</kbd> — move 10 options at a time</li>
            <li><kbd>Enter</kbd> — toggle selection of the focused option</li>
            <li><kbd>Esc</kbd> — clear the search (or close the dropdown if search is empty)</li>
          </ul>
        </.note>
      </.card>

      <.card title="Event Handling">
        <p>
          Listen to <code>select</code>, <code>deselect</code>, and <code>change</code> events
        </p>

        <.form_group>
          <label>Select Options (Check Console)</label>
          <.web_multiselect
            id="events-select"
            search_placeholder="Select options..."
            options={@technologies}
          />
          <small class="form-text">Open browser console to see events</small>
        </.form_group>
        <div
          id="event-log"
          style="background: #f9f9f9; padding: 1rem; border-radius: 4px; margin-top: 1rem; font-family: monospace; font-size: 0.875rem; max-height: 200px; overflow-y: auto;"
        >
          <div style="color: #666;">Event log will appear here...</div>
        </div>
        <small class="form-text" style="margin-top: 0.75rem; display: block;">
          Looking for the <code>on*</code> property handlers and the
          <code>beforeSelect</code>/<code>beforeDeselect</code> interceptors?
          See <.link navigate="/examples/events-callbacks">Events, Handlers &amp; Interceptors</.link>.
        </small>
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

      // Custom group label rendering (renderGroupLabelContentCallback).
      wait('custom-groups-classic').then((el) => {
        el.renderGroupLabelContentCallback = (groupName) => {
          const emojis = {
            'frontend': '🎨',
            'backend': '🔧',
            'database': '🗄️'
          };
          const emoji = emojis[groupName] || '📦';
          return `<strong>${emoji} ${groupName.toUpperCase()}</strong>`;
        };
      });

      // I18n English - Simple English pluralization
      wait('i18n-english').then((el) => {
        el.getCounterCallback = (count) => {
          return count === 1 ? '1 item selected' : `${count} items selected`;
        };
      });

      // I18n Czech - Complex Czech pluralization rules (1 = singular, 2-4 = paucal, 5+ = plural)
      wait('i18n-czech').then((el) => {
        el.getCounterCallback = (count) => {
          if (count === 1) {
            return '1 položka vybrána';
          } else if (count >= 2 && count <= 4) {
            return `${count} položky vybrány`;
          } else {
            return `${count} položek vybráno`;
          }
        };
      });

      // I18n Partial - Spanish pluralization for partial mode and count mode
      wait('i18n-partial').then((el) => {
        el.getCounterCallback = (count, moreCount) => {
          if (moreCount !== undefined) {
            return moreCount === 1 ? '+1 más' : `+${moreCount} más`;
          }
          return count === 1 ? '1 elemento seleccionado' : `${count} elementos seleccionados`;
        };
      });

      // Tooltip Custom - Custom tooltip content with callback (shows subtitle)
      wait('tooltip-custom').then((el) => {
        el.getBadgeTooltipCallback = (item) => {
          return item.subtitle || item.label;
        };
      });

      // RTL Count Mode - Custom Arabic count callback
      wait('rtl-count').then((el) => {
        el.getCounterCallback = (count) => {
          return `${count} محدد`; // "selected" in Arabic
        };
      });

      // Async Search: GitHub Users
      wait('github-search').then((githubSearch) => {
        const mockGitHubUsers = [
          { login: 'octocat', id: 583231 },
          { login: 'torvalds', id: 1024025 },
          { login: 'gaearon', id: 810438 },
          { login: 'tj', id: 25254 },
          { login: 'sindresorhus', id: 170270 },
          { login: 'addyosmani', id: 110953 },
          { login: 'paulirish', id: 39191 },
          { login: 'substack', id: 12631 },
          { login: 'mbostock', id: 230541 },
          { login: 'defunkt', id: 2 }
        ];

        githubSearch.searchCallback = async (searchTerm) => {
          try {
            const response = await fetch(`https://api.github.com/search/users?q=${searchTerm}&per_page=10`);

            if (!response.ok) {
              console.warn('GitHub API rate limit reached, using mock data');
              const term = searchTerm.toLowerCase();
              const filtered = mockGitHubUsers.filter(user =>
                user.login.toLowerCase().includes(term)
              );

              return [
                {
                  value: '__error__',
                  label: '⚠️ GitHub API Rate Limit - Showing Mock Data',
                  subtitle: 'API is temporarily unavailable',
                  disabled: true
                },
                ...filtered.map(user => ({
                  value: user.login,
                  label: user.login,
                  subtitle: `ID: ${user.id} (mock)`,
                  icon: '👤'
                }))
              ];
            }

            const data = await response.json();

            if (!data.items || !Array.isArray(data.items)) {
              console.warn('Invalid GitHub API response, using mock data');
              const term = searchTerm.toLowerCase();
              const filtered = mockGitHubUsers.filter(user =>
                user.login.toLowerCase().includes(term)
              );

              return [
                {
                  value: '__error__',
                  label: '⚠️ Invalid API Response - Showing Mock Data',
                  subtitle: 'Could not parse GitHub API response',
                  disabled: true
                },
                ...filtered.map(user => ({
                  value: user.login,
                  label: user.login,
                  subtitle: `ID: ${user.id} (mock)`,
                  icon: '👤'
                }))
              ];
            }

            return data.items.map(user => ({
              value: user.login,
              label: user.login,
              subtitle: `ID: ${user.id}`,
              icon: '👤'
            }));
          } catch (error) {
            console.error('GitHub search error:', error);
            const term = searchTerm.toLowerCase();
            const filtered = mockGitHubUsers.filter(user =>
              user.login.toLowerCase().includes(term)
            );

            return [
              {
                value: '__error__',
                label: '⚠️ Network Error - Showing Mock Data',
                subtitle: error.message || 'Could not connect to GitHub API',
                disabled: true
              },
              ...filtered.map(user => ({
                value: user.login,
                label: user.login,
                subtitle: `ID: ${user.id} (mock)`,
                icon: '👤'
              }))
            ];
          }
        };
      });

      // Async Search: Products
      wait('product-search-classic').then((productSearchClassic) => {
        const allProducts = [
          { value: '1', label: 'Laptop Pro 15', subtitle: 'Electronics - $1299' },
          { value: '2', label: 'Wireless Mouse', subtitle: 'Electronics - $29' },
          { value: '3', label: 'Mechanical Keyboard', subtitle: 'Electronics - $89' },
          { value: '4', label: 'USB-C Hub', subtitle: 'Electronics - $49' },
          { value: '5', label: 'Office Chair Deluxe', subtitle: 'Furniture - $299' },
          { value: '6', label: 'Standing Desk', subtitle: 'Furniture - $499' },
          { value: '7', label: 'Desk Lamp LED', subtitle: 'Furniture - $39' },
          { value: '8', label: 'Monitor 27"', subtitle: 'Electronics - $349' },
          { value: '9', label: 'Webcam HD', subtitle: 'Electronics - $79' },
          { value: '10', label: 'Headphones', subtitle: 'Electronics - $199' }
        ];

        productSearchClassic.searchCallback = async (searchTerm) => {
          await new Promise(resolve => setTimeout(resolve, 300));

          const term = searchTerm.toLowerCase();
          return allProducts.filter(product =>
            product.label.toLowerCase().includes(term) ||
            product.subtitle.toLowerCase().includes(term)
          );
        };
      });

      // Async Search: Security Groups (Initial + Async Pattern)
      wait('security-groups-search').then((securityGroupsSearch) => {
        const mostUsedSecurityGroups = [
          { id: 'sg-001', name: 'Web Servers', description: 'HTTP/HTTPS access (80, 443)', icon: '🌐', usageCount: 150 },
          { id: 'sg-002', name: 'Database Servers', description: 'MySQL/PostgreSQL (3306, 5432)', icon: '🗄️', usageCount: 120 },
          { id: 'sg-003', name: 'Application Servers', description: 'Internal API access (8080)', icon: '⚙️', usageCount: 100 },
          { id: 'sg-004', name: 'Load Balancers', description: 'ALB/NLB traffic', icon: '⚖️', usageCount: 80 },
          { id: 'sg-005', name: 'Cache Servers', description: 'Redis/Memcached (6379, 11211)', icon: '💾', usageCount: 60 }
        ];

        const allSecurityGroups = [
          ...mostUsedSecurityGroups,
          { id: 'sg-006', name: 'SSH Bastion', description: 'SSH access (22)', icon: '🔐', usageCount: 45 },
          { id: 'sg-007', name: 'Monitoring Agents', description: 'Metrics collection', icon: '📊', usageCount: 40 },
          { id: 'sg-008', name: 'Message Queue', description: 'RabbitMQ/SQS', icon: '📬', usageCount: 35 },
          { id: 'sg-009', name: 'File Storage', description: 'NFS/S3 gateway', icon: '📁', usageCount: 30 },
          { id: 'sg-010', name: 'VPN Gateway', description: 'VPN access (1194)', icon: '🔒', usageCount: 25 },
          { id: 'sg-011', name: 'Email Servers', description: 'SMTP/IMAP (25, 143, 587)', icon: '📧', usageCount: 20 },
          { id: 'sg-012', name: 'DNS Servers', description: 'DNS queries (53)', icon: '🌍', usageCount: 18 },
          { id: 'sg-013', name: 'FTP Servers', description: 'FTP/SFTP (21, 22)', icon: '📤', usageCount: 15 },
          { id: 'sg-014', name: 'CI/CD Pipeline', description: 'Jenkins/GitLab runners', icon: '🚀', usageCount: 12 },
          { id: 'sg-015', name: 'Container Registry', description: 'Docker registry (5000)', icon: '🐳', usageCount: 10 },
          { id: 'sg-016', name: 'Elasticsearch', description: 'Search cluster (9200, 9300)', icon: '🔍', usageCount: 8 },
          { id: 'sg-017', name: 'Kafka Brokers', description: 'Message streaming (9092)', icon: '📨', usageCount: 7 },
          { id: 'sg-018', name: 'Development', description: 'Dev environment access', icon: '💻', usageCount: 6 },
          { id: 'sg-019', name: 'Staging', description: 'Staging environment', icon: '🧪', usageCount: 5 },
          { id: 'sg-020', name: 'Legacy Systems', description: 'Old infrastructure', icon: '🏚️', usageCount: 2 }
        ];

        securityGroupsSearch.searchCallback = async (searchTerm) => {
          await new Promise(resolve => setTimeout(resolve, 400));

          const term = searchTerm.toLowerCase();

          const results = allSecurityGroups.filter(sg =>
            sg.name.toLowerCase().includes(term) ||
            sg.description.toLowerCase().includes(term) ||
            sg.id.toLowerCase().includes(term)
          );

          return results.sort((a, b) => b.usageCount - a.usageCount);
        };
      });

      // Events select - log select / deselect / change to the on-page event log
      wait('events-select').then((eventsSelect) => {
        const eventLog = document.getElementById('event-log');

        const logEvent = (eventName, detail) => {
          const timestamp = new Date().toLocaleTimeString();
          const logEntry = document.createElement('div');
          logEntry.style.marginBottom = '0.5rem';
          logEntry.innerHTML = `<strong style="color: #0066cc;">[${timestamp}] ${eventName}:</strong> ${JSON.stringify(detail, null, 2)}`;
          eventLog.appendChild(logEntry);
          eventLog.scrollTop = eventLog.scrollHeight;
        };

        eventsSelect.addEventListener('select', (e) => {
          console.log('select event:', e.detail);
          logEvent('select', {
            option: e.detail.option?.label,
            selectedValues: e.detail.selectedValues
          });
        });

        eventsSelect.addEventListener('deselect', (e) => {
          console.log('deselect event:', e.detail);
          logEvent('deselect', {
            option: e.detail.option?.label,
            selectedValues: e.detail.selectedValues
          });
        });

        eventsSelect.addEventListener('change', (e) => {
          console.log('change event:', e.detail);
          logEvent('change', {
            count: e.detail.selectedOptions?.length,
            selectedValues: e.detail.selectedValues,
            selectedLabels: e.detail.selectedOptions?.map(o => o.label)
          });
        });
      });
    </script>
    """
  end
end
