# keen_web_multiselect

Phoenix LiveView wrapper for [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect) — a themeable multi-select web component with typeahead, virtual scrolling, async search, and full keyboard navigation.

One package covers both plain HEEx and LiveView. The upstream JS + CSS are bundled, so no `npm install` is required.

## What's New in v1.0.0-rc.3

- **Docs — a dedicated Theming guide** — The component is styled entirely through CSS custom properties, so how those variables work is core knowledge — and the wrapper shipped none of it. The new [Theming guide](guides/theming.md) (in the Hex package and on hexdocs) explains the two-tier cascade where each component token `--ms-*` falls back to a shared design token `--base-*`, then walks the three integration paths: inheriting **pure-admin**'s tokens for free, defining your **own `--base-*` layer** shared across KeenMate components, or running **standalone** with the built-in `light-dark()` fallbacks and per-instance `--ms-*` overrides from HEEx `class`/`style`. Dark-mode signals, `--ms-rem` sizing, and the unlayered-reset footgun are covered too.
- **Package — the live examples site is now linked from Hex** — `mix.exs` gained a `homepage_url` and an "Examples site" link pointing at [keen-web-multiselect.keenmate.dev](https://keen-web-multiselect.keenmate.dev), so the running demo gallery is one click from the package page and hexdocs sidebar.
- **LLM / coding-agent docs — an `ai/` folder ships in the package** — A flat-text knowledge base (`ai/INDEX.txt` + topic files + a 12-recipe `ai/cookbook.txt`) written for the wrapper, so a coding agent can learn `<.web_multiselect>`, the LiveView hook, `push_update/3`, `search_event`, forms, and theming from `deps/keen_web_multiselect/ai/`. On hexdocs it's fronted by a **Using with AI agents** guide, plus ex_doc's generated `llms.txt` index.

## What's New in v1.0.0-rc.2

- **Docs — every component attribute is now documented** — The `web_multiselect/1` reference gained descriptions for the 46 attributes that previously rendered with a blank Description column in hexdocs (the behavior, badges, search, member, and virtual-scroll groups), each noting the relevant upstream default where useful, plus a short "Attribute defaults" preamble explaining the `nil`-means-omit convention. The install snippet was also corrected from the stale `~> 0.1` to `~> 1.0` (with a note on requiring `~> 1.0.0-rc` to opt into the current release candidate). Documentation-only — no code or behavior change.

## Install

```elixir
def deps do
  [
    {:keen_web_multiselect, "~> 1.0"}
  ]
end
```

> **Currently a release candidate.** Only `1.0.0-rc.*` is published so far, and Mix
> skips pre-releases for a plain `~> 1.0` constraint. Until `1.0.0` is final, opt in by
> requiring the pre-release explicitly:
>
> ```elixir
> {:keen_web_multiselect, "~> 1.0.0-rc"}
> ```

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
  only: ~w(multiselect.js multiselect.css keen_web_multiselect_hook.js)
```

Then reference `/keen_web_multiselect/multiselect.js` from your layout `<script type="module">` tag and the CSS from a `<link>`.

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

Pass a `Phoenix.HTML.FormField` and the component fills in `id`, `name`, and the initial value:

```heex
<.simple_form for={@form} phx-change="validate">
  <.web_multiselect
    field={@form[:tags]}
    options={@tag_options}
    hook={true}
  />
</.simple_form>
```

The underlying `<web-multiselect>` writes a hidden input named after `@form[:tags]`, so `phx-change` and `phx-submit` see the selected values in `params[form_name]["tags"]` just like a native `<select>`.

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
#=> "1.12.0-rc07"
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
