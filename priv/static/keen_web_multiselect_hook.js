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
// The hook forwards three events to the server:
//   - "web_multiselect:select"   payload: { id, value, values }
//   - "web_multiselect:deselect" payload: { id, value, values }
//   - "web_multiselect:change"   payload: { id, values }
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
      change: (event) => this._forwardChange(event)
    };

    this.el.addEventListener("select", this._handlers.select);
    this.el.addEventListener("deselect", this._handlers.deselect);
    this.el.addEventListener("change", this._handlers.change);

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
  }
};

export default KeenWebMultiselectHook;
