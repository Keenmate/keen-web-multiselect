defmodule TestAppWeb.Examples.ThemingLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Sample data for all examples (mirrors examples-theming.0.js `technologies`)
  @technologies [
    %{value: "react", label: "React"},
    %{value: "vue", label: "Vue.js"},
    %{value: "angular", label: "Angular"},
    %{value: "svelte", label: "Svelte"},
    %{value: "typescript", label: "TypeScript"},
    %{value: "javascript", label: "JavaScript"},
    %{value: "python", label: "Python"},
    %{value: "nodejs", label: "Node.js"},
    %{value: "deno", label: "Deno"},
    %{value: "rust", label: "Rust"},
    %{value: "go", label: "Go"},
    %{value: "java", label: "Java"},
    %{value: "csharp", label: "C#"},
    %{value: "php", label: "PHP"},
    %{value: "ruby", label: "Ruby"}
  ]

  # Grouped variant of @technologies (mirrors examples-theming groupedTech):
  # each option carries a canonical `group` key so allow_groups renders headers.
  @grouped_technologies [
    %{value: "react", label: "React", group: "Frontend"},
    %{value: "vue", label: "Vue.js", group: "Frontend"},
    %{value: "angular", label: "Angular", group: "Frontend"},
    %{value: "svelte", label: "Svelte", group: "Frontend"},
    %{value: "typescript", label: "TypeScript", group: "Languages"},
    %{value: "javascript", label: "JavaScript", group: "Languages"},
    %{value: "python", label: "Python", group: "Languages"},
    %{value: "nodejs", label: "Node.js", group: "Runtimes"},
    %{value: "deno", label: "Deno", group: "Runtimes"},
    %{value: "rust", label: "Rust", group: "Languages"},
    %{value: "go", label: "Go", group: "Languages"},
    %{value: "java", label: "Java", group: "Languages"},
    %{value: "csharp", label: "C#", group: "Languages"},
    %{value: "php", label: "PHP", group: "Languages"},
    %{value: "ruby", label: "Ruby", group: "Languages"}
  ]

  # Code samples — kept as heredocs so the literal braces/backticks are HEEx-safe.
  @scheme_code ~S"""
  <!-- 1. Per-instance (wins over everything) -->
  <.web_multiselect data-theme="dark" />

  <!-- 2. Framework class on an ancestor -->
  <html class="dark">                    <!-- Tailwind -->
  <html data-bs-theme="dark">            <!-- Bootstrap 5.3+ -->
  <div data-theme="dark"> … <.web_multiselect /> … </div>

  <!-- 3. Follow the OS: opt the page into system switching -->
  <style> html { color-scheme: light dark; } </style>
  <.web_multiselect />   <!-- no signal → tracks prefers-color-scheme -->

  // switch at runtime — it's just an attribute
  picker.setAttribute('data-theme', 'dark');   // or 'light'
  picker.removeAttribute('data-theme');        // back to inherit/OS
  """

  @grouped_code ~S"""
  <.web_multiselect
    allow_groups={true}           # render options under group headers ("group" key)
    search_mode="navigate"        # start in navigate; typing jumps between matches
    show_search_mode_toggle={true} # fullscreen: leading icon flips filter↔navigate live
    options={@grouped_technologies} />

  <!-- Theme it exactly like everything else: just signal the scheme. -->
  <div data-theme="dark"> … </div>   // or data-theme="light", or OS-auto
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Theming — keen_web_multiselect")
     |> assign(:technologies, @technologies)
     |> assign(:grouped_technologies, @grouped_technologies)
     |> assign(:scheme_code, @scheme_code)
     |> assign(:grouped_code, @grouped_code)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🎭"
      title="Theming"
      subtitle="Customize appearance with CSS custom properties. Dark mode, neon, corporate, and more"
    >
      <style>
        /* Theme grid layout */
        .theme-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        /* Theme card base styling */
        .theme-card {
            padding: 1.5rem;
            border-radius: 8px;
        }

        .theme-card p {
            font-size: 0.875rem;
        }

        /* Dark Mode Theme */
        .dark-theme {
            background: #1a1a1a;
        }

        .dark-theme h2,
        .dark-theme p,
        .dark-theme label {
            color: #e5e5e5;
        }

        #dark-mode {
            /* Base theme variables - these cascade to all components */
            --base-input-bg: #2a2a2a;
            --base-dropdown-bg: #2a2a2a;
            --base-actions-bg: #2a2a2a;
            --base-popover-bg: #2a2a2a;
            --base-text-color-1: #e5e5e5;
            --base-text-color-3: #808080;
            --base-border-color: #404040;
            --base-border: 1px solid #404040; /* Sets all component borders at once */
            --base-hover-bg: #3a3a3a;
            --base-accent-color: #667eea;

            /* Component-specific overrides */
            --ms-dropdown-box-shadow: 0 8px 16px rgba(0, 0, 0, 0.6);

            /* Badges - slightly lighter border for visibility */
            --ms-badge-text-bg: #3a3a3a;
            --ms-badge-text-border: 1px solid #505050;

            /* Selected popover */
            --ms-selected-popover-header-bg: rgba(102, 126, 234, 0.1);
            --ms-selected-popover-close-bg-hover: #3a3a3a;

            /* Checkboxes */
            --ms-checkbox-bg: #3a3a3a;
            --ms-checkbox-border: 1px solid #606060;

            /* Scrollbar */
            --ms-scrollbar-thumb-bg: #505050;
            --ms-scrollbar-thumb-bg-hover: #707070;
        }

        /* Neon/Cyberpunk Theme */
        .neon-theme {
            background: #0a0a0a;
            position: relative;
        }

        .neon-theme::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(45deg, rgba(255,0,255,0.1), rgba(0,255,255,0.1));
            pointer-events: none;
        }

        .neon-theme h2,
        .neon-theme p,
        .neon-theme label {
            color: #00ffff;
            text-shadow: 0 0 10px rgba(0, 255, 255, 0.5);
        }

        #neon-mode {
            /* Base theme variables */
            --base-input-bg: #1a0a1a;
            --base-dropdown-bg: #1a0a1a;
            --base-actions-bg: rgba(255, 0, 255, 0.3);
            --base-popover-bg: #1a0a1a;
            --base-text-color-1: #00ffff;
            --base-accent-color: #ff00ff;

            /* Custom icons — one --base-icon-* swap re-skins the lot: the toggle chevron
               (+ fullscreen pager) and every ✕ (badge remove, popover close, count clear).
               Techy double-chevron + a chunky filled square-x for the cyberpunk vibe. */
            --base-icon-chevron: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='black' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='m6 17 5-5-5-5'/><path d='m13 17 5-5-5-5'/></svg>");
            --base-icon-close: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='black'><path d='M19 2h-14a3 3 0 0 0 -3 3v14a3 3 0 0 0 3 3h14a3 3 0 0 0 3 -3v-14a3 3 0 0 0 -3 -3zm-9.387 6.21l.094 .083l2.293 2.292l2.293 -2.292a1 1 0 0 1 1.497 1.32l-.083 .094l-2.292 2.293l2.292 2.293a1 1 0 0 1 -1.32 1.497l-.094 -.083l-2.293 -2.292l-2.293 2.292a1 1 0 0 1 -1.497 -1.32l.083 -.094l2.292 -2.293l-2.292 -2.293a1 1 0 0 1 1.32 -1.497z'/></svg>");
            /* Search glyph (never rotated — feeds the fullscreen overlay's search-mode toggle).
               A solid magnifier for the glow. Visible when the overlay opens on a phone viewport. */
            --base-icon-search: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='black'><path d='M14 3.072a8 8 0 0 1 2.617 11.424l4.944 4.943a1.5 1.5 0 0 1 -2.008 2.225l-.114 -.103l-4.943 -4.944a8 8 0 0 1 -12.49 -6.332l-.006 -.285l.005 -.285a8 8 0 0 1 11.995 -6.643z'/></svg>");

            /* Hover/focus on options. --ms-option-bg-hover cascades from --ms-primary-bg,
               which reads --base-hover-bg (or falls back to a color-mix tint of --base-main-bg).
               This theme overrides the option hover directly so the magenta carries to interaction. */
            --ms-option-bg-hover: rgba(255, 0, 255, 0.3);
            --ms-option-bg-focused: rgba(255, 0, 255, 0.3);

            /* Component-specific overrides */
            --ms-dropdown-border: 1px solid #ff00ff;
            --ms-dropdown-box-shadow: 0 0 20px rgba(255, 0, 255, 0.5);

            /* Badges */
            --ms-badge-text-bg: rgba(255, 0, 255, 0.3);
            --ms-badge-text-border: 1px solid #ff00ff;
            --ms-badge-remove-bg: #00ffff;
            --ms-badge-remove-color: #1a0a1a;

            /* Selected popover */
            --ms-selected-popover-border: 1px solid #ff00ff;
            --ms-selected-popover-header-bg: rgba(255, 0, 255, 0.2);
            --ms-selected-popover-close-color: #ff00ff;
            --ms-selected-popover-close-bg-hover: rgba(255, 0, 255, 0.3);

            /* Checkboxes */
            --ms-checkbox-bg: #1a0a1a;
            --ms-checkbox-border: 1px solid #ff00ff;
            --ms-checkbox-checkmark-color: #00ffff;

            /* Scrollbar */
            --ms-scrollbar-track-bg: #1a0a1a;
            --ms-scrollbar-thumb-bg: #ff00ff;
            --ms-scrollbar-thumb-bg-hover: #00ffff;
        }

        /* Audi Corporate Theme */
        .audi-theme {
            background: #f7f7f7;
        }

        .audi-theme h2 {
            color: #bb0a30;
            font-weight: 300;
            letter-spacing: 0.05em;
        }

        .audi-theme p,
        .audi-theme label {
            color: #555;
        }

        #audi-mode {
            /* Base theme variables */
            --base-text-color-1: #333333;
            --base-text-color-3: #666666;
            --base-border-color: #d0d0d0;
            --base-hover-bg: #f5f5f5;
            --base-accent-color: #bb0a30;

            /* Component-specific overrides */
            --ms-input-border-radius: 2px;
            --ms-dropdown-border-radius: 2px;
            --ms-dropdown-box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);

            /* Badges */
            --ms-badge-text-bg: #f5f5f5;
            --ms-badge-text-color: #333333;
            --ms-badge-text-border: 1px solid #d0d0d0;
            --ms-badge-border-radius: 2px;

            /* Checkboxes */
            --ms-checkbox-border-radius: 2px;

            /* Scrollbar */
            --ms-scrollbar-track-bg: #f7f7f7;
            --ms-scrollbar-thumb-bg: #d0d0d0;
            --ms-scrollbar-thumb-bg-hover: #bb0a30;
        }

        /* Rounded/Soft Theme */
        .rounded-theme {
            background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
        }

        #rounded-mode {
            /* Base theme variables */
            --base-text-color-1: #5a3e36;
            --base-border-color: #f0d0c0;
            --base-hover-bg: #fff5f0;
            --base-accent-color: #ff6b9d;
            --base-accent-color-light: #ffe5f0;

            /* Custom icons — soft rounded glyphs (circle chevron + circle x) to match the
               pill shapes. One --base-icon-* swap covers the toggle chevron and every ✕. */
            --base-icon-chevron: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='black' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'/><path d='m10 8 4 4-4 4'/></svg>");
            --base-icon-close: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='black' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'/><path d='m15 9-6 6'/><path d='m9 9 6 6'/></svg>");

            /* Component-specific overrides */
            --ms-input-border-radius: 24px;
            --ms-dropdown-border-radius: 16px;
            --ms-dropdown-box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);

            /* Badges */
            --ms-badge-text-border: 1px solid #ffc0dd;
            --ms-badge-border-radius: 20px;

            /* Checkboxes */
            --ms-checkbox-border-radius: 8px;
            --ms-checkbox-border: 1px solid #ffc0dd;

            /* Scrollbar */
            --ms-scrollbar-track-bg: #fff5f0;
            --ms-scrollbar-thumb-bg: #ffc0dd;
            --ms-scrollbar-thumb-bg-hover: #ff6b9d;
        }

        /* Sharp/Minimal Theme */
        .sharp-theme {
            background: #ffffff;
            border: 2px solid #000000;
        }

        #sharp-mode {
            /* Base theme variables */
            --base-text-color-1: #000000;
            --base-border-color: #000000;
            --base-hover-bg: #f0f0f0;
            --base-accent-color: #000000;

            /* Custom icons — hard geometric glyphs (filled squares) for the brutalist look.
               One --base-icon-* swap re-skins the toggle chevron and every ✕. */
            --base-icon-chevron: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='black'><path d='M19 2a3 3 0 0 1 3 3v14a3 3 0 0 1 -3 3h-14a3 3 0 0 1 -3 -3v-14a3 3 0 0 1 3 -3zm-10.387 6.21a1 1 0 0 0 -1.32 .083l-.083 .094a1 1 0 0 0 .083 1.32l2.292 2.293l-2.292 2.293l-.083 .094a1 1 0 0 0 1.497 1.32l3 -3l.083 -.094a1 1 0 0 0 -.083 -1.32l-3 -3zm5 0a1 1 0 0 0 -1.32 .083l-.083 .094a1 1 0 0 0 .083 1.32l2.292 2.293l-2.292 2.293l-.083 .094a1 1 0 0 0 1.497 1.32l3 -3l.083 -.094a1 1 0 0 0 -.083 -1.32l-3 -3z'/></svg>");
            --base-icon-close: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='black'><path d='M19 2h-14a3 3 0 0 0 -3 3v14a3 3 0 0 0 3 3h14a3 3 0 0 0 3 -3v-14a3 3 0 0 0 -3 -3zm-9.387 6.21l.094 .083l2.293 2.292l2.293 -2.292a1 1 0 0 1 1.497 1.32l-.083 .094l-2.292 2.293l2.292 2.293a1 1 0 0 1 -1.32 1.497l-.094 -.083l-2.293 -2.292l-2.293 2.292a1 1 0 0 1 -1.497 -1.32l.083 -.094l2.292 -2.293l-2.292 -2.293a1 1 0 0 1 1.32 -1.497z'/></svg>");

            /* Component-specific overrides */
            --ms-input-border: 2px solid #000000;
            --ms-input-border-radius: 0;
            --ms-dropdown-border: 2px solid #000000;
            --ms-dropdown-border-radius: 0;
            --ms-dropdown-box-shadow: none;

            /* Badges */
            --ms-badge-text-bg: #000000;
            --ms-badge-text-color: #ffffff;
            --ms-badge-text-border: 2px solid #000000;
            --ms-badge-border-radius: 0;
            --ms-badge-remove-bg: #ffffff;
            --ms-badge-remove-color: #000000;

            /* Checkboxes */
            --ms-checkbox-border-radius: 0;
            --ms-checkbox-border: 2px solid #000000;

            /* Scrollbar */
            --ms-scrollbar-width: 12px;
            --ms-scrollbar-track-bg: #ffffff;
            --ms-scrollbar-thumb-bg: #000000;
            --ms-scrollbar-thumb-bg-hover: #333333;
            --ms-scrollbar-thumb-border-radius: 0;
        }

        /* Material Design Theme */
        .material-theme {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
        }

        #material-mode {
            /* Base theme variables */
            --base-text-color-1: #212121;
            --base-text-color-3: #757575;
            --base-hover-bg: #f5f5f5;
            --base-accent-color: #1976d2;
            --base-accent-color-light: #e3f2fd;

            /* Custom icon + rotation OPT-OUT. Material's dropdown indicator is a PRE-ORIENTED
               downward triangle (arrow_drop_down), so we hand the toggle a down-caret glyph and
               tell it NOT to rotate the source (0° closed) while still flipping up on open (180°).
               This is the escape hatch from the directional-chevron contract, via the new
               --ms-toggle-rotate-* pair. */
            --base-icon-chevron: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='black'><path d='M18 9c.852 0 1.297 .986 .783 1.623l-.076 .084l-6 6a1 1 0 0 1 -1.32 .083l-.094 -.083l-6 -6l-.083 -.094l-.054 -.077l-.054 -.096l-.017 -.036l-.027 -.067l-.032 -.108l-.01 -.053l-.01 -.06l-.004 -.057v-.118l.005 -.058l.009 -.06l.01 -.052l.032 -.108l.027 -.067l.07 -.132l.065 -.09l.073 -.081l.094 -.083l.077 -.054l.096 -.054l.036 -.017l.067 -.027l.108 -.032l.053 -.01l.06 -.01l.057 -.004l12.059 -.002z'/></svg>");
            --ms-toggle-rotate-closed: 0deg;
            --ms-toggle-rotate-open: 180deg;
            /* The pager rotates its glyph ±90°, so it needs a RIGHT-pointing chevron — give it one
               via its own token so our pre-oriented down-caret above doesn't leak into it. This is
               the fix that lets a pre-oriented toggle glyph coexist with a correct pager. */
            --ms-fullscreen-nav-btn-icon: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='black' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='m9 18 6-6-6-6'/></svg>");

            /* Component-specific overrides */
            --ms-input-border: 1px solid transparent;
            --ms-input-border-radius: 4px;
            --ms-dropdown-border: 1px solid transparent;
            --ms-dropdown-border-radius: 4px;
            --ms-dropdown-box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);

            /* Badges */
            --ms-badge-border-radius: 16px;

            /* Checkboxes */
            --ms-checkbox-border-radius: 2px;

            /* Scrollbar */
            --ms-scrollbar-track-bg: transparent;
            --ms-scrollbar-thumb-bg: #bdbdbd;
            --ms-scrollbar-thumb-bg-hover: #1976d2;
        }

        /* Glassmorphism Theme */
        .glass-theme {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: visible;
        }

        .glass-theme::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="15" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="20" fill="rgba(255,255,255,0.05)"/><circle cx="50" cy="80" r="25" fill="rgba(255,255,255,0.08)"/></svg>');
            background-size: 200px 200px;
            pointer-events: none;
        }

        .glass-theme h2,
        .glass-theme p,
        .glass-theme label {
            color: #ffffff;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        #glass-mode {
            /* Base theme variables */
            --base-input-bg: rgba(255, 255, 255, 0.15);
            --base-dropdown-bg: rgba(255, 255, 255, 0.15);
            --base-actions-bg: rgba(255, 255, 255, 0.15);
            --base-text-color-1: #ffffff;
            --base-text-color-3: rgba(255, 255, 255, 0.7);
            --base-border-color: rgba(255, 255, 255, 0.3);
            --base-hover-bg: rgba(255, 255, 255, 0.25);
            --base-accent-color: #667eea;

            /* Component-specific overrides */
            --ms-input-border-radius: 12px;
            --ms-input-placeholder-color: rgba(255, 255, 255, 0.5);
            --ms-dropdown-border-radius: 12px;
            --ms-dropdown-box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);

            /* Options */
            --ms-option-bg-selected: rgba(255, 255, 255, 0.4);

            /* Badges */
            --ms-badge-text-bg: rgba(255, 255, 255, 0.25);
            --ms-badge-text-border: 1px solid rgba(255, 255, 255, 0.3);
            --ms-badge-border-radius: 16px;
            --ms-badge-remove-bg: rgba(255, 255, 255, 0.4);
            --ms-badge-remove-color: #667eea;

            /* Checkboxes */
            --ms-checkbox-bg: rgba(255, 255, 255, 0.15);
            --ms-checkbox-border: 1px solid rgba(255, 255, 255, 0.4);
            --ms-checkbox-border-radius: 4px;
            --ms-checkbox-checked-bg: rgba(255, 255, 255, 0.4);
            --ms-checkbox-checked-border: 1px solid rgba(255, 255, 255, 0.6);
            --ms-checkbox-checkmark-color: #667eea;
            --ms-checkbox-hover-border-color: rgba(255, 255, 255, 0.6);

            /* Scrollbar */
            --ms-scrollbar-track-bg: rgba(255, 255, 255, 0.1);
            --ms-scrollbar-thumb-bg: rgba(255, 255, 255, 0.3);
            --ms-scrollbar-thumb-bg-hover: rgba(255, 255, 255, 0.5);
        }

        /* Add backdrop blur for glass effect */
        #glass-mode::part(input),
        #glass-mode::part(dropdown),
        #glass-mode::part(actions) {
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }

        .size-grid {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            max-width: 500px;
        }

        .size-table {
            margin-bottom: 1.5rem;
            border-collapse: collapse;
            font-size: 0.875rem;
        }

        .form-text {
            display: block;
            margin-top: 0.25rem;
            font-size: 0.75rem;
            opacity: 0.7;
        }

        /* Built-in color-scheme demo. The card's OWN chrome follows the same signal it
           passes to the picker, so the whole panel flips coherently:
           - Auto  → JS sets `color-scheme: light dark` (no data-theme); light-dark() below
                     resolves per the OS, and the picker inherits that color-scheme.
           - Light → data-theme="light"  (ancestor signal, matched by :host-context in dark-mode.css)
           - Dark  → data-theme="dark"
           No component color overrides here (no --ms- or --base- vars): dark styling is 100%
           the component built-in light-dark() fallbacks, driven only by color-scheme. */
        .scheme-demo {
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid;
            transition: background-color .2s ease, color .2s ease, border-color .2s ease;
            /* Auto (no data-theme): follow the used color-scheme (set to `light dark` by JS). */
            background: light-dark(#ffffff, #0c0c0e);
            color: light-dark(#111827, #e5e5e5);
            border-color: light-dark(#e2e8f0, #2e2e33);
        }
        .scheme-demo[data-theme="light"] {
            color-scheme: light;
            background: #ffffff;
            color: #111827;
            border-color: #e2e8f0;
        }
        .scheme-demo[data-theme="dark"] {
            color-scheme: dark;
            background: #0c0c0e;
            color: #e5e5e5;
            border-color: #2e2e33;
        }
        .scheme-demo .form-text { color: inherit; }

        /* Segmented Auto / Light / Dark switch built from radios. */
        .segmented {
            display: inline-flex;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 1.25rem;
        }
        .segmented label {
            padding: 0.4rem 1rem;
            cursor: pointer;
            font-size: 0.9rem;
            background: #f8fafc;
            color: #334155;
            border-inline-start: 1px solid #cbd5e1;
        }
        .segmented label:first-of-type { border-inline-start: none; }
        .segmented input { position: absolute; opacity: 0; pointer-events: none; }
        .segmented label:has(input:checked) { background: #667eea; color: #fff; }
      </style>

      <.card title="TH01 · Built-in Color Scheme — auto / light / dark">
        <.tip>Every picker ships dark-ready — <code>--ms-*</code> colors are wrapped in <code>light-dark()</code>. Signal the scheme; the component picks the branch.</.tip>
        <p>
          Every picker ships <strong>dark-ready</strong>: all <code>--ms-*</code> color defaults are
          wrapped in CSS <code>light-dark()</code>, keyed on the host's <code>color-scheme</code>. You
          never override <code>--base-*</code> to go dark (that's what the theme cards further down do,
          for <em>custom</em> palettes) — you just <strong>signal the scheme</strong> and the component
          picks the right branch. Three ways, in priority order:
        </p>
        <ul>
          <li>
            <strong>Per-instance</strong>
            — <code>data-theme="dark"</code> / <code>"light"</code> on the
            <code>{"<web-multiselect>"}</code> itself (highest priority; overrides any ancestor).
          </li>
          <li>
            <strong>Framework class on an ancestor</strong>
            — <code>.dark</code> (Tailwind), <code>[data-bs-theme="dark"]</code> (Bootstrap 5.3+),
            or <code>[data-theme="dark"]</code>.
          </li>
          <li>
            <strong>Follow the OS</strong>
            — set no explicit signal and let the page opt into <code>color-scheme: light dark</code>;
            both the page and the picker track the system setting.
          </li>
        </ul>

        <div class="segmented" role="radiogroup" aria-label="Color scheme">
          <label><input type="radio" name="scheme" value="auto" checked /> Auto (OS)</label>
          <label><input type="radio" name="scheme" value="light" /> Light</label>
          <label><input type="radio" name="scheme" value="dark" /> Dark</label>
        </div>

        <div class="scheme-demo" id="scheme-demo">
          <.form_group style="max-width: 420px;">
            <label for="scheme-select" style="display:block; margin-bottom:.4rem; font-weight:600;">
              Select technologies
            </label>
            <.web_multiselect
              id="scheme-select"
              multiple={true}
              show_checkboxes={true}
              badges_display_mode="badges"
              options={@technologies}
            />
            <span class="form-text">
              Open the dropdown — the panel, options, checkboxes, badges and scrollbar all flip
              with the scheme. No per-instance color overrides in play.
            </span>
          </.form_group>
        </div>

        <details class="mt-1">
          <summary>Show code</summary>
          <.code_block>{@scheme_code}</.code_block>
        </details>
      </.card>

      <.card title="TH02 · Grouped options + fullscreen mode switch">
        <.tip>Grouped options in the fullscreen overlay with the built-in <code>filter</code>↔<code>navigate</code> toggle — all following the same color scheme.</.tip>
        <p>
          Everything at once: <strong>grouped options</strong> (<code>allow_groups</code>) rendered in the
          <strong>fullscreen overlay</strong>, with the built-in <code>filter</code>↔<code>navigate</code>
          toggle (<code>show_search_mode_toggle</code>) in the search header — all following the same
          built-in color scheme. Pick a scheme, tick <em>Preview as fullscreen</em>, open the picker, then
          tap the leading icon in the search bar (magnifier = navigate, funnel = filter). Group headers,
          matched rows, checkboxes, badges and the <code>N of M</code> match navigator all stay themed
          with zero per-instance color overrides.
        </p>

        <div class="segmented" role="radiogroup" aria-label="Color scheme">
          <label><input type="radio" name="scheme2" value="auto" checked /> Auto (OS)</label>
          <label><input type="radio" name="scheme2" value="light" /> Light</label>
          <label><input type="radio" name="scheme2" value="dark" /> Dark</label>
        </div>
        <label class="toggle-label" style="margin-inline-start: 1rem;">
          <input type="checkbox" id="grouped-fs-preview" /> Preview as fullscreen (desktop)
        </label>

        <div class="scheme-demo" id="grouped-demo">
          <.form_group style="max-width: 420px;">
            <label for="grouped-select" style="display:block; margin-bottom:.4rem; font-weight:600;">
              Select technologies
            </label>
            <.web_multiselect
              id="grouped-select"
              multiple={true}
              show_checkboxes={true}
              allow_groups={true}
              search_mode="navigate"
              show_search_mode_toggle={true}
              badges_display_mode="partial"
              badges_max_visible={3}
              options={@grouped_technologies}
            />
            <span class="form-text">
              Grouped by Frontend / Runtimes / Languages. In the fullscreen sheet, tap the leading
              search icon to switch filter ↔ navigate.
            </span>
          </.form_group>
        </div>

        <details class="mt-1">
          <summary>Show code</summary>
          <.code_block lang="elixir">{@grouped_code}</.code_block>
        </details>
      </.card>

      <.card title="TH03 · Sizing — scale the whole picker with --ms-rem">
        <.tip>Pick a preset with <code>input-size="xs | sm | md | lg | xl"</code>, all scaled off <code>--ms-rem: 10px</code></.tip>
        <p>
          Control input field dimensions with the <code>input-size</code>
          attribute. Five sizes available: xs, sm, md (default), lg, xl.
        </p>

        <table class="size-table">
          <thead>
            <tr style="background: #f3f4f6;">
              <th style="padding: 0.5rem 1rem; text-align: left; border: 1px solid #e5e7eb;">Size</th>
              <th style="padding: 0.5rem 1rem; text-align: left; border: 1px solid #e5e7eb;">Height</th>
              <th style="padding: 0.5rem 1rem; text-align: left; border: 1px solid #e5e7eb;">Font</th>
              <th style="padding: 0.5rem 1rem; text-align: left; border: 1px solid #e5e7eb;">
                Calc Formula
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;"><code>xs</code></td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">31px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">12px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>calc(3.1 * var(--ms-rem))</code>
              </td>
            </tr>
            <tr>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;"><code>sm</code></td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">33px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">13px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>calc(3.3 * var(--ms-rem))</code>
              </td>
            </tr>
            <tr style="background: #eff6ff;">
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>md</code> (default)
              </td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;"><strong>35px</strong></td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">14px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>calc(3.5 * var(--ms-rem))</code>
              </td>
            </tr>
            <tr>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;"><code>lg</code></td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">38px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">16px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>calc(3.8 * var(--ms-rem))</code>
              </td>
            </tr>
            <tr>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;"><code>xl</code></td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">41px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">18px</td>
              <td style="padding: 0.5rem 1rem; border: 1px solid #e5e7eb;">
                <code>calc(4.1 * var(--ms-rem))</code>
              </td>
            </tr>
          </tbody>
        </table>
        <p style="font-size: 0.875rem; color: #6b7280; margin-bottom: 1.5rem;">
          <strong>Note:</strong>
          Heights use Pure Admin standard. Base unit <code>--ms-rem: 10px</code>
          (default). Set <code>--ms-rem: 1rem</code> for Pure Admin integration.
        </p>

        <div class="size-grid">
          <.form_group>
            <label>Extra Small (xs)</label>
            <.web_multiselect
              id="size-xs"
              placeholder="Extra small input..."
              multiple={false}
              options={@technologies}
            />
          </.form_group>

          <.form_group>
            <label>Small (sm)</label>
            <.web_multiselect
              id="size-sm"
              placeholder="Small input..."
              multiple={false}
              options={@technologies}
            />
          </.form_group>

          <.form_group>
            <label>Medium (md) - Default</label>
            <.web_multiselect
              id="size-md"
              placeholder="Medium input (default)..."
              multiple={false}
              options={@technologies}
            />
          </.form_group>

          <.form_group>
            <label>Large (lg)</label>
            <.web_multiselect
              id="size-lg"
              placeholder="Large input..."
              multiple={false}
              options={@technologies}
            />
          </.form_group>

          <.form_group>
            <label>Extra Large (xl)</label>
            <.web_multiselect
              id="size-xl"
              placeholder="Extra large input..."
              multiple={false}
              options={@technologies}
            />
          </.form_group>
        </div>
      </.card>

      <.card title="TH05–TH10 · Theme Examples (Dark · Neon · Audi · Rounded · Sharp · Material + wrapper-only Glassmorphism)">
        <.tip>Whole themes from CSS vars on the element: <code>--base-accent-color</code> · <code>--base-input-bg</code> · <code>--ms-input-border-radius</code></.tip>
        <div class="theme-grid">
          <div class="theme-card dark-theme">
            <h2>🌙 Dark Mode</h2>
            <p>High contrast dark theme for low-light environments</p>
            <.form_group>
              <label for="dark-mode">Select Technologies</label>
              <.web_multiselect
                id="dark-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">Dark backgrounds with light text and purple accents</span>
            </.form_group>
          </div>

          <div class="theme-card neon-theme">
            <h2>⚡ Neon/Cyberpunk</h2>
            <p>Bright neon colors with glowing effects</p>
            <.form_group>
              <label for="neon-mode">Select Technologies</label>
              <.web_multiselect
                id="neon-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">
                Cyan and magenta with glowing shadows · custom double-chevron + square-x icons via <code>--base-icon-*</code>
              </span>
            </.form_group>
          </div>

          <div class="theme-card audi-theme">
            <h2>🚗 Audi Corporate</h2>
            <p>Clean, minimal corporate styling with subtle borders</p>
            <.form_group>
              <label for="audi-mode">Select Technologies</label>
              <.web_multiselect
                id="audi-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">Professional gray with Audi red accents</span>
            </.form_group>
          </div>

          <div class="theme-card rounded-theme">
            <h2>🌸 Rounded/Soft</h2>
            <p>Large border-radius with soft shadows and pastel colors</p>
            <.form_group>
              <label for="rounded-mode">Select Technologies</label>
              <.web_multiselect
                id="rounded-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">
                Warm gradient background with pink accents · soft circle icons via <code>--base-icon-*</code>
              </span>
            </.form_group>
          </div>

          <div class="theme-card sharp-theme">
            <h2>▪️ Sharp/Minimal</h2>
            <p>No border-radius, flat design, pure black and white</p>
            <.form_group>
              <label for="sharp-mode">Select Technologies</label>
              <.web_multiselect
                id="sharp-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">
                Brutalist design with sharp edges · filled square icons via <code>--base-icon-*</code>
              </span>
            </.form_group>
          </div>

          <div class="theme-card material-theme">
            <h2>📐 Material Design</h2>
            <p>Elevation shadows, vibrant colors, standard radius</p>
            <.form_group>
              <label for="material-mode">Select Technologies</label>
              <.web_multiselect
                id="material-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">
                Google Material Design principles · pre-oriented down-caret with <code>--ms-toggle-rotate-*</code> opt-out
              </span>
            </.form_group>
          </div>

          <div class="theme-card glass-theme">
            <h2>🔮 Glassmorphism</h2>
            <p>Frosted glass effect with backdrop blur and transparency</p>
            <.form_group>
              <label for="glass-mode">Select Technologies</label>
              <.web_multiselect
                id="glass-mode"
                placeholder="Choose your stack..."
                show_checkboxes={true}
                options={@technologies}
              />
              <span class="form-text">Translucent with blur effect (requires modern browser)</span>
            </.form_group>
          </div>
        </div>
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

      // Size examples — set input-size (no wrapper attr exists for it).
      const sizeIds = ['size-xs', 'size-sm', 'size-md', 'size-lg', 'size-xl'];
      sizeIds.forEach(async (id) => {
        const el = await wait(id);
        el.setAttribute('input-size', id.replace('size-', ''));
      });

      // Theme examples — enable select-all (no wrapper attr exists for it).
      const themeIds = ['dark-mode', 'neon-mode', 'audi-mode', 'rounded-mode', 'sharp-mode', 'material-mode', 'glass-mode'];
      themeIds.forEach(async (id) => {
        const el = await wait(id);
        el.setAttribute('show-select-all', 'true');
      });

      // Reusable Auto/Light/Dark switcher — drives the signal on a demo card that the
      // picker inside inherits. Auto = no signal + OS switching; light/dark = data-theme.
      const applySchemeTo = (card, value) => {
        if (value === 'auto') {
          card.removeAttribute('data-theme');
          card.style.colorScheme = 'light dark';
        } else {
          card.style.colorScheme = '';
          card.setAttribute('data-theme', value);
        }
      };
      // Delegate on document: listeners bound directly to these radios/checkbox are
      // dropped when LiveView patches the card's DOM on connect (the <web-multiselect>
      // survives via phx-update="ignore", plain form controls do not). One document
      // listener per switcher survives.
      const wireScheme = (radioName, card) => {
        if (!card) return;
        document.addEventListener('change', (e) => {
          const r = e.target;
          if (r && r.name === radioName && r.checked) applySchemeTo(card, r.value);
        });
        applySchemeTo(card, 'auto'); // match the checked radio on load
      };

      // TH01 · Built-in color-scheme demo.
      wireScheme('scheme', document.getElementById('scheme-demo'));

      // TH02 · Grouped options + fullscreen mode switch, themed.
      wireScheme('scheme2', document.getElementById('grouped-demo'));

      // Preview-as-fullscreen toggle (forces the overlay on desktop so the mode toggle shows).
      wait('grouped-select').then((groupedSelect) => {
        document.addEventListener('change', (e) => {
          if (e.target && e.target.id === 'grouped-fs-preview') {
            groupedSelect.setAttribute('mobile-presentation', e.target.checked ? 'fullscreen' : 'auto');
          }
        });
      });
    </script>
    """
  end
end
