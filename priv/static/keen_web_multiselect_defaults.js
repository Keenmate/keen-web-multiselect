/* keen_web_multiselect_defaults.js
   =============================================================================
   Project-wide shared shadow-DOM styles for every <web-multiselect> — configure a
   unified look ONCE instead of on every instance. Installs a small, idempotent
   `window.KeenWebMultiselect` registry.

   This file is self-contained (no imports/exports), so it can be BOTH:
     • imported for its side effect by keen_web_multiselect_hook.js (bundled into
       your app.js), and
     • inlined verbatim by the `<.shadow_styles/>` HEEx component into a plain
       <script> in the page — for dead views that don't load the hook.
   Both paths install the same global, so state is shared.

   Public API (window.KeenWebMultiselect):
     registerShadowStyles(css)  Set the shared CSS. It's compiled into one
                                Constructable Stylesheet and adopted into every
                                <web-multiselect> shadow root (now and future). Call
                                again to update it live — every adopter re-styles.
                                This is what `<.shadow_styles/>` calls.
     getShadowStyles()          The current shared CSS string (or null). Handy to
                                read + re-register with extra rules appended.

   Why adoptedStyleSheets (and not the element's customStylesCallback): a single
   shared sheet is deterministic and cheap — it applies immediately, survives the
   component's own shadow re-renders, and isn't duplicated per instance. Because the
   sheet lives in each shadow root, `:host(.your-class) .ms__badge { … }` selectors
   work, so a select opts into (or diverges from) the shared theme with a plain
   `class`/id — no per-instance JavaScript.

   Flash-free (upstream 2.1.0 `defer`): the wrapper emits the `defer` attribute when
   shared styles are configured, so the element reserves space but builds NOTHING on
   upgrade. We adopt the shared sheet into its (already-attached) shadow root, then
   release the gate by removing `defer` — the picker builds once, styled, in a single
   paint. No default-badge flash before the theme lands. Elements flagged
   `data-kwms-manual` (the component's `defer={true}` opt-in) are adopted but NOT
   released — the author owns their release via `el.ready()`.

   NOTE: this is the escape hatch for arbitrary shadow-DOM CSS. For anything
   expressible as CSS custom properties (colors, sizing, radii — the --base-* /
   --ms-* contract), prefer plain global CSS at :root: those pierce the shadow DOM
   with no JS at all.
   ============================================================================= */
(function () {
  "use strict";
  if (typeof window === "undefined") return;
  if (window.KeenWebMultiselect) return; // idempotent — first installer wins

  var css = null; // current shared CSS text
  var sheet = null; // the shared Constructable Stylesheet (created lazily)
  var patched = false;
  var attachTries = typeof WeakMap === "function" ? new WeakMap() : null;

  function constructableSupported() {
    if (typeof CSSStyleSheet !== "function") return false;
    try {
      // Constructing + replaceSync throws in engines without constructable sheets.
      var s = new CSSStyleSheet();
      s.replaceSync("");
      return true;
    } catch (e) {
      return false;
    }
  }

  var supported = constructableSupported();

  // The one shared sheet; replaceSync updates it in place, so every shadow root that
  // has adopted it re-styles live with no re-adoption needed.
  function ensureSheet() {
    if (!supported) return null;
    if (!sheet) sheet = new CSSStyleSheet();
    try {
      sheet.replaceSync(css == null ? "" : css);
    } catch (e) {
      /* malformed CSS — leave the previous rules in place */
    }
    return sheet;
  }

  // Release the upstream `defer` render gate (2.1.0+): removing the attribute builds the
  // picker ONCE, now that the shared sheet is adopted — the styled result paints in one shot,
  // no default-style flash. We release every deferred element EXCEPT ones flagged
  // `data-kwms-manual` — the wrapper's `defer={true}` opt-in, where the author releases via
  // their hook / `el.ready()` (we still adopt the sheet so their eventual build is styled too).
  // Auto-deferred elements carry only a bare `defer`; after we remove it, LiveView's DOM patch
  // on connect leaves it off, so the element settles with a clean DOM (no lingering marker).
  function releaseDefer(el) {
    if (
      el && el.hasAttribute &&
      el.hasAttribute("defer") && !el.hasAttribute("data-kwms-manual")
    ) {
      el.removeAttribute("defer");
    }
  }

  function adoptInto(el) {
    var sr = el.shadowRoot;
    if (!sr) {
      // The shadow root usually exists immediately (a deferred element attaches it in its
      // constructor), but a non-deferred element only attaches it as the picker builds — so
      // poll for it rather than giving up on a fixed schedule. Don't release the gate here:
      // we only release AFTER adopting (when there's a sheet), so the single build paints styled.
      if (attachTries && typeof setTimeout === "function") {
        var tries = attachTries.get(el) || 0;
        if (tries < 100) {
          attachTries.set(el, tries + 1);
          setTimeout(function () { adoptInto(el); }, 100);
        }
      }
      return;
    }
    // Adopt the shared sheet when one is configured AND supported; otherwise skip (a bare hook
    // load with no `<.shadow_styles/>` registers no CSS — the element still builds, unthemed).
    if (css != null && css !== "" && "adoptedStyleSheets" in sr) {
      var s = ensureSheet();
      if (s && sr.adoptedStyleSheets.indexOf(s) === -1) {
        // Append so the shared theme wins ties against the component's own defaults,
        // while a per-instance `:host(.class)` rule (higher specificity) still wins.
        sr.adoptedStyleSheets = sr.adoptedStyleSheets.concat(s);
      }
    }
    // Sheet (if any) is in the shadow root — safe to build now. Release runs whether or not a
    // sheet was adopted, so an auto-deferred element ALWAYS builds once the registry is loaded
    // (via the hook or `<.shadow_styles/>`), never stranded held.
    releaseDefer(el);
  }

  function adoptAll() {
    if (typeof document === "undefined" || !document.querySelectorAll) return;
    var els = document.querySelectorAll("web-multiselect");
    for (var i = 0; i < els.length; i++) adoptInto(els[i]);
  }

  // Adopt into every FUTURE instance as it connects (covers LiveView-patched-in
  // elements). connectedCallback runs before the shadow root exists, so adoptInto
  // polls for it.
  function ensurePatched() {
    if (patched || typeof customElements === "undefined") return;
    patched = true;
    customElements.whenDefined("web-multiselect").then(function (Ctor) {
      var proto = Ctor.prototype;
      var original = proto.connectedCallback;
      proto.connectedCallback = function () {
        var result = original && original.apply(this, arguments);
        adoptInto(this);
        return result;
      };
      adoptAll(); // instances that upgraded before this patch ran
    });
  }

  window.KeenWebMultiselect = {
    registerShadowStyles: function (newCss) {
      css = newCss == null ? "" : String(newCss);
      ensureSheet(); // update the shared sheet in place → live for all adopters
      ensurePatched();
      adoptAll();
    },

    getShadowStyles: function () {
      return css;
    }
  };

  // Release the `defer` gate as soon as the registry is loaded — by ANY path (the hook
  // bundled into app.js, or `<.shadow_styles/>`), independent of whether CSS is registered.
  // This is what guarantees an auto-deferred element always builds: a layout that loads the
  // hook but omits `<.shadow_styles/>` still releases its gates (unthemed). When CSS *is*
  // registered (in `<head>`, before the elements upgrade), adoptInto has it in hand and the
  // build paints themed in one shot.
  ensurePatched();
  adoptAll();
})();
