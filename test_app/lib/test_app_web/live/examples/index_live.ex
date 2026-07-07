defmodule TestAppWeb.Examples.IndexLive do
  use TestAppWeb, :live_view

  @pages [
    %{
      href: "/examples/classic",
      icon: "📦",
      title: "Classic Examples",
      description:
        "Declarative `<option>` markup, single/multi select, search hints, badge display modes, badge positioning, tooltips, and RTL."
    },
    %{
      href: "/examples/new-api",
      icon: "🚀",
      title: "Flexible Data API",
      description:
        "Custom objects, tuple arrays, member callbacks, async search, form integration (json/csv/array), and cascading selects."
    },
    %{
      href: "/examples/tree",
      icon: "🌳",
      title: "Tree of Options",
      description:
        "Hierarchical options via a materialized `path_member` — always-expanded, indented by depth, branch/leaf theming hooks, ancestor-preserving search, custom separators."
    },
    %{
      href: "/examples/search-index",
      icon: "🔎",
      title: "External Search (FlexSearch)",
      description:
        "Externalize the whole search via `searchCallback` — fuzzy, partial, accent-insensitive, ranked matching from a FlexSearch index. Works on flat lists and trees; FlexSearch never enters the wrapper bundle."
    },
    %{
      href: "/examples/performance",
      icon: "⚡",
      title: "Virtual Scrolling",
      description:
        "15,000 options with virtual scrolling, init/render/search timing, plus rich rendering with priority-based badges."
    },
    %{
      href: "/examples/templating",
      icon: "✨",
      title: "Custom Rendering",
      description:
        "Render callbacks for options, badges, and selected items — frameworks, products, articles, jobs, movies, images."
    },
    %{
      href: "/examples/action-buttons",
      icon: "🎛️",
      title: "Action Buttons",
      description:
        "Static and dynamic action buttons: tooltips, visibility/disabled callbacks, custom actions, layout wrap, Font Awesome, plus position/rows/alignment."
    },
    %{
      href: "/examples/tooltips",
      icon: "💬",
      title: "Tooltips",
      description:
        "Hover tooltips on dropdown options — default content, custom callbacks, virtual scroll, placement/follow-cursor, side placement, independent styling, and badge tooltips."
    },
    %{
      href: "/examples/events-callbacks",
      icon: "🔔",
      title: "Events & Interceptors",
      description:
        "DOM events, the `on*` property twin, and `beforeSelect`/`beforeDeselect` veto interceptors — with live veto demos and the callback-vs-event rule."
    },
    %{
      href: "/examples/sizes",
      icon: "📏",
      title: "Sizes & Fonts",
      description:
        "Global `--ms-rem` scaling, fine-grained CSS vars, narrow-input / wide-dropdown patterns, and six font-family demos."
    },
    %{
      href: "/examples/base-variables",
      icon: "🎨",
      title: "Base Variables",
      description:
        "Interactive `--base-*` typography panel — font family, sizes, weights, line heights — wired live into four multiselects."
    },
    %{
      href: "/examples/theming",
      icon: "🎭",
      title: "Theming",
      description:
        "Size presets and seven full themes — Dark, Neon, Audi Corporate, Rounded, Sharp/Minimal, Material, Glassmorphism."
    },
    %{
      href: "/examples/logging",
      icon: "🐛",
      title: "Logging & Debugging",
      description:
        "Built-in categorized logging — INIT/DATA/UI/INTERACTION — with runtime enable/disable and category-specific controls."
    },
    %{
      href: "/examples/positioning",
      icon: "📐",
      title: "Positioning Edge Cases",
      description:
        "How the dropdown anchors inside transformed, contained, and container-query ancestors — plus the drift-detection warning."
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "keen_web_multiselect — examples")
     |> assign(:pages, @pages)
     |> assign(:upstream_version, Keenmate.WebMultiselect.upstream_version())
     |> assign(:wrapper_version, Application.spec(:keen_web_multiselect, :vsn) |> to_string())}
  end

  def render(assigns) do
    ~H"""
    <style>
      body {
        background: #f0f2f5;
        min-height: 100vh;
        padding: 2rem;
        max-width: none;
      }

      .page-container {
        max-width: 1200px;
        margin: 0 auto;
      }

      .header-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 16px;
        padding: 2.5rem 3rem;
        margin-bottom: 2rem;
        color: white;
      }

      .header-card h1 {
        font-size: 2.5rem;
        font-weight: 700;
        margin: 0 0 0.5rem 0;
        color: white;
        border-bottom: none;
        padding-bottom: 0;
      }

      .header-card .subtitle {
        font-size: 1.1rem;
        opacity: 0.9;
        margin: 0 0 1rem 0;
      }

      .version-badge {
        display: inline-block;
        background: rgba(255, 255, 255, 0.2);
        padding: 0.35rem 0.85rem;
        border-radius: 8px;
        font-size: 0.875rem;
        font-weight: 500;
        margin-right: 0.5rem;
      }

      .cards {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 1.5rem;
      }

      .card-link {
        background: white;
        border-radius: 12px;
        padding: 1.75rem;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        cursor: pointer;
        text-decoration: none;
        color: inherit;
        display: block;
      }

      .card-link:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        text-decoration: none;
      }

      .card-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
      }

      .card-link h2.card-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin: 0 0 0.5rem 0;
        color: #1a202c;
        border-bottom: none;
        padding-bottom: 0;
      }

      .card-description {
        color: #64748b;
        line-height: 1.6;
        margin: 0;
        font-size: 0.95rem;
      }

      footer {
        text-align: center;
        margin-top: 3rem;
        color: #64748b;
        font-size: 0.875rem;
      }

      footer a {
        color: #667eea;
        text-decoration: none;
      }

      footer a:hover {
        text-decoration: underline;
      }

      .fixtures-link {
        margin-top: 2rem;
        background: white;
        border-radius: 12px;
        padding: 1.5rem 1.75rem;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .fixtures-link h3 {
        margin: 0 0 0.5rem;
        font-size: 1rem;
        color: #4a5568;
      }

      .fixtures-link ul {
        list-style: none;
        margin: 0;
        padding: 0;
        line-height: 1.6;
      }

      .fixtures-link a {
        font-size: 0.9rem;
        color: #667eea;
      }

      .fixtures-link code {
        font-size: 0.8rem;
        color: #64748b;
      }
    </style>

    <div class="page-container">
      <header class="header-card">
        <h1>keen_web_multiselect</h1>
        <p class="subtitle">
          Phoenix LiveView wrapper for the <code style="color:white;background:rgba(255,255,255,0.15)">&lt;web-multiselect&gt;</code> custom element. Themeable, virtual-scrolling, form-aware.
        </p>
        <span class="version-badge">wrapper v{@wrapper_version}</span>
        <span class="version-badge">upstream v{@upstream_version}</span>
      </header>

      <div class="cards">
        <a :for={page <- @pages} href={page.href} class="card-link">
          <div class="card-icon">{page.icon}</div>
          <h2 class="card-title">{page.title}</h2>
          <p class="card-description">{page.description}</p>
        </a>
      </div>

      <div class="fixtures-link">
        <h3>E2E test fixtures (Playwright)</h3>
        <ul>
          <li><a href="/test/selection">selection & multiplicity</a> <code>/test/selection</code></li>
          <li><a href="/test/form">form integration</a> <code>/test/form</code></li>
          <li><a href="/test/events">LV hook events</a> <code>/test/events</code></li>
          <li>
            <a href="/test/attributes">snake_case → kebab-case mapping</a>
            <code>/test/attributes</code>
          </li>
        </ul>
      </div>

      <footer>
        <p>
          Built by <a href="https://github.com/keenmate" target="_blank">KeenMate</a>
          · <a href="https://github.com/keenmate/keen_web_multiselect" target="_blank">Hex repo</a>
          · <a href="https://github.com/keenmate/web-multiselect" target="_blank">Upstream component</a>
        </p>
      </footer>
    </div>
    """
  end
end
