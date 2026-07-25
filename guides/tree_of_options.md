# Tree of options

`<.web_multiselect>` can render its options as a **hierarchy** instead of a flat
list. Give each option a materialized *path* and the component indents it by
depth, rendering parents immediately before their children.

The tree is **always fully expanded** — there is no collapse or chevron. If you
need expand/collapse, use [`@keenmate/web-treeview`](https://github.com/keenmate/web-treeview)
(this feature reuses its `ltree` model so the ordering matches).

## Shape your data with a path

Each option gets a **materialized dot-path**. The root level is a single
segment (`"1"`, `"2"`), children extend the parent's path (`"1.1"`, `"1.2"`),
grandchildren extend again (`"1.1.1"`), and so on. Parent and depth are derived
from the path — you don't supply them.

```elixir
@categories [
  %{value: "fruit",  label: "Fruit",      path: "1"},
  %{value: "apple",  label: "Apple",      path: "1.1"},
  %{value: "gala",   label: "Gala",       path: "1.1.1"},
  %{value: "fuji",   label: "Fuji",       path: "1.1.2"},
  %{value: "pear",   label: "Pear",       path: "1.2"},
  %{value: "veg",    label: "Vegetables", path: "2"},
  %{value: "carrot", label: "Carrot",     path: "2.1"}
]
```

## Turn on tree mode

Point `path_member` at the key that holds the path. That's it — tree mode
auto-enables:

```heex
<.web_multiselect
  id="categories"
  options={@categories}
  path_member="path" />
```

Renders (indented by depth):

```
Fruit
  Apple
    Gala
    Fuji
  Pear
Vegetables
  Carrot
```

Every node — branch or leaf — is a normal, selectable option. Selection,
checkboxes (`show_checkboxes`), icons, subtitles, and single/multi mode all work
exactly as they do for a flat list.

## Options

| Attribute | Purpose |
| --- | --- |
| `path_member` | Key holding the materialized dot-path. **Setting it enables tree mode.** |
| `parent_path_member` | Key holding the parent path. Optional — derived from the path when unset. |
| `level_member` | Key holding the depth/level. Optional — derived from the path when unset. |
| `has_children_member` | Key holding a precomputed `hasChildren` flag. Optional — derived from the tree when unset. |
| `is_selectable_member` | Key holding a per-option selectability flag (see below). Optional. |
| `tree_path_separator` | Separator used in paths. Defaults to `"."`. |
| `checkbox_mode` | `"independent"` (default) or `"cascade"` — cascade checks a node's whole subtree with a tristate box (see below). |
| `cascade_select_policy` | In cascade mode, which values a selection emits: `"rolled-up"` (default), `"leaves"`, or `"all"`. |

Using a different separator:

```heex
<.web_multiselect
  id="categories"
  options={@categories_slash}
  path_member="path"
  tree_path_separator="/" />
```

## Selectable leaves only

Sometimes a branch is pure structure — a heading, not a real choice. Mark it
**non-selectable** with `is_selectable_member`, pointing at a boolean key in your
data. A non-selectable node is *not* the same as a disabled one: it renders
**normally** (no grey-out), but it has no checkbox, is skipped by keyboard
arrows, and can't be toggled or picked by Select&nbsp;All.

```elixir
@categories [
  %{value: "fruit",  label: "Fruit",  path: "1",     selectable: false},
  %{value: "apple",  label: "Apple",  path: "1.1",   selectable: true},
  %{value: "gala",   label: "Gala",   path: "1.1.1", selectable: true},
  %{value: "veg",    label: "Vegetables", path: "2", selectable: false},
  %{value: "carrot", label: "Carrot", path: "2.1",   selectable: true}
]
```

```heex
<.web_multiselect
  id="categories"
  options={@categories}
  path_member="path"
  is_selectable_member="selectable"
  show_checkboxes={true} />
```

For a "leaves are the only real choices" tree, precompute the flag from whether
an option has children (a node is a branch when some other option's path starts
with `"#{path}."`):

```elixir
def only_leaves_selectable(options) do
  paths = MapSet.new(options, & &1.path)
  Enum.map(options, fn opt ->
    has_children? = Enum.any?(paths, &String.starts_with?(&1, opt.path <> "."))
    Map.put(opt, :selectable, not has_children?)
  end)
end
```

> The equivalent JS-side predicate `getIsSelectableCallback` — which receives the
> built tree node and can read its derived `hasChildren` (so
> `(node) => !node.hasChildren` is a one-liner) — is JavaScript-only and has no
> HEEx attribute. From LiveView, precompute `is_selectable_member` as above.

Use `disabled_member` (which *does* grey the row out) for options that are
genuinely unavailable rather than merely structural.

## Cascade checkboxes and the value policy

By default a checkbox toggles only its own node (`checkbox_mode="independent"`).
Set `checkbox_mode="cascade"` and checking a node toggles its **whole subtree**,
while a partially-selected branch shows a **tristate** (dash) box. Tree +
multiple only.

Orthogonally, `cascade_select_policy` decides **which values a cascade selection
emits** — the values you get as badges, in the form, and in `change` events:

| Policy | A fully-checked subtree emits… | Why |
| --- | --- | --- |
| `rolled-up` *(default)* | the subtree's **root** (one value) | Minimal cover — a partial branch instead emits its individually-checked descendants. Rolls to the nearest **selectable** descendant when the root itself is non-selectable (e.g. a leaves-only tree). |
| `leaves` | every checked **leaf** | You only care about the concrete leaf items. |
| `all` | **every** fully-checked node (branches + leaves) | Matches `@keenmate/web-treeview`. |

```heex
<.web_multiselect
  id="categories"
  options={@categories}
  path_member="path"
  show_checkboxes={true}
  checkbox_mode="cascade"
  cascade_select_policy="rolled-up" />
```

So with `rolled-up`, checking a parent whose entire subtree is selected gives you
a **single** value (the parent) rather than one badge per descendant; a
partially-selected branch surfaces exactly the descendants you checked. The
emitted values are a pure projection of the selection, so the form value and
`change` payload always reflect the policy.

Both `checkbox_mode` and `cascade_select_policy` are **live**: flip either after
mount (e.g. `el.checkboxMode = "cascade"` from JS) and the current selection
re-projects immediately, so badges, form value, and checkboxes reflect the new
mode/policy without a rebuild.

### Custom node rendering

`renderOptionContentCallback(item, ctx)` (JS-only) replaces a node's inner content
while the component keeps drawing the tree chrome (checkbox, indentation, state
classes). On tree rows `ctx` carries tree metadata so you can branch without
re-deriving it: `isTreeNode`, `isBranch`, `isLeaf`, `childCount`, `level`, `depth`,
`path`, `isSelectable`, and `isIndeterminate` (cascade tristate). Style full rows
by node type with the `.ms__option--tree-branch` / `.ms__option--tree-leaf` hooks
(via `customStylesCallback`) — the render callback only fills the content area.

## Search

With `enable_search` on (the default), typing filters the hierarchy to the
**matching nodes plus their ancestors**, so the indentation of the results still
makes sense. Searching `gala` on the data above shows:

```
Fruit
  Apple
    Gala
```

## Full breadcrumb on badges

A leaf can share a name across branches (two "Gala" nodes under different parents),
which makes a plain badge ambiguous. If your data carries a **full title** — a
fully-qualified label like `"Fruit / Pome fruit / Apple"` — point `full_title_member`
at it and turn on `show_badge_full_title`; badges then show the full title instead of
the display value (falling back to the display value for options without one). The
component never computes the full title — it must ship with the data.

```heex
<.web_multiselect
  id="categories"
  options={@categories}          {!-- each option also has a :full_title --}
  path_member="path"
  full_title_member="full_title"
  show_badge_full_title={true} />
```

An explicit JS-side `getBadgeDisplayCallback` still takes precedence over the full title.

## Styling the indentation

Each row is indented via an inline `--ms-tree-depth` custom property (0 for
top-level nodes). Tune the step and base offset with CSS variables on the
element:

```css
web-multiselect {
  --ms-tree-indent: 1.25rem;      /* per-level indent */
  --ms-tree-base-indent: 0.75rem; /* inline-start padding of a top-level row */
}
```

Branch and leaf rows also carry `.ms__option--tree-branch` /
`.ms__option--tree-leaf` classes as theming hooks if you want to style them
differently (e.g. bolder branch labels).

## Row height and long labels

Deep indentation eats horizontal space, so long labels are common in trees. By
default a title **wraps** to multiple lines (the row grows). Two option-level CSS
variables let you change that — they apply to flat lists too, and follow the same
label-hook approach as `@keenmate/web-treeview`:

```css
web-multiselect {
  /* A consistent minimum row height (rows still grow if content is taller). */
  --ms-option-min-height: 3.5rem;

  /* …or truncate long titles to a single line with an ellipsis. */
  --ms-option-title-white-space: nowrap;
  --ms-option-title-overflow: hidden;
  --ms-option-title-text-overflow: ellipsis;
}
```

`.ms__option-title` is the label hook. When you truncate, pair it with
`enable_option_tooltips={true}` so the full label shows on hover:

```heex
<.web_multiselect
  id="categories"
  options={@categories}
  path_member="path"
  enable_option_tooltips={true}
  style="--ms-option-title-white-space: nowrap; --ms-option-title-overflow: hidden; --ms-option-title-text-overflow: ellipsis;" />
```

(Virtual-scroll rows use the fixed `--ms-option-height` / `option_height` instead
of `--ms-option-min-height`.)

## LiveView

Tree options work with the LiveView hook and `push_update/3` like any other
option list — push a new list (with paths) and the tree rebuilds. See the
README for hook setup.
