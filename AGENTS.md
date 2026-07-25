# AGENTS.md

Guidance for AI coding agents working in or with `keen_web_multiselect` — the
Phoenix LiveView wrapper for the `@keenmate/web-multiselect` custom element.

## Read this first

A flat-text knowledge base for LLMs ships in the **`ai/`** folder
([browse in the repo](https://github.com/keenmate/keen-web-multiselect/tree/HEAD/ai),
or read from `deps/keen_web_multiselect/ai/` in a consuming app). It is the
fastest way to answer "how do I use this?" — start at `ai/INDEX.txt` (keyword
index, common questions, features-by-category), then open the relevant topic file
or `ai/cookbook.txt`.

| You need… | Read |
|-----------|------|
| Install + asset wiring + first render | `ai/getting-started.txt` |
| The `<.web_multiselect>` attributes | `ai/component-reference.txt` (full list: hexdocs `web_multiselect/1`) |
| React to selection changes in LiveView | `ai/liveview-events.txt` |
| Change options/selection from the server | `ai/server-updates.txt` (`push_update/3`) |
| Async / server-side search | `ai/server-search.txt` (`search_event`) |
| Use it in a form | `ai/forms.txt` |
| Option shapes / custom data keys | `ai/data-and-options.txt` |
| Colors / dark mode / sizing | `ai/theming.txt` and `guides/theming.md` |
| Use without LiveView (dead view / SSR) | `ai/dead-views-and-ssr.txt` |
| Copy-paste recipes | `ai/cookbook.txt` |

## Core facts (don't get these wrong)

- The component is `<.web_multiselect>` from `Keenmate.WebMultiselect.Components`
  (`import` it). No process/GenServer state; the same call works in a dead view
  and a LiveView.
- snake_case HEEx attrs → kebab-case element attrs. Booleans render explicit
  `"true"`/`"false"`. A `nil` attr is omitted (upstream default applies).
- LiveView events are **opt-in** via `hook={true}` (resolves to
  `"KeenWebMultiselectHook"`). Events: `"web_multiselect:change"`
  (`%{"id","values"}`), `":select"` / `":deselect"` (`%{"id","value","values"}` —
  `value` is the delta, `values` the full selection after it).
- The element renders `phx-update="ignore"`, so re-rendering will **not** push new
  options/selection. Use `Keenmate.WebMultiselect.push_update(socket, id, options:/value:)`.
- Server-side search replies with `{:reply, %{results: [...]}, socket}` — not
  `{:noreply, ...}`.
- Options: maps `%{value:, label:, icon?:, subtitle?:, group?:, disabled?:}` or
  `{value, label}` tuples (value first). The six member attrs default to those
  canonical keys.

## Repo conventions

- Elixir/Phoenix follows the **Bliss Framework** house style (see the KeenMate
  Bliss guidelines). Match the surrounding code.
- **Documentation is a first-class deliverable** — when you change public surface
  (a component attr, a helper, an event), update the docs in the same change:
  the `@doc`/hexdocs, `README.md`, the relevant `ai/` file, and `guides/` if
  theming/behavior is affected. Keep `ai/cookbook.txt` recipes runnable.
- Releases go through the `/publish` flow / `make publish-rc`. `mix hex.publish`
  ships package **and** docs together.
- The demo/examples app is `test_app/` (served at `/examples/*`), deployed to
  keen-web-multiselect.keenmate.dev.
