---
description: Prepare keen_web_multiselect for Hex publish — bump version, finalize CHANGELOG/README, compile, test, commit
argument-hint: rc|release|patch|minor|major
---

# /publish — prepare a Hex release of keen_web_multiselect

You are preparing this package for `mix hex.publish`. **Do not run `mix hex.publish`** — the user authenticates and publishes manually.

This command follows the canonical `/publish` structure defined in the BlissFramework component guidelines at
`web-components/publish-command.md`, adapted for an Elixir / Hex package instead of an npm package. Sections marked
**[canonical]** are byte-identical (modulo the npm→Hex substitutions) across every component's `/publish`; sections
marked **[per-repo]** are customized for this repo's layout, build, and tests.

## npm → Hex substitution map

| npm concept (canonical text) | Hex equivalent (this repo) |
|---|---|
| `package.json` `version` | `@version` module attribute in `mix.exs` |
| `npm view <pkg>@<v> version` | `mix hex.info keen_web_multiselect <v>` (exits 0 + prints "Released at …" if it exists; exits non-zero otherwise) |
| `npm view <pkg> version` | `mix hex.info keen_web_multiselect` (prints `Releases: <latest>, …`) |
| `npm run build` | `mix compile --warnings-as-errors` |
| `npm run test:e2e` | `mix test` |
| `npm pack --dry-run` | `mix hex.build` (writes `keen_web_multiselect-<v>.tar`; inspect with `tar -tzf <file> \| sort`, or `mix hex.build --unpack` for a folder) |
| `npm publish` / `npm publish --tag rc` | `mix hex.publish` (Hex has **no** dist-tags — see Section 11) |
| `files` field in `package.json` | `:files` list in `package/0` inside `mix.exs` |

## Argument [canonical]

The release type: **$ARGUMENTS**

Must be one of:

- `rc` — ship the WIP rc as-is. The topmost CHANGELOG heading (e.g. `## [0.2.0-rc.0] - 2026-06-23`) gets ` [PUBLISHED]` appended.
- `release` — promote a WIP rc to a final release. `X.Y.Z-rc.N` → `X.Y.Z`. CHANGELOG heading is renamed to match the new version.
- `patch` — SemVer patch bump. Drops any `-rc.N` suffix.
- `minor` — SemVer minor bump. Drops `-rc.N`. Resets patch.
- `major` — SemVer major bump. Drops `-rc.N`. Resets minor and patch.

If missing or invalid, stop and ask the user which one to use (don't guess).

## Repo layout [per-repo]

Single-package Hex library, everything at root:

- **`./mix.exs`** — `@version` module attribute is the source of truth.
- **`./CHANGELOG.md`** — at the root. Topmost `## [X.Y.Z] - YYYY-MM-DD` heading **without** the `[PUBLISHED]` marker is the WIP section.
- **`./README.md`** — at the root. Carries `## What's New in vX.Y.Z` sections near the top (one per release, the **two most recent** retained).
- **`./lib/`** — Elixir sources. Always staged for release.
- **`./priv/static/`** — bundled upstream JS + CSS + the LV hook. Tracked in git (this is what consumers get). If you re-bundle a newer `@keenmate/web-multiselect`, update both these files *and* the `@upstream_version` attribute in `lib/keen_web_multiselect.ex` in the same commit.
- **`./_build/`, `./deps/`, `./doc/`** — gitignored. Never staged. Recreated by `mix deps.get` / `mix compile` / `mix docs`.
- **`./mix.lock`** — tracked in git. Don't touch during `/publish` unless deps were intentionally changed in this release.

## CHANGELOG convention in this repo [canonical]

There is **no `## [Unreleased]` section**. The WIP section is the topmost `## [X.Y.Z] - YYYY-MM-DD` heading without a `[PUBLISHED]` tag. Already-released sections carry `[PUBLISHED]` at the end of their heading:

```
## [0.2.0-rc.0] - 2026-06-23                  ← WIP, the one you're shipping
### Added
- ...

## [0.1.0] - 2026-06-22 [PUBLISHED]
### Added
- ...
```

Publishing the WIP section means **appending ` [PUBLISHED]`** to its heading — exact format: `## [X.Y.Z] - YYYY-MM-DD [PUBLISHED]`. The next development cycle creates a fresh `## [next-version] - <date>` heading on its first CHANGELOG edit.

## Resolve versions [canonical]

Read the `@version` module attribute from `./mix.exs` as `CURRENT_VERSION`.
Read the topmost `## [X.Y.Z...]` heading from `./CHANGELOG.md` as `WIP_VERSION` (the version the latest WIP section is tagged for).

Compute `NEW_VERSION`:

| Argument | Logic |
|---|---|
| `rc` | If `CURRENT_VERSION` matches `X.Y.Z-rc.N`, `NEW_VERSION = CURRENT_VERSION` (no bump — we're shipping what's already in mix.exs). If `CURRENT_VERSION` is not an rc, stop and ask the user (they probably wanted `release`/`patch`/etc.). |
| `release` | If `CURRENT_VERSION` matches `X.Y.Z-rc.N`, `NEW_VERSION = X.Y.Z`. Otherwise stop. |
| `patch` | Strip any `-rc.N`, then bump patch. |
| `minor` | Strip any `-rc.N`, then bump minor, reset patch. |
| `major` | Strip any `-rc.N`, then bump major, reset minor and patch. |

If `WIP_VERSION` ≠ `NEW_VERSION` (e.g. the WIP is `X.Y.Z-rc.N` but the user asked for `release`), the CHANGELOG heading rename in step 3 also re-tags the section to `NEW_VERSION` — call this out in the report so the user notices.

## Steps (in order)

### 1. Sanity checks [canonical]

- Run `git status`. The repo intentionally keeps `.claude/`, `_build/`, `deps/`, and `doc/` untracked — those are fine. If there are **other** uncommitted changes that aren't `CHANGELOG.md`, `README.md`, or `mix.exs`, list them and ask the user before continuing. (Typical case: substantive source changes belonging in this release that haven't been committed yet — confirm they're intended for this version before bumping.)
- **Verify the new version isn't already on Hex.** Run `mix hex.info keen_web_multiselect <NEW_VERSION> 2>/dev/null` — if it returns a "Released at …" line, that version is already published and **stop**: re-publishing fails after the one-hour revert window and pollutes the commit.
- **Verify the registry hasn't drifted past you.** Run `make last-published` (or `mix hex.info keen_web_multiselect`) and look at the `Releases:` line — it lists the latest stable first. If it's higher than `NEW_VERSION` (e.g. someone shipped from another machine), warn the user and ask before continuing.
- Confirm the WIP CHANGELOG section has at least one bullet of substantive content under `### Added`, `### Changed`, `### Removed`, `### Fixed`, or `### Internal`. If empty, stop — there's nothing meaningful to release.
- Confirm `./README.md` has a `## What's New in vWIP_VERSION` section. If it's missing, draft one from the CHANGELOG and present it to the user for approval before continuing:
  - Read the WIP CHANGELOG section, distill it to 5–8 scannable bullets covering the Added/Changed themes (paraphrase, don't copy CHANGELOG bullets verbatim — those are exhaustive; What's New is the highlight reel). Pure internal refactors and Fixed-only entries don't need coverage, though headline bug fixes worth advertising are worth a bullet.
  - **Follow the canonical "What's New" format** defined in the BlissFramework component guidelines (`web-components/readme-structure.md` → "`## What's New in vX.Y.Z` — canonical format"). Concretely:
    - **Heading:** `## What's New in vNEW_VERSION` — lowercase `v`, no backticks around the version, no date.
    - **Each bullet:** `- **<area or component> — <one-line headline>** — <engineer-level prose, 3–8 sentences>`. Bold-wrapped lead phrase, then a true em-dash (` — `, U+2014 with surrounding spaces), then a prose body explaining *what changed*, *why* (regression history / motivation), *what surface is affected* (concrete module / function / file names listed inline), and *the mechanism* (the technique used). Plain hyphens or en-dashes fail the check.
    - **No `### ` sub-headings** inside a What's New section — no `### Added` / `### Fixed` lifted from the CHANGELOG. It's a flat bullet list.
  - Show the user the proposed draft as plain markdown in your reply. Ask whether to (a) insert as-is, (b) edit, or (c) abort so they can write it themselves.
  - Only proceed past step 1 once the user approves the draft (or supplies their own). On approval, insert the section directly above the current top `## What's New in vX.Y.Z` heading in `./README.md`, then continue.
  - Do not silently insert the draft without confirmation — release highlights are a writing call and the user owns the voice.

### Repo-specific extras

- **If `priv/static/multiselect.js` or `multiselect.css` was re-bundled from a new upstream release this cycle**, confirm `@upstream_version` in `lib/keen_web_multiselect.ex` matches the version those files came from. If they're out of sync, the `KeenWebMultiselect.upstream_version/0` runtime accessor will lie to consumers. Fix before continuing.

### 2. Bump version (if needed) [canonical]

If `NEW_VERSION` ≠ `CURRENT_VERSION`, edit `./mix.exs` and change `@version "CURRENT_VERSION"` to `@version "NEW_VERSION"`.

For `rc` arg this is normally a no-op — version was bumped earlier in the development cycle.

### 3. Finalize CHANGELOG [canonical]

In `./CHANGELOG.md`:

- If `WIP_VERSION` ≠ `NEW_VERSION` (e.g. promoting `X.Y.Z-rc.N` → `X.Y.Z`), rename the WIP heading from `## [WIP_VERSION] - <date>` to `## [NEW_VERSION] - <today>` (today's date from system context).
- If `WIP_VERSION` == `NEW_VERSION`, leave the bracketed version alone but update the date to today **if** the existing date is stale (more than a few days old). The WIP date is usually whatever day the section was opened; refresh it so the changelog reflects the actual ship date.
- In either case, **append ` [PUBLISHED]`** to the heading so it reads exactly: `## [NEW_VERSION] - YYYY-MM-DD [PUBLISHED]`.
- Leave all bullet content untouched.
- **Do not** create an empty new WIP section — the next dev cycle's first CHANGELOG edit will create one.

### 4. Update README "What's New" — only if version changed [canonical]

In `./README.md`:

- If the existing `## What's New in vWIP_VERSION` section's version differs from `NEW_VERSION` (e.g. promoting `X.Y.Z-rc.N` → `X.Y.Z`), rename its heading to `## What's New in vNEW_VERSION`. (No content rewrites — the text was already curated for this release.)
- Then count the `## What's New in vX.Y.Z` headings. If there are more than **two**, delete the oldest ones so only the **two most recent** remain (the just-finalized one plus the one before it).

For `rc` arg this is normally a no-op on the heading itself — only trims if someone left an extra-old section behind.

### 5. Validate README reflects the release [canonical]

Read both the finalized CHANGELOG section and the matching `What's New in vNEW_VERSION` section. Every **Added** or **Changed** bullet in the CHANGELOG that represents a user-facing feature or behavior change should have a corresponding hit in the What's New section (paraphrased, not verbatim). Pure internal refactors and `Fixed`-only entries don't need coverage, though headline bug fixes worth advertising (e.g. "X used to silently fail; now works") are worth a bullet.

If you find a significant CHANGELOG entry that isn't reflected in What's New, add a bullet for it. If the section ends up with more than ~8 bullets after this pass, condense — What's New should be scannable, not exhaustive.

### 6. Validate CHANGELOG entries match recent work [canonical]

Find the previous `[PUBLISHED]` tag in CHANGELOG (the version just before NEW_VERSION) and locate the commit that bumped to it — usually a commit whose subject starts with `v<previous-version>`. Run `git log --oneline <previous-publish-commit>..HEAD` to list commits since.

Also check `git diff` (or `git status`) for any uncommitted source/test work outside the files you're editing in this command.

For every substantive commit or uncommitted change, verify the WIP CHANGELOG section mentions it. If something significant is missing, **stop and ask the user** before finalizing — don't invent entries on their behalf. Pure example/doc tweaks and trivial typo fixes don't need entries.

### 7. Run tests [per-repo]

Run `mix test`. ExUnit unit tests for the component, helpers, and form integration. All tests must pass.

If anything fails, **stop and report**. Do not proceed to compile/build/commit. The user fixes the regression (or decides to skip the spec) before the publish flow can continue.

### 8. Compile and build docs [per-repo]

Run `make build` (which is `mix compile --warnings-as-errors && mix docs`). The compile step catches any deprecation warnings, unused-variable nags, or attribute-typo warnings that would otherwise ship silently — any warning aborts the build.

`mix docs` then:

- Generates HTML docs into `./doc/` via ex_doc using the `docs` keyword in `mix.exs`'s `project/0`.
- Verifies `@moduledoc` / `@doc` strings parse cleanly.

Smoke check:
- `./doc/index.html` exists.
- `./doc/KeenWebMultiselect.Components.html` (the component docs) exists and lists `web_multiselect/1`.

`mix hex.publish` will rebuild docs internally — running `mix docs` here is a pre-flight gate that surfaces ex_doc errors before the publish prompt.

### 9. Verify the package contents [per-repo]

Run `make hex-build-inspect` (which is `mix hex.build` plus a `tar -tzf <tarball> | sort` print). It writes `keen_web_multiselect-<NEW_VERSION>.tar` in the repo root and prints its file list.

Or equivalently, run them by hand:

```
mix hex.build
tar -tzf keen_web_multiselect-<NEW_VERSION>.tar | sort
```

The tarball MUST include:

- `lib/` (all `.ex` source files)
- `priv/static/multiselect.js`, `priv/static/multiselect.css`, `priv/static/multiselect.d.ts`, `priv/static/keen_web_multiselect_hook.js`
- `mix.exs`
- `README.md`
- `CHANGELOG.md`
- `LICENSE`
- `.formatter.exs`

The tarball MUST NOT include:

- `test/` (test files — never ship)
- `_build/`, `deps/`, `doc/` (build artifacts)
- `.elixir_ls/`, `.idea/`, `.vscode/` (editor metadata)
- `tmp/`, `cover/`, `*.tar` (workspace cruft)

The `:files` key in `package/0` inside `mix.exs` is the control surface — if anything's wrong, fix it there.

Delete the inspection tarball before committing: `make clean` (or `rm keen_web_multiselect-<NEW_VERSION>.tar`). It's `.gitignore`d via the `keen_web_multiselect-*.tar` pattern, but tidy is better.

### 10. Commit [canonical]

Stage:

- `./CHANGELOG.md`
- `./README.md`
- `./mix.exs`

Do **not** stage `_build/`, `deps/`, `doc/`, or the `mix hex.build` tarball — they're gitignored.

Commit message format:

```
vNEW_VERSION - <one-line summary of the headline change>

<grouped bullets paraphrased from the CHANGELOG section — split into the same
groups the CHANGELOG used: Added, Fixed, Changed, Internal, etc. Keep bullets
terse; full prose lives in the CHANGELOG.>

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

### 11. Report [canonical-adapted]

Report back with:

- The new version number
- The commit SHA
- The exact commands to publish. **Pick the right one for the arg type** — the `Makefile` wraps `mix hex.publish` with a pre-flight version-shape guard so the wrong target refuses to run:

  - For `rc` (publishing a pre-release):
    ```
    mix hex.user auth     # if not already authenticated on this machine
    make publish-rc
    ```
    `make publish-rc` refuses unless `@version` in `mix.exs` matches `X.Y.Z-rc.N`, then runs `make build` + `mix hex.publish`.

  - For `release` / `patch` / `minor` / `major` (publishing a stable):
    ```
    mix hex.user auth     # if not already authenticated on this machine
    make publish
    ```
    `make publish` refuses if `@version` is an rc, then runs `make build` + `mix hex.publish`.

  Either way, `mix hex.publish` prompts twice:
  1. Once to confirm the package contents and version (review the file list and metadata, then `Y`).
  2. Once to confirm the publish (`Y`).

  It builds **and** publishes both the package and the hex docs in one step. No separate `mix hex.publish docs` is needed unless you only want to refresh docs without re-publishing the package.

  Direct `mix hex.publish` works too; the `make` wrappers exist for muscle-memory consistency with the upstream `@keenmate/web-multiselect` Makefile and for the rc/release guard.

- **Hex has no dist-tags** — unlike npm's `--tag rc`, an rc version (`0.2.0-rc.0`) is just a regular published version. The SemVer pre-release semantics handle the rest: a consumer's `{:keen_web_multiselect, "~> 0.1"}` constraint **skips** pre-releases by default and stays on the last stable. Consumers opt in by pinning explicitly (`{:keen_web_multiselect, "0.2.0-rc.0"}`) or by passing `pre_release: true` in their constraint. So the `rc` vs `release` distinction is enforced by the version-shape guard in `make publish` / `make publish-rc`, plus the SemVer pre-release semantics — not by a publish-time flag.

- The state-inspection targets `make current-version` and `make last-published` are the quick "what version are we at vs the Hex registry?" answers — useful for both this command's sanity checks and for ad-hoc grepping between releases.

- A reminder that the CHANGELOG `[PUBLISHED]` tag is now in place — if `mix hex.publish` fails or you change your mind, you have **one hour** after publish to run `mix hex.publish --revert <NEW_VERSION>` (per `mix help hex.publish`). After that window, you cannot reuse the version — bump and re-publish. Before the publish actually goes through, revert both the tag (CHANGELOG heading) and the version bump (`mix.exs`).

## Things not to do [canonical-adapted]

- **Do not run `mix hex.publish`.** The user publishes manually after `mix hex.user auth`.
- **Do not push to git remote.** The commit stays local until the user pushes.
- **Do not create an empty `[Unreleased]` or new WIP heading** in CHANGELOG after finalizing — the next dev cycle's first edit creates the next heading.
- **Do not retro-fix older CHANGELOG sections** that are missing the `[PUBLISHED]` tag or carry legacy markers — only finalize the section you're shipping.
- **Do not silently insert a drafted What's New section.** If you draft one in Step 1 because it's missing, you must present it and wait for explicit approval (or edits) before inserting — the writing voice is the user's call, even when you're handing them a starting point.
- **Do not keep more than two `## What's New in vX.Y.Z` sections in the README.** Step 4 trims older ones; if you see three or more after Step 4, you missed one.
- **Do not skip the compile gate** (`mix compile --warnings-as-errors`) — a deprecation warning that ships silently becomes a consumer's "why does my project log warnings now?" issue.
- **Do not skip `mix test`** — the gate is what catches regressions before they ship.
- **Do not invent CHANGELOG entries** to cover commits you find; ask the user if something's missing.
- **Do not bump if there's nothing meaningful in the WIP section** — stop and explain.

### Repo-specific don'ts

- **Do not stage `test/`, `_build/`, `deps/`, `doc/`, or `keen_web_multiselect-*.tar`** — they're either gitignored or intermediate artifacts of `mix hex.build`.
- **Do not let `priv/static/multiselect.js` and `lib/keen_web_multiselect.ex`'s `@upstream_version` drift** — when re-bundling from upstream, update both in the same commit. The `KeenWebMultiselect.upstream_version/0` accessor is how consumers introspect which upstream they're getting.
