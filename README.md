# keen_web_multiselect

Phoenix LiveView wrapper for [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect) — a themeable multi-select web component with typeahead, virtual scrolling, async search, and full keyboard navigation.

One package covers both plain HEEx and LiveView. The upstream JS + CSS are bundled, so no `npm install` is required.

## What's New in v2.0.0

_First stable release of the wrapper, aligned with upstream `@keenmate/web-multiselect` `2.2.0`. Consolidates everything from the `2.0.0-rc.1`/`2.0.0-rc.2` pre-releases — the wrapper is versioned **independently** of upstream (see [Versioning](#versioning)); `Keenmate.WebMultiselect.upstream_version/0` reports the bundled upstream version._

- **Declarative client-side REST loading — `data-fetch-*` attributes** — point a picker at an HTTP endpoint and it fetches its **own** options, bypassing the LiveView process (a public API, or a same-origin API authed by the session cookie). Pure HEEx, no per-instance JavaScript: `data-fetch-url` (+ optional `data-fetch-mode`, `data-fetch-headers`, `data-fetch-credentials`, `data-fetch-query-param`, `data-fetch-results-path`). Header values render server-side, so secrets stay in Elixir and never land in the JS bundle. For cases the attributes don't cover, import and call the exported `wireRestOptions(el, opts)` escape hatch.
- **Theme every picker from one place, flash-free — `<.shadow_styles/>` + `defer`** — point `:shadow_styles` at CSS (inline string, `{:file, path}`, or a function / `{mod, fun, args}`) and drop `<Keenmate.WebMultiselect.Components.shadow_styles/>` once in your root layout; the client registry adopts it into every element's shadow root (`adoptedStyleSheets`) — one shared sheet, not duplicated per instance, with `:host(.your-class) …` opt-in via a plain `class`. When it's configured the wrapper also emits upstream's `defer` render gate automatically, so the element builds nothing until the sheet is adopted, then paints themed badges in **one shot** (no default-style flash). See the [Theming guide](guides/theming.md).
- **Server-driven imperative control — `Keenmate.WebMultiselect.push_command/3`** — drive a mounted picker from the LiveView process without touching options or selection: `open` / `close` / `toggle`, `search` / `clear_search`, or `scroll_to_value` / `scroll_to_group` / `scroll_to_index`. Pair with the new **`ready_event`** (a one-shot "the element is ready" trigger) for an "open + scroll" on page entry.
- **"Add new" creation, inline clear, single-active overlays** — `allow_add_new` shows a clickable "Add new …" prompt on an empty search (commit it with or without a JS `addNewCallback`; with a hook attached the choice fires `"web_multiselect:add"`); `show_clear` renders an inline ✕ that wipes the selection; `overlay_group` makes pickers dismiss each other when one opens.
- **Mobile & responsive** — `mobile_presentation` (`auto` / `floating` / `fullscreen`) turns the dropdown into a phone full-screen overlay with its own search + close, `fullscreen_autofocus` controls the soft keyboard, `show_search_mode_toggle` flips filter/navigate in the overlay, and `collapse_badges_below` collapses to the count badge based on the control's **own** width (not the window).
- **Grouped select-all + selection ordering** — `group_select_mode="cascade"` gives each flat-list group header a tristate select-all checkbox and a per-group `[N]` count (the group name is never a selected value); `selected_order` (+ `selected_order_member`) orders the *chosen* items across badges, "+N more", and the popover, display-only (the submitted form value keeps as-selected order).
- **`custom-styles` — static shadow-DOM CSS without JS** — the element now takes a `custom-styles` attribute (a raw CSS string dropped verbatim into the same slot `customStylesCallback` targets). No dedicated wrapper attr, but the component's `:global` passthrough carries it — `custom-styles={"..."}` on `<.web_multiselect>` reaches the element verbatim.
- **Tree `checkbox_mode` now defaults to `cascade`** — checking a branch checks its whole subtree and the emitted selection follows `cascade_select_policy` (default `rolled-up`). **Behavior change** for existing tree consumers — set `checkbox_mode="independent"` to keep the old per-node toggling. Flat and single-select lists are unaffected.
- **Bundled `@keenmate/web-multiselect` upgraded `2.0.0-rc02` → `2.2.0`** — one bundle jump across the whole 2.0.x/2.1.0/2.2.0 span (imperative API, field-shell input, single-active overlays, mobile/fullscreen, `defer`, groups/cascade), landing on the first stable `2.2.0`. The final release standardizes callback context — the action-button and display `get*` callbacks now receive a typed second argument (`ActionContext` / render context), fully additive so existing one-argument callbacks keep working. Headline fixes worth calling out: single-select no longer keeps a stale multi-selection when seeded with more than one value, single-select no longer clears on re-click, async-search dropdowns no longer overflow the viewport when results grow the panel, and the per-group count chip now scales in the phone fullscreen overlay. `priv/static/multiselect.{js,css,d.ts}` re-bundled; `Keenmate.WebMultiselect.upstream_version/0` now reports `"2.2.0"`.

## Install

```elixir
def deps do
  [
    {:keen_web_multiselect, "~> 2.0"}
  ]
end
```

## Wire up the assets

The bundled JS and CSS live in this library's `priv/static/` directory.

### Quick start — the installer

On a standard esbuild Phoenix app, let the installer wire everything for you:

```sh
mix keen_web_multiselect.install
```

It edits `assets/js/app.js` (imports + `LiveSocket` hook registration) and
`assets/css/app.css` (stylesheet import), idempotently — re-running is safe. Pass
`--dry-run` to preview. Anything it can't confidently patch (an unusual `LiveSocket`
setup, an importmap app with no `assets/js/app.js`) is left untouched and printed as a
manual step. To wire it by hand, use one of the two paths below.

### Path A — import from `deps/` (esbuild, the Phoenix default)

In `assets/js/app.js`:

```js
import KeenWebMultiselectHook from "../../deps/keen_web_multiselect/priv/static/keen_web_multiselect_hook.js";
import "../../deps/keen_web_multiselect/priv/static/multiselect.js";

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { KeenWebMultiselectHook },
  params: { _csrf_token: csrfToken }
});
```

In `assets/css/app.css`:

```css
@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";
```

### Path B — serve directly from the dep's `priv/static`

In your endpoint, add another `Plug.Static`:

```elixir
plug Plug.Static,
  at: "/keen_web_multiselect",
  from: {:keen_web_multiselect, "priv/static"},
  gzip: false,
  only: ~w(multiselect.js multiselect.css keen_web_multiselect_hook.js keen_web_multiselect_defaults.js)
```

Then reference `/keen_web_multiselect/multiselect.js` from your layout `<script type="module">` tag and the CSS from a `<link>`.

> `keen_web_multiselect_hook.js` imports `keen_web_multiselect_defaults.js` (the shared-styles registry). When you bundle (esbuild), it's inlined automatically. When you serve files individually like above, add it to the `only:` list — otherwise the hook's import 404s. It's not needed if you load neither the hook nor `<.shadow_styles/>`.

## Use the component

Import the component in the module where you render templates (a `LiveView`, a `LiveComponent`, or your `MyAppWeb.html_helpers/0`):

```elixir
import Keenmate.WebMultiselect.Components
```

### Declarative — no JavaScript needed

```heex
<.web_multiselect id="answer" multiple={false}>
  <option value="yes">Yes</option>
  <option value="no">No</option>
  <option value="maybe" selected>Maybe</option>
</.web_multiselect>
```

### Programmatic

```heex
<.web_multiselect
  id="languages"
  placeholder="Pick a language"
  search_placeholder="Search…"
  options={[
    %{value: "js", label: "JavaScript", icon: "🟨"},
    %{value: "ts", label: "TypeScript", icon: "🔷"},
    %{value: "py", label: "Python", icon: "🐍"}
  ]}
  value={["py"]}
/>
```

### LiveView events

Set `hook={true}` and the hook will forward the upstream `select`, `deselect`, and `change` events to your LiveView (pass a string instead to name a custom hook):

```heex
<.web_multiselect
  id="tags"
  hook={true}
  options={@tag_options}
  value={@selected_tags}
/>
```

```elixir
def handle_event("web_multiselect:change", %{"id" => "tags", "values" => values}, socket) do
  {:noreply, assign(socket, :selected_tags, values)}
end

def handle_event("web_multiselect:select", %{"id" => "tags", "value" => value}, socket) do
  # ...
end
```

### Driving the component from the server

Because the element renders `phx-update="ignore"`, LiveView's DOM patcher won't push
new options or a new selection to it. Use `Keenmate.WebMultiselect.push_update/3`
(the sanctioned channel — it sends the event `KeenWebMultiselectHook` listens for):

```elixir
# Cascading selects — parent changed, swap the child's options and clear it
def handle_event("web_multiselect:change", %{"id" => "country", "values" => [c]}, socket) do
  {:noreply, Keenmate.WebMultiselect.push_update(socket, "region", options: regions(c), value: [])}
end

# Server-authoritative rule — allow optimistically, then correct
def handle_event("web_multiselect:change", %{"id" => "tags", "values" => v}, socket) when length(v) > 3 do
  {:noreply, Keenmate.WebMultiselect.push_update(socket, "tags", value: Enum.take(v, 3))}
end
```

Only the keys you pass are sent: `value: []` clears the selection without touching
the options; `options: opts` swaps options and leaves the selection to the component.
The target needs `hook={true}` and a matching `id`.

### Server-side search

Set `search_event` and the hook installs an async `searchCallback` that runs each
query through your LiveView — no JavaScript. Reply from `handle_event/3` with
`{:reply, %{results: [...]}, socket}`; the results (in the usual option shape)
populate the dropdown:

```heex
<.web_multiselect
  id="repos"
  hook={true}
  search_event="search_repos"
  search_placeholder="Search GitHub…"
/>
```

```elixir
def handle_event("search_repos", %{"id" => "repos", "query" => q}, socket) do
  results =
    q
    |> MyApp.GitHub.search_repos()
    |> Enum.map(&%{value: &1.id, label: &1.full_name})

  {:reply, %{results: results}, socket}
end
```

The reply must use `{:reply, %{results: ...}, socket}` (not `{:noreply, ...}`) — the
hook resolves the pending search with `reply.results`. Queries that are superseded by
a newer keystroke are dropped client-side (the rc04 `AbortSignal` contract), so a slow
stale reply never overwrites fresher results. Pair with `search_debounce` to collapse
keystroke bursts into a single round-trip.

### Form integration

Pass a `Phoenix.HTML.FormField` and the component fills in `id`, `name`, and the initial value — no other wiring, and **no hook required**:

```heex
<.form for={@form} phx-change="validate" phx-submit="save">
  <.web_multiselect field={@form[:tags]} options={@tag_options} />

  <.button>Save</.button>
</.form>
```

That's the whole setup. It works because `<web-multiselect>` is a real form-associated custom element: it writes hidden inputs named after `@form[:tags]` (`tags[]`, one per value) into the form, and — since it exposes a native `.form` — LiveView's `phx-change` delegation picks up every selection change. So `phx-change` (live validation) and `phx-submit` both see the selected values in `params[form_name]["tags"]`, exactly like a native `<select multiple>`. Pre-selected values from the `FormField` render as badges on mount.

The optional `hook={true}` is **orthogonal** to this — add it only when you also want the raw `select`/`deselect`/`change` events pushed to the server as `web_multiselect:*` messages, or to drive the element from the server via `push_update` (see [Driving the component from the server](#driving-the-component-from-the-server)). Plain `<.form>` binding needs none of that.

## Attributes

Every documented attribute from the upstream component is exposed as a typed `attr/3`. See `Keenmate.WebMultiselect.Components.web_multiselect/1` for the full list, or the [upstream usage docs](https://github.com/keenmate/web-multiselect/blob/main/docs/usage.md) for what each one does.

Snake_case in HEEx maps to kebab-case on the rendered element: `search_placeholder` → `search-placeholder`, `badges_display_mode` → `badges-display-mode`, etc.

## Theming

The component is styled entirely through CSS custom properties, in a two-tier
cascade: component tokens (`--ms-*`) each fall back to a shared design token
(`--base-*`), so it works out of the box, inherits a design system when one is
present, and is overridable per-instance from HEEx via `class` / `style`.

See the **[Theming guide](guides/theming.md)** for the three integration paths:

- **With pure-admin** — the multiselect inherits the `--base-*` tokens pure-admin
  provides, matching palette and dark mode with zero configuration.
- **With other KeenMate components (no pure-admin)** — define the `--base-*` layer
  yourself once as a single source of truth; every component reads it.
- **Standalone** — built-in `light-dark()` fallbacks give a working light/dark
  theme; override `--ms-*` to restyle just the multiselect.

## Versioning

`keen_web_multiselect` versions are independent of `@keenmate/web-multiselect`. The bundled upstream version is reported by:

```elixir
Keenmate.WebMultiselect.upstream_version()
#=> "2.2.0"
```

## For LLMs and coding agents

A flat-text knowledge base for coding agents ships in the package under the `ai/`
folder — modelled on the upstream component's `ai/` layout but written for this
wrapper. Browse it in the
[repository](https://github.com/keenmate/keen-web-multiselect/tree/HEAD/ai), or
read it from `deps/keen_web_multiselect/ai/` in a consuming app: start at
`ai/INDEX.txt` (keyword index + common questions) or `ai/cookbook.txt`
(copy-paste recipes).

On hexdocs, see the **Using with AI agents** page. ex_doc also publishes a
machine-readable `llms.txt` for the package (the [llms.txt](https://llmstxt.org)
convention), so agents that fetch `hexdocs.pm/keen_web_multiselect/llms.txt` get a
structured index of the docs.

## License

MIT.
