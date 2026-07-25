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
and the component's proportional unit is `--ms-rem` (default `10px`). Point it at
`rem` so the two scale together:

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

## Sizing

`--ms-rem` is the proportional base unit (default `10px`); most sizes are
`calc(N * var(--ms-rem))`. Scale the whole component with one variable:

```css
web-multiselect.compact { --ms-rem: 8px;  }   /*  80% */
web-multiselect         { --ms-rem: 10px; }   /* 100% (default) */
web-multiselect.large   { --ms-rem: 12px; }   /* 120% */
```

```heex
<.web_multiselect id="c" class="compact" options={@opts} />
```

Five input-height variants read `--base-input-size-*-height`, so setting them at
the base layer keeps input heights consistent across all KeenMate components:

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
