# Theming

The multiselect is styled entirely through **CSS custom properties**. Nothing
about theming is specific to this Elixir wrapper — you set the same variables
you would with the raw web component — but this guide frames it for a Phoenix
app: where the CSS goes, and how the variables reach `<.web_multiselect>`.

For the exhaustive list of every variable (150+), see the upstream
[theming reference](https://github.com/keenmate/web-multiselect/blob/main/docs/theming.md)
and the interactive [KeenMate Theme Designer](https://theme-designer.keenmate.dev).

## The two-tier variable cascade

Every visible color, size, and effect is exposed as a `--ms-*` variable, and
**each `--ms-*` variable is defined as `var(--base-*, <fallback>)`**. For example,
straight from the bundled `multiselect.css`:

```css
--ms-accent-color:  var(--base-accent-color, #3b82f6);
--ms-text-color-1:  var(--base-text-color-1, light-dark(#111827, #f5f5f5));
--ms-input-bg:      var(--base-input-bg, light-dark(#ffffff, #1a1a1a));
--ms-border:        var(--base-border, 1px solid var(--ms-border-color));
```

That gives two layers you can theme at:

| Layer | Prefix | Who provides it | Effect |
|-------|--------|-----------------|--------|
| **Base / design tokens** | `--base-*` | You, or a design system that fills them in (pure-admin) | Shared across *all* KeenMate components at once |
| **Component tokens** | `--ms-*` | This component | Affects only the multiselect |

The `--base-*` layer is the components' own cross-component token **contract** —
it predates pure-admin. It was introduced first simply because a shared base
layer was convenient; pure-admin came later and populates exactly these tokens,
which is why adopting pure-admin themes the multiselect "for free." You can
provide the `--base-*` values yourself (Scenario B) and get the same benefit
without pure-admin.

Because `--ms-*` falls back to a hardcoded default (with `light-dark()` for
automatic light/dark), the component **works out of the box with no variables
defined at all**. Define `--base-*` and it inherits your design system; override
`--ms-*` and you tweak just the multiselect.

> **Shadow DOM is not a barrier.** The component renders into a shadow root, but
> CSS custom properties inherit *through* the shadow boundary. A `--ms-accent-color`
> set on `:root`, on `web-multiselect`, or inline on the element all reach the
> internals. You never need `::part()` for color/size theming.

### Where the CSS lives in a Phoenix app

On a standard esbuild app, put theme rules in `assets/css/app.css` **after** the
component's stylesheet import:

```css
@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";

:root {
  --base-accent-color: #7c3aed;   /* affects every KeenMate component */
}

web-multiselect {
  --ms-border-radius: 0.5rem;      /* affects only multiselects */
}
```

Per-instance, use the forwarded `class` and `style` attributes on the component:

```heex
<.web_multiselect id="tags" class="compact" style="--ms-rem: 8px;" options={@opts} />
```

(`class`, `style`, and any `data-*` attribute pass straight through to the
`<web-multiselect>` element — see `Keenmate.WebMultiselect.Components.web_multiselect/1`.)

---

## Scenario A — with pure-admin

pure-admin populates the `--base-*` token contract (colors, text scale, input
sizes, dark-mode surfaces) at `:root`. The components were already reading those
tokens — every `--ms-*` variable is `var(--base-*, …)` — so when pure-admin
supplies them, **the multiselect themes itself to match with zero
component-specific configuration** — same accent, same borders, same dark
palette. It worked "for free" precisely because the `--base-*` layer existed
first and pure-admin filled it in.

Load pure-admin's stylesheet, then the component's, then you're done:

```css
/* assets/css/app.css */
@import "pure-admin/dist/pure-admin.css";                                  /* defines --base-* */
@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";     /* --ms-* read them */
```

One alignment knob worth setting: pure-admin scales from `html { font-size: 10px }`,
and the component's proportional unit is `--ms-rem` (which resolves to
`var(--base-rem, 10px)`). If pure-admin sets `--base-rem` the two already scale
together; otherwise point `--ms-rem` at `rem` explicitly:

```css
web-multiselect { --ms-rem: 1rem; }
```

**Dark mode comes for free.** pure-admin toggles dark via a `data-bs-theme="dark"`
(or `data-theme="dark"`) attribute on an ancestor; the multiselect honors that
same signal (see [Dark mode](#dark-mode) below), so flipping pure-admin's theme
flips the multiselect too. You do not wire up anything.

---

## Scenario B — with other KeenMate components, without pure-admin

If you use several KeenMate components (multiselect, web-daterangepicker, …) but
not pure-admin, define the `--base-*` layer **yourself, once**, as your single
source of truth. Every component reads it:

```css
/* assets/css/app.css — your design tokens */
:root {
  --base-accent-color:  #3b82f6;
  --base-main-bg:       light-dark(#ffffff, #1a1a1a);
  --base-hover-bg:      light-dark(#f3f4f6, #262626);
  --base-text-color-1:  light-dark(#111827, #f5f5f5);
  --base-border-color:  light-dark(#e5e7eb, #3a3a3a);
}
```

Change `--base-accent-color` once and the multiselect (`--ms-accent-color`), the
daterangepicker (`--drp-accent-color`), and every other component update together.
The **Tier-1** names are aligned across components so the mapping is predictable:

| Purpose | Base token | multiselect | daterangepicker |
|---------|-----------|-------------|-----------------|
| Brand / accent | `--base-accent-color` | `--ms-accent-color` | `--drp-accent-color` |
| Background | `--base-hover-bg` * | `--ms-primary-bg` | `--drp-primary-bg` |
| Text | `--base-text-color-1` | `--ms-text-color-1` | `--drp-text-primary` |
| Border | `--base-border-color` | `--ms-border-color` | `--drp-border-color` |

\* Accent, text, and border map 1:1. Background is the one indirect case:
`--ms-primary-bg` reads `--base-hover-bg` first, falling back to a `color-mix`
over `--base-main-bg` when it's unset — so set **both** (as above) for a
predictable surface color.

This *is* the base-layer contract in its original form — a shared token set you
own. pure-admin is simply one ready-made provider of it; Scenario B is "bring
your own base layer" and predates the pure-admin option.

---

## Scenario C — standalone / just the multiselect

No `--base-*` tokens, no other components. The component's built-in fallbacks —
each with `light-dark()` — already give a working light **and** dark theme, so
you can ship with nothing at all.

To restyle only the multiselect, override `--ms-*` directly. Scope it to the
element selector so it can't leak into other components:

```css
web-multiselect {
  --ms-accent-color:        #10b981;   /* emerald */
  --ms-input-border-radius: 0.5rem;
  --ms-options-max-height: 24rem;
}
```

…or to a single instance from HEEx:

```heex
<.web_multiselect
  id="languages"
  style="--ms-accent-color:#e11d48; --ms-badge-border-radius:9999px;"
  options={@languages}
/>
```

Because these are `--ms-*` (not `--base-*`), nothing else on the page is affected.

---

## Sharing arbitrary shadow-DOM CSS across every instance

Everything above is **CSS custom properties**, and those pierce the shadow DOM — so a
project-wide theme is a `:root` (or `web-multiselect`) rule set **once**, with no
JavaScript. **Reach for variables first.** This section is only for the residual: styling
the component's shadow-DOM internals (or your own custom badge/option classes) with
*arbitrary* CSS that variables can't express — which page CSS can't reach, and the
component exposes no `::part()`.

The wrapper lets you ship that CSS **once** and adopt it into every element's shadow root.

### Configure it from application config

Point `:shadow_styles` at your CSS (an inline string, a `{:file, path}`, or a
function / `{mod, fun, args}` that returns the CSS):

```elixir
# config/config.exs
config :keen_web_multiselect, shadow_styles: {:file, "assets/ms-shadow.css"}
```

Then drop the component **once** in your root layout — ideally inside `<head>`:

```heex
<Keenmate.WebMultiselect.Components.shadow_styles />
```

It inlines your CSS into a `<template>` and hands it to the client registry, which
compiles it into a single [Constructable Stylesheet](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleSheet)
and **adopts it into every `<web-multiselect>` shadow root** (`adoptedStyleSheets`) — now
and for elements added later (dead views and LiveView alike). One shared sheet, applied
deterministically, that survives the component's own re-renders and isn't duplicated per
instance. Renders nothing when `:shadow_styles` is unset. Under a strict CSP, pass a
nonce: `<.shadow_styles nonce={@csp_nonce} />`.

Because the sheet lives inside each shadow root, `:host(...)` selectors target the element
itself:

```css
/* assets/ms-shadow.css — styles the component's shadow internals */
.ms__badge { border-radius: 999px; }                       /* every select */
:host(.brand) .ms__badge { background: linear-gradient(135deg,#7c3aed,#ec4899); color:#fff; }
```

### Opt in, override, and extend — with a class, no JavaScript

Since the shared sheet is plain CSS in the shadow root, per-instance differences are just
**CSS scoping** — no callbacks, no JS. Tag a select from HEEx and target it with `:host()`:

```heex
<.web_multiselect id="a" class="brand" options={@opts} />   {!-- opts into the .brand rules --}
<.web_multiselect id="b" options={@opts} />                  {!-- default look --}
```

- **Opt in / diverge:** scope rules with `:host(.brand)` (as above) so only tagged selects
  get them.
- **Override one instance:** a more specific `:host(#special) .ms__badge { … }` in the same
  sheet wins; or set per-instance CSS variables inline (`style="--ms-badge-border-radius:0"`).
- **Extend from JS (optional):** importing the hook re-exports `registerShadowStyles(css)`
  and `getShadowStyles()`, so you can append to the shared sheet at runtime:
  `registerShadowStyles(getShadowStyles() + extraCss)`.

### Things to know

- **One shared sheet, not per-instance** — a single `CSSStyleSheet` is adopted by every
  shadow root (no duplication), and updating it re-styles them all live.
- **Register early.** Put `<.shadow_styles/>` in `<head>` so the sheet is ready as the
  elements come up. The registry also polls briefly for each element's shadow root (it can
  appear a beat after the element upgrades under LiveView), so the theme lands reliably.
- **Flash-free, automatically (upstream 2.1.0 `defer`).** With `:shadow_styles` configured,
  `web_multiselect/1` adds upstream's `defer` attribute to every select: it reserves space
  but builds *nothing* on upgrade, so the registry can adopt the shared sheet into the
  (already-attached) shadow root and *then* release the gate (by removing the attribute) —
  the picker builds once, styled, in a single paint, with no default-badge flash. This makes
  `<.shadow_styles/>` in `<head>` a hard requirement when `:shadow_styles` is set (it ships
  the registry that releases the gate). Opt one select out with `defer={false}`, or force the
  gate yourself with `defer={true}` and release it from a `hook`'s `mounted()` via `el.ready()`
  (e.g. after async options land) — that manual gate is flagged `data-kwms-manual`, so the
  registry adopts the shared sheet into it but leaves the release to you. (Auto-gates emit a
  bare `defer` the registry removes on release; LiveView's connect-time patch leaves it off, so
  the element settles with a clean DOM.)
- **Serving files individually?** `keen_web_multiselect_hook.js` imports
  `keen_web_multiselect_defaults.js`. Bundlers inline it; if you serve from the dep's
  `priv/static` via `Plug.Static`, add it to the `only:` allowlist (see the README).

---

## Sizing

`--ms-rem` is the proportional base unit; most sizes are `calc(N * var(--ms-rem))`.
It resolves to `var(--base-rem, 10px)`, so a design system that sets `--base-rem`
rescales the whole component (and every other KeenMate component) from one knob,
while the `10px` fallback and per-instance `--ms-rem` overrides keep working when
no base layer is loaded. Scale the whole component with one variable:

```css
web-multiselect.compact { --ms-rem: 8px;  }   /*  80% */
web-multiselect         { --ms-rem: 10px; }   /* 100% (default) */
web-multiselect.large   { --ms-rem: 12px; }   /* 120% */
```

```heex
<.web_multiselect id="c" class="compact" options={@opts} />
```

The input height reads `--base-input-size-md-height` (default `3.5` → 35px at
`--ms-rem: 10px`), so setting it at the base layer keeps input heights consistent
across all KeenMate components:

```css
:root { --base-input-size-md-height: 4.0; }   /* 40px at --ms-rem: 10px */
```

### Independent panel widths

The control (input), the options **dropdown**, and the **selected-items popover**
are three separate panels with independent widths:

```css
web-multiselect {
  --ms-dropdown-width: 60rem;          /* options dropdown; default: tracks the input */
  --ms-selected-popover-width: 30rem;  /* "N selected" popover; default: intrinsic 32rem */
}
```

Set the variables at app/theme level to size every picker at once. The
`dropdown_width` / `selected_popover_width` attributes are per-instance sugar that
write those variables on a single element:

```heex
<.web_multiselect id="cats" style="width: 15rem;"
  dropdown_width="60rem" selected_popover_width="30rem" options={@opts} />
```

### Option rows — height and long labels

Dropdown option rows (including tree nodes) are content-driven by default: a long
title **wraps** and the row grows. Two option-level variables change that:

| Variable | Default | Effect |
|---|---|---|
| `--ms-option-min-height` | `auto` | A consistent minimum row height. Rows still grow if content is taller. (Virtual-scroll rows use the fixed `--ms-option-height` instead.) |
| `--ms-option-title-white-space` | `normal` | Set `nowrap` to keep the title on one line. |
| `--ms-option-title-overflow` | `visible` | Set `hidden` to clip the overflow. |
| `--ms-option-title-text-overflow` | `clip` | Set `ellipsis` for a trailing `…`. |

```css
web-multiselect {
  --ms-option-min-height: 3.5rem;

  /* truncate long titles to one line + ellipsis */
  --ms-option-title-white-space: nowrap;
  --ms-option-title-overflow: hidden;
  --ms-option-title-text-overflow: ellipsis;
}
```

`.ms__option-title` is the label hook (the analog of web-treeview's
`.wtv__node-label`). When truncating, turn on `enable_option_tooltips={true}` so
the full label appears on hover. See the *Tree of options* guide for the tree
angle.

## Icons & control affordances

The component's glyphs — the toggle chevron, the search funnel, the badge-remove /
input-clear / count-clear ✕, and the checkbox check + indeterminate dash — are CSS
**mask** icons (not font characters or border shapes), each chained to the shared
`--base-icon-*` contract:

```css
--ms-icon-chevron:       var(--base-icon-chevron, <inline Lucide fallback>);
--ms-icon-check:         var(--base-icon-check, …);
--ms-icon-indeterminate: var(--base-icon-indeterminate, …);
--ms-icon-filter:        var(--base-icon-filter, …);
--ms-icon-clear:         var(--base-icon-clear, …);
--ms-icon-remove:        var(--base-icon-remove, …);
--ms-icon-search:        var(--base-icon-search, …);
```

Set a `--base-icon-*` (a `url(...)` or inline SVG data URI) once and every KeenMate
component reskins that glyph together; override the `--ms-icon-*` to diverge a single
component. Because the checkmark and dash are masks now,
`--ms-checkbox-checkmark-thickness` is a **no-op** (the stroke is baked into the SVG) —
retint via `--ms-checkbox-checkmark-color`.

**Checkmark size — `--base-icon-check-size`** (default `68%`). The selected-row
checkmark masks its glyph at this fraction of the checkbox box (the same knob
pure-admin's `.pa-checkbox` uses, so the two match). Raise it toward `100%` for an
edge-to-edge glyph, or lower it for a smaller mark; the indeterminate dash inherits the
same mask box. (Before 2.0.1 the mark was masked at `contain` ≈ 100%, which oversized
custom edge-to-edge glyphs — if you preferred that larger default, set
`--base-icon-check-size: 100%`.)

**Toggle-chevron rotation opt-out.** The toggle rotates the directional chevron into
place (`--ms-toggle-rotate-closed` default `90deg` → down, `--ms-toggle-rotate-open`
default `-90deg` → up). A theme that supplies a **pre-oriented** down-glyph can opt out:
set both to `0deg` for a static glyph, or `0deg` / `180deg` to flip a down-caret up on
open. The fullscreen match-navigator pager reads its own `--ms-fullscreen-nav-btn-icon`
(defaulting to `--ms-icon-chevron`) so a pre-oriented toggle glyph doesn't leak into it.

**Inline clear button** (`show_clear`). The ✕ inside the input is themed by
`--ms-input-clear-*` — `size`, `icon-size`, `color`, `bg-hover`, `color` and
`border-radius` (which follows `--ms-border-radius`).

**"Add new" prompt** (`allow_add_new`). The clickable creation row in the empty
dropdown is themed by `--ms-add-new-*` — `color`, `color-hover`, `bg-hover`, `padding`,
`gap`, `font-size`, and `icon-size` (the plus glyph chains `--base-icon-plus` →
`--base-icon-add`).

## Mobile & fullscreen overlay

On phone-sized touch devices the open dropdown (and the selected-items popover)
become a full-screen overlay — see the `mobile_presentation` / `fullscreen_autofocus`
/ `show_search_mode_toggle` attributes on `web_multiselect/1`. The overlay is a
separate chrome with its own theming layer:

- **One knob to scale it all — `--ms-fullscreen-rem`** (default `12px`). The overlay
  rebases `--ms-rem` to this, so rows, text, checkboxes, padding, the header, and the
  search grow together for comfortable ~44–48px touch targets. Raise it for chunkier
  targets.
- **Header, close, and search** — `--ms-fullscreen-header-*` (background, border,
  padding, min-height, gap), `--ms-fullscreen-close-*` (a themeable close chip:
  background, border, radius, size, edge nudge), and `--ms-fullscreen-search-*`
  (border, radius, padding, plus the clear-affordance `--ms-fullscreen-search-clear-*`).
- **Navigate-mode match navigator** (the touch counterpart to desktop `Ctrl`+`Arrow`)
  — `--ms-fullscreen-nav-*` (the `N of M` count + prev/next buttons) and the search-mode
  toggle chip `--ms-fullscreen-mode-toggle-*`.
- **Clipped-label reveal** — `--ms-fullscreen-info-*` (the circled-ⓘ affordance shown on
  truncated rows, the touch counterpart to the hover tooltip).
- **Tighter tree indent** — `--ms-fullscreen-tree-base-indent` / `--ms-fullscreen-tree-indent`
  (deep nesting needs less per-level indent when the labels are enlarged).

For the safe-area insets to apply in landscape (avoiding the system bars / camera
cutout), the host page must opt into edge-to-edge with
`<meta name="viewport" content="… viewport-fit=cover">` — a page-level responsibility
the component can't self-serve.

### Component-anchored messages — `showMessage()`

The JS API `element.showMessage(content, opts)` / `hideMessage()` renders a transient
toast anchored to the control (pinned over the sheet while a fullscreen overlay is open).
Theme it via the `--ms-message-*` variables (surface, per-variant `bg`/`color` for
`info`/`warning`/`error`/`success`, padding, radius, font, shadow, max-width, z-index).
`beforeSelectCallback` / `beforeDeselectCallback` returning a **string** vetoes the
change *and* surfaces the string as a warning toast.

## Dark mode

Since upstream v1.12.0 the component honors **five** dark-mode signals — pick
whichever your app already uses; you don't wire up all of them:

| Signal | Set by | Example |
|--------|--------|---------|
| OS preference + page `color-scheme` | You | `html { color-scheme: light dark }` |
| Page `color-scheme: dark` | You | `body { color-scheme: dark }` |
| Framework `data-*` on an ancestor | Bootstrap, pure-admin | `<html data-bs-theme="dark">` / `<div data-theme="dark">` |
| Framework class on an ancestor | Tailwind, custom | `<html class="dark">` |
| Per-instance attribute on the host | You | `<.web_multiselect data-theme="dark" … />` |

Precedence (highest wins): per-instance → framework ancestor → page `color-scheme`.
To force one widget light on an otherwise-dark page, set `data-theme="light"` on it:

```heex
<.web_multiselect id="always-light" data-theme="light" options={@opts} />
```

## The unlayered-reset footgun

The component's internal CSS uses named cascade layers
(`@layer variables, component, overrides;`). A global reset like
`* { margin: 0; padding: 0 }` (Bootstrap reboot, Tailwind preflight) is
**unlayered**, so it beats every *layered* rule inside the component and can break
its spacing even though your variables resolved correctly. Wrap your reset in its
own layer so the component's defaults can win:

```css
@layer reset { * { margin: 0; padding: 0; box-sizing: border-box; } }
```

Variables-first theming (`--ms-*` / `--base-*`) covers ~95% of customization;
cascade layers are the escape hatch for the rest.
