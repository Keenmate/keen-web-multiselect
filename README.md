# keen_web_multiselect

Phoenix LiveView wrapper for [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect) — a themeable multi-select web component with typeahead, virtual scrolling, async search, and full keyboard navigation.

One package covers both plain HEEx and LiveView. The upstream JS + CSS are bundled, so no `npm install` is required.

## What's New in v2.0.0-rc.2

_Aligned with upstream `@keenmate/web-multiselect` `2.0.0-rc10`._

- **Mobile & fullscreen presentation** — on phone-sized touch devices the open dropdown (and the "N selected" popover) can now become a full-screen overlay with its own search field, close button, and page-scroll lock, instead of a floating panel anchored to the input (which thrashes the soft keyboard). Two new typed attributes drive it: `mobile_presentation` (`auto` default / `floating` / `fullscreen` — `fullscreen` forces the overlay on any device, handy for previewing on desktop) and `fullscreen_autofocus` (whether opening the sheet pops the keyboard immediately; default `false`). A third, `show_search_mode_toggle`, adds an in-overlay toggle to flip `search_mode` between `filter` and `navigate` live. All resolve reactively to orientation/resize.
- **Container-responsive badge collapse — `collapse_badges_below`** — set a pixel width and the control watches its **own** box (not the window) and collapses to the `count` badge mode ("N selected") while narrower than that, so a picker in a narrow column/sidebar never overflows with pills even on a wide monitor. A distinct axis from `mobile_presentation`, and composes with it.
- **Own the whole selection UI — `enable_selected_popover`** — set `false` to make the built-in selected-items popover inert (and drop its pointer cursor) when you render your own selection list from the `change` event. Pairs with `badges_display_mode="none"` + `show_counter`.
- **Bundled `@keenmate/web-multiselect` upgraded `2.0.0-rc02` → `2.0.0-rc10`** — the eight intervening RCs are largely the mobile/fullscreen work above (built on `@keenmate/web-components-core` `1.0.0-rc09`), plus: `search_mode="navigate"` now works on trees, RTL rebuilt on CSS logical properties (runtime `dir` switching), a bumped default border colour, a Lucide-consistent close/remove `×`, and rounded-dropdown-corner fixes. New JS-only callbacks are available on the element for hook-based consumers — `keydownCallback` (remap/veto keys), `renderBadgeCallback` (own the whole badge, not just its content), and `showMessage()` / `hideMessage()` (a component-anchored toast); the render callbacks also now carry a `presentation` flag (`isFullscreen`) so a single renderer can vary between the desktop dropdown and the phone sheet. `priv/static/multiselect.{js,css,d.ts}` were re-bundled and `Keenmate.WebMultiselect.upstream_version/0` now reports `"2.0.0-rc10"`. Many new `--ms-fullscreen-*` / `--ms-message-*` theming variables (see the [Theming guide](guides/theming.md)).

## What's New in v2.0.0-rc.1

_Aligned with upstream `@keenmate/web-multiselect` `2.0.0-rc02`._

- **Bundled upstream — the 2.0.0 "core adoption" major** — the bundled `@keenmate/web-multiselect` jumps from `1.12.0-rc08` to `2.0.0-rc02`, rebuilt on the shared `@keenmate/web-components-core` (`BlissElement`). The dropdown engine, CSS, tree mode, and virtual scroll are unchanged; what moved into the core is the element plumbing — attribute parsing, reactivity, positioning, logging, and registration. For you it's mostly invisible: `priv/static/multiselect.{js,css,d.ts}` were re-bundled (still one self-contained file — the core is inlined), and `Keenmate.WebMultiselect.upstream_version/0` now reports `"2.0.0-rc02"`.
- **Form integration is hook-free and rock-solid** — `<.web_multiselect field={@form[:tags]}>` inside a `<.form phx-change ... phx-submit ...>` just works with no hook: the element is a real form-associated control that writes `tags[]` hidden inputs and now exposes a native `.form`, so LiveView's `phx-change` live validation and `phx-submit` both see the selection like a native `<select multiple>`. The core rework briefly hid the form association behind a private field; upstream `2.0.0-rc02` restored a public `form` getter, so the wrapper dropped its old internals-reading shim and keeps only a defensive `closest("form")` fallback for pre-2.0 bundles. The README "Form integration" section was rewritten to show the hook-free pattern, and it's covered end-to-end by the form e2e suite.
- **Custom `value_member` events forward clean scalars** — if you key options by your own field (e.g. `value_member="userId"`) and forward events through the LV hook, `select`/`deselect` now push the extracted scalar value — not the whole option map. Previously the hook fell back to the raw option object when it couldn't find a `value`/`id`, which crashed scalar-expecting server handlers (`to_string/1` on a `Map`). It now uses the element's own extracted `selectedValues` plus the configured value-member, guaranteeing a scalar payload; a custom-`value_member` case in the e2e suite guards it.
- **New `data_options_*` attributes for HTML-authored option data** — upstream 2.0.0 lets the raw `data-options` attribute carry JSON, CSV, or plain-text; the wrapper exposes it via `data_options_format` (`json` default / `csv` / `plain`) plus `data_options_splitter` and `data_options_row_splitter` for custom field/row delimiters. These only matter if you hand-write a raw `data-options` string — the normal `options={...}` prop always emits JSON, so the default path is untouched.

## What's New in v1.0.0-rc.5

_Aligned with upstream `@keenmate/web-multiselect` `1.12.0-rc08`._

- **Independently sizable panels — `dropdown_width` / `selected_popover_width`** — the control input, the options dropdown, and the "N selected" popover are three separate panels, and you can now size the latter two independently of the input and of each other. Both are typed-attribute sugar over CSS variables: `dropdown_width` writes `--ms-dropdown-width` (which otherwise tracks the input width) and `selected_popover_width` writes `--ms-selected-popover-width` (intrinsic `32rem`). Set the variables at app/theme level to size every picker at once, or use the attributes to override a single instance. Documented in `guides/theming.md` ("Independent panel widths") and demoed as section 14 on `/examples/tree`.
- **Tree metadata in the custom node renderer — `renderOptionContentCallback(item, ctx)`** — on tree rows the JS-side render callback's context now carries the hierarchy: `isTreeNode`, `isBranch`, `isLeaf`, `childCount`, `level`, `depth`, `path`, `isSelectable`, and `isIndeterminate` (the cascade tristate). A custom renderer can branch on node type without re-deriving it — e.g. draw a child-count badge on branches and a plain label on leaves — while the component still draws the tree chrome (checkbox, indentation, state classes) around your content. Demoed as the new section 12 ("Custom Node Rendering").
- **Bundled `@keenmate/web-multiselect` upgraded to `1.12.0-rc08`** — beyond the two features above, rc08 adds a counter-chip tooltip, makes the cascade counter count the rolled-up cover (rather than the emit policy), and fixes two rough edges: a live `checkbox_mode` / `cascade_select_policy` switch now re-projects the current selection instead of needing a rebuild, and badge hover no longer washes out to white. `priv/static/multiselect.{js,css,d.ts}` were re-bundled and `Keenmate.WebMultiselect.upstream_version/0` now reports `"1.12.0-rc08"`.

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
#=> "2.0.0-rc10"
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
