// Phoenix LiveView hook for <web-multiselect>.
//
// Wire up once in your app.js:
//
//   import KeenWebMultiselectHook from "../../deps/keen_web_multiselect/priv/static/keen_web_multiselect_hook.js";
//   import "../../deps/keen_web_multiselect/priv/static/multiselect.js";
//   import "../../deps/keen_web_multiselect/priv/static/multiselect.css";
//
//   let liveSocket = new LiveSocket("/live", Socket, {
//     hooks: { KeenWebMultiselectHook }
//   });
//
// Then in HEEx:
//
//   <.web_multiselect id="tags" hook="KeenWebMultiselectHook" options={@options} />
//
// The hook ALWAYS forwards four events to the server:
//   - "web_multiselect:select"   payload: { id, value, values }
//   - "web_multiselect:deselect" payload: { id, value, values }
//   - "web_multiselect:change"   payload: { id, values }
//   - "web_multiselect:add"      payload: { id, value, option }
//                                (fires when allow-add-new is on and the user chose
//                                 the "Add new …" prompt; `value` is the typed text,
//                                 `option` is the created option's scalar value or null)
//
// It also forwards a fifth, OPT-IN event when the wrapper renders
// data-ready-event="<name>" (from the ready_event= assign):
//   - "<name>"                   payload: { id }
//                                (fires ONCE when the picker has finished its first
//                                 build — after the element is upgraded and, with
//                                 `defer`, after release. This is the reliable moment
//                                 to drive it from the server: the hook's listeners
//                                 are attached and the dropdown DOM exists, so a
//                                 push_command/3 issued in reply won't be dropped.)
//                                Opt-in because an always-on new event would crash any
//                                consumer LiveView lacking a matching handle_event/3.
//
// The hook also LISTENS for one server→client event so consumers can mutate
// element state from the LV process. This is necessary because the wrapper
// renders phx-update="ignore" on the element (to keep morphdom away from the
// component's internally-managed children), which also blocks LV from
// propagating attribute changes like data-options. To update the option list
// or selection from the server, push:
//
//   push_event(socket, "web_multiselect:update",
//              %{id: "cascade-unit", options: new_options, value: []})
//
// Payload shape:  { id, options?, value? }
//   - id      DOM id of the target element; events with non-matching id are ignored
//   - options (optional) new option list; assigned to el.options
//   - value   (optional) new selection; passed to el.setSelected([...])
//
// The hook also listens for "web_multiselect:command" — the imperative channel behind
// Keenmate.WebMultiselect.push_command/3. It drives the dropdown without changing options
// or selection:
//
//   push_command(socket, "tags", open: true)
//   push_command(socket, "tags", scroll_to_value: "py")
//   push_command(socket, "tags", search: "back")
//
// Payload shape:  { id, open?, close?, toggle?, search?, clear_search?,
//                    scroll_to_value?, scroll_to_group?, scroll_to_index? }
// Each key maps to the matching element method (open/close/toggle/search/clearSearch/
// scrollToValue/scrollToGroup/scrollToIndex). Unknown/absent keys are ignored.

// Install the shared shadow-styles registry (window.KeenWebMultiselect) as a side
// effect of importing the hook, so an app that wires up the hook can also register
// project-wide shadow CSS from JS. Bundlers (esbuild) follow this relative import
// automatically. See keen_web_multiselect_defaults.js.
import "./keen_web_multiselect_defaults.js";

// Ergonomic ESM re-exports so app.js can `import { registerShadowStyles, getShadowStyles }`
// from the hook module instead of reaching for the global. They delegate to the same
// window.KeenWebMultiselect registry the <.shadow_styles/> component uses.
export const registerShadowStyles = (css) =>
  typeof window !== "undefined" && window.KeenWebMultiselect
    ? window.KeenWebMultiselect.registerShadowStyles(css)
    : undefined;

export const getShadowStyles = () =>
  typeof window !== "undefined" && window.KeenWebMultiselect
    ? window.KeenWebMultiselect.getShadowStyles()
    : undefined;

// Ensure <web-multiselect> exposes a .form getter so Phoenix LV's phx-change
// delegation can resolve the parent form. LV's form change handler does
// `if (e instanceof CustomEvent && e.target.form === void 0) return;` and
// silently drops the change event when the target has no .form.
//
// Since upstream 2.0.0 the element is built on @keenmate/web-components-core
// (BlissElement), which defines a real, form-associated `get form()` on the
// prototype (reads its ElementInternals.form) — so no shim is needed on current
// bundles. This block only installs a fallback for OLDER bundles that predate
// that getter; it resolves the form by DOM ancestry via closest("form"). It is
// a no-op on 2.0.0+ because the native getter already occupies the prototype.
// (The v1 shim read `this.internals?.form`; core made `internals` a true private
// field, so that path is dead — closest("form") is the correct fallback now.)
// Module-level — runs once per page load even if no element opts into the hook.
if (typeof customElements !== "undefined") {
  customElements.whenDefined("web-multiselect").then((WebMultiselect) => {
    if (!("form" in WebMultiselect.prototype)) {
      Object.defineProperty(WebMultiselect.prototype, "form", {
        configurable: true,
        get() { return this.closest("form"); }
      });
    }
  });
}

const KeenWebMultiselectHook = {
  mounted() {
    this._handlers = {
      select: (event) => this._forward("web_multiselect:select", event),
      deselect: (event) => this._forward("web_multiselect:deselect", event),
      change: (event) => this._forwardChange(event),
      add: (event) => this._forwardAdd(event),
      ready: () => this._forwardReady()
    };

    this.el.addEventListener("select", this._handlers.select);
    this.el.addEventListener("deselect", this._handlers.deselect);
    this.el.addEventListener("change", this._handlers.change);
    this.el.addEventListener("add", this._handlers.add);

    // Ready forwarding is OPT-IN via data-ready-event (rendered when the wrapper is
    // given ready_event=). It must NOT be always-on: it would push a brand-new event
    // to every hooked consumer, crashing any LiveView that lacks a matching
    // handle_event/3 clause. Only wire it when the consumer asked for it. Mirrors the
    // data-search-event opt-in below.
    if (this.el.dataset.readyEvent) {
      this.el.addEventListener("ready", this._handlers.ready);
      // The `ready` event may have ALREADY fired before this hook mounted — the
      // element upgrades and (unless deferred) builds synchronously on connect,
      // which can precede the hook's mounted(). `el.isReady` latches true on that
      // first build, so if it's already set, replay the notification now so a
      // server "open on entry" handler never misses it.
      if (this.el.isReady === true) this._forwardReady();
    }

    this.handleEvent("web_multiselect:update", (payload) => {
      if (!payload || payload.id !== this.el.id) return;
      if ("options" in payload) this.el.options = payload.options;
      if ("value" in payload) {
        const next = Array.isArray(payload.value)
          ? payload.value
          : payload.value == null ? [] : [payload.value];
        if (typeof this.el.setSelected === "function") this.el.setSelected(next);
        else this.el.value = next;
      }
    });

    // Imperative command channel — Keenmate.WebMultiselect.push_command/3. Drives the
    // dropdown (open/close/scroll/search) without touching options or selection. Each key
    // maps to the element method of the same name; guard on presence + callability so an
    // older bundle lacking a given method silently ignores it.
    this.handleEvent("web_multiselect:command", (payload) => {
      if (!payload || payload.id !== this.el.id) return;
      const call = (method, ...args) => {
        if (typeof this.el[method] === "function") this.el[method](...args);
      };
      if (payload.close) call("close");
      if (payload.open) call("open");
      if (payload.toggle) call("toggle");
      if ("clear_search" in payload && payload.clear_search) call("clearSearch");
      if ("search" in payload) call("search", payload.search == null ? "" : String(payload.search));
      if ("scroll_to_value" in payload) call("scrollToValue", payload.scroll_to_value);
      if ("scroll_to_group" in payload) call("scrollToGroup", payload.scroll_to_group);
      if ("scroll_to_index" in payload) call("scrollToIndex", payload.scroll_to_index);
    });

    // Server-driven async search. When the wrapper renders data-search-event="...",
    // install a searchCallback that pushes the query to the LV and resolves with
    // the {:reply, %{results: [...]}, socket} payload. The reply pattern keeps
    // each search atomic — no separate result event, no id routing.
    //
    // The AbortSignal arg (added in upstream rc04) is honored: if a newer search
    // supersedes an in-flight one, the late LV reply is dropped before reaching
    // the dropdown. The server still does its work — we can't cancel an LV
    // process from the client — but stale results never overwrite live ones.
    const searchEvent = this.el.dataset.searchEvent;
    if (searchEvent) {
      this.el.searchCallback = (query, signal) => new Promise((resolve) => {
        let aborted = false;
        if (signal) {
          if (signal.aborted) { resolve([]); return; }
          signal.addEventListener("abort", () => { aborted = true; resolve([]); }, { once: true });
        }
        this.pushEventTo(this.el, searchEvent, { id: this.el.id, query }, (reply) => {
          if (aborted) return;
          resolve((reply && reply.results) || []);
        });
      });
    }
  },

  destroyed() {
    if (!this._handlers) return;
    this.el.removeEventListener("select", this._handlers.select);
    this.el.removeEventListener("deselect", this._handlers.deselect);
    this.el.removeEventListener("change", this._handlers.change);
    this.el.removeEventListener("add", this._handlers.add);
    this.el.removeEventListener("ready", this._handlers.ready);
  },

  _forward(name, event) {
    const detail = event.detail || {};

    // `selectedValues` is the element's OWN extracted scalar values — it honours
    // the configured value-member, a `getValueCallback`, and cascade policy. Always
    // prefer it over re-deriving from the option objects: for custom-shaped data
    // (keyed by e.g. `userId`, with no `.value`/`.id`), naive extraction would emit
    // whole option maps, which then crash server handlers that expect a scalar
    // (e.g. `to_string/1` on the payload).
    const values = Array.isArray(detail.selectedValues)
      ? detail.selectedValues
      : (detail.selectedOptions || []).map((o) => this._optionValue(o));

    this.pushEventTo(this.el, name, {
      id: this.el.id,
      value: this._optionValue(detail.option || null),
      values
    });
  },

  // Best-effort scalar value for a single option object. Uses the element's
  // configured value-member (falling back to `value` / `id`), and never returns a
  // non-scalar — an unresolvable object (e.g. a getValueCallback-only picker) yields
  // null rather than a map, so the payload is always safe to serialize/print.
  _optionValue(option) {
    if (option == null || typeof option !== "object") return option;
    const member = this.el.getAttribute("value-member") || "value";
    const value = option[member] ?? option.value ?? option.id;
    return value == null || typeof value === "object" ? null : value;
  },

  _forwardChange(event) {
    const detail = event.detail || {};
    const values = detail.selectedValues || [];
    this.pushEventTo(this.el, "web_multiselect:change", { id: this.el.id, values });
  },

  // The `ready` event carries no useful detail — the id is all the server needs to
  // route "open on entry" handlers. Push the consumer-named event (data-ready-event);
  // guard against a double emit (real event + the isReady replay in mounted()) so the
  // server only ever sees it once per mount.
  _forwardReady() {
    const name = this.el.dataset.readyEvent;
    if (!name || this._readyForwarded) return;
    this._readyForwarded = true;
    this.pushEventTo(this.el, name, { id: this.el.id });
  },

  // The `add` event (allow-add-new). `detail.value` is the raw typed text; `detail.option`
  // is the option materialized by an `addNewCallback`, or absent when creation is left to the
  // server. Forward both — the typed text verbatim, and a safe scalar for the created option.
  _forwardAdd(event) {
    const detail = event.detail || {};
    this.pushEventTo(this.el, "web_multiselect:add", {
      id: this.el.id,
      value: detail.value != null ? detail.value : null,
      option: this._optionValue(detail.option != null ? detail.option : null)
    });
  }
};

export default KeenWebMultiselectHook;
