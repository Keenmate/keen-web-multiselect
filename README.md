# keen_web_multiselect

Phoenix LiveView wrapper for [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect) — a themeable multi-select web component with typeahead, virtual scrolling, async search, and full keyboard navigation.

One package covers both plain HEEx and LiveView. The upstream JS + CSS are bundled, so no `npm install` is required.

## What's New in v1.0.0-rc.1

- **Component — `<.web_multiselect>` covers the full upstream API as a pure render** — `Keenmate.WebMultiselect.Components.web_multiselect/1` declares a typed `attr/3` for every documented `<web-multiselect>` attribute (booleans, `values:`-whitelisted enums, integers, JSON option lists), mapping snake_case in HEEx to kebab-case on the element (`search_placeholder` → `search-placeholder`). Booleans render as explicit `"true"`/`"false"` because several upstream booleans default to `true` and need a real opt-out, not HTML presence. No GenServer, no state — the same call works identically in a dead view and a LiveView.
- **One-command installer — `mix keen_web_multiselect.install`** — Wires a standard esbuild Phoenix app for you: imports the bundled `multiselect.js` + hook into `assets/js/app.js`, registers `KeenWebMultiselectHook` on your `LiveSocket` (merging into the stock `hooks: {...colocatedHooks}` object), and imports `multiselect.css` into `assets/css/app.css`. Idempotent and conservative — anything it can't confidently patch is left untouched and printed as a manual step. `--dry-run` previews.
- **Bundled assets — no npm install** — The upstream `@keenmate/web-multiselect` build (currently 1.12.0-rc05) ships inside the Hex package's `priv/static/` alongside `multiselect.d.ts` and the LV hook; `Keenmate.WebMultiselect.upstream_version/0` reports which upstream you're getting. Wire it via the installer, an esbuild import from `deps/`, or a `Plug.Static` mount.
- **LiveView events — opt in with `hook={true}`** — Set `hook={true}` and the hook forwards the component's `select`/`deselect`/`change` events to the server as `"web_multiselect:select"` / `":deselect"` / `":change"` with payload `{id, value, values}`, so `handle_event/3` matches by id. `hook={true}` resolves to the bundled `"KeenWebMultiselectHook"`; pass a string for a custom hook. Omit it for plain HEEx where the form's hidden input is enough.
- **Server-driven updates — `Keenmate.WebMultiselect.push_update/3`** — Push new options or a new selection from the LiveView process: `push_update(socket, "region", options: opts, value: [])`. It's the sanctioned path across the `phx-update="ignore"` boundary (which otherwise blocks LV from morphing option changes onto the element); only the keys you pass are sent, so it covers cascades, resets, and server-authoritative corrections cleanly.
- **Server-side search — `search_event`** — `<.web_multiselect search_event="search_repos" hook={true} />` installs an async `searchCallback` that tunnels each query to your LiveView; reply with `{:reply, %{results: [...]}, socket}` and the dropdown fills — zero JavaScript. Superseded queries are dropped client-side (the upstream `AbortSignal` contract), and `search_debounce` collapses keystroke bursts.
- **Form integration — `field={@form[:tags]}`** — Pass a `Phoenix.HTML.FormField` and `FormHelpers.assign_from_field/1` fills `id`/`name`/value; explicit assigns win. The value flows into the upstream `initial-values` attribute, and the component writes a hidden input named after the field, so `phx-change`/`phx-submit` see the selection in `params[form_name]["tags"]` exactly like a native `<select multiple>`.
- **LiveView morph compatibility — three quirks handled for you** — Putting a self-rendering custom element in LiveView needs three fixes the wrapper applies automatically: `phx-update="ignore"` is emitted whenever `:id` is set (keeps morphdom out of the component's shadow children); `data-ready=""` is pre-emitted so the placeholder doesn't flash on WS connect; and a `.form` getter is polyfilled onto the element (without it, Phoenix's `phx-change` delegation silently drops the component's CustomEvents). The polyfill installs even if you never opt into the hook.

## Install

```elixir
def deps do
  [
    {:keen_web_multiselect, "~> 0.1"}
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

## Versioning

`keen_web_multiselect` versions are independent of `@keenmate/web-multiselect`. The bundled upstream version is reported by:

```elixir
Keenmate.WebMultiselect.upstream_version()
#=> "1.12.0-rc05"
```

## License

MIT.
