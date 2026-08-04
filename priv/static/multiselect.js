var No = Object.defineProperty;
var $t = (o) => {
  throw TypeError(o);
};
var Ro = (o, e, t) => e in o ? No(o, e, { enumerable: !0, configurable: !0, writable: !0, value: t }) : o[e] = t;
var y = (o, e, t) => Ro(o, typeof e != "symbol" ? e + "" : e, t), dt = (o, e, t) => e.has(o) || $t("Cannot " + t);
var f = (o, e, t) => (dt(o, e, "read from private field"), t ? t.call(o) : e.get(o)), V = (o, e, t) => e.has(o) ? $t("Cannot add the same private member more than once") : e instanceof WeakSet ? e.add(o) : e.set(o, t), z = (o, e, t, s) => (dt(o, e, "write to private field"), s ? s.call(o, t) : e.set(o, t), t), C = (o, e, t) => (dt(o, e, "access private method"), t);
function W(o, e = {}) {
  const t = new Set(o), s = e.shouldNullOnInvalid ? null : e.default ?? null;
  return {
    values: o,
    fromAttribute(i) {
      return i === null ? e.default ?? s : t.has(i) ? i : s;
    },
    validate(i) {
      return typeof i == "string" && t.has(i);
    },
    toAttribute(i) {
      return i == null ? null : String(i);
    }
  };
}
function G(o = {}) {
  const e = (s) => (o.min == null || s >= o.min) && (o.max == null || s <= o.max), t = o.default;
  return {
    fromAttribute(s) {
      if (s === null)
        return t;
      const i = Number.parseInt(s, 10);
      return Number.isNaN(i) || !e(i) ? t : i;
    },
    validate(s) {
      return typeof s == "number" && Number.isInteger(s) && e(s);
    },
    toAttribute(s) {
      return s == null ? null : String(s);
    }
  };
}
function E(o = {}) {
  const e = o.isNullable === !0, t = o.default ?? (e ? null : ""), s = (i) => o.shouldTrim ? i.trim() : i;
  return {
    fromAttribute(i) {
      if (i === null)
        return t;
      const r = s(i);
      return !o.isEmptyAllowed && r === "" ? t : r;
    },
    validate(i) {
      return i === null ? e : typeof i == "string" && (o.isEmptyAllowed === !0 || i !== "");
    },
    toAttribute(i) {
      return i == null ? null : String(i);
    }
  };
}
const Bo = /* @__PURE__ */ new Set(["", "true", "1", "yes", "on"]), Ko = /* @__PURE__ */ new Set(["false", "0", "no", "off"]);
function K(o = "presence") {
  const e = (t) => {
    const s = t.trim().toLowerCase();
    return Bo.has(s) ? !0 : Ko.has(s) ? !1 : null;
  };
  return {
    fromAttribute(t) {
      switch (o) {
        case "presence":
          return t !== null;
        case "default-true":
          return t === null ? !0 : e(t) ?? !0;
        case "default-false":
          return t === null ? !1 : e(t) ?? !1;
        case "tristate":
          return t === null ? null : e(t);
      }
    },
    validate(t) {
      return o === "tristate" ? t === !0 || t === !1 || t === null : typeof t == "boolean";
    },
    toAttribute(t) {
      return o === "presence" ? t ? "" : null : t == null ? null : String(t);
    }
  };
}
function Ho(o = {}) {
  const e = o.default;
  return {
    fromAttribute(t) {
      if (t === null || t.trim() === "")
        return e;
      let s;
      try {
        s = JSON.parse(t);
      } catch {
        return e;
      }
      return o.validate && !o.validate(s) ? e : s;
    },
    validate: o.validate,
    toAttribute(t) {
      return t == null ? null : JSON.stringify(t);
    }
  };
}
function Fo(o = {}) {
  const e = o.default ?? [], t = (s) => Array.isArray(s) && (!o.validateItem || s.every(o.validateItem));
  return {
    fromAttribute(s) {
      if (s === null || s.trim() === "")
        return e;
      let i;
      try {
        i = JSON.parse(s);
      } catch {
        return e;
      }
      return t(i) ? i : e;
    },
    validate: t,
    toAttribute(s) {
      return Array.isArray(s) ? JSON.stringify(s) : null;
    }
  };
}
function Wo() {
  return {
    validate(o) {
      return o == null || typeof o == "function";
    }
  };
}
function jo(o, e, t) {
  const s = o.converter, i = s != null && s.fromAttribute ? s.fromAttribute(e, t, o.attribute ?? o.configKey) : e ?? o.default;
  return { configKey: o.configKey, field: o.field, value: i, on: o.on ?? "update" };
}
function Uo(o, e) {
  const t = o.converter;
  return t != null && t.validate && !t.validate(e) ? null : { configKey: o.configKey, field: o.field, value: e, on: o.on ?? "update" };
}
function Go() {
  const o = /* @__PURE__ */ new Set();
  let e = !1;
  const t = () => {
    e = !1;
    const s = [...o];
    o.clear();
    for (const i of s)
      i();
  };
  return {
    schedule(s) {
      o.add(s), e || (e = !0, queueMicrotask(t));
    },
    flush() {
      if (o.size === 0)
        return;
      e = !1;
      const s = [...o];
      o.clear();
      for (const i of s)
        i();
    },
    cancel() {
      o.clear(), e = !1;
    }
  };
}
const Ze = /* @__PURE__ */ new Map();
function qo(o, e) {
  let t = Ze.get(o);
  t || Ze.set(o, t = /* @__PURE__ */ new Set()), t.add(e);
}
function Jo(o, e) {
  var t;
  (t = Ze.get(o)) == null || t.delete(e);
}
function Xo(o) {
  return Array.from(Ze.get(o) ?? []);
}
const no = /* @__PURE__ */ new Map();
function Yo(o, e) {
  no.set(o.toLowerCase(), e);
}
function Qo(o) {
  return no.get(o.toLowerCase());
}
function Zo(o, e, t, s = {}) {
  return o.dispatchEvent(new CustomEvent(e, {
    detail: t,
    bubbles: s.bubbles ?? !0,
    composed: s.composed ?? !0,
    cancelable: s.cancelable ?? !1
  }));
}
function es(o) {
  return o.split(/[-_]/).filter(Boolean).map((e) => e[0].toUpperCase() + e.slice(1)).join("");
}
function ts(o) {
  return `on${es(o)}`;
}
function os(o) {
  return o ? o.map((e) => {
    const t = typeof e == "string" ? { name: e } : e, s = t.property === !1 ? null : t.property ?? ts(t.name);
    return { name: t.name, property: s, bubbles: t.bubbles, composed: t.composed, cancelable: t.cancelable };
  }) : [];
}
const ss = typeof HTMLElement < "u" ? HTMLElement : class {
}, Vt = /* @__PURE__ */ new WeakSet();
let is = 0;
const rs = { trace() {
}, debug() {
}, info() {
}, warn() {
}, error() {
} }, ns = new Proxy({}, { get: () => rs });
var de, He, Se, Fe, be, We, st, ve, he, ye, Te, Ie, Oe, Pe, it, te, Me, P, ao, lo, co, J, ho, po, ft, gt, ze, bt, mo;
class ut extends ss {
  constructor() {
    super();
    V(this, P);
    V(this, de, {});
    V(this, He, /* @__PURE__ */ new Map());
    V(this, Se, /* @__PURE__ */ new Map());
    V(this, Fe, /* @__PURE__ */ new Map());
    /** Live handler currently bound via each managed `on<Name>` property, keyed by event name. */
    V(this, be, /* @__PURE__ */ new Map());
    V(this, We, Go());
    V(this, st, () => C(this, P, bt).call(this));
    V(this, ve, null);
    V(this, he, !1);
    V(this, ye, []);
    V(this, Te, !1);
    /**
     * configKeys that carried a value assigned BEFORE the element was upgraded
     * (`el.foo = …` before its class was defined). The browser fires the initial
     * `attributeChangedCallback`s AFTER the constructor, so without this an initial
     * attribute would clobber that lifted property. We let the pre-upgrade property
     * win over the *initial* attribute (the conventional lazy-property-upgrade
     * guarantee); post-connect attribute changes react normally. Cleared on first
     * connect.
     */
    V(this, Ie, null);
    V(this, Oe, !1);
    V(this, Pe);
    V(this, it);
    V(this, te);
    V(this, Me);
    const t = this.constructor, s = t.inputs ?? [], i = os(t.events);
    C(this, P, co).call(this, s, i);
    for (const r of s)
      f(this, He).set(r.configKey, r), r.attribute && f(this, Se).set(r.attribute, r);
    for (const r of i)
      f(this, Fe).set(r.name, r);
    C(this, P, ao).call(this, s), C(this, P, ho).call(this, s), C(this, P, po).call(this, i);
  }
  static get observedAttributes() {
    return (this.inputs ?? []).filter((t) => t.attribute).map((t) => t.attribute);
  }
  // ── lifecycle ──────────────────────────────────────────────────────────
  attributeChangedCallback(t, s, i) {
    var a;
    if (f(this, Oe))
      return;
    const r = f(this, Se).get(t);
    if (!r || !f(this, Te) && ((a = f(this, Ie)) != null && a.has(r.configKey)))
      return;
    let n;
    try {
      n = jo(r, i, this);
    } catch (l) {
      C(this, P, J).call(this, `converter for "${r.configKey}" threw parsing attribute ${t}="${i}"; using default`, l), n = C(this, P, lo).call(this, r);
    }
    C(this, P, gt).call(this, n);
  }
  connectedCallback() {
    qo(this.localName, this), f(this, Te) || (z(this, Te, !0), z(this, Ie, null), z(this, he, !0)), C(this, P, ze).call(this), this.connect();
  }
  disconnectedCallback() {
    Jo(this.localName, this), this.disconnect();
  }
  // ── public batching API ─────────────────────────────────────────────────
  /** Apply many inputs (by `configKey` or attribute name) as ONE reinit/update. */
  setAttributes(t) {
    for (const [s, i] of Object.entries(t)) {
      const r = f(this, He).get(s) ?? f(this, Se).get(s);
      r && C(this, P, ft).call(this, r, i);
    }
    C(this, P, ze).call(this);
  }
  /** Run `fn` and coalesce every input change it makes into a single reinit/update. */
  batch(t) {
    t(), C(this, P, ze).call(this);
  }
  /**
   * Apply any pending input writes **synchronously, now** — running the
   * resulting `reinit()`/`update()` before this call returns. No-op when nothing
   * is pending (or while detached, where changes are held until connect).
   *
   * This is the escape hatch for **imperative methods** that read or mutate live
   * state built from inputs. Loose property assignments coalesce on a microtask
   * (`el.options = …`), so a synchronous method called right after (e.g.
   * `el.setSelected(…)`) would otherwise run against pre-write state. Call
   * `this.flush()` at the top of such a method to preserve the intuitive
   * "set property, then call method" ordering without forcing consumers to
   * `await whenSettled()` between the two.
   */
  flush() {
    C(this, P, ze).call(this);
  }
  /**
   * Resolves once the element is **settled** — i.e. every staged input change
   * has been applied and the resulting `reinit()`/`update()` has run. If nothing
   * is pending it resolves immediately (a microtask); otherwise it resolves at
   * the end of the next flush. This is the deterministic "await the pipeline"
   * signal for tests AND consumers — read rendered state right after it, instead
   * of guessing with a bare `await Promise.resolve()`.
   *
   * Note: loose property assignments coalesce on a microtask, so
   * `el.x = …; await el.whenSettled()` awaits that microtask. `setAttributes()`
   * and `batch()` flush synchronously, so after either the element is already
   * settled. While the element is **detached**, pending changes are held (the
   * flush no-ops until connected), so the promise resolves on the next connect's
   * flush — not before the change is actually applied.
   */
  whenSettled() {
    return !f(this, ve) && !f(this, he) ? Promise.resolve() : new Promise((t) => f(this, ye).push(t));
  }
  // ── subclass surface ─────────────────────────────────────────────────────
  /** The current validated config. */
  get config() {
    return f(this, de);
  }
  /**
   * Instance-scoped loggers, one per category of the bundle this component
   * registered (via `registerComponent`'s `logging` option). Each line is
   * prefixed with a `tag#id` handle — the element's own `id` when set, else a
   * `tag#n` counter — and gated by the more verbose of the type-level category
   * level and this instance's own override, so a devtools overlay can make ONE
   * element loud while its type stays quiet (SPEC §12.3). Returns no-op loggers
   * when the tag has no attached bundle. Prefer this over the shared type-level
   * loggers inside a component.
   */
  get log() {
    if (f(this, Me))
      return f(this, Me);
    const t = Qo(this.localName);
    if (!t)
      return ns;
    const s = f(this, it) ?? z(this, it, `${this.localName}#${this.id || ++is}`);
    return z(this, Me, t.forInstance(s, () => f(this, te)));
  }
  /**
   * Turn on verbose logging for THIS element only (default `debug`), independent
   * of the type-level level. The seam a Ctrl-Alt-C overlay calls after the user
   * picks one instance. Pairs with {@link disableLogging}.
   */
  enableLogging(t = "debug") {
    z(this, te, t);
  }
  /** Clear this element's logging override (falls back to the type-level level). */
  disableLogging() {
    z(this, te, void 0);
  }
  /** Whether this element has an active logging override (not unset/`silent`). */
  get isLoggingEnabled() {
    return f(this, te) != null && f(this, te) !== "silent" && f(this, te) !== 5;
  }
  /**
   * Full rebuild: called when a batch changes any `on: 'reinit'` input, and on
   * first connect. Reads {@link config} (already fully merged) — it is not given
   * a partial, because any `on: 'update'` keys that changed in the same batch
   * are absorbed by the rebuild. Override in components that need it; no-op by
   * default so the input table stays opt-in.
   */
  reinit() {
  }
  /**
   * In-place patch: called with just the changed `on: 'update'` keys, when a
   * batch contains NO reinit-level change. Override to apply the named keys
   * without a teardown; no-op by default.
   */
  update(t) {
  }
  /**
   * Activate: called on EVERY connect, after any `reinit()`/`update()` for that
   * connect (including the first). Start live resources here — document/window
   * listeners, observers, floating-ui `autoUpdate`, timers. Pairs with
   * {@link disconnect} and can run many times (any DOM move re-fires it), so
   * keep it balanced/idempotent. No-op by default.
   */
  connect() {
  }
  /**
   * Deactivate: called on EVERY disconnect. Stop whatever {@link connect}
   * started. The shadow DOM persists across disconnect/reconnect, so do NOT
   * tear down structure here — only the live resources. No-op by default.
   */
  disconnect() {
  }
  // ── form association ──────────────────────────────────────────────────────
  /**
   * This element's {@link ElementInternals}, lazily attached on first access and
   * memoized. Available to form-associated components (`static formAssociated =
   * true`); returns `null` when `attachInternals` is unavailable (SSR, older
   * jsdom) or the element opts out. Because `attachInternals()` may be called at
   * most once per element, a subclass must NOT call it itself — read this getter
   * instead (e.g. `this.internals?.setFormValue(value)`).
   */
  get internals() {
    if (f(this, Pe))
      return f(this, Pe);
    if (typeof this.attachInternals != "function")
      return null;
    try {
      return z(this, Pe, this.attachInternals());
    } catch {
      return null;
    }
  }
  /**
   * The `<form>` this element is associated with, or `null`. A form-associated
   * custom element (`static formAssociated = true`) participates in its form, but
   * — unlike a native control — gets NO `.form` property for free: the browser
   * records the association only inside {@link ElementInternals}. This re-exposes
   * it so `el.form` and `event.target.form` resolve like a native input. Host
   * frameworks that route form changes by reading `target.form` (e.g. Phoenix
   * LiveView's `phx-change` delegation) depend on it. Unlike `closest('form')`,
   * `ElementInternals.form` honours shadow-DOM boundaries and `form=` association.
   */
  get form() {
    var t;
    return ((t = this.internals) == null ? void 0 : t.form) ?? null;
  }
  // ── events & callbacks (SPEC §12.5) ───────────────────────────────────────
  /**
   * Fire an outward notification: dispatch a typed `CustomEvent`. `name` and
   * `detail` are checked against the component's event map (`static events`),
   * and per-event dispatch overrides from the table are applied (defaulting to
   * the {@link dispatch} defaults: bubbles + composed). Returns `false` when a
   * cancelable event was `preventDefault()`-ed. The paired `on<Name>` property
   * (if declared) is a real listener, so it fires through the normal dispatch —
   * `emit` does not call it separately.
   */
  emit(t, s, i) {
    const r = f(this, Fe).get(t);
    return Zo(this, t, s, {
      bubbles: (i == null ? void 0 : i.bubbles) ?? (r == null ? void 0 : r.bubbles),
      composed: (i == null ? void 0 : i.composed) ?? (r == null ? void 0 : r.composed),
      cancelable: (i == null ? void 0 : i.cancelable) ?? (r == null ? void 0 : r.cancelable)
    });
  }
  /**
   * Typed `addEventListener` for a declared event: the handler receives a
   * `CustomEvent<detail>`. Returns an unsubscribe function. Complements the
   * managed `on<Name>` property with the same event object.
   */
  on(t, s, i) {
    const r = s;
    return this.addEventListener(t, r, i), () => this.removeEventListener(t, r, i);
  }
  /**
   * Invoke a `*Callback` input through the one unified protocol (SPEC §12.5):
   * unset → `opts.whenUnset`; the callback is called with a single `ctx`
   * argument and its result is normalized through `Promise.resolve` (so sync OR
   * async callbacks both work); a throw routes to `opts.onError` if given, else
   * re-throws (no silent swallow). The RESULT contract — the discriminated
   * `action`, adjustments, etc. — is the component's; core owns only the
   * plumbing. Correctness that used to drift across per-component hook wrappers
   * lives here once.
   */
  async runHook(t, s, i) {
    const r = f(this, de)[t];
    if (typeof r != "function")
      return i.whenUnset;
    try {
      return await Promise.resolve(r(s));
    } catch (n) {
      if (i.onError)
        return i.onError(n);
      throw n;
    }
  }
}
de = new WeakMap(), He = new WeakMap(), Se = new WeakMap(), Fe = new WeakMap(), be = new WeakMap(), We = new WeakMap(), st = new WeakMap(), ve = new WeakMap(), he = new WeakMap(), ye = new WeakMap(), Te = new WeakMap(), Ie = new WeakMap(), Oe = new WeakMap(), Pe = new WeakMap(), it = new WeakMap(), te = new WeakMap(), Me = new WeakMap(), P = new WeakSet(), // ── internals ─────────────────────────────────────────────────────────────
ao = function(t) {
  var s;
  for (const i of t) {
    let r = i.default;
    if ((s = i.converter) != null && s.fromAttribute)
      try {
        r = i.converter.fromAttribute(null, this, i.attribute ?? i.configKey);
      } catch (n) {
        C(this, P, J).call(this, `converter for "${i.configKey}" threw computing its default; using \`default\``, n), r = i.default;
      }
    f(this, de)[i.configKey] = r, i.field && (this[i.field] = r);
  }
}, lo = function(t) {
  return { configKey: t.configKey, field: t.field, value: t.default, on: t.on ?? "update" };
}, /** Sanity-check the input + event tables once per class; warn (never throw) on mistakes. */
co = function(t, s) {
  var l;
  const i = this.constructor;
  if (Vt.has(i))
    return;
  Vt.add(i);
  const r = /* @__PURE__ */ new Set(), n = /* @__PURE__ */ new Set();
  for (const c of t)
    r.has(c.configKey) && C(this, P, J).call(this, `invalid input table: duplicate configKey "${c.configKey}"`), r.add(c.configKey), c.attribute && (n.has(c.attribute) && C(this, P, J).call(this, `invalid input table: duplicate attribute "${c.attribute}"`), n.add(c.attribute)), c.reflect && !c.attribute && C(this, P, J).call(this, `invalid input table: "${c.configKey}" has reflect:true but no attribute to reflect to`), c.reflect && !((l = c.converter) != null && l.toAttribute) && C(this, P, J).call(this, `invalid input table: "${c.configKey}" has reflect:true but its converter has no toAttribute`);
  const a = /* @__PURE__ */ new Set();
  for (const c of s)
    a.has(c.name) && C(this, P, J).call(this, `invalid event table: duplicate event "${c.name}"`), a.add(c.name), /^[a-z][a-z0-9-]*$/.test(c.name) || C(this, P, J).call(this, `invalid event table: event "${c.name}" should be lowercase kebab-case (e.g. "date-select")`), c.property && r.has(c.property) && C(this, P, J).call(this, `invalid event table: event "${c.name}" property "${c.property}" collides with an input configKey`);
}, /**
 * Always-on console warning for input validation failures. Deliberately uses
 * `console.warn` directly — NOT the (future) categorized logger — so rejected
 * inputs surface even when logging is disabled.
 */
J = function(t, ...s) {
  console.warn(`[BlissElement] <${this.localName ?? "unknown"}> ${t}`, ...s);
}, ho = function(t) {
  for (const s of t) {
    const i = s.configKey, r = Object.prototype.hasOwnProperty.call(this, i), n = r ? this[i] : void 0;
    r && delete this[i], Object.defineProperty(this, i, {
      configurable: !0,
      enumerable: !0,
      get: () => f(this, de)[i],
      set: (a) => C(this, P, ft).call(this, s, a)
    }), r && ((f(this, Ie) ?? z(this, Ie, /* @__PURE__ */ new Set())).add(i), this[i] = n);
  }
}, /**
 * Install a managed `on<Name>` handler property per event. Assigning it
 * (de)registers a real listener for the event, so the property behaves like
 * `addEventListener(name, …)` and its handler receives the `CustomEvent`.
 */
po = function(t) {
  for (const s of t) {
    const i = s.property;
    if (!i)
      continue;
    const r = s.name, n = Object.prototype.hasOwnProperty.call(this, i), a = n ? this[i] : void 0;
    n && delete this[i], Object.defineProperty(this, i, {
      configurable: !0,
      enumerable: !0,
      get: () => f(this, be).get(r) ?? null,
      set: (l) => {
        const c = f(this, be).get(r);
        if (c && this.removeEventListener(r, c), typeof l == "function") {
          const d = l;
          f(this, be).set(r, d), this.addEventListener(r, d);
        } else
          f(this, be).delete(r);
      }
    }), n && (this[i] = a);
  }
}, ft = function(t, s) {
  var r;
  const i = Uo(t, s);
  if (!i) {
    C(this, P, J).call(this, `rejected invalid value for property "${t.configKey}"; keeping previous value`, s);
    return;
  }
  if (C(this, P, gt).call(this, i), t.reflect && t.attribute && ((r = t.converter) != null && r.toAttribute)) {
    const n = t.converter.toAttribute(i.value);
    z(this, Oe, !0);
    try {
      n === null ? this.removeAttribute(t.attribute) : this.setAttribute(t.attribute, n);
    } finally {
      z(this, Oe, !1);
    }
  }
}, gt = function(t) {
  f(this, de)[t.configKey] = t.value, t.field && (this[t.field] = t.value), t.on !== "none" && (t.on === "reinit" && z(this, he, !0), (f(this, ve) ?? z(this, ve, {}))[t.configKey] = t.value, f(this, We).schedule(f(this, st)));
}, /** Cancel any queued microtask and flush pending changes synchronously now. */
ze = function() {
  f(this, We).cancel(), C(this, P, bt).call(this);
}, bt = function() {
  if (!this.isConnected)
    return;
  const t = f(this, he), s = f(this, ve);
  z(this, he, !1), z(this, ve, null), t ? this.reinit() : s && Object.keys(s).length > 0 && this.update(s), C(this, P, mo).call(this);
}, /** Resolve everyone awaiting {@link whenSettled} for the flush that just ran. */
mo = function() {
  if (f(this, ye).length === 0)
    return;
  const t = f(this, ye);
  z(this, ye, []);
  for (const s of t)
    s();
}, /** The opt-in input table. Subclasses set this to enable attribute/property reactivity. */
y(ut, "inputs"), /**
 * The opt-in event table (SPEC §12.5). Each entry (a bare name, or an
 * {@link EventDef} for overrides) declares an outward notification that
 * {@link emit} can fire and installs a managed `on<Name>` handler property.
 */
y(ut, "events");
function Dt(o, e, t) {
  typeof customElements > "u" || customElements.get(o) || customElements.define(o, e, t);
}
function as(o) {
  return {
    enableLogging: (e) => o.enableLogging(e),
    disableLogging: () => o.disableLogging(),
    setLogLevel: (e) => o.setLogLevel(e),
    setCategoryLevel: (e, t) => o.setCategoryLevel(e, t),
    getCategories: () => [...o.LOGGING_CATEGORIES]
  };
}
function ls(o, e, t) {
  const { config: s, logging: i, shouldAutoDefine: r = !0 } = t;
  i && Yo(o, i);
  const n = {
    version: () => s.version,
    config: s,
    ...i ? { logging: as(i) } : {},
    register: () => Dt(o, e),
    getInstances: () => Xo(o)
  };
  return typeof window < "u" && ((window.components ?? (window.components = {}))[o] = n), r && Dt(o, e), n;
}
const zt = /* @__PURE__ */ new Map(), Nt = /* @__PURE__ */ new WeakMap();
let qe;
function cs(o) {
  if (typeof CSSStyleSheet > "u" || !("adoptedStyleSheets" in o))
    return !1;
  if (qe === void 0)
    try {
      new CSSStyleSheet().replaceSync(""), qe = !0;
    } catch {
      qe = !1;
    }
  return qe;
}
function ds(o, ...e) {
  if (typeof document > "u")
    return;
  let t = Nt.get(o);
  t || Nt.set(o, t = /* @__PURE__ */ new Set());
  const s = e.filter((r) => r && !t.has(r));
  if (s.length === 0)
    return;
  for (const r of s)
    t.add(r);
  if (cs(o)) {
    const r = s.map((n) => {
      let a = zt.get(n);
      return a || (a = new CSSStyleSheet(), a.replaceSync(n), zt.set(n, a)), a;
    });
    o.adoptedStyleSheets = [...o.adoptedStyleSheets, ...r];
    return;
  }
  const i = o.head ?? o;
  for (const r of s) {
    const n = document.createElement("style");
    n.textContent = r, i.appendChild(n);
  }
}
function hs(o, e = {}) {
  const t = e.position ?? "last", s = o.head ?? o;
  let i = null;
  const r = () => typeof document > "u" ? null : (i || (i = document.createElement("style"), e.className && (i.className = e.className)), i.parentNode !== s && (t === "first" && s.firstChild ? s.insertBefore(i, s.firstChild) : s.appendChild(i)), i), n = () => {
    i == null || i.remove();
  };
  return {
    set(a) {
      if (!a) {
        n();
        return;
      }
      const l = r();
      l && (l.textContent = a);
    },
    clear: n,
    destroy() {
      i == null || i.remove(), i = null;
    }
  };
}
function uo(o) {
  return o.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}
function ps(o, e) {
  const t = /* @__PURE__ */ new Set(), s = new RegExp(`var\\(\\s*(${uo(e)}[a-z0-9-]+)`, "gi");
  let i;
  for (; i = s.exec(o); )
    i[1] && t.add(i[1]);
  return t;
}
function ms(o, e) {
  const t = /* @__PURE__ */ new Set(), s = new RegExp(`(${uo(e)}[a-z0-9-]+)\\s*:`, "gi");
  let i;
  for (; i = s.exec(o); )
    i[1] && t.add(i[1]);
  return [...t];
}
function us(o, e, t = {}) {
  const s = t.minScore ?? 3, i = t.limit ?? 3, r = new Set(o.split("-").filter(Boolean));
  return [...e].map((n) => ({ k: n, score: n.split("-").filter((a) => r.has(a)).length })).filter((n) => n.score >= s).sort((n, a) => a.score - n.score).slice(0, i).map((n) => n.k);
}
function fs(o, e) {
  if (e.consumed.size === 0)
    return [];
  const t = [];
  for (const s of ms(o, e.prefix))
    e.consumed.has(s) || t.push({ name: s, suggestions: us(s, e.consumed, { minScore: e.minScore }) });
  return t;
}
var gs = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {}, fo = { exports: {} };
(function(o) {
  (function(e, t) {
    o.exports ? o.exports = t() : e.log = t();
  })(gs, function() {
    var e = function() {
    }, t = "undefined", s = typeof window !== t && typeof window.navigator !== t && /Trident\/|MSIE /.test(window.navigator.userAgent), i = [
      "trace",
      "debug",
      "info",
      "warn",
      "error"
    ], r = {}, n = null;
    function a(u, v) {
      var p = u[v];
      if (typeof p.bind == "function")
        return p.bind(u);
      try {
        return Function.prototype.bind.call(p, u);
      } catch {
        return function() {
          return Function.prototype.apply.apply(p, [u, arguments]);
        };
      }
    }
    function l() {
      console.log && (console.log.apply ? console.log.apply(console, arguments) : Function.prototype.apply.apply(console.log, [console, arguments])), console.trace && console.trace();
    }
    function c(u) {
      return u === "debug" && (u = "log"), typeof console === t ? !1 : u === "trace" && s ? l : console[u] !== void 0 ? a(console, u) : console.log !== void 0 ? a(console, "log") : e;
    }
    function d() {
      for (var u = this.getLevel(), v = 0; v < i.length; v++) {
        var p = i[v];
        this[p] = v < u ? e : this.methodFactory(p, u, this.name);
      }
      if (this.log = this.debug, typeof console === t && u < this.levels.SILENT)
        return "No console available for logging";
    }
    function h(u) {
      return function() {
        typeof console !== t && (d.call(this), this[u].apply(this, arguments));
      };
    }
    function g(u, v, p) {
      return c(u) || h.apply(this, arguments);
    }
    function m(u, v) {
      var p = this, x, S, k, A = "loglevel";
      typeof u == "string" ? A += ":" + u : typeof u == "symbol" && (A = void 0);
      function L(w) {
        var _ = (i[w] || "silent").toUpperCase();
        if (!(typeof window === t || !A)) {
          try {
            window.localStorage[A] = _;
            return;
          } catch {
          }
          try {
            window.document.cookie = encodeURIComponent(A) + "=" + _ + ";";
          } catch {
          }
        }
      }
      function B() {
        var w;
        if (!(typeof window === t || !A)) {
          try {
            w = window.localStorage[A];
          } catch {
          }
          if (typeof w === t)
            try {
              var _ = window.document.cookie, $ = encodeURIComponent(A), I = _.indexOf($ + "=");
              I !== -1 && (w = /^([^;]+)/.exec(
                _.slice(I + $.length + 1)
              )[1]);
            } catch {
            }
          return p.levels[w] === void 0 && (w = void 0), w;
        }
      }
      function F() {
        if (!(typeof window === t || !A)) {
          try {
            window.localStorage.removeItem(A);
          } catch {
          }
          try {
            window.document.cookie = encodeURIComponent(A) + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
          } catch {
          }
        }
      }
      function M(w) {
        var _ = w;
        if (typeof _ == "string" && p.levels[_.toUpperCase()] !== void 0 && (_ = p.levels[_.toUpperCase()]), typeof _ == "number" && _ >= 0 && _ <= p.levels.SILENT)
          return _;
        throw new TypeError("log.setLevel() called with invalid level: " + w);
      }
      p.name = u, p.levels = {
        TRACE: 0,
        DEBUG: 1,
        INFO: 2,
        WARN: 3,
        ERROR: 4,
        SILENT: 5
      }, p.methodFactory = v || g, p.getLevel = function() {
        return k ?? S ?? x;
      }, p.setLevel = function(w, _) {
        return k = M(w), _ !== !1 && L(k), d.call(p);
      }, p.setDefaultLevel = function(w) {
        S = M(w), B() || p.setLevel(w, !1);
      }, p.resetLevel = function() {
        k = null, F(), d.call(p);
      }, p.enableAll = function(w) {
        p.setLevel(p.levels.TRACE, w);
      }, p.disableAll = function(w) {
        p.setLevel(p.levels.SILENT, w);
      }, p.rebuild = function() {
        if (n !== p && (x = M(n.getLevel())), d.call(p), n === p)
          for (var w in r)
            r[w].rebuild();
      }, x = M(
        n ? n.getLevel() : "WARN"
      );
      var T = B();
      T != null && (k = M(T)), d.call(p);
    }
    n = new m(), n.getLogger = function(v) {
      if (typeof v != "symbol" && typeof v != "string" || v === "")
        throw new TypeError("You must supply a name when creating a logger.");
      var p = r[v];
      return p || (p = r[v] = new m(
        v,
        n.methodFactory
      )), p;
    };
    var b = typeof window !== t ? window.log : void 0;
    return n.noConflict = function() {
      return typeof window !== t && window.log === n && (window.log = b), n;
    }, n.getLoggers = function() {
      return r;
    }, n.default = n, n;
  });
})(fo);
var oe = fo.exports;
const bs = ["INIT", "DATA", "UI"], vs = "debug", Rt = [
  "#4c8bf5",
  // blue
  "#2ea043",
  // green
  "#d29922",
  // amber
  "#a371f7",
  // purple
  "#db61a2",
  // pink
  "#e5534b",
  // red
  "#3fb0ac",
  // teal
  "#8a6d3b"
  // brown
], Bt = /* @__PURE__ */ new WeakSet();
function ys(o, e, t) {
  if (Bt.has(o))
    return;
  Bt.add(o);
  const s = o.methodFactory, i = `color:${t};font-weight:bold`;
  o.methodFactory = (r, n, a) => {
    const l = s(r, n, a);
    return (...c) => l(`%c[${e}]`, i, ...c);
  }, o.setLevel(o.getLevel(), !1);
}
function ws(o) {
  return typeof o == "number" ? o : oe.levels[o.toUpperCase()] ?? oe.levels.SILENT;
}
const xs = [
  ["trace", oe.levels.TRACE, "debug"],
  ["debug", oe.levels.DEBUG, "debug"],
  ["info", oe.levels.INFO, "info"],
  ["warn", oe.levels.WARN, "warn"],
  ["error", oe.levels.ERROR, "error"]
];
function _s(o, e, t) {
  const s = `color:${o.color};font-weight:bold`, i = "color:#888", r = {};
  for (const [n, a, l] of xs)
    r[n] = (...c) => {
      const d = t(), h = Math.min(o.logger.getLevel(), d == null ? oe.levels.SILENT : ws(d));
      if (a < h)
        return;
      (console[l] ?? console.log).bind(console)(`%c[${o.label}]%c ${e}`, s, i, ...c);
    };
  return r;
}
function ks(o, e = bs) {
  const t = {}, s = {};
  e.forEach((r, n) => {
    const a = `${o}:${r}`, l = Rt[n % Rt.length], c = oe.getLogger(a);
    ys(c, a, l), t[r] = c, s[r] = { label: a, color: l, logger: c };
  });
  const i = (r) => {
    for (const n of e)
      t[n].setLevel(r, !1);
  };
  return {
    loggers: t,
    LOGGING_CATEGORIES: e,
    enableLogging(r = vs) {
      i(r);
    },
    disableLogging() {
      i("silent");
    },
    setLogLevel(r) {
      i(r);
    },
    setCategoryLevel(r, n) {
      var a;
      (a = t[r]) == null || a.setLevel(n, !1);
    },
    forInstance(r, n) {
      const a = {};
      for (const l of e)
        a[l] = _s(s[l], r, n);
      return a;
    }
  };
}
const me = Math.min, ie = Math.max, et = Math.round, Je = Math.floor, re = (o) => ({
  x: o,
  y: o
}), Cs = {
  left: "right",
  right: "left",
  bottom: "top",
  top: "bottom"
};
function go(o, e, t) {
  return ie(o, me(e, t));
}
function Ee(o, e) {
  return typeof o == "function" ? o(e) : o;
}
function xe(o) {
  return o.split("-")[0];
}
function $e(o) {
  return o.split("-")[1];
}
function bo(o) {
  return o === "x" ? "y" : "x";
}
function Ot(o) {
  return o === "y" ? "height" : "width";
}
function se(o) {
  const e = o[0];
  return e === "t" || e === "b" ? "y" : "x";
}
function Pt(o) {
  return bo(se(o));
}
function Ss(o, e, t) {
  t === void 0 && (t = !1);
  const s = $e(o), i = Pt(o), r = Ot(i);
  let n = i === "x" ? s === (t ? "end" : "start") ? "right" : "left" : s === "start" ? "bottom" : "top";
  return e.reference[r] > e.floating[r] && (n = tt(n)), [n, tt(n)];
}
function Ts(o) {
  const e = tt(o);
  return [vt(o), e, vt(e)];
}
function vt(o) {
  return o.includes("start") ? o.replace("start", "end") : o.replace("end", "start");
}
const Kt = ["left", "right"], Ht = ["right", "left"], Is = ["top", "bottom"], Os = ["bottom", "top"];
function Ps(o, e, t) {
  switch (o) {
    case "top":
    case "bottom":
      return t ? e ? Ht : Kt : e ? Kt : Ht;
    case "left":
    case "right":
      return e ? Is : Os;
    default:
      return [];
  }
}
function Ms(o, e, t, s) {
  const i = $e(o);
  let r = Ps(xe(o), t === "start", s);
  return i && (r = r.map((n) => n + "-" + i), e && (r = r.concat(r.map(vt)))), r;
}
function tt(o) {
  const e = xe(o);
  return Cs[e] + o.slice(e.length);
}
function As(o) {
  var e, t, s, i;
  return {
    top: (e = o.top) != null ? e : 0,
    right: (t = o.right) != null ? t : 0,
    bottom: (s = o.bottom) != null ? s : 0,
    left: (i = o.left) != null ? i : 0
  };
}
function vo(o) {
  return typeof o != "number" ? As(o) : {
    top: o,
    right: o,
    bottom: o,
    left: o
  };
}
function ot(o) {
  const {
    x: e,
    y: t,
    width: s,
    height: i
  } = o;
  return {
    width: s,
    height: i,
    top: t,
    left: e,
    right: e + s,
    bottom: t + i,
    x: e,
    y: t
  };
}
function Ft(o, e, t) {
  let {
    reference: s,
    floating: i
  } = o;
  const r = se(e), n = Pt(e), a = Ot(n), l = xe(e), c = r === "y", d = s.x + s.width / 2 - i.width / 2, h = s.y + s.height / 2 - i.height / 2, g = s[a] / 2 - i[a] / 2;
  let m;
  switch (l) {
    case "top":
      m = {
        x: d,
        y: s.y - i.height
      };
      break;
    case "bottom":
      m = {
        x: d,
        y: s.y + s.height
      };
      break;
    case "right":
      m = {
        x: s.x + s.width,
        y: h
      };
      break;
    case "left":
      m = {
        x: s.x - i.width,
        y: h
      };
      break;
    default:
      m = {
        x: s.x,
        y: s.y
      };
  }
  const b = $e(e);
  return b && (m[n] += g * (b === "end" ? 1 : -1) * (t && c ? -1 : 1)), m;
}
async function Ls(o, e) {
  var t;
  e === void 0 && (e = {});
  const {
    x: s,
    y: i,
    platform: r,
    rects: n,
    elements: a,
    strategy: l
  } = o, {
    boundary: c = "clippingAncestors",
    rootBoundary: d = "viewport",
    elementContext: h = "floating",
    altBoundary: g = !1,
    padding: m = 0
  } = Ee(e, o), b = vo(m), v = a[g ? h === "floating" ? "reference" : "floating" : h], p = ot(await r.getClippingRect({
    element: (t = await (r.isElement == null ? void 0 : r.isElement(v))) == null || t ? v : v.contextElement || await (r.getDocumentElement == null ? void 0 : r.getDocumentElement(a.floating)),
    boundary: c,
    rootBoundary: d,
    strategy: l
  })), x = h === "floating" ? {
    x: s,
    y: i,
    width: n.floating.width,
    height: n.floating.height
  } : n.reference, S = await (r.getOffsetParent == null ? void 0 : r.getOffsetParent(a.floating)), k = await (r.isElement == null ? void 0 : r.isElement(S)) && await (r.getScale == null ? void 0 : r.getScale(S)) || {
    x: 1,
    y: 1
  }, A = ot(r.convertOffsetParentRelativeRectToViewportRelativeRect ? await r.convertOffsetParentRelativeRectToViewportRelativeRect({
    elements: a,
    rect: x,
    offsetParent: S,
    strategy: l
  }) : x);
  return {
    top: (p.top - A.top + b.top) / k.y,
    bottom: (A.bottom - p.bottom + b.bottom) / k.y,
    left: (p.left - A.left + b.left) / k.x,
    right: (A.right - p.right + b.right) / k.x
  };
}
const Es = 50, $s = async (o, e, t) => {
  const {
    placement: s = "bottom",
    strategy: i = "absolute",
    middleware: r = [],
    platform: n
  } = t, a = n.detectOverflow ? n : {
    ...n,
    detectOverflow: Ls
  }, l = await (n.isRTL == null ? void 0 : n.isRTL(e));
  let c = await n.getElementRects({
    reference: o,
    floating: e,
    strategy: i
  }), {
    x: d,
    y: h
  } = Ft(c, s, l), g = s, m = 0;
  const b = {};
  for (let u = 0; u < r.length; u++) {
    const v = r[u];
    if (!v)
      continue;
    const {
      name: p,
      fn: x
    } = v, {
      x: S,
      y: k,
      data: A,
      reset: L
    } = await x({
      x: d,
      y: h,
      initialPlacement: s,
      placement: g,
      strategy: i,
      middlewareData: b,
      rects: c,
      platform: a,
      elements: {
        reference: o,
        floating: e
      }
    });
    d = S ?? d, h = k ?? h, b[p] = {
      ...b[p],
      ...A
    }, L && m < Es && (m++, typeof L == "object" && (L.placement && (g = L.placement), L.rects && (c = L.rects === !0 ? await n.getElementRects({
      reference: o,
      floating: e,
      strategy: i
    }) : L.rects), {
      x: d,
      y: h
    } = Ft(c, g, l)), u = -1);
  }
  return {
    x: d,
    y: h,
    placement: g,
    strategy: i,
    middlewareData: b
  };
}, Vs = (o) => ({
  name: "arrow",
  options: o,
  async fn(e) {
    const {
      x: t,
      y: s,
      placement: i,
      rects: r,
      platform: n,
      elements: a,
      middlewareData: l
    } = e, {
      element: c,
      padding: d = 0
    } = Ee(o, e) || {};
    if (c == null)
      return {};
    const h = vo(d), g = {
      x: t,
      y: s
    }, m = Pt(i), b = Ot(m), u = await n.getDimensions(c), v = m === "y", p = v ? "top" : "left", x = v ? "bottom" : "right", S = v ? "clientHeight" : "clientWidth", k = r.reference[b] + r.reference[m] - g[m] - r.floating[b], A = g[m] - r.reference[m], L = await (n.getOffsetParent == null ? void 0 : n.getOffsetParent(c));
    let B = L ? L[S] : 0;
    (!B || !await (n.isElement == null ? void 0 : n.isElement(L))) && (B = a.floating[S] || r.floating[b]);
    const F = k / 2 - A / 2, M = B / 2 - u[b] / 2 - 1, T = me(h[p], M), w = me(h[x], M), _ = B - u[b] - w, $ = B / 2 - u[b] / 2 + F, I = go(T, $, _), R = !l.arrow && $e(i) != null && $ !== I && r.reference[b] / 2 - ($ < T ? T : w) - u[b] / 2 < 0, ee = R ? $ < T ? $ - T : $ - _ : 0;
    return {
      [m]: g[m] + ee,
      data: {
        [m]: I,
        centerOffset: $ - I - ee,
        ...R && {
          alignmentOffset: ee
        }
      },
      reset: R
    };
  }
}), Ds = function(o) {
  return o === void 0 && (o = {}), {
    name: "flip",
    options: o,
    async fn(e) {
      var t, s;
      const {
        placement: i,
        middlewareData: r,
        rects: n,
        initialPlacement: a,
        platform: l,
        elements: c
      } = e, {
        mainAxis: d = !0,
        crossAxis: h = !0,
        fallbackPlacements: g,
        fallbackStrategy: m = "bestFit",
        fallbackAxisSideDirection: b = "none",
        flipAlignment: u = !0,
        ...v
      } = Ee(o, e);
      if ((t = r.arrow) != null && t.alignmentOffset)
        return {};
      const p = xe(i), x = se(a), S = xe(a) === a, k = await (l.isRTL == null ? void 0 : l.isRTL(c.floating)), A = g || (S || !u ? [tt(a)] : Ts(a)), L = b !== "none";
      !g && L && A.push(...Ms(a, u, b, k));
      const B = [a, ...A], F = await l.detectOverflow(e, v), M = [];
      let T = ((s = r.flip) == null ? void 0 : s.overflows) || [];
      if (d && M.push(F[p]), h) {
        const I = Ss(i, n, k);
        M.push(F[I[0]], F[I[1]]);
      }
      if (T = [...T, {
        placement: i,
        overflows: M
      }], !M.every((I) => I <= 0)) {
        var w, _;
        const I = (((w = r.flip) == null ? void 0 : w.index) || 0) + 1, R = B[I];
        if (R && (!(h === "alignment" ? x !== se(R) : !1) || // We leave the current main axis only if every placement on that axis
        // overflows the main axis.
        T.every((q) => se(q.placement) === x ? q.overflows[0] > 0 : !0)))
          return {
            data: {
              index: I,
              overflows: T
            },
            reset: {
              placement: R
            }
          };
        let ee = (_ = T.filter((fe) => fe.overflows[0] <= 0).sort((fe, q) => fe.overflows[1] - q.overflows[1])[0]) == null ? void 0 : _.placement;
        if (!ee)
          switch (m) {
            case "bestFit": {
              var $;
              const fe = ($ = T.filter((q) => {
                if (L) {
                  const le = se(q.placement);
                  return le === x || // Create a bias to the `y` side axis due to horizontal
                  // reading directions favoring greater width.
                  le === "y";
                }
                return !0;
              }).map((q) => [q.placement, q.overflows.filter((le) => le > 0).reduce((le, zo) => le + zo, 0)]).sort((q, le) => q[1] - le[1])[0]) == null ? void 0 : $[0];
              fe && (ee = fe);
              break;
            }
            case "initialPlacement":
              ee = a;
              break;
          }
        if (i !== ee)
          return {
            reset: {
              placement: ee
            }
          };
      }
      return {};
    }
  };
}, zs = /* @__PURE__ */ new Set(["left", "top"]);
async function Ns(o, e) {
  const {
    placement: t,
    platform: s,
    elements: i
  } = o, r = await (s.isRTL == null ? void 0 : s.isRTL(i.floating)), n = xe(t), a = $e(t), l = se(t) === "y", c = zs.has(n) ? -1 : 1, d = r && l ? -1 : 1, h = Ee(e, o);
  let {
    mainAxis: g,
    crossAxis: m,
    alignmentAxis: b
  } = typeof h == "number" ? {
    mainAxis: h,
    crossAxis: 0,
    alignmentAxis: null
  } : {
    mainAxis: h.mainAxis || 0,
    crossAxis: h.crossAxis || 0,
    alignmentAxis: h.alignmentAxis
  };
  return a && typeof b == "number" && (m = a === "end" ? b * -1 : b), l ? {
    x: m * d,
    y: g * c
  } : {
    x: g * c,
    y: m * d
  };
}
const Rs = function(o) {
  return o === void 0 && (o = 0), {
    name: "offset",
    options: o,
    async fn(e) {
      var t, s;
      const {
        x: i,
        y: r,
        placement: n,
        middlewareData: a
      } = e, l = await Ns(e, o);
      return n === ((t = a.offset) == null ? void 0 : t.placement) && (s = a.arrow) != null && s.alignmentOffset ? {} : {
        x: i + l.x,
        y: r + l.y,
        data: {
          ...l,
          placement: n
        }
      };
    }
  };
}, Bs = function(o) {
  return o === void 0 && (o = {}), {
    name: "shift",
    options: o,
    async fn(e) {
      const {
        x: t,
        y: s,
        placement: i,
        platform: r
      } = e, {
        mainAxis: n = !0,
        crossAxis: a = !1,
        limiter: l = {
          fn: (x) => {
            let {
              x: S,
              y: k
            } = x;
            return {
              x: S,
              y: k
            };
          }
        },
        ...c
      } = Ee(o, e), d = {
        x: t,
        y: s
      }, h = await r.detectOverflow(e, c), g = se(i), m = bo(g);
      let b = d[m], u = d[g];
      const v = (x, S) => go(S + h[x === "y" ? "top" : "left"], S, S - h[x === "y" ? "bottom" : "right"]);
      n && (b = v(m, b)), a && (u = v(g, u));
      const p = l.fn({
        ...e,
        [m]: b,
        [g]: u
      });
      return {
        ...p,
        data: {
          x: p.x - t,
          y: p.y - s,
          enabled: {
            [m]: n,
            [g]: a
          }
        }
      };
    }
  };
}, Ks = function(o) {
  return o === void 0 && (o = {}), {
    name: "size",
    options: o,
    async fn(e) {
      const {
        placement: t,
        rects: s,
        platform: i,
        elements: r
      } = e, {
        apply: n = () => {
        },
        ...a
      } = Ee(o, e), l = await i.detectOverflow(e, a), c = xe(t), d = $e(t), h = se(t) === "y", {
        width: g,
        height: m
      } = s.floating;
      let b, u;
      c === "top" || c === "bottom" ? (b = c, u = d === (await (i.isRTL == null ? void 0 : i.isRTL(r.floating)) ? "start" : "end") ? "left" : "right") : (u = c, b = d === "end" ? "top" : "bottom");
      const v = m - l.top - l.bottom, p = g - l.left - l.right, x = me(m - l[b], v), S = me(g - l[u], p), k = e.middlewareData.shift, A = !k;
      let L = x, B = S;
      k != null && k.enabled.x && (B = p), k != null && k.enabled.y && (L = v), A && !d && (h ? B = g - 2 * ie(l.left, l.right) : L = m - 2 * ie(l.top, l.bottom)), await n({
        ...e,
        availableWidth: B,
        availableHeight: L
      });
      const F = await i.getDimensions(r.floating);
      return g !== F.width || m !== F.height ? {
        reset: {
          rects: !0
        }
      } : {};
    }
  };
};
function rt() {
  return typeof window < "u";
}
function Ve(o) {
  return yo(o) ? (o.nodeName || "").toLowerCase() : "#document";
}
function U(o) {
  var e;
  return (o == null || (e = o.ownerDocument) == null ? void 0 : e.defaultView) || window;
}
function ne(o) {
  var e;
  return (e = (yo(o) ? o.ownerDocument : o.document) || window.document) == null ? void 0 : e.documentElement;
}
function yo(o) {
  return rt() ? o instanceof Node || o instanceof U(o).Node : !1;
}
function Q(o) {
  return rt() ? o instanceof Element || o instanceof U(o).Element : !1;
}
function ue(o) {
  return rt() ? o instanceof HTMLElement || o instanceof U(o).HTMLElement : !1;
}
function Wt(o) {
  return !rt() || typeof ShadowRoot > "u" ? !1 : o instanceof ShadowRoot || o instanceof U(o).ShadowRoot;
}
function nt(o) {
  const {
    overflow: e,
    overflowX: t,
    overflowY: s,
    display: i
  } = Z(o);
  return /auto|scroll|overlay|hidden|clip/.test(e + s + t) && i !== "inline" && i !== "contents";
}
function Hs(o) {
  return /^(table|td|th)$/.test(Ve(o));
}
function at(o) {
  try {
    if (o.matches(":popover-open"))
      return !0;
  } catch {
  }
  try {
    return o.matches(":modal");
  } catch {
    return !1;
  }
}
const Fs = /transform|translate|scale|rotate|perspective|filter/, Ws = /paint|layout|strict|content/, ge = (o) => !!o && o !== "none";
let ht;
function Mt(o) {
  const e = Q(o) ? Z(o) : o;
  return ge(e.transform) || ge(e.translate) || ge(e.scale) || ge(e.rotate) || ge(e.perspective) || !At() && (ge(e.backdropFilter) || ge(e.filter)) || Fs.test(e.willChange || "") || Ws.test(e.contain || "");
}
function js(o) {
  let e = _e(o);
  for (; ue(e) && !Be(e); ) {
    if (Mt(e))
      return e;
    if (at(e))
      return null;
    e = _e(e);
  }
  return null;
}
function At() {
  return ht == null && (ht = typeof CSS < "u" && CSS.supports && CSS.supports("-webkit-backdrop-filter", "none")), ht;
}
function Be(o) {
  return /^(html|body|#document)$/.test(Ve(o));
}
function Z(o) {
  return U(o).getComputedStyle(o);
}
function lt(o) {
  return Q(o) ? {
    scrollLeft: o.scrollLeft,
    scrollTop: o.scrollTop
  } : {
    scrollLeft: o.scrollX,
    scrollTop: o.scrollY
  };
}
function _e(o) {
  if (Ve(o) === "html")
    return o;
  const e = (
    // Step into the shadow DOM of the parent of a slotted node.
    o.assignedSlot || // DOM Element detected.
    o.parentNode || // ShadowRoot detected.
    Wt(o) && o.host || // Fallback.
    ne(o)
  );
  return Wt(e) ? e.host : e;
}
function wo(o) {
  const e = _e(o);
  return Be(e) ? (o.ownerDocument || o).body : ue(e) && nt(e) ? e : wo(e);
}
function Ke(o, e, t) {
  var s;
  e === void 0 && (e = []), t === void 0 && (t = !0);
  const i = wo(o), r = i === ((s = o.ownerDocument) == null ? void 0 : s.body), n = U(i);
  if (r) {
    const a = yt(n);
    return e.concat(n, n.visualViewport || [], nt(i) ? i : [], a && t ? Ke(a) : []);
  } else
    return e.concat(i, Ke(i, [], t));
}
function yt(o) {
  return o.parent && Object.getPrototypeOf(o.parent) ? o.frameElement : null;
}
function xo(o) {
  const e = Z(o);
  let t = parseFloat(e.width) || 0, s = parseFloat(e.height) || 0;
  const i = ue(o), r = i ? o.offsetWidth : t, n = i ? o.offsetHeight : s, a = et(t) !== r || et(s) !== n;
  return a && (t = r, s = n), {
    width: t,
    height: s,
    $: a
  };
}
function Lt(o) {
  return Q(o) ? o : o.contextElement;
}
function Ce(o) {
  const e = Lt(o);
  if (!ue(e))
    return re(1);
  const t = e.getBoundingClientRect(), {
    width: s,
    height: i,
    $: r
  } = xo(e);
  let n = (r ? et(t.width) : t.width) / s, a = (r ? et(t.height) : t.height) / i;
  return (!n || !Number.isFinite(n)) && (n = 1), (!a || !Number.isFinite(a)) && (a = 1), {
    x: n,
    y: a
  };
}
const Us = /* @__PURE__ */ re(0);
function _o(o) {
  const e = U(o);
  return !At() || !e.visualViewport ? Us : {
    x: e.visualViewport.offsetLeft,
    y: e.visualViewport.offsetTop
  };
}
function Gs(o, e, t) {
  return e === void 0 && (e = !1), !!t && e && t === U(o);
}
function ke(o, e, t, s) {
  e === void 0 && (e = !1), t === void 0 && (t = !1);
  const i = o.getBoundingClientRect(), r = Lt(o);
  let n = re(1);
  e && (s ? Q(s) && (n = Ce(s)) : n = Ce(o));
  const a = Gs(r, t, s) ? _o(r) : re(0);
  let l = (i.left + a.x) / n.x, c = (i.top + a.y) / n.y, d = i.width / n.x, h = i.height / n.y;
  if (r && s) {
    const g = U(r), m = Q(s) ? U(s) : s;
    let b = g, u = yt(b);
    for (; u && m !== b; ) {
      const v = Ce(u), p = u.getBoundingClientRect(), x = Z(u), S = p.left + (u.clientLeft + parseFloat(x.paddingLeft)) * v.x, k = p.top + (u.clientTop + parseFloat(x.paddingTop)) * v.y;
      l *= v.x, c *= v.y, d *= v.x, h *= v.y, l += S, c += k, b = U(u), u = yt(b);
    }
  }
  return ot({
    width: d,
    height: h,
    x: l,
    y: c
  });
}
function ct(o, e) {
  const t = lt(o).scrollLeft;
  return e ? e.left + t : ke(ne(o)).left + t;
}
function ko(o, e) {
  const t = o.getBoundingClientRect(), s = t.left + e.scrollLeft - ct(o, t), i = t.top + e.scrollTop;
  return {
    x: s,
    y: i
  };
}
function qs(o) {
  let {
    elements: e,
    rect: t,
    offsetParent: s,
    strategy: i
  } = o;
  const r = i === "fixed", n = ne(s), a = e ? at(e.floating) : !1;
  if (s === n || a && r)
    return t;
  let l = {
    scrollLeft: 0,
    scrollTop: 0
  }, c = re(1);
  const d = re(0), h = ue(s);
  if ((h || !r) && ((Ve(s) !== "body" || nt(n)) && (l = lt(s)), h)) {
    const m = ke(s);
    c = Ce(s), d.x = m.x + s.clientLeft, d.y = m.y + s.clientTop;
  }
  const g = n && !h && !r ? ko(n, l) : re(0);
  return {
    width: t.width * c.x,
    height: t.height * c.y,
    x: t.x * c.x - l.scrollLeft * c.x + d.x + g.x,
    y: t.y * c.y - l.scrollTop * c.y + d.y + g.y
  };
}
function Js(o) {
  return o.getClientRects ? Array.from(o.getClientRects()) : [];
}
function Xs(o) {
  const e = lt(o), t = o.ownerDocument.body, s = ie(o.scrollWidth, o.clientWidth, t.scrollWidth, t.clientWidth), i = ie(o.scrollHeight, o.clientHeight, t.scrollHeight, t.clientHeight);
  let r = -e.scrollLeft + ct(o);
  const n = -e.scrollTop;
  return Z(t).direction === "rtl" && (r += ie(o.clientWidth, t.clientWidth) - s), {
    width: s,
    height: i,
    x: r,
    y: n
  };
}
const Ys = 25;
function Qs(o, e, t) {
  t === void 0 && (t = "viewport");
  const s = t === "layoutViewport", i = U(o), r = ne(o), n = i.visualViewport;
  let a = r.clientWidth, l = r.clientHeight, c = 0, d = 0;
  if (n) {
    const g = !At() || e === "fixed";
    s ? g || (c = -n.offsetLeft, d = -n.offsetTop) : (a = n.width, l = n.height, g && (c = n.offsetLeft, d = n.offsetTop));
  }
  if (ct(r) <= 0) {
    const g = r.ownerDocument, m = g.body, b = getComputedStyle(m), u = g.compatMode === "CSS1Compat" && parseFloat(b.marginLeft) + parseFloat(b.marginRight) || 0, v = Math.abs(r.clientWidth - m.clientWidth - u), p = getComputedStyle(r).scrollbarGutter === "stable both-edges" ? v / 2 : v;
    p <= Ys && (a -= p);
  }
  return {
    width: a,
    height: l,
    x: c,
    y: d
  };
}
function Zs(o, e) {
  const t = ke(o, !0, e === "fixed"), s = t.top + o.clientTop, i = t.left + o.clientLeft, r = Ce(o), n = o.clientWidth * r.x, a = o.clientHeight * r.y, l = i * r.x, c = s * r.y;
  return {
    width: n,
    height: a,
    x: l,
    y: c
  };
}
function jt(o, e, t) {
  let s;
  if (e === "viewport" || e === "layoutViewport")
    s = Qs(o, t, e);
  else if (e === "document")
    s = Xs(ne(o));
  else if (Q(e))
    s = Zs(e, t);
  else {
    const i = _o(o);
    s = {
      x: e.x - i.x,
      y: e.y - i.y,
      width: e.width,
      height: e.height
    };
  }
  return ot(s);
}
function ei(o, e) {
  const t = e.get(o);
  if (t)
    return t;
  let s = Ke(o, [], !1).filter((a) => Q(a) && Ve(a) !== "body"), i = null;
  const r = Z(o).position === "fixed";
  let n = r ? _e(o) : o;
  for (; Q(n) && !Be(n); ) {
    const a = Z(n), l = Mt(n), c = i ? i.position : r ? "fixed" : "";
    !l && (c === "fixed" || c === "absolute" && a.position === "static") ? s = s.filter((h) => h !== n) : i = a, n = _e(n);
  }
  return e.set(o, s), s;
}
function ti(o) {
  let {
    element: e,
    boundary: t,
    rootBoundary: s,
    strategy: i
  } = o;
  const n = [...t === "clippingAncestors" ? at(e) ? [] : ei(e, this._c) : [].concat(t), s], a = jt(e, n[0], i);
  let l = a.top, c = a.right, d = a.bottom, h = a.left;
  for (let g = 1; g < n.length; g++) {
    const m = jt(e, n[g], i);
    l = ie(m.top, l), c = me(m.right, c), d = me(m.bottom, d), h = ie(m.left, h);
  }
  return {
    width: c - h,
    height: d - l,
    x: h,
    y: l
  };
}
function oi(o) {
  const {
    width: e,
    height: t
  } = xo(o);
  return {
    width: e,
    height: t
  };
}
function si(o, e, t) {
  const s = ue(e), i = ne(e), r = t === "fixed", n = ke(o, !0, r, e);
  let a = {
    scrollLeft: 0,
    scrollTop: 0
  };
  const l = re(0);
  if ((s || !r) && ((Ve(e) !== "body" || nt(i)) && (a = lt(e)), s)) {
    const g = ke(e, !0, r, e);
    l.x = g.x + e.clientLeft, l.y = g.y + e.clientTop;
  }
  !s && i && (l.x = ct(i));
  const c = i && !s && !r ? ko(i, a) : re(0), d = n.left + a.scrollLeft - l.x - c.x, h = n.top + a.scrollTop - l.y - c.y;
  return {
    x: d,
    y: h,
    width: n.width,
    height: n.height
  };
}
function pt(o) {
  return Z(o).position === "static";
}
function Ut(o, e) {
  if (!ue(o) || Z(o).position === "fixed")
    return null;
  if (e)
    return e(o);
  let t = o.offsetParent;
  return ne(o) === t && (t = t.ownerDocument.body), t;
}
function Co(o, e) {
  const t = U(o);
  if (at(o))
    return t;
  if (!ue(o)) {
    let i = _e(o);
    for (; i && !Be(i); ) {
      if (Q(i) && !pt(i))
        return i;
      i = _e(i);
    }
    return t;
  }
  let s = Ut(o, e);
  for (; s && Hs(s) && pt(s); )
    s = Ut(s, e);
  return s && Be(s) && pt(s) && !Mt(s) ? t : s || js(o) || t;
}
const ii = async function(o) {
  const e = this.getOffsetParent || Co, t = this.getDimensions, s = await t(o.floating);
  return {
    reference: si(o.reference, await e(o.floating), o.strategy),
    floating: {
      x: 0,
      y: 0,
      width: s.width,
      height: s.height
    }
  };
};
function ri(o) {
  return Z(o).direction === "rtl";
}
const So = {
  convertOffsetParentRelativeRectToViewportRelativeRect: qs,
  getDocumentElement: ne,
  getClippingRect: ti,
  getOffsetParent: Co,
  getElementRects: ii,
  getClientRects: Js,
  getDimensions: oi,
  getScale: Ce,
  isElement: Q,
  isRTL: ri
};
function To(o, e) {
  return o.x === e.x && o.y === e.y && o.width === e.width && o.height === e.height;
}
function ni(o, e, t) {
  let s = null, i;
  const r = ne(o);
  function n() {
    var d;
    clearTimeout(i), (d = s) == null || d.disconnect(), s = null;
  }
  function a(d, h) {
    d === void 0 && (d = !1), h === void 0 && (h = 1), n();
    const g = o.getBoundingClientRect(), {
      left: m,
      top: b,
      width: u,
      height: v
    } = g;
    if (d || e(), !u || !v)
      return;
    const p = Je(b), x = Je(r.clientWidth - (m + u)), S = Je(r.clientHeight - (b + v)), k = Je(m), L = {
      rootMargin: -p + "px " + -x + "px " + -S + "px " + -k + "px",
      threshold: ie(0, me(1, h)) || 1
    };
    let B = !0;
    function F(M) {
      const T = M[0].intersectionRatio;
      if (!To(g, o.getBoundingClientRect()))
        return a();
      if (T !== h) {
        if (!B)
          return a();
        T ? a(!1, T) : i = setTimeout(() => {
          a(!1, 1e-7);
        }, 1e3);
      }
      B = !1;
    }
    try {
      s = new IntersectionObserver(F, {
        ...L,
        // Handle <iframe>s
        root: r.ownerDocument
      });
    } catch {
      s = new IntersectionObserver(F, L);
    }
    s.observe(o);
  }
  const l = U(o), c = () => a(t);
  return l.addEventListener("resize", c), a(!0), () => {
    l.removeEventListener("resize", c), n();
  };
}
function ai(o, e, t, s) {
  s === void 0 && (s = {});
  const {
    ancestorScroll: i = !0,
    ancestorResize: r = !0,
    elementResize: n = typeof ResizeObserver == "function",
    layoutShift: a = typeof IntersectionObserver == "function",
    animationFrame: l = !1
  } = s, c = Lt(o), d = i || r ? [...c ? Ke(c) : [], ...e ? Ke(e) : []] : [];
  d.forEach((p) => {
    i && p.addEventListener("scroll", t), r && p.addEventListener("resize", t);
  });
  const h = c && a ? ni(c, t, r) : null;
  let g = -1, m = null;
  n && (m = new ResizeObserver((p) => {
    let [x] = p;
    x && x.target === c && m && e && (m.unobserve(e), cancelAnimationFrame(g), g = requestAnimationFrame(() => {
      var S;
      (S = m) == null || S.observe(e);
    })), t();
  }), c && !l && m.observe(c), e && m.observe(e));
  let b, u = l ? ke(o) : null;
  l && v();
  function v() {
    const p = ke(o);
    u && !To(u, p) && t(), u = p, b = requestAnimationFrame(v);
  }
  return t(), () => {
    var p;
    d.forEach((x) => {
      i && x.removeEventListener("scroll", t), r && x.removeEventListener("resize", t);
    }), h == null || h(), (p = m) == null || p.disconnect(), m = null, l && cancelAnimationFrame(b);
  };
}
const li = Rs, ci = Bs, di = Ds, Gt = Ks, hi = Vs, pi = (o, e, t) => {
  const s = /* @__PURE__ */ new Map(), i = t ?? {}, r = {
    ...So,
    ...i.platform,
    _c: s
  };
  return $s(o, e, {
    ...i,
    platform: r
  });
};
function wt(o) {
  const e = o.parentNode ?? null;
  return e instanceof ShadowRoot ? e.host : e;
}
function mi(o) {
  if (o.transform !== "none" || o.perspective !== "none" || o.filter !== "none")
    return !0;
  const e = o.backdropFilter;
  return !!(e && e !== "none" || o.willChange && /\b(transform|filter|perspective)\b/.test(o.willChange));
}
function qt(o) {
  let e = wt(o);
  for (; e && !(e === document.body || e === document.documentElement); ) {
    if (e instanceof Element && mi(getComputedStyle(e)))
      return e;
    e = wt(e);
  }
  return window;
}
function ui(o, e, t) {
  let s = o;
  for (; s && !(s === document.body || s === document.documentElement); ) {
    if (s instanceof Element) {
      const i = s.getBoundingClientRect();
      if (Math.abs(i.x - e) < 2 && Math.abs(i.y - t) < 2)
        return s;
    }
    s = wt(s);
  }
  return null;
}
function fi(o) {
  const e = getComputedStyle(o), t = [];
  e.transform !== "none" && t.push(`transform: ${e.transform}`), e.perspective !== "none" && t.push(`perspective: ${e.perspective}`), e.filter !== "none" && t.push(`filter: ${e.filter}`);
  const s = e.backdropFilter;
  s && s !== "none" && t.push(`backdrop-filter: ${s}`), e.willChange && /\b(transform|filter|perspective)\b/.test(e.willChange) && t.push(`will-change: ${e.willChange}`), e.contain && /\b(paint|layout|strict|content)\b/.test(e.contain) && t.push(`contain: ${e.contain}`);
  const i = e.containerType;
  return i && i !== "normal" && t.push(`container-type: ${i}`), t.join("; ");
}
function gi(o) {
  const e = o.id ? `#${o.id}` : "", t = typeof o.className == "string" && o.className ? "." + o.className.split(/\s+/).filter(Boolean).slice(0, 2).join(".") : "";
  return `<${o.tagName.toLowerCase()}${e}${t}>`;
}
function bi(o) {
  const e = o.tolerance ?? 1.5;
  let t = 0, s = 0;
  if (o.offsetParent instanceof Element) {
    const l = o.offsetParent.getBoundingClientRect(), c = getComputedStyle(o.offsetParent);
    t = l.x + (parseFloat(c.borderLeftWidth) || 0), s = l.y + (parseFloat(c.borderTopWidth) || 0);
  }
  const i = o.panel.getBoundingClientRect(), r = i.x - (t + o.expectedX), n = i.y - (s + o.expectedY);
  if (Math.abs(r) < e && Math.abs(n) < e)
    return null;
  const a = ui(o.reference, r, n);
  return {
    driftX: r,
    driftY: n,
    culprit: a,
    culpritDescription: a ? gi(a) : "an ancestor element (could not auto-identify)",
    culpritCss: a ? fi(a) : ""
  };
}
function vi(o, e) {
  var i;
  const t = (i = o.closest) == null ? void 0 : i.call(o, "[data-theme]"), s = t == null ? void 0 : t.getAttribute("data-theme");
  s != null && e.setAttribute("data-theme", s);
}
const yi = { top: "bottom", right: "left", bottom: "top", left: "right" };
function wi(o, e, t) {
  if (!t)
    return;
  const s = e.split("-")[0], i = yi[s];
  o.style.left = t.x != null ? `${t.x}px` : "", o.style.top = t.y != null ? `${t.y}px` : "", o.style.right = "", o.style.bottom = "", o.style[i] = `-${o.offsetWidth / 2}px`;
}
function Jt(o, e) {
  const t = [li(o.offset ?? 4)];
  if (o.matchWidth) {
    const i = o.matchWidth;
    t.push(Gt({
      apply({ rects: r, elements: n }) {
        const a = `${r.reference.width}px`;
        i === "exact" ? n.floating.style.width = a : n.floating.style.minWidth = a;
      }
    }));
  }
  e && t.push(di({
    ...o.lockPlacement === !0 ? { fallbackStrategy: "initialPlacement" } : {},
    ...o.flipPadding != null ? { padding: o.flipPadding } : {}
  }));
  const s = o.shift ?? 8;
  if (s !== !1 && t.push(ci({ padding: s })), o.maxHeight) {
    const i = typeof o.maxHeight == "object" ? o.maxHeight.padding : void 0;
    t.push(Gt({
      padding: i,
      apply({ availableHeight: r, elements: n }) {
        n.floating.style.maxHeight = `${Math.max(0, r)}px`;
      }
    }));
  }
  return o.arrow && t.push(hi({ element: o.arrow.element, padding: o.arrow.padding })), t;
}
function xt(o, e, t = {}) {
  const s = t.strategy ?? "fixed";
  t.inheritThemeFrom && vi(t.inheritThemeFrom, o), o.style.position = s, o.style.left = "0", o.style.top = "0";
  let i = t.placement ?? "bottom-start", r = t.flip ?? !0, n = Jt(t, r);
  const a = t.lockPlacement === "freeze";
  let l = !1;
  const c = !!t.fixedContainingBlock && !t.platform, d = t.platform ?? (c ? { ...So, getOffsetParent: () => qt(o) } : void 0), h = () => {
    var m;
    (m = t.beforeCompute) == null || m.call(t), pi(e, o, {
      placement: i,
      strategy: s,
      middleware: n,
      ...d ? { platform: d } : {}
    }).then(({ x: b, y: u, placement: v, middlewareData: p }) => {
      var x, S;
      if (o.style.left = `${b}px`, o.style.top = `${u}px`, t.arrow && wi(t.arrow.element, v, p.arrow), a && !l && (l = !0, i = v, r = !1, n = Jt(t, !1)), (x = t.onPlaced) == null || x.call(t, v), (S = t.onComputed) == null || S.call(t, { x: b, y: u, placement: v }), t.onDrift && e instanceof Element) {
        const k = c ? qt(o) : window, A = bi({ panel: o, reference: e, expectedX: b, expectedY: u, offsetParent: k });
        A && t.onDrift(A);
      }
    });
  };
  let g;
  return t.autoUpdate ?? !0 ? g = ai(e, o, h, t.autoUpdateOptions) : h(), {
    update: h,
    destroy() {
      g == null || g(), g = void 0;
    }
  };
}
function xi(o) {
  return typeof o == "number" ? { show: o, hide: o } : { show: (o == null ? void 0 : o.show) ?? 0, hide: (o == null ? void 0 : o.hide) ?? 0 };
}
function _i(o) {
  const e = o.container ?? document.body, t = o.placement ?? "top", s = o.visibleClass ?? "is-visible", i = xi(o.delay), r = document.createElement("div");
  r.setAttribute("role", "tooltip"), o.cssClass && (r.className = o.cssClass), typeof o.content == "string" ? r.textContent = o.content : r.append(o.content);
  let n, a = !1, l, c, d;
  const h = {
    getBoundingClientRect: () => d ?? o.trigger.getBoundingClientRect(),
    contextElement: o.trigger
  }, g = (x) => {
    d = new DOMRect(x.clientX, x.clientY, 0, 0), n == null || n.update();
  }, m = () => {
    l && clearTimeout(l), c && clearTimeout(c), l = c = void 0;
  }, b = () => {
    var S;
    if (m(), a)
      return;
    (S = o.onBeforeShow) == null || S.call(o), a = !0, e.append(r);
    const x = o.followCursor ? h : o.trigger;
    n = xt(r, x, {
      placement: t,
      strategy: o.strategy,
      offset: o.offset ?? 8,
      inheritThemeFrom: o.inheritThemeFrom ?? o.trigger
    }), o.followCursor && o.trigger.addEventListener("mousemove", g), r.classList.add(s);
  }, u = () => {
    m(), a && (a = !1, r.classList.remove(s), o.followCursor && o.trigger.removeEventListener("mousemove", g), n == null || n.destroy(), n = void 0, r.remove());
  }, v = () => {
    m(), i.show > 0 ? l = setTimeout(b, i.show) : b();
  }, p = () => {
    m(), i.hide > 0 ? c = setTimeout(u, i.hide) : u();
  };
  return o.trigger.addEventListener("mouseenter", v), o.trigger.addEventListener("mouseleave", p), o.trigger.addEventListener("focusin", v), o.trigger.addEventListener("focusout", p), {
    element: r,
    get isVisible() {
      return a;
    },
    show: b,
    hide: u,
    destroy() {
      o.trigger.removeEventListener("mouseenter", v), o.trigger.removeEventListener("mouseleave", p), o.trigger.removeEventListener("focusin", v), o.trigger.removeEventListener("focusout", p), u();
    }
  };
}
const Io = ["INIT", "DATA", "UI", "INTERACTION"], ae = ks("MULTISELECT", Io), Xe = ae.loggers.INIT, H = ae.loggers.DATA, Y = ae.loggers.UI, j = ae.loggers.INTERACTION, Ki = Io.map((o) => `MULTISELECT:${o}`);
function Hi() {
  ae.enableLogging();
}
function Fi() {
  ae.disableLogging();
}
function Wi(o) {
  ae.setLogLevel(o);
}
function ji(o, e) {
  const t = o.includes(":") ? o.split(":").pop() : o;
  ae.setCategoryLevel(t, e);
}
class Xt {
  constructor(e) {
    y(this, "container");
    y(this, "wrapper");
    y(this, "viewport");
    y(this, "itemHeight");
    y(this, "items");
    y(this, "renderItem");
    y(this, "bufferSize");
    y(this, "onVisibleRangeChange");
    y(this, "onScroll");
    y(this, "scrollTop", 0);
    y(this, "viewportHeight", 0);
    y(this, "visibleStart", 0);
    y(this, "visibleEnd", 0);
    y(this, "scrollHandler");
    y(this, "resizeObserver");
    this.container = e.container, this.itemHeight = e.itemHeight, this.items = e.items, this.renderItem = e.renderItem, this.bufferSize = e.bufferSize ?? 10, this.onVisibleRangeChange = e.onVisibleRangeChange, this.onScroll = e.onScroll, this.scrollHandler = this.handleScroll.bind(this), this.init();
  }
  /**
   * Initialize virtual scroll DOM structure
   *
   * Structure:
   * container (overflow-y: auto)
   *   └─ wrapper (height: totalItems * itemHeight)
   *      └─ viewport (position: absolute, top: 0)
   *         └─ items (position: absolute, top: index * itemHeight)
   */
  init() {
    this.container.innerHTML = "", this.wrapper = document.createElement("div"), this.wrapper.style.position = "relative", this.wrapper.style.width = "100%", this.wrapper.style.height = `${this.items.length * this.itemHeight}px`, this.wrapper.className = "ms__virtual-scroll-wrapper", this.viewport = document.createElement("div"), this.viewport.style.position = "absolute", this.viewport.style.top = "0", this.viewport.style.left = "0", this.viewport.style.right = "0", this.viewport.style.width = "100%", this.viewport.className = "ms__virtual-scroll-viewport", this.wrapper.appendChild(this.viewport), this.container.appendChild(this.wrapper), this.container.addEventListener("scroll", this.scrollHandler), typeof ResizeObserver < "u" && (this.resizeObserver = new ResizeObserver(() => {
      this.updateViewportHeight(), this.render();
    }), this.resizeObserver.observe(this.container)), this.updateViewportHeight(), this.render();
  }
  /**
   * Update viewport height (visible area)
   */
  updateViewportHeight() {
    const e = this.container.clientHeight;
    e > 0 && (this.viewportHeight = e);
  }
  /**
   * Handle scroll event
   */
  handleScroll() {
    this.scrollTop = this.container.scrollTop, this.onScroll && this.onScroll(this.scrollTop), this.render();
  }
  /**
   * Calculate visible range based on scroll position
   */
  calculateVisibleRange() {
    const e = Math.floor(this.scrollTop / this.itemHeight), t = Math.ceil((this.scrollTop + this.viewportHeight) / this.itemHeight), s = Math.max(0, e - this.bufferSize), i = Math.min(this.items.length, t + this.bufferSize);
    return { start: s, end: i };
  }
  /**
   * Render visible items
   */
  render() {
    const { start: e, end: t } = this.calculateVisibleRange();
    if (e === this.visibleStart && t === this.visibleEnd)
      return;
    this.visibleStart = e, this.visibleEnd = t, this.onVisibleRangeChange && this.onVisibleRangeChange(e, t);
    let s = "";
    for (let i = e; i < t; i++) {
      const r = this.items[i], n = this.renderItem(r, i), a = i * this.itemHeight;
      s += `<div class="ms__virtual-item" style="position: absolute; top: ${a}px; left: 0; right: 0; height: ${this.itemHeight}px;" data-index="${i}">`, s += n, s += "</div>";
    }
    this.viewport.innerHTML = s;
  }
  /**
   * Update items and re-render
   */
  setItems(e) {
    const t = e !== this.items || e.length !== this.items.length;
    this.items = e, this.wrapper.style.height = `${e.length * this.itemHeight}px`, this.updateViewportHeight(), t && (this.scrollTop = 0, this.container.scrollTop = 0), this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Scroll to make item at index visible (like scrollIntoView with block: 'nearest')
   * Only scrolls if item is outside visible area, and scrolls minimally
   */
  scrollToIndex(e) {
    if (e < 0 || e >= this.items.length)
      return;
    const t = e * this.itemHeight, s = t + this.itemHeight, i = this.container.scrollTop, r = i + this.viewportHeight;
    t < i ? this.container.scrollTop = t : s > r && (this.container.scrollTop = s - this.viewportHeight);
  }
  /**
   * Get currently visible range
   */
  getVisibleRange() {
    return { start: this.visibleStart, end: this.visibleEnd };
  }
  /**
   * Get total number of items
   */
  getItemCount() {
    return this.items.length;
  }
  /**
   * Update item height and re-render
   */
  setItemHeight(e) {
    this.itemHeight = e, this.wrapper.style.height = `${this.items.length * e}px`, this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Update buffer size
   */
  setBufferSize(e) {
    this.bufferSize = e, this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Refresh/force re-render
   */
  refresh() {
    this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Cleanup and remove event listeners
   */
  destroy() {
    this.container.removeEventListener("scroll", this.scrollHandler), this.resizeObserver && this.resizeObserver.disconnect(), this.container.innerHTML = "";
  }
}
function Yt(o) {
  return {
    treeId: "",
    id: -1,
    path: "",
    pathSegment: "",
    parentPath: void 0,
    level: void 0,
    children: {},
    hasChildren: !1,
    isSelectable: !0,
    data: void 0,
    ...o
  };
}
const Ne = (o) => !o || typeof o == "string" && o.trim() === "";
function ki(o, e = ".") {
  if (!o || typeof o != "string") return null;
  const t = o.lastIndexOf(e);
  return t === -1 ? "" : o.substring(0, t);
}
function Qt(o, e, t = ".") {
  return Ne(e) ? o : o.startsWith(e + t) ? o.substring(e.length + t.length) : o;
}
function Zt(o, e = 0, t = 1, s = ".") {
  return o.split(s).slice(e, e + t).join(s);
}
function Ci(o, e) {
  return o.split(e).length;
}
function ce(o, e) {
  return o[e];
}
function Si(o = {}) {
  const e = o.idMember, t = o.pathMember, s = o.getPathCallback, i = o.parentPathMember, r = o.levelMember, n = o.hasChildrenMember, a = o.isSelectableMember, l = o.getIsSelectableCallback, c = o.treeId || "multiselect-tree", d = o.orderMember, h = o.getDisplayValueCallback, g = Ne(i), m = Ne(r), b = Ne(n), u = Ne(a), v = "x", p = o.treePathSeparator || ".", x = Yt();
  let S = 0, k = null;
  const A = (M) => s ? s(M) : t ? ce(M, t) : void 0, L = {
    treePathSeparator: p,
    root: x,
    get tree() {
      return Object.values(x.children);
    },
    /**
     * Every node in depth-first render order (a parent immediately precedes
     * its subtree). Computed once per `insertArray` and cached.
     */
    get flatNodes() {
      if (k) return k;
      const M = [], T = o.isSorted ?? !1, w = o.sortCallback;
      function _($) {
        let I = Object.values($.children);
        T && w && I.length > 0 && (I = w(I));
        for (const R of I)
          M.push(R), R.hasChildren && _(R);
      }
      return _(x), k = M, M;
    },
    insertArray(M) {
      M = M || [], x.children = {}, S = 0, k = null;
      const T = [];
      let w = M.map((_, $) => {
        const I = Yt();
        I.treeId = c, I.id = e ? ce(_, e) : void 0;
        const R = A(_);
        return R == null || R === "" || typeof R != "string" ? (T.push(`index ${$}`), null) : (I.path = R, (I.id === void 0 || I.id === -1) && (I.id = R), g ? I.parentPath = ki(I.path, p) : I.parentPath = ce(_, i), I.pathSegment = Zt(
          Qt(I.path, I.parentPath ?? "", p),
          0,
          1,
          p
        ), m ? I.level = Ci(I.path, p) : I.level = ce(_, r), b || (I.hasChildren = ce(_, n)), I.data = _, I);
      }).filter((_) => _ !== null);
      o.isSorted || (o.sortCallback ? w = o.sortCallback(w) : w = F(w));
      for (const _ of w)
        B(_.parentPath ?? "", _);
      if (l || !u)
        for (const _ of w)
          if (l)
            _.isSelectable = l(_) !== !1;
          else {
            const $ = ce(_.data, a);
            _.isSelectable = $ == null ? !0 : !!$;
          }
      T.length > 0 && console.warn(
        `[ltree ${c}] ${T.length} option(s) had an invalid path and were skipped (pathMember="${t}"). Offending: ${T.slice(0, 5).join(", ")}` + (T.length > 5 ? ", …" : "")
      );
    },
    getNodeByPath(M, T) {
      let w = T || x;
      if (M) {
        const _ = M.split(p);
        for (let $ = 0; $ < _.length; $++) {
          const I = v + _[$];
          if (!w.children.hasOwnProperty(I))
            return null;
          w = w.children[I];
        }
      }
      return w;
    }
  };
  function B(M, T) {
    const w = L.getNodeByPath(M);
    if (!w)
      return `Node: ${T.path} - Could not find parent node: ${M}`;
    m && (T.level = (w.level || 0) + 1);
    const _ = v + Zt(Qt(T.path, M, p), 0, 1, p);
    return w.children.hasOwnProperty(_) || (w.children[_] = T, b && !w.hasChildren && (w.hasChildren = !0), S = Math.max(S, T.level || 0)), null;
  }
  function F(M) {
    return M.sort((T, w) => {
      const _ = T.level || 0, $ = w.level || 0;
      if (_ !== $) return _ - $;
      if (T.parentPath !== w.parentPath)
        return T.parentPath ? w.parentPath ? T.parentPath.localeCompare(w.parentPath) : 1 : -1;
      if (d && T.data && w.data) {
        const I = ce(T.data, d) ?? 0, R = ce(w.data, d) ?? 0;
        if (I !== R) return I - R;
      }
      return h ? h(T).localeCompare(h(w)) : T.path.localeCompare(w.path);
    });
  }
  return L;
}
function eo(o, e) {
  const t = /* @__PURE__ */ new Map(), s = /* @__PURE__ */ new Map(), i = /* @__PURE__ */ new Set(), r = (l) => String(e(l.data)), n = (l) => {
    t.set(r(l), l);
    const c = [];
    for (const h of Object.values(l.children))
      c.push(...n(h));
    let d;
    return c.length > 0 ? d = c : l.isSelectable !== !1 ? (d = [r(l)], i.add(l.path)) : d = [], s.set(l.path, d), d;
  }, a = o.tree;
  for (const l of a) n(l);
  return { nodeByValue: t, atomsUnder: s, atomPaths: i, roots: a };
}
function Et(o, e, t) {
  const s = o.atomsUnder.get(e.path);
  if (!s || s.length === 0) return "unchecked";
  let i = 0;
  for (const r of s) t.has(r) && i++;
  return i === 0 ? "unchecked" : i === s.length ? "checked" : "indeterminate";
}
function De(o, e) {
  const t = /* @__PURE__ */ new Set();
  for (const s of e) {
    const i = o.nodeByValue.get(String(s));
    if (i)
      for (const r of o.atomsUnder.get(i.path) ?? []) t.add(r);
  }
  return t;
}
function Ti(o, e, t) {
  const s = o.atomsUnder.get(e.path) ?? [], i = new Set(t), r = Et(o, e, t), n = [], a = [];
  if (r === "checked")
    for (const l of s) i.delete(l) && a.push(l);
  else
    for (const l of s) i.has(l) || (i.add(l), n.push(l));
  return { checkedAtoms: i, addedAtoms: n, removedAtoms: a };
}
function mt(o, e, t, s) {
  const i = (a) => String(s(a.data)), r = [], n = (a) => {
    const l = Et(o, a, e);
    if (l === "unchecked") return;
    const c = a.isSelectable !== !1, d = Object.values(a.children);
    if (t === "leaves") {
      o.atomPaths.has(a.path) && l === "checked" && r.push(i(a));
      for (const h of d) n(h);
      return;
    }
    if (t === "all") {
      l === "checked" && c && r.push(i(a));
      for (const h of d) n(h);
      return;
    }
    if (l === "checked" && c) {
      r.push(i(a));
      return;
    }
    for (const h of d) n(h);
  };
  for (const a of o.roots) n(a);
  return r;
}
class Ii {
  constructor(e, t = {}) {
    y(this, "element");
    y(this, "instanceId");
    y(this, "options");
    y(this, "isOpen", !1);
    y(this, "selectedValues", /* @__PURE__ */ new Set());
    y(this, "selectedOptions", /* @__PURE__ */ new Map());
    y(this, "allOptions", []);
    y(this, "filteredOptions", []);
    // Tree mode: the hierarchy built from option paths, and the flat list of
    // nodes currently shown. `treeNodes` stays index-aligned with
    // `filteredOptions` so focus/keyboard/virtual-scroll keep working unchanged.
    y(this, "tree", null);
    y(this, "treeNodes", []);
    // Cascade checkbox mode (tree + multiple + checkbox-mode="cascade"): the index
    // is rebuilt with the tree; `cascadeCheckedAtoms` is the derived set of checked
    // leaf-level atoms, refreshed from `selectedValues` before each render.
    y(this, "cascadeIndex", null);
    y(this, "cascadeCheckedAtoms", /* @__PURE__ */ new Set());
    y(this, "hiddenInputs", []);
    y(this, "focusedIndex", -1);
    y(this, "matchingIndices", /* @__PURE__ */ new Set());
    y(this, "searchTerm", "");
    y(this, "isLoading", !1);
    y(this, "searchDebounceTimer");
    y(this, "searchAbortController");
    y(this, "showSelectedPopover", !1);
    y(this, "selectedPopoverPlacement", null);
    y(this, "dropdownPlacement", null);
    y(this, "isRTL", !1);
    y(this, "effectiveBadgesPosition", "bottom");
    y(this, "justClosedViaClick", !1);
    y(this, "positioningDriftWarned", !1);
    // Floating UI cleanup functions
    y(this, "dropdownCleanup", null);
    y(this, "hintCleanup", null);
    y(this, "selectedPopoverCleanup", null);
    // All hover tooltips (badge text, badge-remove buttons, action buttons), keyed by id.
    y(this, "tooltips", /* @__PURE__ */ new Map());
    // Dismiss option tooltips the instant the list scrolls. Without this, a shown
    // tooltip's floating-ui autoUpdate keeps chasing its anchor row as it scrolls
    // (most visible under virtual scroll, where the row also recycles), so the
    // tooltip visibly slides to the viewport edge before the next render clears it.
    // Capturing so it catches scroll from the inner options container (scroll
    // doesn't bubble). Same function ref → addEventListener dedupes across opens.
    y(this, "onDropdownScroll", () => this.hideOptionTooltips());
    // Virtual scroll instance
    y(this, "virtualScroll", null);
    y(this, "optionsContainer", null);
    y(this, "selectedPopoverVirtualScroll", null);
    y(this, "selectedPopoverContainer", null);
    // DOM elements
    y(this, "input");
    y(this, "dropdown");
    y(this, "dropdownInner");
    y(this, "badgesContainer");
    y(this, "counter");
    y(this, "hint");
    y(this, "selectedPopover");
    // Document-level event handlers (stored for cleanup)
    y(this, "documentKeydownHandler", null);
    y(this, "documentClickHandler", null);
    this.element = e, this.instanceId = `MS-${Math.random().toString(36).slice(2, 11)}`, this.options = {
      // String options
      searchHint: e.dataset.searchHint || "",
      searchPlaceholder: e.dataset.searchPlaceholder || "Search...",
      selectPlaceholder: e.dataset.selectPlaceholder || "Pick an option...",
      noDataPlaceholder: e.dataset.noDataPlaceholder || void 0,
      dropdownMinWidth: e.dataset.dropdownMinWidth || void 0,
      dropdownMaxWidth: e.dataset.dropdownMaxWidth || void 0,
      badgesDisplayMode: e.dataset.badgesDisplayMode || "badges",
      badgesPosition: e.dataset.badgesPosition || "bottom",
      badgesThresholdMode: e.dataset.badgesThresholdMode || "count",
      maxHeight: e.dataset.maxHeight || "20rem",
      emptyMessage: e.dataset.emptyMessage || "No results found",
      loadingMessage: e.dataset.loadingMessage || "Loading...",
      searchInputMode: e.dataset.searchInputMode || "normal",
      searchMode: e.dataset.searchMode || "filter",
      // Number options
      badgesThreshold: e.dataset.badgesThreshold ? parseInt(e.dataset.badgesThreshold) : void 0,
      minSearchLength: parseInt(e.dataset.minSearchLength || "0") || 0,
      searchDebounce: parseInt(e.dataset.searchDebounce || "0") || 0,
      // Boolean options (internal names with 'is' prefix)
      isMultipleEnabled: e.dataset.multiple !== "false",
      isGroupsAllowed: e.dataset.allowGroups !== "false",
      isCheckboxesShown: e.dataset.showCheckboxes !== "false",
      isActionsSticky: e.dataset.stickyActions !== "false",
      isCloseOnSelect: e.dataset.closeOnSelect === "true",
      isPlacementLocked: e.dataset.lockPlacement !== "false",
      isSearchEnabled: e.dataset.enableSearch !== "false",
      isAddNewAllowed: e.dataset.allowAddNew === "true",
      isCounterShown: e.dataset.showCounter === "true",
      isKeepOptionsOnSearch: e.dataset.keepOptionsOnSearch !== "false",
      shouldKeepSearchOnClose: e.dataset.keepSearchOnClose !== "false",
      // Data and callbacks
      options: [],
      container: void 0,
      // Override with provided options
      ...t
    }, this.init();
  }
  // ========================================================================
  // DATA EXTRACTION METHODS (following svelte-treeview pattern)
  // ========================================================================
  /**
   * Generic field extractor with the precedence:
   *   tuple short-circuit -> member property -> callback -> fallback
   *
   * Tuple handling:
   *   - `tupleIndex` (0 | 1): for `[key, value]` items, return that slot.
   *   - `tupleSkip: true`: for any tuple, skip directly to fallback (used for icon/subtitle/group/disabled —
   *     fields that don't make sense on a 2-element array).
   *   - neither: tuples flow through the member/callback/fallback chain as if they were objects.
   *
   * `transform` is applied to tuple-slot and member-property reads (not to callback returns or the fallback),
   * so e.g. you can pass `String` to coerce numeric members to strings while letting a typed callback return its
   * own type unchanged.
   */
  extractField(e, t) {
    if (Array.isArray(e) && e.length === 2) {
      if (t.tupleSkip)
        return typeof t.fallback == "function" ? t.fallback() : t.fallback;
      if (t.tupleIndex !== void 0) {
        const i = e[t.tupleIndex];
        return t.transform ? t.transform(i) : i;
      }
    }
    if (t.member && e[t.member] !== void 0) {
      const i = e[t.member];
      return t.transform ? t.transform(i) : i;
    }
    return t.callback ? t.callback(e) : typeof t.fallback == "function" ? t.fallback() : t.fallback;
  }
  getItemValue(e) {
    return this.extractField(e, {
      tupleIndex: 0,
      member: this.options.valueMember,
      callback: this.options.getValueCallback,
      fallback: "[N/A]"
    });
  }
  getItemDisplayValue(e) {
    return this.extractField(e, {
      tupleIndex: 1,
      member: this.options.displayValueMember,
      callback: this.options.getDisplayValueCallback,
      transform: String,
      fallback: "[N/A]"
    });
  }
  /**
   * Badge display falls back to the regular display value rather than '[N/A]', so consumers can override badge
   * text independently. Doesn't fit the extractField shape (no tuple/member layer of its own).
   */
  getItemBadgeDisplayValue(e) {
    if (this.options.getBadgeDisplayCallback) return this.options.getBadgeDisplayCallback(e);
    if (this.options.isBadgeFullTitleShown) {
      const t = this.getItemFullTitle(e);
      if (t) return t;
    }
    return this.getItemDisplayValue(e);
  }
  /**
   * Full title — a fully-qualified label supplied with the data (never computed here). Used by
   * badges when `isBadgeFullTitleShown` is on. Returns undefined when the option has none.
   */
  getItemFullTitle(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.fullTitleMember,
      callback: this.options.getFullTitleCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemSearchValue(e) {
    return this.extractField(e, {
      member: this.options.searchValueMember,
      callback: this.options.getSearchValueCallback,
      transform: String,
      fallback: () => this.getItemDisplayValue(e)
    });
  }
  getItemIcon(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.iconMember,
      callback: this.options.getIconCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemSubtitle(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.subtitleMember,
      callback: this.options.getSubtitleCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemGroup(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.groupMember,
      callback: this.options.getGroupCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemDisabled(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.disabledMember,
      callback: this.options.getDisabledCallback,
      transform: Boolean,
      fallback: !1
    });
  }
  /**
   * Tree mode: whether the visible node at `index` may be selected. Non-selectable
   * nodes (see `isSelectableMember`/`getIsSelectableCallback`) still render — just
   * without a checkbox — but are skipped by focus and cannot be toggled. Always
   * true outside tree mode. `treeNodes` is index-aligned with `filteredOptions`.
   */
  isIndexSelectable(e) {
    if (!this.isTreeMode()) return !0;
    const t = this.treeNodes[e];
    return t ? t.isSelectable !== !1 : !0;
  }
  /** Whether an option may be selected. Always true outside tree mode. */
  isOptionSelectable(e) {
    if (!this.isTreeMode()) return !0;
    const t = this.filteredOptions.indexOf(e);
    if (t >= 0) return this.isIndexSelectable(t);
    const s = String(this.getItemValue(e)), i = this.treeNodes.find((r) => String(this.getItemValue(r.data)) === s);
    return i ? i.isSelectable !== !1 : !0;
  }
  init() {
    this.parseOptions(), this.buildHTML(), this.attachEvents(), this.parseInitialSelection(), Xe.debug(`Initialized [${this.instanceId}] with options:`, {
      placeholder: this.options.searchPlaceholder,
      totalOptions: this.allOptions.length,
      isCloseOnSelect: this.options.isCloseOnSelect,
      dataAttribute: this.element.dataset.closeOnSelect
    });
  }
  parseOptions() {
    const e = this.element.dataset.options;
    if (e)
      try {
        this.allOptions = JSON.parse(e);
      } catch (t) {
        H.error(`[${this.instanceId}] Failed to parse data-options:`, t), this.allOptions = [];
      }
    else this.options.options && (this.allOptions = this.options.options);
    this.filteredOptions = [...this.allOptions], this.isTreeMode() && this.buildTree();
  }
  // ========================================================================
  // TREE MODE
  // ========================================================================
  /** Whether options should be rendered as an (always-expanded) tree. */
  isTreeMode() {
    return this.options.isTreeEnabled === !1 ? !1 : !!(this.options.isTreeEnabled || this.options.pathMember || this.options.getPathCallback);
  }
  /** (Re)build the ltree from `allOptions` and derive the visible flat list. */
  buildTree() {
    this.tree = Si({
      idMember: this.options.valueMember,
      pathMember: this.options.pathMember,
      getPathCallback: this.options.getPathCallback,
      parentPathMember: this.options.parentPathMember,
      levelMember: this.options.levelMember,
      hasChildrenMember: this.options.hasChildrenMember,
      isSelectableMember: this.options.isSelectableMember,
      getIsSelectableCallback: this.options.getIsSelectableCallback,
      treePathSeparator: this.options.treePathSeparator,
      treeId: this.instanceId,
      getDisplayValueCallback: (e) => this.getItemDisplayValue(e.data)
    }), this.tree.insertArray(this.allOptions), this.cascadeIndex = this.isCascadeMode() ? eo(this.tree, (e) => String(this.getItemValue(e))) : null, this.rebuildTreeVisible();
  }
  /**
   * Whether cascade checkbox mode is active: a multi-select tree with
   * `checkbox-mode="cascade"`. Checking a node then toggles its whole subtree
   * and branches show a tristate box.
   */
  isCascadeMode() {
    return this.isTreeMode() && this.options.isMultipleEnabled !== !1 && this.options.checkboxMode === "cascade";
  }
  cascadePolicy() {
    return this.options.cascadeSelectPolicy ?? "rolled-up";
  }
  /** Refresh the derived checked-atom set from the emitted `selectedValues`. */
  refreshCascadeAtoms() {
    this.isCascadeMode() && this.cascadeIndex && (this.cascadeCheckedAtoms = De(this.cascadeIndex, this.selectedValues));
  }
  /**
   * Toggle a tree node in cascade mode: flip its whole subtree, re-project the
   * checked atoms to emitted values under the active policy, and commit the diff
   * so badges / form / change events reflect the policy (rolled-up branches, etc.).
   */
  toggleTreeCascade(e) {
    const t = this.cascadeIndex, s = De(t, this.selectedValues), { checkedAtoms: i } = Ti(t, e, s);
    this.commitCascadeAtoms(i);
  }
  /**
   * Given a checked-atom set, project it to emitted values under the active
   * policy, diff it against the current selection, and commit. Shared by every
   * cascade entry point (node toggle, Select All) so they all emit the same
   * policy-projected shape (e.g. a full subtree rolls up to one value).
   */
  commitCascadeAtoms(e) {
    var l;
    const t = this.cascadeIndex, s = mt(
      t,
      e,
      this.cascadePolicy(),
      (c) => String(this.getItemValue(c))
    ), i = new Set(s), r = [], n = [];
    for (const [c, d] of this.selectedOptions)
      i.has(c) || n.push(d);
    const a = /* @__PURE__ */ new Map();
    for (const c of s) {
      const h = ((l = t.nodeByValue.get(c)) == null ? void 0 : l.data) ?? this.selectedOptions.get(c);
      h !== void 0 && (a.set(c, h), this.selectedValues.has(c) || r.push(h));
    }
    this.selectedValues = i, this.selectedOptions = a, this.cascadeCheckedAtoms = e, this.commit({ added: r, removed: n });
  }
  /**
   * The "meaningful selection" list used by the counter chip — the rolled-up
   * minimal cover, regardless of the active emit policy. In cascade mode
   * `leaves`/`all` emit many values for a single branch pick, which made the
   * counter read e.g. `[5]` for what a person experiences as two selections.
   * The counter should count the branches actually chosen, and stay stable when
   * the policy knob flips. Outside cascade this is just the selected options.
   */
  counterSelection() {
    if (this.isCascadeMode() && this.cascadeIndex) {
      const e = mt(
        this.cascadeIndex,
        this.cascadeCheckedAtoms,
        "rolled-up",
        (s) => String(this.getItemValue(s))
      ), t = [];
      for (const s of e) {
        const i = this.cascadeIndex.nodeByValue.get(s), r = (i == null ? void 0 : i.data) ?? this.selectedOptions.get(s);
        r !== void 0 && t.push(r);
      }
      return t;
    }
    return Array.from(this.selectedOptions.values());
  }
  /** Native `title` for the counter chip: the picked items, capped so it can't grow unbounded. */
  buildCounterTooltip(e) {
    const s = e.slice(0, 12).map((i) => this.getItemBadgeDisplayValue(i));
    return e.length > 12 && s.push(`…and ${e.length - 12} more`), s.join(`
`);
  }
  /**
   * Derive `treeNodes` + `filteredOptions` from the full tree, applying the
   * current search term. Matching nodes keep all their ancestors visible so
   * indentation stays coherent (the tree is always fully expanded).
   */
  rebuildTreeVisible() {
    if (!this.tree) {
      this.treeNodes = [];
      return;
    }
    const e = this.tree.flatNodes, t = this.options.isSearchEnabled ? (this.searchTerm || "").trim().toLowerCase() : "";
    let s;
    if (!t)
      s = e;
    else {
      const i = this.tree.treePathSeparator, r = /* @__PURE__ */ new Set();
      for (const n of e)
        if (this.getItemSearchValue(n.data).toLowerCase().includes(t)) {
          const l = n.path.split(i);
          for (let c = 1; c <= l.length; c++)
            r.add(l.slice(0, c).join(i));
        }
      s = e.filter((n) => r.has(n.path));
    }
    this.treeNodes = s, this.filteredOptions = s.map((i) => i.data);
  }
  /**
   * Reset the visible list to "everything". **Tree-aware**: in tree mode it
   * rebuilds `treeNodes` (kept index-aligned with `filteredOptions`) from the
   * full tree, so the two never drift. A raw `filteredOptions = [...allOptions]`
   * would leave `treeNodes` stale after clearing a search — the virtual list
   * then reserves height for every option but renders blank rows because
   * `treeNodes[index]` is undefined. Always use this to clear the visible list.
   */
  resetVisibleToAll() {
    this.isTreeMode() ? this.rebuildTreeVisible() : this.filteredOptions = [...this.allOptions];
  }
  /**
   * Tree mode: derive the visible list from an **external** set of matched
   * options — e.g. the results returned by `searchCallback` — keeping each
   * match's ancestors so indentation stays coherent. This is the async-search
   * analogue of `rebuildTreeVisible`: the matching is done by the caller (their
   * own index/engine) instead of a local substring test, but ancestor
   * preservation and `treeNodes`/`filteredOptions` index-alignment still happen
   * here. Pass all options to show the whole tree.
   */
  rebuildTreeVisibleFromMatches(e) {
    if (!this.tree) {
      this.treeNodes = [], this.filteredOptions = [];
      return;
    }
    const t = this.tree.flatNodes, s = this.tree.treePathSeparator, i = new Set((e || []).map((a) => String(this.getItemValue(a)))), r = /* @__PURE__ */ new Set();
    for (const a of t)
      if (i.has(String(this.getItemValue(a.data)))) {
        const l = a.path.split(s);
        for (let c = 1; c <= l.length; c++)
          r.add(l.slice(0, c).join(s));
      }
    const n = t.filter((a) => r.has(a.path));
    this.treeNodes = n, this.filteredOptions = n.map((a) => a.data);
  }
  buildHTML() {
    const e = this.options.container || document.body, t = this.element.getRootNode(), s = t instanceof ShadowRoot ? t.host : this.element, i = s.getAttribute("dir") === "rtl", r = s.closest('[dir="rtl"]') !== null;
    this.isRTL = i || r, Xe.debug(`[${this.instanceId}] RTL Debug:`, {
      isShadowRoot: t instanceof ShadowRoot,
      hostElement: s,
      elementDir: s.getAttribute("dir"),
      hasElementDir: i,
      hasAncestorDir: r,
      isRTL: this.isRTL
    }), this.effectiveBadgesPosition = this.options.badgesPosition || "bottom", this.isRTL && (this.effectiveBadgesPosition === "left" ? this.effectiveBadgesPosition = "right" : this.effectiveBadgesPosition === "right" && (this.effectiveBadgesPosition = "left")), this.element.classList.add("ms"), this.isRTL && (this.element.classList.add("ms--rtl"), Xe.debug(`[${this.instanceId}] Added ms--rtl class to element`)), (!this.options.isCheckboxesShown || !this.options.isMultipleEnabled) && this.element.classList.add("ms--no-checkboxes");
    const n = document.createElement("div");
    n.className = "ms__input-wrapper", this.input = document.createElement("input"), this.input.type = "text", this.input.className = "ms__input", this.input.placeholder = this.getPlaceholderText(), this.input.autocomplete = "off", this.options.searchInputMode === "readonly" ? this.input.readOnly = !0 : this.options.searchInputMode === "hidden" && (this.input.style.display = "none");
    const a = document.createElement("span");
    a.className = "ms__toggle", a.innerHTML = "▼", this.counter = document.createElement("span"), this.counter.className = "ms__counter", this.counter.style.display = "none", n.appendChild(this.input), n.appendChild(this.counter), n.appendChild(a), this.badgesContainer = document.createElement("div"), this.badgesContainer.className = "ms__badges";
    const l = document.createElement("div");
    l.className = "ms__wrapper", (this.effectiveBadgesPosition === "left" || this.effectiveBadgesPosition === "right") && l.classList.add("ms__wrapper--inline"), l.appendChild(n), l.appendChild(this.badgesContainer), this.element.appendChild(l), this.dropdown = document.createElement("div"), this.dropdown.className = "ms__dropdown", this.dropdownInner = document.createElement("div"), this.dropdownInner.className = "ms__dropdown-inner", this.dropdown.appendChild(this.dropdownInner), e.appendChild(this.dropdown), this.options.searchHint && (this.hint = document.createElement("div"), this.hint.className = "ms__hint", this.hint.textContent = this.options.searchHint, e.appendChild(this.hint)), this.selectedPopover = document.createElement("div"), this.selectedPopover.className = "ms__selected-popover", e.appendChild(this.selectedPopover), this.renderDropdown();
  }
  /**
   * Check if virtual scroll should be used
   */
  shouldUseVirtualScroll() {
    if (!this.options.isVirtualScrollEnabled || this.options.isGroupsAllowed && this.hasGroups()) return !1;
    const e = this.options.virtualScrollThreshold ?? 100;
    return this.filteredOptions.length >= e;
  }
  /**
   * Check if any options have groups
   */
  hasGroups() {
    return this.filteredOptions.some((e) => {
      const t = this.getItemGroup(e);
      return t && t.trim() !== "";
    });
  }
  renderDropdown() {
    if (this.destroyAllActionButtonTooltips(), this.refreshCascadeAtoms(), this.shouldUseVirtualScroll()) {
      this.dropdown.classList.add("ms__dropdown--virtual"), this.renderDropdownVirtual();
      return;
    }
    this.dropdown.classList.remove("ms__dropdown--virtual"), this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null, this.optionsContainer = null);
    let e = "";
    if (this.isLoading) {
      e += '<div class="ms__loader">', e += '<div class="pa-loader pa-loader--sm"></div>', e += `<div class="ms__loading-text">${this.options.loadingMessage}</div>`, e += "</div>", this.dropdownInner.innerHTML = e;
      return;
    }
    const t = this.renderActionsHTML(), s = this.options.actionsPosition === "bottom";
    if (s || (e += t), this.options.isVirtualScrollEnabled) {
      const i = this.options.optionHeight ?? 50;
      e += `<div class="ms__options ms__options--fixed-height" style="--ms-option-height: ${i}px;">`;
    } else
      e += '<div class="ms__options">';
    if (this.filteredOptions.length === 0)
      e += `<div class="ms__empty">${this.options.emptyMessage}</div>`;
    else if (this.isTreeMode())
      this.treeNodes.forEach((i, r) => {
        e += this.renderTreeNode(i, r);
      });
    else if (this.options.isGroupsAllowed) {
      const i = this.groupOptions(this.filteredOptions), r = /* @__PURE__ */ new Map();
      this.filteredOptions.forEach((n, a) => r.set(n, a)), Object.keys(i).forEach((n) => {
        if (e += '<div class="ms__group">', n !== "__ungrouped__")
          if (this.options.renderGroupLabelContentCallback) {
            const a = this.options.renderGroupLabelContentCallback(n);
            if (a instanceof HTMLElement) {
              const l = document.createElement("div");
              l.className = "ms__group-label", l.appendChild(a), e += l.outerHTML;
            } else
              e += `<div class="ms__group-label">${a}</div>`;
          } else
            e += `<div class="ms__group-label">${n}</div>`;
        i[n].forEach((a) => {
          e += this.renderOption(a, r.get(a) ?? -1);
        }), e += "</div>";
      });
    } else
      this.filteredOptions.forEach((i, r) => {
        e += this.renderOption(i, r);
      });
    e += "</div>", s && (e += t), this.dropdownInner.innerHTML = e, this.attachActionButtonTooltips(), this.attachOptionTooltips();
  }
  /**
   * Render dropdown with virtual scrolling
   */
  renderDropdownVirtual() {
    if (this.destroyAllActionButtonTooltips(), !this.virtualScroll) {
      let s = "";
      const i = this.renderActionsHTML(), r = this.options.actionsPosition === "bottom";
      r || (s += i);
      const n = this.options.maxHeight || "20rem", a = this.options.optionHeight ?? 50;
      s += `<div class="ms__options ms__options--virtual" style="height: ${n}; max-height: ${n}; overflow-y: auto; position: relative; --ms-option-height: ${a}px;"></div>`, r && (s += i), this.dropdownInner.innerHTML = s, this.optionsContainer = this.dropdownInner.querySelector(".ms__options");
    }
    if (this.filteredOptions.length === 0) {
      this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null), this.optionsContainer.innerHTML = `<div class="ms__empty">${this.options.emptyMessage}</div>`;
      return;
    }
    const e = this.options.optionHeight ?? 50, t = this.options.virtualScrollBuffer ?? 10;
    requestAnimationFrame(() => {
      this.optionsContainer && (this.virtualScroll ? this.virtualScroll.setItems(this.filteredOptions) : this.virtualScroll = new Xt({
        container: this.optionsContainer,
        itemHeight: e,
        items: this.filteredOptions,
        renderItem: (s, i) => this.isTreeMode() ? this.renderTreeNode(this.treeNodes[i], i) : this.renderOption(s, i),
        bufferSize: t,
        onVisibleRangeChange: () => {
          this.attachOptionTooltips();
        }
      }), this.attachActionButtonTooltips());
    });
  }
  /**
   * Render the Select All / Clear All / custom action buttons row.
   * Returns the empty string if multiple-select is off or no buttons are configured.
   */
  /**
   * Default enabled/disabled state for the built-in actions, applied only when the consumer hasn't
   * set an explicit `isDisabled` / `getIsDisabledCallback`:
   * - `select-all` is disabled when it would add nothing (every selectable, non-disabled filtered
   *   option is already selected — this also covers an empty list).
   * - `clear-all` is disabled when nothing is selected.
   */
  getBuiltInActionDisabled(e) {
    return e === "select-all" ? !this.filteredOptions.some((t) => !this.getItemDisabled(t) && !this.selectedValues.has(String(this.getItemValue(t)))) : e === "clear-all" ? this.selectedValues.size === 0 : !1;
  }
  renderActionsHTML() {
    const e = this.options.actionButtons;
    if (!this.options.isMultipleEnabled || !e || e.length === 0) return "";
    const t = this.options.actionsPosition === "bottom" ? "bottom" : "top", s = this.options.actionsAlign ?? "stretch", i = ` ms__actions--${t}`, r = this.options.isActionsSticky ? " ms__actions--sticky" : "", n = this.options.actionsLayout === "wrap" ? " ms__actions--wrap" : "", a = ` ms__actions--align-${s}`, l = /* @__PURE__ */ new Map();
    if (e.forEach((d, h) => {
      if (!(d.getIsVisibleCallback ? d.getIsVisibleCallback(this) : d.isVisible ?? !0)) return;
      let m;
      d.getIsDisabledCallback ? m = d.getIsDisabledCallback(this) : d.isDisabled !== void 0 ? m = d.isDisabled : m = this.getBuiltInActionDisabled(d.action);
      const b = m ? " disabled" : "", u = d.getTextCallback ? d.getTextCallback(this) : d.text;
      let v = "";
      if (d.getClassCallback) {
        const S = d.getClassCallback(this);
        v = Array.isArray(S) ? ` ${S.join(" ")}` : S ? ` ${S}` : "";
      } else d.cssClass && (v = ` ${d.cssClass}`);
      const p = Math.max(1, Math.floor(d.row ?? 1)), x = `<button type="button"${b} class="ms__action-btn${v}" data-action="${d.action}" data-button-index="${h}">${u}</button>`;
      l.has(p) || l.set(p, []), l.get(p).push(x);
    }), l.size === 0) return "";
    const c = Array.from(l.keys()).sort((d, h) => d - h).map((d) => `<div class="ms__actions-row" data-row="${d}">${l.get(d).join("")}</div>`).join("");
    return `<div class="ms__actions${i}${r}${n}${a}">${c}</div>`;
  }
  renderOption(e, t) {
    const s = this.getItemValue(e), i = this.getItemDisplayValue(e), r = this.getItemIcon(e), n = this.getItemSubtitle(e), a = this.getItemDisabled(e), l = this.selectedValues.has(String(s)), c = t === this.focusedIndex, d = this.matchingIndices.has(t), h = ["ms__option"];
    l && h.push("ms__option--selected"), c && h.push("ms__option--focused"), d && h.push("ms__option--matched"), a && h.push("ms__option--disabled");
    const g = this.options.checkboxAlign && this.options.checkboxAlign !== "center" ? ` data-checkbox-align="${this.options.checkboxAlign}"` : "";
    let m = `<div class="${h.join(" ")}" data-value="${s}" data-index="${t}"${g}>`;
    if (this.options.isCheckboxesShown && this.options.isMultipleEnabled && (m += `<input type="checkbox" class="ms__checkbox" ${l ? "checked" : ""} ${a ? "disabled" : ""}>`), m += '<div class="ms__option-content">', this.options.renderOptionContentCallback) {
      const b = {
        index: t,
        isSelected: l,
        isFocused: c,
        isMatched: d,
        isDisabled: a,
        isTreeNode: !1
      }, u = this.options.renderOptionContentCallback(e, b);
      typeof u == "string" ? m += u : m += u.outerHTML;
    } else
      r && (m += `<span class="ms__option-icon">${r}</span>`), m += '<div class="ms__option-text">', m += `<div class="ms__option-title">${this.highlightMatch(i, this.searchTerm)}</div>`, n && (m += `<div class="ms__option-subtitle">${n}</div>`), m += "</div>";
    return m += "</div>", m += "</div>", m;
  }
  /**
   * Render a single tree-mode row. Separate from `renderOption`: a tree row is
   * indented by its depth (via the `--ms-tree-depth` custom property) and
   * tagged branch/leaf, but otherwise carries the same selection/checkbox/
   * icon/subtitle content. The tree is always fully expanded, so there is no
   * chevron/toggle — every node is just a normal, selectable option.
   */
  renderTreeNode(e, t) {
    const s = e.data, i = this.getItemValue(s), r = this.getItemDisplayValue(s), n = this.getItemIcon(s), a = this.getItemSubtitle(s), l = this.getItemDisabled(s), c = this.isCascadeMode() && this.cascadeIndex, d = c ? Et(this.cascadeIndex, e, this.cascadeCheckedAtoms) : null, h = c ? d === "checked" : this.selectedValues.has(String(i)), g = d === "indeterminate", m = t === this.focusedIndex, b = e.isSelectable !== !1, u = e.level ?? 1, v = Math.max(0, u - 1), p = ["ms__option", "ms__option--tree"];
    p.push(e.hasChildren ? "ms__option--tree-branch" : "ms__option--tree-leaf"), h && p.push("ms__option--selected"), g && p.push("ms__option--indeterminate"), m && p.push("ms__option--focused"), l && p.push("ms__option--disabled"), b || p.push("ms__option--tree-unselectable");
    const x = this.options.checkboxAlign && this.options.checkboxAlign !== "center" ? ` data-checkbox-align="${this.options.checkboxAlign}"` : "", S = b ? "" : ' data-selectable="false"';
    let k = `<div class="${p.join(" ")}" data-value="${i}" data-index="${t}" data-path="${e.path}" data-level="${u}" style="--ms-tree-depth: ${v};"${x}${S}>`;
    if (this.options.isCheckboxesShown && this.options.isMultipleEnabled && b && (k += `<input type="checkbox" class="${g ? "ms__checkbox ms__checkbox--indeterminate" : "ms__checkbox"}" ${h ? "checked" : ""}${g ? ' aria-checked="mixed"' : ""} ${l ? "disabled" : ""}>`), k += '<div class="ms__option-content">', this.options.renderOptionContentCallback) {
      const A = {
        index: t,
        isSelected: h,
        isFocused: m,
        isMatched: !1,
        isDisabled: l,
        // Tree metadata — lets the callback branch on depth / branch-vs-leaf /
        // tristate without re-deriving any of it from the raw data item.
        isTreeNode: !0,
        isBranch: e.hasChildren,
        isLeaf: !e.hasChildren,
        childCount: Object.keys(e.children).length,
        level: u,
        depth: v,
        path: e.path,
        isSelectable: b,
        isIndeterminate: g
      }, L = this.options.renderOptionContentCallback(s, A);
      k += typeof L == "string" ? L : L.outerHTML;
    } else
      n && (k += `<span class="ms__option-icon">${n}</span>`), k += '<div class="ms__option-text">', k += `<div class="ms__option-title">${this.highlightMatch(r, this.searchTerm)}</div>`, a && (k += `<div class="ms__option-subtitle">${a}</div>`), k += "</div>";
    return k += "</div>", k += "</div>", k;
  }
  highlightMatch(e, t) {
    if (!t) return e;
    const s = new RegExp(`(${t.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")})`, "gi");
    return e.replace(s, "<mark>$1</mark>");
  }
  groupOptions(e) {
    const t = {};
    return e.forEach((s) => {
      const i = this.getItemGroup(s) || "__ungrouped__";
      t[i] || (t[i] = []), t[i].push(s);
    }), t;
  }
  /** Whether the input currently functions as a usable search field (drives placeholder wording). */
  get isSearchUsable() {
    return !!this.options.isSearchEnabled && this.options.searchInputMode !== "readonly" && this.options.searchInputMode !== "hidden";
  }
  /**
   * Resolve the closed-state input placeholder for the current data/search state.
   * Priority: explicit no-data placeholder (when the list is empty) → "pick" prompt when
   * search is unusable → the search placeholder.
   */
  getPlaceholderText() {
    return this.options.noDataPlaceholder && this.allOptions.length === 0 ? this.options.noDataPlaceholder : this.isSearchUsable ? this.options.searchPlaceholder : this.options.selectPlaceholder || this.options.searchPlaceholder;
  }
  renderBadges() {
    this.destroyAllBadgeTooltips();
    const e = Array.from(this.selectedOptions.values()), t = this.selectedValues.size;
    if (!this.options.isMultipleEnabled) {
      this.badgesContainer.innerHTML = "", this.counter.style.display = "none";
      let r;
      e[0] && (this.options.renderSelectedContentCallback ? r = this.options.renderSelectedContentCallback(e[0]) : r = this.getItemDisplayValue(e[0])), !this.isOpen && t > 0 && e.length > 0 ? this.input.value = r : this.isOpen || (this.input.value = "");
      return;
    }
    let s = this.options.badgesDisplayMode;
    if (this.options.badgesThreshold !== null && t > this.options.badgesThreshold && s !== "none" && (s = this.options.badgesThresholdMode || "count"), !this.isOpen)
      if (t > 0 && s === "count") {
        const r = this.options.getCounterCallback ? this.options.getCounterCallback(t) : `${t} selected`;
        this.input.placeholder = r;
      } else
        this.input.placeholder = this.getPlaceholderText();
    if (this.options.isCounterShown && t > 0) {
      const r = this.counterSelection(), n = r.length;
      this.counter.textContent = `[${n}]`, this.counter.title = this.buildCounterTooltip(r), this.counter.style.display = n > 0 ? "" : "none";
    } else
      this.counter.title = "", this.counter.style.display = "none";
    if (s === "none") {
      this.badgesContainer.innerHTML = "";
      return;
    }
    if (s === "badges")
      this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, this.badgesContainer.innerHTML = e.map((r) => this.renderBadgeHTML(r, { displayMode: "badges", isInPopover: !1 })).join("");
    else if (s === "partial") {
      this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`;
      const r = this.options.badgesMaxVisible || 3, n = e.slice(0, r), a = t - r, l = n.map((d) => this.renderBadgeHTML(d, { displayMode: "partial", isInPopover: !1 })).join("");
      let c = "";
      a > 0 && (c = `
                    <div class="ms__badge ms__badge--counter ms__badge--more" data-action="show-selected">
                        <span class="ms__badge-text">${this.options.getCounterCallback ? this.options.getCounterCallback(t, a) : `+${a} more`}</span>
                        <button type="button" class="ms__badge-remove" data-action="remove-hidden" aria-label="Remove ${a} hidden items"></button>
                    </div>
                `), this.badgesContainer.innerHTML = l + c;
    } else if (s === "compact")
      if (this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, t > 0) {
        const r = e[0], n = this.getItemBadgeDisplayValue(r), a = t - 1;
        let l = n;
        if (a > 0) {
          const c = this.options.getCounterCallback ? this.options.getCounterCallback(t, a) : `+${a} more`;
          l = `${n} (${c})`;
        }
        this.badgesContainer.innerHTML = `
                    <div class="ms__badge" data-action="show-selected">
                        <span class="ms__badge-text">${l}</span>
                        <button type="button" class="ms__badge-remove" data-action="clear-count" aria-label="Clear all selections"></button>
                    </div>
                `;
      } else
        this.badgesContainer.innerHTML = "";
    else if (this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, t > 0) {
      const r = this.options.getCounterCallback ? this.options.getCounterCallback(t) : `${t} selected`;
      this.badgesContainer.innerHTML = `
                    <div class="ms__badge ms__badge--counter" data-action="show-selected">
                        <span class="ms__badge-text">${r}</span>
                        <button type="button" class="ms__badge-remove" data-action="clear-count" aria-label="Clear all selections"></button>
                    </div>
                `;
    } else
      this.badgesContainer.innerHTML = "";
    this.attachBadgeTooltips();
  }
  attachEvents() {
    this.input.addEventListener("mousedown", (e) => {
      e.stopPropagation(), this.isOpen ? (this.justClosedViaClick = !0, this.close(), setTimeout(() => {
        this.justClosedViaClick = !1;
      }, 0)) : this.open();
    }), this.input.addEventListener("focus", () => {
      !this.isOpen && !this.justClosedViaClick && this.open();
    }), this.input.addEventListener("input", (e) => {
      const t = e.target.value;
      this.options.isSearchEnabled && !this.isOpen && this.open(), this.handleSearch(t);
    }), this.input.addEventListener("keydown", (e) => this.handleKeydown(e)), this.documentClickHandler = (e) => this.handleClickOutside(e), setTimeout(() => {
      document.addEventListener("click", this.documentClickHandler);
    }, 0), this.documentKeydownHandler = (e) => {
      e.key === "Escape" && this.showSelectedPopover && (e.preventDefault(), this.hideSelectedPopover());
    }, document.addEventListener("keydown", this.documentKeydownHandler), this.dropdown.addEventListener("click", (e) => this.handleDropdownClick(e)), this.dropdownInner.addEventListener("wheel", (e) => {
      if (this.virtualScroll)
        return;
      const t = e.currentTarget, s = t.scrollTop === 0, i = t.scrollTop + t.clientHeight >= t.scrollHeight;
      (e.deltaY < 0 && s || e.deltaY > 0 && i) && e.preventDefault(), e.stopPropagation();
    }, { passive: !1 }), this.badgesContainer.addEventListener("mousedown", (e) => {
      e.target.closest('[data-action="show-selected"]') && !this.showSelectedPopover && e.stopPropagation();
    }), this.badgesContainer.addEventListener("click", (e) => this.handleBadgeClick(e)), this.counter.addEventListener("mousedown", (e) => {
      this.showSelectedPopover || e.stopPropagation();
    }), this.counter.addEventListener("click", (e) => {
      e.stopPropagation(), this.toggleSelectedPopover();
    }), this.selectedPopover.addEventListener("click", (e) => this.handleSelectedPopoverClick(e));
  }
  async handleSearch(e) {
    if (this.searchTerm = e, !this.options.isSearchEnabled)
      return;
    let t = e;
    if (this.options.beforeSearchCallback) {
      const s = this.options.beforeSearchCallback(e);
      if (s === null) {
        H.debug(`[${this.instanceId}] beforeSearchCallback blocked search for term:`, e), this.abortInFlightSearch(), this.matchingIndices.clear(), this.isTreeMode() ? (this.searchTerm = "", this.rebuildTreeVisible()) : this.filteredOptions = [...this.allOptions], this.renderDropdown();
        return;
      }
      t = s, t !== e && H.debug(`[${this.instanceId}] beforeSearchCallback transformed: "${e}" -> "${t}"`);
    }
    if (this.options.searchCallback) {
      if (t.length < this.options.minSearchLength) {
        this.abortInFlightSearch(), this.isLoading = !1, this.options.isKeepOptionsOnSearch ? (this.isTreeMode() ? this.rebuildTreeVisibleFromMatches(this.allOptions) : this.filteredOptions = [...this.allOptions], H.debug(`[${this.instanceId}] Search term below minimum, showing ${this.allOptions.length} initial options`)) : (this.filteredOptions = [], this.isTreeMode() && (this.treeNodes = [])), this.matchingIndices.clear(), this.renderDropdown();
        return;
      }
      this.searchDebounceTimer && (clearTimeout(this.searchDebounceTimer), this.searchDebounceTimer = void 0);
      const s = this.options.searchDebounce || 0;
      s > 0 ? this.searchDebounceTimer = setTimeout(() => {
        this.searchDebounceTimer = void 0, this.searchTerm === e && this.performAsyncSearch(e, t);
      }, s) : await this.performAsyncSearch(e, t);
    } else {
      if (this.isTreeMode()) {
        this.rebuildTreeVisible(), this.matchingIndices.clear(), this.focusedIndex = this.filteredOptions.length > 0 ? 0 : -1, this.renderDropdown();
        return;
      }
      if (!t)
        this.filteredOptions = [...this.allOptions], this.matchingIndices.clear(), this.focusedIndex = this.filteredOptions.length > 0 ? 0 : -1;
      else {
        const s = this.options.searchMode || "filter", i = t.toLowerCase();
        if (s === "filter")
          this.filteredOptions = this.allOptions.filter((r) => this.getItemSearchValue(r).toLowerCase().includes(i)), this.matchingIndices.clear(), this.focusedIndex = this.filteredOptions.length > 0 ? 0 : -1, H.debug(`[${this.instanceId}] Filter mode: ${this.filteredOptions.length} matches for "${t}"`);
        else {
          this.filteredOptions = [...this.allOptions], this.matchingIndices.clear();
          let r = -1;
          this.allOptions.forEach((n, a) => {
            this.getItemSearchValue(n).toLowerCase().includes(i) && (this.matchingIndices.add(a), r === -1 && (r = a));
          }), r >= 0 ? (this.focusedIndex = r, H.debug(`[${this.instanceId}] Navigate mode: ${this.matchingIndices.size} matches, jumped to index ${r}`)) : H.debug(`[${this.instanceId}] Navigate mode: No matches found, keeping previous focus`);
        }
      }
      this.renderDropdown(), this.options.searchMode === "navigate" && this.focusedIndex >= 0 && this.scrollToFocused();
    }
  }
  /** Abort the search request currently in flight, if any. The aborted request's results
   *  are then ignored (and the consumer's `searchCallback` can short-circuit its fetch via
   *  the `AbortSignal` it was handed). */
  abortInFlightSearch() {
    this.searchAbortController && (this.searchAbortController.abort(), this.searchAbortController = void 0);
  }
  /**
   * Invoke the async `searchCallback` and apply its results. Split out of `handleSearch`
   * so it can be called immediately or after the debounce timer.
   *
   * Any request still in flight is aborted before a new one starts, so a slow earlier
   * request can't overwrite a newer one — and consumers that wire the passed `AbortSignal`
   * into their fetch get the request actually cancelled, not just ignored. The
   * `aborted` / `searchTerm === value` guards drop superseded or out-of-order responses.
   */
  async performAsyncSearch(e, t) {
    this.abortInFlightSearch();
    const s = new AbortController();
    this.searchAbortController = s, this.isLoading = !0, this.renderDropdown(), H.debug(`[${this.instanceId}] Loading data for search term:`, t);
    try {
      const i = await this.options.searchCallback(t, s.signal);
      if (s.signal.aborted || this.searchTerm !== e) return;
      const r = i || [];
      this.isTreeMode() ? this.rebuildTreeVisibleFromMatches(r) : this.filteredOptions = [...r], this.isLoading = !1, this.matchingIndices.clear(), this.focusedIndex = this.options.isSearchEnabled && this.filteredOptions.length > 0 ? 0 : -1, this.renderDropdown(), H.debug(`[${this.instanceId}] Loaded ${r.length} results`);
    } catch (i) {
      if (s.signal.aborted) return;
      H.error(`[${this.instanceId}] Error loading data:`, i), this.isLoading = !1, this.options.isKeepOptionsOnSearch ? this.isTreeMode() ? this.rebuildTreeVisibleFromMatches(this.allOptions) : this.filteredOptions = [...this.allOptions] : (this.filteredOptions = [], this.isTreeMode() && (this.treeNodes = [])), this.matchingIndices.clear(), this.renderDropdown();
    } finally {
      this.searchAbortController === s && (this.searchAbortController = void 0);
    }
  }
  handleKeydown(e) {
    if (!this.isOpen) {
      (e.key === "Enter" || e.key === "ArrowDown") && (e.preventDefault(), this.open());
      return;
    }
    if (!this.options.isSearchEnabled) {
      const t = e.key.length === 1 || e.key === "Backspace" || e.key === "Delete", s = ["ArrowUp", "ArrowDown", "PageUp", "PageDown", "Home", "End", "Enter", "Escape", "Tab"].includes(e.key);
      if (t && !s) {
        e.preventDefault();
        return;
      }
    }
    switch (e.key) {
      case "ArrowDown":
        e.preventDefault(), e.ctrlKey || e.metaKey ? this.focusNextMatch() : this.focusNext();
        break;
      case "ArrowUp":
        e.preventDefault(), e.ctrlKey || e.metaKey ? this.focusPreviousMatch() : this.focusPrevious();
        break;
      case "Enter":
        e.preventDefault(), this.focusedIndex >= 0 ? this.toggleOption(this.filteredOptions[this.focusedIndex]) : this.options.isAddNewAllowed && this.options.addNewCallback && this.input.value.trim() && this.handleAddNew(this.input.value.trim());
        break;
      case "Escape":
        e.preventDefault(), this.showSelectedPopover ? this.hideSelectedPopover() : this.input.value ? (this.input.value = "", this.searchTerm = "", this.resetVisibleToAll(), this.matchingIndices.clear(), this.focusedIndex = -1, this.renderDropdown()) : this.close();
        break;
      case "Tab":
        this.close();
        break;
      case "PageUp":
        e.preventDefault(), this.focusPageUp();
        break;
      case "PageDown":
        e.preventDefault(), this.focusPageDown();
        break;
      case "Home":
        e.preventDefault(), this.focusFirst();
        break;
      case "End":
        e.preventDefault(), this.focusLast();
        break;
    }
  }
  handleDropdownClick(e) {
    var i;
    j.debug(`[${this.instanceId}] Dropdown clicked`, { target: e.target.className }), e.stopPropagation();
    const t = e.target.closest("[data-action]");
    if (t) {
      e.preventDefault();
      const r = t.dataset.action;
      if (j.debug(`[${this.instanceId}] Action button clicked:`, r), r === "select-all")
        this.selectAll();
      else if (r === "clear-all")
        this.clearAll();
      else if (r === "custom") {
        const n = parseInt(t.dataset.buttonIndex || "-1"), a = (i = this.options.actionButtons) == null ? void 0 : i[n];
        a != null && a.onClick && a.onClick(this);
      }
      return;
    }
    const s = e.target.closest(".ms__option");
    if (s && !s.classList.contains("ms__option--disabled")) {
      e.preventDefault();
      const r = s.dataset.value, n = this.filteredOptions.findIndex((a) => String(this.getItemValue(a)) === r);
      j.debug(`[${this.instanceId}] Option clicked:`, {
        value: r,
        optionIndex: n,
        closeOnSelect: this.options.isCloseOnSelect,
        placeholder: this.options.searchPlaceholder
      }), n >= 0 && (this.focusedIndex = n, this.toggleOption(this.filteredOptions[n]), this.isOpen && this.input.focus());
    }
  }
  handleBadgeClick(e) {
    if (e.target.closest('[data-action="clear-count"]')) {
      e.preventDefault(), e.stopPropagation(), j.debug(`[${this.instanceId}] Clear count button clicked`), this.clearAll();
      return;
    }
    if (e.target.closest('[data-action="show-selected"]')) {
      e.preventDefault(), e.stopPropagation(), this.toggleSelectedPopover();
      return;
    }
    const i = e.target.closest(".ms__badge-remove");
    if (i) {
      if (e.preventDefault(), e.stopPropagation(), i.dataset.action === "remove-hidden") {
        j.debug(`[${this.instanceId}] Remove hidden items button clicked`);
        const l = this.options.badgesMaxVisible || 3;
        Array.from(this.selectedOptions.values()).slice(l).forEach((h) => this.interactiveDeselect(h));
        return;
      }
      const n = i.dataset.value, a = this.selectedOptions.get(n);
      a && this.interactiveDeselect(a);
      return;
    }
    if (e.target.closest(".ms__badge--more") && !e.target.closest(".ms__badge-remove")) {
      e.preventDefault(), e.stopPropagation(), j.debug(`[${this.instanceId}] '+X more' badge clicked, showing popover`), this.toggleSelectedPopover();
      return;
    }
  }
  handleClickOutside(e) {
    var i;
    const t = e.composedPath();
    if (this.showSelectedPopover && !t.some(
      (n) => n instanceof Node && (this.selectedPopover.contains(n) || this.counter.contains(n) || n.closest && n.closest('[data-action="show-selected"]'))
    )) {
      Y.debug(`[${this.instanceId}] Closing selected popover due to click outside`), this.hideSelectedPopover();
      return;
    }
    if (!this.isOpen) return;
    const s = t.some(
      (r) => r instanceof Node && (this.element.contains(r) || this.dropdown.contains(r) || this.hint && this.hint.contains(r))
    );
    j.debug(`[${this.instanceId}] handleClickOutside`, {
      target: e.target.className,
      targetTag: e.target.tagName,
      clickedInside: s,
      pathLength: t.length,
      firstInPath: (i = t[0]) == null ? void 0 : i.tagName,
      elementContains: t.some((r) => r instanceof Node && this.element.contains(r)),
      dropdownContains: t.some((r) => r instanceof Node && this.dropdown.contains(r)),
      isConnected: this.dropdown.isConnected
    }), s || (j.warn(`[${this.instanceId}] Closing dropdown due to click outside`), this.close());
  }
  /**
   * Move focus by computing a new index from (current, total).
   * Returning -1 from `compute` is a no-op (used for empty list / no match).
   */
  focusBy(e, t = 1) {
    const s = this.filteredOptions.length;
    if (s === 0) return;
    const i = e(this.focusedIndex, s);
    if (i < 0) return;
    const r = this.resolveSelectableIndex(i, t, s);
    r < 0 || (this.focusedIndex = r, this.renderDropdown(), this.scrollToFocused());
  }
  /**
   * Given a target index and a preferred direction, return the nearest index
   * whose node is selectable (skipping non-selectable tree nodes). Falls back to
   * the opposite direction, then to -1 if nothing is selectable. No-op outside
   * tree mode.
   */
  resolveSelectableIndex(e, t, s) {
    if (!this.isTreeMode()) return e;
    let i = e;
    for (; i >= 0 && i < s && !this.isIndexSelectable(i); ) i += t;
    if (i < 0 || i >= s)
      for (i = e - t; i >= 0 && i < s && !this.isIndexSelectable(i); ) i -= t;
    return i >= 0 && i < s ? i : -1;
  }
  focusNext() {
    this.focusBy((e, t) => Math.min(t - 1, e + 1), 1);
  }
  focusPrevious() {
    this.focusBy((e) => Math.max(0, e - 1), -1);
  }
  focusFirst() {
    this.focusBy(() => 0, 1);
  }
  focusLast() {
    this.focusBy((e, t) => t - 1, -1);
  }
  focusPageUp() {
    this.focusBy((e) => Math.max(0, e - 10), -1);
  }
  focusPageDown() {
    this.focusBy((e, t) => Math.min(t - 1, e + 10), 1);
  }
  focusNextMatch() {
    if (this.matchingIndices.size === 0) return;
    const e = Array.from(this.matchingIndices).sort((i, r) => i - r), t = e.findIndex((i) => i === this.focusedIndex), s = (t + 1) % e.length;
    this.focusBy(() => e[s]), j.debug(`[${this.instanceId}] Jumped to next match: index ${this.focusedIndex} (${t + 1} of ${e.length})`);
  }
  focusPreviousMatch() {
    if (this.matchingIndices.size === 0) return;
    const e = Array.from(this.matchingIndices).sort((i, r) => i - r), t = e.findIndex((i) => i === this.focusedIndex), s = t <= 0 ? e.length - 1 : t - 1;
    this.focusBy(() => e[s]), j.debug(`[${this.instanceId}] Jumped to previous match: index ${this.focusedIndex} (${t + 1} of ${e.length})`);
  }
  scrollToFocused() {
    if (this.virtualScroll && this.focusedIndex >= 0)
      this.virtualScroll.scrollToIndex(this.focusedIndex);
    else {
      const e = this.dropdown.querySelector(".ms__option--focused");
      e && e.scrollIntoView({ block: "nearest", behavior: "smooth" });
    }
  }
  toggleOption(e) {
    if (this.getItemDisabled(e)) {
      j.debug(`[${this.instanceId}] toggleOption ignored — option is disabled`);
      return;
    }
    if (!this.isOptionSelectable(e)) {
      j.debug(`[${this.instanceId}] toggleOption ignored — node is not selectable`);
      return;
    }
    const t = this.getItemValue(e), s = String(t);
    if (j.debug(`[${this.instanceId}] toggleOption called`, { value: t, multiple: this.options.isMultipleEnabled }), this.isCascadeMode() && this.cascadeIndex) {
      const n = this.cascadeIndex.nodeByValue.get(s);
      if (n) {
        this.toggleTreeCascade(n), this.options.isCloseOnSelect && this.close();
        return;
      }
    }
    (this.selectedValues.has(s) ? this.interactiveDeselect(e) : this.interactiveSelect(e)) && (this.options.isMultipleEnabled ? this.options.isCloseOnSelect && this.close() : this.close());
  }
  /**
   * The single funnel for an interactive (user-initiated) selection. Consults
   * `beforeSelectCallback` and only mutates state if allowed, so the veto can
   * never be bypassed by a new UI entry point. Programmatic `setSelected` and
   * the Select-All button deliberately do not route through here.
   * Returns true if the option was selected, false if the veto blocked it.
   */
  interactiveSelect(e) {
    return this.options.beforeSelectCallback && this.options.beforeSelectCallback(e, this.getSelected()) === !1 ? (j.debug(`[${this.instanceId}] Selection blocked by beforeSelectCallback`), !1) : (this.options.isMultipleEnabled || (this.selectedValues.clear(), this.selectedOptions.clear()), this.selectOption(e), !0);
  }
  /**
   * The single funnel for an interactive (user-initiated) deselection. Every
   * removal affordance — dropdown toggle, badge × button, selected-items
   * popover × button, and the "remove hidden" badge — routes through here so
   * the `beforeDeselectCallback` veto applies uniformly. Programmatic
   * `setSelected` and the Clear-All button deliberately bypass it.
   * Returns true if the option was deselected, false if the veto blocked it.
   */
  interactiveDeselect(e) {
    return this.options.beforeDeselectCallback && this.options.beforeDeselectCallback(e, this.getSelected()) === !1 ? (j.debug(`[${this.instanceId}] Deselection blocked by beforeDeselectCallback`), !1) : (this.deselectOption(e), !0);
  }
  async handleAddNew(e) {
    if (this.options.addNewCallback)
      try {
        H.debug(`[${this.instanceId}] Adding new option:`, e);
        const t = await this.options.addNewCallback(e);
        this.allOptions.push(t), this.filteredOptions.push(t), this.selectOption(t), this.input.value = "", this.renderDropdown(), this.renderBadges(), this.options.isCloseOnSelect && this.close();
      } catch (t) {
        H.error(`[${this.instanceId}] Error adding new option:`, t);
      }
  }
  selectOption(e) {
    const t = this.getItemValue(e), s = String(t);
    this.selectedValues.add(s), this.selectedOptions.set(s, e), this.commit({ added: [e] });
  }
  deselectOption(e) {
    const t = this.getItemValue(e), s = String(t);
    if (this.isCascadeMode() && this.cascadeIndex) {
      const i = this.cascadeIndex.nodeByValue.get(s);
      if (i) {
        const r = this.cascadeIndex.atomsUnder.get(i.path) ?? [], n = new Set(De(this.cascadeIndex, this.selectedValues));
        for (const a of r) n.delete(a);
        this.commitCascadeAtoms(n);
        return;
      }
    }
    this.selectedValues.delete(s), this.selectedOptions.delete(s), this.commit({ removed: [e] });
  }
  selectAll() {
    if (this.isCascadeMode() && this.cascadeIndex) {
      const t = this.cascadeIndex, s = new Set(De(t, this.selectedValues));
      for (const i of this.treeNodes)
        t.atomPaths.has(i.path) && (this.getItemDisabled(i.data) || s.add(String(this.getItemValue(i.data))));
      this.commitCascadeAtoms(s);
      return;
    }
    const e = [];
    this.filteredOptions.forEach((t, s) => {
      if (this.getItemDisabled(t) || !this.isIndexSelectable(s)) return;
      const i = String(this.getItemValue(t));
      this.selectedValues.has(i) || (this.selectedValues.add(i), this.selectedOptions.set(i, t), e.push(t));
    }), this.commit({ added: e });
  }
  clearAll() {
    const e = Array.from(this.selectedOptions.values());
    this.selectedValues.clear(), this.selectedOptions.clear(), this.commit({ removed: e });
  }
  /**
   * Re-render and fire callbacks after a selection state change.
   * `added` / `removed` drive per-item select/deselect callbacks.
   * `onChange` fires once if anything actually changed.
   */
  commit(e) {
    this.renderDropdown(), this.renderBadges(), this.updateHiddenInput();
    const t = e.added ?? [], s = e.removed ?? [];
    this.options.onSelect && t.forEach((i) => this.options.onSelect(i)), this.options.onDeselect && s.forEach((i) => this.options.onDeselect(i)), (t.length > 0 || s.length > 0) && this.options.onChange && this.options.onChange(this.getSelected());
  }
  open() {
    Y.debug(`[${this.instanceId}] open() called`, { isOpen: this.isOpen }), !this.isOpen && (this.isOpen = !0, this.element.classList.add("ms--open"), this.dropdown.classList.add("ms__dropdown--visible"), Y.info(`[${this.instanceId}] Dropdown opened`), this.input.placeholder = this.getPlaceholderText(), !this.options.isMultipleEnabled && this.options.isSearchEnabled && (this.input.value = this.searchTerm), this.options.searchCallback && this.options.isKeepOptionsOnSearch && !this.searchTerm && (this.filteredOptions = [...this.allOptions], Y.debug(`[${this.instanceId}] Showing ${this.allOptions.length} initial options on open`)), this.renderDropdown(), this.positionDropdown(), this.dropdown.addEventListener("scroll", this.onDropdownScroll, !0), this.hint && (this.hint.classList.add("ms__hint--visible"), this.positionHint()));
  }
  close() {
    Y.debug(`[${this.instanceId}] close() called`, { isOpen: this.isOpen }), this.isOpen && (this.isOpen = !1, this.element.classList.remove("ms--open"), this.dropdown.classList.remove("ms__dropdown--visible"), this.hint && this.hint.classList.remove("ms__hint--visible"), this.options.shouldKeepSearchOnClose || (this.searchTerm = "", (this.options.isMultipleEnabled || this.options.isSearchEnabled) && (this.input.value = ""), this.resetVisibleToAll()), this.focusedIndex = -1, this.dropdown.removeEventListener("scroll", this.onDropdownScroll, !0), this.destroyAllOptionTooltips(), this.renderBadges(), this.dropdownCleanup && (this.dropdownCleanup(), this.dropdownCleanup = null), this.hintCleanup && (this.hintCleanup(), this.hintCleanup = null), this.dropdownPlacement = null, Y.debug(`[${this.instanceId}] Dropdown closed`));
  }
  /**
   * Anchor a floating panel (dropdown or selected-items popover) below/above the input with
   * placement-locking and width-syncing. Returns the `autoUpdate` cleanup.
   *
   * Both panels share: anchor on input, sync width, default to 'bottom-start', flip on first
   * compute then lock the resulting placement, optionally clamp by dropdownMin/MaxWidth.
   */
  anchorFloatingPanel(e, t) {
    var r;
    const s = ((r = t.isLocked) == null ? void 0 : r.call(t)) ?? !0, i = xt(e, this.input, {
      strategy: "fixed",
      placement: "bottom-start",
      offset: 4,
      shift: 8,
      // Locked → flip once to where it fits, then pin (core 'freeze'). Unlocked
      // → re-flip every frame (default flip:true, no lock).
      lockPlacement: s ? "freeze" : !1,
      // Narrow floating-ui's fixed-position containing-block heuristic to what browsers
      // reliably honour (transform/perspective/filter/backdrop-filter/will-change),
      // resolved from the portaled panel — core builds the custom platform for us. The
      // panel is appended to `container` (default document.body), so its containing block
      // can differ from the input's; measuring from the panel is what the browser does.
      // For other CB-establishing properties (contain, container-type) the browser keeps
      // fixed elements viewport-anchored, so `onDrift` catches the inverse edge case and
      // warns, pointing at the likely culprit.
      fixedContainingBlock: !0,
      onDrift: (n) => this.warnDrift(n),
      beforeCompute: () => {
        (this.options.hostElement ?? this.element).style.setProperty("--ms-input-current-width", `${this.input.offsetWidth}px`), this.options.dropdownMinWidth && (e.style.minWidth = this.options.dropdownMinWidth), t.applyMaxWidth && this.options.dropdownMaxWidth && (e.style.maxWidth = this.options.dropdownMaxWidth);
      },
      onPlaced: (n) => {
        var a;
        t.getPlacement() || t.setPlacement(n), (a = t.afterPosition) == null || a.call(t);
      }
    });
    return () => i.destroy();
  }
  /**
   * Surface a multiselect-branded, once-per-instance warning when core's drift check
   * (`anchor`'s `onDrift`) reports the panel didn't land where it was positioned. The
   * consumer has an ancestor that establishes a fixed containing block but isn't on the
   * reliable-anchors list (likely `contain: paint|layout|strict` or `container-type`).
   * We can't fix it from inside the library, but we point at the likely culprit. Core
   * owns the measurement + culprit-finding + CB-CSS diagnostic (`detectFixedDrift`).
   */
  warnDrift(e) {
    this.positioningDriftWarned || (this.positioningDriftWarned = !0, console.warn(
      `[@keenmate/web-multiselect] Dropdown panel rendered ${e.driftX.toFixed(0)}px / ${e.driftY.toFixed(0)}px away from where the library positioned it. Most likely culprit: ${e.culpritDescription}` + (e.culpritCss ? ` (has ${e.culpritCss})` : "") + ".\nAn ancestor of <web-multiselect> establishes a fixed-positioning containing block that the library's heuristic doesn't recognize. Fix on your side: replace the property with `transform: translateZ(0)` on that ancestor, OR move the trigger out of that ancestor's subtree. If neither is acceptable, please file an issue at https://github.com/keenmate/web-multiselect/issues with the ancestor's computed CSS."
    ));
  }
  positionDropdown() {
    this.dropdownCleanup = this.anchorFloatingPanel(this.dropdown, {
      getPlacement: () => this.dropdownPlacement,
      setPlacement: (e) => {
        this.dropdownPlacement = e, Y.debug(`[${this.instanceId}] Locked dropdown placement:`, e);
      },
      isLocked: () => !!this.options.isPlacementLocked,
      applyMaxWidth: !0,
      afterPosition: () => {
        this.hint && this.isOpen && this.positionHint();
      }
    });
  }
  positionHint() {
    if (!this.hint) return;
    this.hintCleanup && this.hintCleanup();
    let e = "top-start";
    this.dropdownPlacement && (this.dropdownPlacement.startsWith("bottom") ? e = this.dropdownPlacement.replace("bottom", "top") : this.dropdownPlacement.startsWith("top") && (e = this.dropdownPlacement.replace("top", "bottom")));
    const t = xt(this.hint, this.input, {
      strategy: "fixed",
      placement: e,
      offset: 4,
      shift: 8,
      flip: !1
    });
    this.hintCleanup = () => t.destroy();
  }
  parseInitialSelection() {
    const e = this.element.dataset.initialValues;
    if (e)
      try {
        JSON.parse(e).forEach((s) => {
          this.selectedValues.add(String(s));
        }), this.reconcileSelectedOptions(), this.renderBadges();
      } catch (t) {
        H.error(`[${this.instanceId}] Failed to parse initial values:`, t);
      }
  }
  /**
   * Resolve any `selectedValues` entries that don't yet have a matching
   * `selectedOptions` object by looking them up in the current `allOptions`.
   * Idempotent; safe to call after init *and* after `options` is replaced
   * (e.g., async fetch, `searchCallback` result, or late `element.options =`
   * assignment). Without this, `initial-values` declared before options
   * arrive ends up with phantom values that `getValue()` can never report.
   */
  reconcileSelectedOptions() {
    this.selectedValues.size === 0 || this.allOptions.length === 0 || this.selectedValues.forEach((e) => {
      if (this.selectedOptions.has(e)) return;
      const t = this.allOptions.find((s) => String(this.getItemValue(s)) === e);
      t && this.selectedOptions.set(e, t);
    });
  }
  toggleSelectedPopover() {
    this.showSelectedPopover ? this.hideSelectedPopover() : this.showPopover();
  }
  showPopover() {
    Y.debug(`[${this.instanceId}] showPopover() called`), this.isOpen && this.close(), this.showSelectedPopover = !0, this.renderSelectedPopover(), this.selectedPopover.classList.add("ms__selected-popover--visible");
    const e = this.options.virtualScrollThreshold ?? 100;
    this.selectedValues.size >= e && this.selectedPopover.classList.add("ms__selected-popover--virtual"), this.positionSelectedPopover();
  }
  hideSelectedPopover() {
    var e;
    Y.debug(`[${this.instanceId}] hideSelectedPopover() called`), this.showSelectedPopover = !1, this.selectedPopover.classList.remove("ms__selected-popover--visible"), this.selectedPopover.classList.remove("ms__selected-popover--virtual"), this.selectedPopoverPlacement = null, this.selectedPopoverVirtualScroll && (this.selectedPopoverVirtualScroll.destroy(), this.selectedPopoverVirtualScroll = null, this.selectedPopoverContainer = null), this.selectedPopoverCleanup && (this.selectedPopoverCleanup(), this.selectedPopoverCleanup = null);
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("popover-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  renderSelectedPopover() {
    const e = Array.from(this.selectedOptions.values()), t = this.selectedValues.size, s = this.options.virtualScrollThreshold ?? 100;
    if (t >= s) {
      this.renderSelectedPopoverVirtual(e, t);
      return;
    }
    this.selectedPopover.innerHTML = `
            <div class="ms__selected-popover-header">
                <span>Selected Items (${t})</span>
                <button type="button" class="ms__selected-popover-close" aria-label="Close"></button>
            </div>
            <div class="ms__selected-popover-body">
                ${e.map((i) => this.renderBadgeHTML(i, { displayMode: this.options.badgesDisplayMode || "badges", isInPopover: !0 })).join("")}
            </div>
        `, this.attachBadgeTooltips(this.selectedPopover);
  }
  renderSelectedPopoverVirtual(e, t) {
    if (this.selectedPopoverVirtualScroll) {
      const a = this.selectedPopover.querySelector(".ms__selected-popover-header span");
      a && (a.textContent = `Selected Items (${t})`);
    } else {
      const a = this.options.badgeHeight ?? 36, l = `
                <div class="ms__selected-popover-header">
                    <span>Selected Items (${t})</span>
                    <button type="button" class="ms__selected-popover-close" aria-label="Close"></button>
                </div>
                <div class="ms__selected-popover-body ms__selected-popover-body--virtual" style="height: 18rem; overflow-y: auto; position: relative; --ms-badge-height-virtual: ${a}px;"></div>
            `;
      this.selectedPopover.innerHTML = l, this.selectedPopoverContainer = this.selectedPopover.querySelector(".ms__selected-popover-body");
    }
    if (!this.selectedPopoverContainer) return;
    const r = (this.options.badgeHeight ?? 36) + 4, n = this.options.virtualScrollBuffer ?? 10;
    requestAnimationFrame(() => {
      this.selectedPopoverContainer && (this.selectedPopoverVirtualScroll ? this.selectedPopoverVirtualScroll.setItems(e) : this.selectedPopoverVirtualScroll = new Xt({
        container: this.selectedPopoverContainer,
        itemHeight: r,
        items: e,
        renderItem: (a) => this.renderBadgeHTML(a, { displayMode: this.options.badgesDisplayMode || "badges", isInPopover: !0 }),
        bufferSize: n,
        onVisibleRangeChange: () => {
          this.attachBadgeTooltips(this.selectedPopoverContainer);
        }
      }));
    });
  }
  /**
   * Render a removable badge for a selected option (used by the badges/partial display modes
   * and by the selected-items popover).
   *
   * - In the popover, `renderSelectedItemContentCallback` and `getSelectedItemClassCallback` win
   *   over the regular badge callbacks; that's how consumers customize popover items independently.
   * - The `data-value` and aria-label both go through `getItemBadgeDisplayValue` so badge text and
   *   accessible name stay in sync.
   */
  renderBadgeHTML(e, t) {
    const s = this.getItemValue(e);
    let i;
    const r = t.isInPopover ? this.options.renderSelectedItemContentCallback : void 0;
    if (r) {
      const c = r(e);
      i = typeof c == "string" ? c : c.outerHTML;
    } else if (this.options.renderBadgeContentCallback) {
      const c = this.options.renderBadgeContentCallback(e, t);
      i = typeof c == "string" ? c : c.outerHTML;
    } else
      i = this.getItemBadgeDisplayValue(e);
    const n = t.isInPopover ? this.options.getSelectedItemClassCallback || this.options.getBadgeClassCallback : this.options.getBadgeClassCallback;
    let a = "ms__badge";
    if (n) {
      const c = n(e), d = Array.isArray(c) ? c : [c];
      a += " " + d.filter((h) => h).join(" ");
    }
    const l = this.getItemBadgeDisplayValue(e);
    return `
            <div class="${a}">
                <span class="ms__badge-text">${i}</span>
                <button type="button" class="ms__badge-remove" data-value="${s}" aria-label="Remove ${l}"></button>
            </div>
        `;
  }
  handleSelectedPopoverClick(e) {
    if (e.stopPropagation(), e.target.closest(".ms__selected-popover-close")) {
      e.preventDefault(), this.hideSelectedPopover();
      return;
    }
    const s = e.target.closest(".ms__badge-remove");
    if (s) {
      e.preventDefault();
      const i = s.dataset.value, r = this.selectedOptions.get(i);
      r && this.interactiveDeselect(r) && (this.renderSelectedPopover(), this.selectedValues.size === 0 && this.hideSelectedPopover());
    }
  }
  positionSelectedPopover() {
    this.selectedPopoverCleanup = this.anchorFloatingPanel(this.selectedPopover, {
      getPlacement: () => this.selectedPopoverPlacement,
      setPlacement: (e) => {
        this.selectedPopoverPlacement = e, Y.debug(`[${this.instanceId}] Locked popover placement:`, e);
      }
    });
  }
  // ========================================================================
  // FORM INTEGRATION
  // ========================================================================
  updateHiddenInput() {
    if (!this.options.formFieldId) return;
    this.hiddenInputs.forEach((i) => i.remove()), this.hiddenInputs = [];
    const e = this.options.valueFormat || "json", t = Array.from(this.selectedOptions.values()).map((i) => this.getItemValue(i)), s = this.options.hostElement || this.element;
    if (e === "array")
      t.forEach((i) => {
        const r = document.createElement("input");
        r.type = "hidden", r.name = `${this.options.formFieldId}[]`, r.value = String(i), s.appendChild(r), this.hiddenInputs.push(r);
      });
    else {
      const i = document.createElement("input");
      i.type = "hidden", i.name = this.options.formFieldId, i.id = this.options.formFieldId, i.value = this.getFormValue(), s.appendChild(i), this.hiddenInputs.push(i);
    }
  }
  getFormValue() {
    const e = Array.from(this.selectedOptions.values()).map((s) => this.getItemValue(s));
    return this.options.getValueFormatCallback ? this.options.getValueFormatCallback(e) : (this.options.valueFormat || "json") === "csv" ? e.join(",") : JSON.stringify(e);
  }
  // ========================================================================
  // PUBLIC API
  // ========================================================================
  getSelected() {
    return Array.from(this.selectedOptions.values());
  }
  /**
   * Set the selection programmatically. **Silent by default** — it does not fire
   * `select`/`deselect`/`change` (so restoring saved state, cascade resets, or a
   * server-authoritative correction can't loop back or trip "user changed it"
   * handlers). Pass `{ notify: true }` to announce the result as a **single
   * aggregate `change`** — for a deliberate user gesture (e.g. an action button)
   * that should reach the same listeners a manual pick does, without the per-item
   * `select`/`deselect` flood a bulk change would otherwise cause.
   */
  setSelected(e, t = {}) {
    this.selectedValues = new Set(e.map((s) => String(s))), this.selectedOptions.clear(), e.forEach((s) => {
      const i = String(s), r = this.allOptions.find((n) => String(this.getItemValue(n)) === i);
      r && this.selectedOptions.set(i, r);
    }), this.renderDropdown(), this.renderBadges(), this.updateHiddenInput(), t.notify && this.options.onChange && this.options.onChange(this.getSelected());
  }
  /**
   * Merge a partial config update into the live picker without tearing down the DOM.
   *
   * Handles the cheap structural toggles inline (no-checkboxes class, badges-position class,
   * input placeholder, search-input mode) and re-renders dropdown + badges + hidden inputs.
   *
   * Returns `true` if the change could be applied in place. Returns `false` for changes that
   * truly require rebuilding the DOM scaffolding (currently: adding/removing the `searchHint`
   * element, since it's only created in `buildHTML` if a hint string was provided). The caller
   * should fall back to destroy + re-init in that case.
   */
  updateOptions(e) {
    var n;
    const t = !!this.hint, s = "searchHint" in e ? !!e.searchHint : t;
    if (t !== s) return !1;
    Object.assign(this.options, e);
    const i = "pathMember" in e || "getPathCallback" in e || "parentPathMember" in e || "levelMember" in e || "hasChildrenMember" in e || "treePathSeparator" in e || "isTreeEnabled" in e || "isSelectableMember" in e || "getIsSelectableCallback" in e;
    if ("options" in e && e.options !== void 0 ? (this.allOptions = e.options, this.reconcileSelectedOptions(), this.isTreeMode() ? this.buildTree() : this.filteredOptions = this.searchTerm ? this.filteredOptions : [...this.allOptions]) : i && (this.isTreeMode() ? this.buildTree() : this.filteredOptions = this.searchTerm ? this.filteredOptions : [...this.allOptions]), ("checkboxMode" in e || "cascadeSelectPolicy" in e) && !i && !("options" in e) && this.isTreeMode() && (this.cascadeIndex = this.isCascadeMode() ? eo(this.tree, (a) => String(this.getItemValue(a))) : null, this.isCascadeMode() && this.cascadeIndex)) {
      this.cascadeCheckedAtoms = De(this.cascadeIndex, this.selectedValues);
      const a = mt(
        this.cascadeIndex,
        this.cascadeCheckedAtoms,
        this.cascadePolicy(),
        (c) => String(this.getItemValue(c))
      ), l = /* @__PURE__ */ new Map();
      for (const c of a) {
        const d = ((n = this.cascadeIndex.nodeByValue.get(c)) == null ? void 0 : n.data) ?? this.selectedOptions.get(c);
        d !== void 0 && l.set(c, d);
      }
      this.selectedValues = new Set(a), this.selectedOptions = l;
    }
    if (this.element.classList.toggle(
      "ms--no-checkboxes",
      !this.options.isCheckboxesShown || !this.options.isMultipleEnabled
    ), "badgesPosition" in e) {
      this.effectiveBadgesPosition = this.options.badgesPosition || "bottom", this.isRTL && (this.effectiveBadgesPosition === "left" ? this.effectiveBadgesPosition = "right" : this.effectiveBadgesPosition === "right" && (this.effectiveBadgesPosition = "left"));
      const a = this.element.querySelector(".ms__wrapper");
      a == null || a.classList.toggle(
        "ms__wrapper--inline",
        this.effectiveBadgesPosition === "left" || this.effectiveBadgesPosition === "right"
      );
    }
    return this.isOpen || (this.input.placeholder = this.getPlaceholderText()), "searchInputMode" in e && (this.input.readOnly = this.options.searchInputMode === "readonly", this.input.style.display = this.options.searchInputMode === "hidden" ? "none" : ""), "searchHint" in e && this.hint && (this.hint.textContent = this.options.searchHint || ""), this.renderDropdown(), this.renderBadges(), this.updateHiddenInput(), !0;
  }
  get selectedItem() {
    return this.selectedOptions.size === 0 ? null : Array.from(this.selectedOptions.values())[0];
  }
  get selectedValue() {
    if (!this.options.valueMember && !this.options.getValueCallback)
      return null;
    if (this.selectedOptions.size === 0)
      return this.options.isMultipleEnabled ? [] : null;
    const e = Array.from(this.selectedOptions.values()).map((t) => this.getItemValue(t));
    return this.options.isMultipleEnabled ? e : e[0] ?? null;
  }
  getValue() {
    if (this.selectedOptions.size === 0)
      return this.options.isMultipleEnabled ? [] : null;
    const e = Array.from(this.selectedOptions.values()).map((t) => this.getItemValue(t));
    return this.options.isMultipleEnabled ? e : e[0] ?? null;
  }
  // ========================================================================
  // TOOLTIPS (badge text, badge-remove buttons, action buttons)
  // ========================================================================
  /**
   * Create or replace a tracked tooltip with the given id. Replacing destroys the old one,
   * which is the normal flow when re-rendering badges/actions.
   */
  spawnTooltip(e) {
    var r;
    (r = this.tooltips.get(e.id)) == null || r.destroy();
    const t = this.element.getRootNode(), s = t instanceof ShadowRoot ? t : null, i = _i({
      trigger: e.trigger,
      container: this.options.container ?? s ?? document.body,
      content: e.content,
      placement: e.placement ?? this.options.badgeTooltipPlacement ?? "top",
      offset: e.offsetDistance ?? this.options.badgeTooltipOffset ?? 8,
      // Core takes a {show, hide} delay; the old Tooltip defaulted hide to 100ms.
      delay: { show: e.showDelay ?? this.options.badgeTooltipDelay ?? 100, hide: 100 },
      // Core createTooltip has no cssClass default and uses 'is-visible';
      // fall back to the component's badge-tooltip classes the old Tooltip
      // defaulted to (option tooltips override with ms__option-tooltip).
      cssClass: e.cssClass ?? "ms__badge-tooltip",
      visibleClass: e.visibleClass ?? "ms__badge-tooltip--visible",
      followCursor: e.followCursor,
      onBeforeShow: e.onBeforeShow
    });
    this.tooltips.set(e.id, i);
  }
  destroyAllTooltips() {
    this.tooltips.forEach((e) => e.destroy()), this.tooltips.clear();
  }
  /** Build the badge-text tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
  buildBadgeTooltipContent(e) {
    if (this.options.getBadgeTooltipCallback) return this.options.getBadgeTooltipCallback(e);
    const t = this.getItemBadgeDisplayValue(e), s = this.getItemSubtitle(e);
    return s ? `${t}
${s}` : t;
  }
  /** Build the remove-button tooltip text (callback > format string with {0} > "Remove {name}"). */
  buildRemoveButtonTooltipText(e, t) {
    return t && this.options.getRemoveButtonTooltipCallback ? this.options.getRemoveButtonTooltipCallback(t) : this.options.removeButtonTooltipText ? this.options.removeButtonTooltipText.replace("{0}", e) : `Remove ${e}`;
  }
  attachBadgeTooltips(e) {
    if (!this.options.isBadgeTooltipsEnabled) return;
    const t = !!e, s = e || this.badgesContainer, i = t ? "popover-" : "";
    if (s.querySelectorAll(".ms__badge:not(.ms__badge--more)").forEach((n) => {
      const a = n.querySelector(".ms__badge-remove");
      if (!a) return;
      const l = a.dataset.value, c = this.selectedOptions.get(l);
      if (!c) return;
      const d = `${i}${l}`, h = `${i}${l}-remove`, g = n.querySelector(".ms__badge-text");
      g && this.spawnTooltip({
        id: d,
        trigger: g,
        content: this.buildBadgeTooltipContent(c)
      });
      const m = this.getItemBadgeDisplayValue(c);
      this.spawnTooltip({
        id: h,
        trigger: a,
        content: this.buildRemoveButtonTooltipText(m, c),
        // Keep parent badge tooltip from overlapping the remove-button tooltip.
        onBeforeShow: () => {
          var b;
          return (b = this.tooltips.get(d)) == null ? void 0 : b.hide();
        }
      });
    }), !t) {
      const n = this.badgesContainer.querySelector(".ms__badge--more"), a = n == null ? void 0 : n.querySelector(".ms__badge-remove");
      if (a && a.dataset.action === "remove-hidden") {
        const l = this.options.badgesMaxVisible || 3, c = this.selectedOptions.size - l;
        this.spawnTooltip({
          id: "more-badge-remove",
          trigger: a,
          content: this.buildRemoveButtonTooltipText(`${c} hidden items`)
        });
      }
    }
  }
  /** Build the option tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
  buildOptionTooltipContent(e) {
    if (this.options.getOptionTooltipCallback) return this.options.getOptionTooltipCallback(e);
    const t = this.getItemDisplayValue(e), s = this.getItemSubtitle(e);
    return s ? `${t}
${s}` : t;
  }
  /**
   * Attach hover tooltips to the currently rendered dropdown options. Prunes existing option
   * tooltips first, so it's safe to call on every render and on every virtual-scroll range change
   * (where option DOM is recycled). Each option resolves its source object via `data-index` into
   * `filteredOptions`, the same global index `renderOption` was given.
   */
  attachOptionTooltips() {
    if (this.destroyAllOptionTooltips(), !this.options.isOptionTooltipsEnabled) return;
    this.dropdown.querySelectorAll(".ms__option").forEach((t) => {
      const s = t, i = parseInt(s.dataset.index ?? "-1", 10);
      if (i < 0) return;
      const r = this.filteredOptions[i];
      if (!r) return;
      const n = this.buildOptionTooltipContent(r);
      n && this.spawnTooltip({
        id: `option-${i}`,
        trigger: s,
        content: n,
        // Default to `top-start` (anchored to the row's start edge) so the tooltip doesn't
        // center on a full-width row. Falls through to the badge settings for delay/offset.
        placement: this.options.optionTooltipPlacement ?? "top-start",
        offsetDistance: this.options.optionTooltipOffset ?? this.options.badgeTooltipOffset ?? 8,
        showDelay: this.options.optionTooltipDelay ?? this.options.badgeTooltipDelay ?? 100,
        cssClass: "ms__option-tooltip",
        visibleClass: "ms__option-tooltip--visible",
        followCursor: this.options.isOptionTooltipFollowCursor
      });
    });
  }
  /**
   * Hide (don't destroy) every currently-shown option tooltip immediately,
   * ignoring the hide delay. Wired to dropdown scroll so a tooltip can't trail
   * its recycling/scrolling anchor row. Handles stay in the map; a fresh hover
   * re-shows them.
   */
  hideOptionTooltips() {
    for (const [e, t] of this.tooltips)
      e.startsWith("option-") && t.hide();
  }
  /**
   * Destroy only the option tooltips (prefixed `option-`). Called before re-rendering or
   * recycling the options list so per-option tooltip state doesn't leak.
   */
  destroyAllOptionTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("option-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  attachActionButtonTooltips() {
    this.dropdown.querySelectorAll(".ms__action-btn").forEach((t) => {
      var c, d;
      const s = t, i = s.dataset.action;
      if (!i) return;
      const r = parseInt(s.dataset.buttonIndex || "-1"), n = r >= 0 ? (c = this.options.actionButtons) == null ? void 0 : c[r] : (d = this.options.actionButtons) == null ? void 0 : d.find((h) => h.action === i);
      if (!n) return;
      const a = n.getTooltipCallback ? n.getTooltipCallback(this) : n.tooltip;
      if (!a) return;
      const l = `action-${r >= 0 ? r : i}`;
      this.spawnTooltip({ id: l, trigger: s, content: a });
    });
  }
  /**
   * Destroy only the action-button tooltips. Called from `renderDropdown`/`renderDropdownVirtual`
   * before rebuilding the actions row, so per-button tooltip state doesn't leak.
   */
  destroyAllActionButtonTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("action-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  /**
   * Destroy main-badges-container tooltips. Called before re-rendering the badges container.
   * Popover tooltips (prefixed `popover-`) survive — they're owned by the popover lifecycle and
   * cleaned up in `hideSelectedPopover`. Action-button tooltips (prefixed `action-`) survive too.
   */
  destroyAllBadgeTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      !t.startsWith("action-") && !t.startsWith("popover-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  // ========================================================================
  // PUBLIC API
  // ========================================================================
  destroy() {
    this.destroyAllTooltips(), this.searchDebounceTimer && (clearTimeout(this.searchDebounceTimer), this.searchDebounceTimer = void 0), this.abortInFlightSearch(), this.dropdownCleanup && this.dropdownCleanup(), this.hintCleanup && this.hintCleanup(), this.selectedPopoverCleanup && this.selectedPopoverCleanup(), this.documentClickHandler && (document.removeEventListener("click", this.documentClickHandler), this.documentClickHandler = null), this.documentKeydownHandler && (document.removeEventListener("keydown", this.documentKeydownHandler), this.documentKeydownHandler = null), this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null), this.dropdown && this.dropdown.remove(), this.hint && this.hint.remove(), this.selectedPopover && this.selectedPopover.remove(), this.element.innerHTML = "", this.element.classList.remove("ms", "ms--open", "ms--no-checkboxes"), Xe.info(`[${this.instanceId}] Component destroyed`);
  }
}
function Oi() {
  return {
    fromAttribute(o) {
      if (o === null || o.trim() === "") return [];
      const e = o.trim();
      if (e.startsWith("["))
        try {
          const t = JSON.parse(e);
          if (Array.isArray(t)) return t;
        } catch {
        }
      return e.split(",").map((t) => t.trim());
    },
    validate(o) {
      return Array.isArray(o) && o.every((e) => typeof e == "string" || typeof e == "number");
    },
    toAttribute(o) {
      return Array.isArray(o) ? JSON.stringify(o) : null;
    }
  };
}
const Pi = ["json", "csv", "plain"], to = ",", oo = `
`;
function Mi(o, e, t = {}) {
  if (o == null || o.trim() === "") return { options: [] };
  const s = so(t.splitter ?? to) || to, i = so(t.rowSplitter ?? oo) || oo;
  switch (e) {
    case "csv":
      return Ei(o, s, i);
    case "plain":
      return Li(o, s, i);
    case "json":
    default:
      return Ai(o);
  }
}
function so(o) {
  return o.replace(
    /\\[ntr\\]/g,
    (e) => e === "\\n" ? `
` : e === "\\t" ? "	" : e === "\\r" ? "\r" : "\\"
  );
}
function Ai(o) {
  let e;
  try {
    e = JSON.parse(o);
  } catch (t) {
    return { options: [], error: `data-options is not valid JSON: ${t.message}` };
  }
  return Array.isArray(e) ? { options: e } : { options: [], error: "data-options JSON must be an array" };
}
function Li(o, e, t) {
  return { options: o.split(t).flatMap((i) => i.split(e)).map((i) => i.trim()).filter((i) => i.length > 0).map((i) => [i, i]) };
}
function Ei(o, e, t) {
  const s = $i(o, e, t).filter((n) => !(n.length === 1 && n[0].trim() === ""));
  if (s.length < 2)
    return { options: [], error: "data-options CSV needs a header row and at least one data row" };
  const i = s[0].map((n) => n.trim());
  return { options: s.slice(1).map((n) => {
    const a = {};
    return i.forEach((l, c) => {
      a[l] = (n[c] ?? "").trim();
    }), a;
  }) };
}
function $i(o, e, t) {
  const s = [];
  let i = [], r = "", n = !1;
  for (let a = 0; a < o.length; ) {
    const l = o[a];
    if (n) {
      l === '"' ? o[a + 1] === '"' ? (r += '"', a += 2) : (n = !1, a += 1) : (r += l, a += 1);
      continue;
    }
    l === '"' ? (n = !0, a += 1) : o.startsWith(e, a) ? (i.push(r), r = "", a += e.length) : o.startsWith(t, a) ? (i.push(r), s.push(i), i = [], r = "", a += t.length) : (l === "\r" || (r += l), a += 1);
  }
  return i.push(r), s.push(i), s;
}
const Oo = `@layer variables,component,overrides;@layer variables{:host{display:block;--ms-rem: 10px;font-family:var(--ms-font-family, var(--base-font-family, inherit));--ms-accent-color: var(--base-accent-color, #3b82f6);--ms-accent-color-hover: var(--base-accent-color-hover, #2563eb);--ms-accent-color-active: var(--base-accent-color-active, #1d4ed8);--ms-accent-color-light: var(--base-accent-color-light, light-dark(#eff6ff, #1e3a5f));--ms-accent-color-light-hover: var(--base-accent-color-light-hover, light-dark(#e0f2fe, #264a73));--ms-text-color-1: var(--base-text-color-1, light-dark(#111827, #f5f5f5));--ms-text-color-2: var(--base-text-color-2, light-dark(#353b47, #d4d4d4));--ms-text-color-3: var(--base-text-color-3, light-dark(#6b7280, #a3a3a3));--ms-text-color-4: var(--base-text-color-4, light-dark(#a0a3a9, #737373));--ms-text-color-on-accent: var(--base-text-color-on-accent, #ffffff);--ms-text-primary: var(--ms-text-color-1);--ms-text-secondary: var(--ms-text-color-3);--ms-primary-bg: var(--base-hover-bg, color-mix(in srgb, var(--ms-text-color-1) 8%, var(--base-main-bg, light-dark(#ffffff, #1a1a1a))));--ms-primary-bg-hover: var(--base-active-bg, color-mix(in srgb, var(--ms-text-color-1) 14%, var(--base-main-bg, light-dark(#ffffff, #1a1a1a))));--ms-border-color: var(--base-border-color, light-dark(#e5e7eb, #3a3a3a));--ms-border: var(--base-border, 1px solid var(--ms-border-color));--ms-input-bg: var(--base-input-bg, light-dark(#ffffff, #1a1a1a));--ms-input-color: var(--base-input-color, var(--ms-text-color-1));--ms-input-border: var(--base-input-border, 1px solid var(--ms-border-color));--ms-input-border-hover: var(--base-input-border-hover, 1px solid var(--ms-accent-color));--ms-input-border-focus: var(--base-input-border-focus, 1px solid var(--ms-accent-color));--ms-input-placeholder-color: var(--base-input-placeholder-color, var(--ms-text-color-4));--ms-input-bg-disabled: var(--base-input-bg-disabled, rgba(107, 114, 128, .05));--ms-toggle-icon-color: var(--ms-text-color-3);--ms-toggle-icon-color-open: var(--ms-text-color-3);--ms-counter-badge-bg: var(--ms-accent-color);--ms-counter-badge-bg-hover: var(--ms-accent-color-hover);--ms-counter-badge-color: var(--ms-text-color-on-accent);--ms-hint-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-hint-color: var(--ms-text-color-4);--ms-hint-border-color: var(--ms-border-color);--ms-dropdown-bg: var(--base-dropdown-bg, var(--base-elevated-bg, light-dark(#ffffff, #1a1a1a)));--ms-dropdown-text-color: var(--ms-text-color-1);--ms-dropdown-border-color: var(--ms-border-color);--ms-dropdown-box-shadow-semantic: var(--base-dropdown-box-shadow, 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1));--ms-actions-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-actions-border-color: var(--ms-border-color);--ms-action-button-bg: transparent;--ms-action-button-bg-hover: var(--ms-primary-bg);--ms-action-button-border-color: var(--ms-border-color);--ms-action-button-border-color-hover: var(--ms-accent-color);--ms-action-button-color: var(--ms-text-color-1);--ms-group-border-color: var(--ms-border-color);--ms-option-text-color: var(--ms-text-color-1);--ms-option-bg: transparent;--ms-option-bg-hover: var(--ms-primary-bg);--ms-option-color-hover: inherit;--ms-option-bg-focused: var(--ms-primary-bg);--ms-option-color-focused: inherit;--ms-option-outline-color-focused: var(--ms-accent-color);--ms-option-bg-selected: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-option-bg-matched: color-mix(in srgb, var(--ms-accent-color) 8%, transparent);--ms-option-color-matched: inherit;--ms-option-border-matched-color: color-mix(in srgb, var(--ms-accent-color) 40%, transparent);--ms-option-title-color: var(--ms-text-color-1);--ms-option-subtitle-color: var(--ms-text-color-3);--ms-option-mark-bg: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-option-mark-color: inherit;--ms-loading-color: var(--ms-text-color-3);--ms-badge-bg: var(--ms-accent-color-light);--ms-badge-bg-hover: var(--base-hover-bg, var(--ms-accent-color-light-hover));--ms-badge-bg-active: var(--ms-accent-color-light-hover);--ms-badge-text-bg-hover: var(--base-hover-bg, var(--ms-accent-color-light-hover));--ms-badge-text-color-hover: var(--ms-badge-text-color);--ms-badge-counter-border-color: var(--ms-border-color);--ms-badge-counter-text-bg: var(--ms-primary-bg-hover);--ms-badge-counter-text-color: var(--ms-text-color-1);--ms-badge-counter-remove-bg: var(--ms-text-color-3);--ms-badge-counter-remove-bg-hover: var(--ms-text-color-1);--ms-badge-counter-remove-color: var(--ms-text-color-on-accent);--ms-counter-wrapper-border-color: var(--ms-border-color);--ms-count-clear-bg-hover: var(--ms-accent-color);--ms-tooltip-bg: var(--base-tooltip-bg, var(--base-inverse-bg, light-dark(#333333, #f5f5f5)));--ms-tooltip-text-color: var(--base-tooltip-text-color, light-dark(#ffffff, #1a1a1a));--ms-selected-popover-bg: var(--base-dropdown-bg, var(--base-elevated-bg, light-dark(#ffffff, #1a1a1a)));--ms-selected-popover-border-color: var(--ms-border-color);--ms-selected-popover-header-border-color: var(--ms-border-color);--ms-selected-popover-close-bg-hover: var(--ms-accent-color);--ms-input-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-input-padding-right: calc(4 * var(--ms-rem));--ms-input-padding-h: calc(1.2 * var(--ms-rem));--ms-input-height: calc(var(--base-input-size-md-height, 3.5) * var(--ms-rem));--ms-input-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-input-border-width: 1px;--ms-input-border-radius: var(--ms-border-radius-md);--ms-input-text: var(--ms-text-color-1);--ms-input-bg-disabled: rgba(107, 114, 128, .05);--ms-toggle-right: calc(1.2 * var(--ms-rem));--ms-toggle-color: var(--ms-text-color-3);--ms-transform-center-y: translateY(-50%);--ms-transform-rotate-180: 180deg;--ms-counter-offset: calc(3.2 * var(--ms-rem));--ms-counter-padding: calc(.2 * var(--ms-rem)) calc(.4 * var(--ms-rem));--ms-counter-bg: var(--ms-accent-color);--ms-counter-color: var(--ms-text-color-on-accent);--ms-counter-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-counter-font-weight: var(--base-font-weight-semibold, 600);--ms-counter-border-radius: var(--ms-border-radius-sm);--ms-counter-bg-hover: var(--ms-accent-color-hover);--ms-transform-scale-hover: 1.1;--ms-hint-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-hint-border: 1px solid var(--ms-hint-border-color);--ms-hint-border-radius: var(--ms-border-radius-lg);--ms-hint-box-shadow: 0 4px 6px -1px rgb(0 0 0 / .1), 0 2px 4px -2px rgb(0 0 0 / .1);--ms-hint-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-dropdown-border: var(--base-dropdown-border, 1px solid var(--ms-dropdown-border-color));--ms-dropdown-border-radius: var(--ms-border-radius-lg);--ms-dropdown-box-shadow: 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1);--ms-input-current-width: auto;--ms-dropdown-width: var(--ms-input-current-width);--ms-options-max-height: calc(32 * var(--ms-rem));--ms-option-color: var(--ms-text-color-1);--ms-z-index-dropdown: 9999;--ms-z-index-sticky: 1;--ms-actions-gap: calc(.4 * var(--ms-rem));--ms-actions-padding: calc(.8 * var(--ms-rem));--ms-actions-border-bottom: 1px solid var(--ms-actions-border-color);--ms-action-btn-padding: calc(.4 * var(--ms-rem)) calc(.8 * var(--ms-rem));--ms-action-btn-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-action-btn-border: var(--ms-border);--ms-action-btn-border-radius: var(--ms-border-radius-sm);--ms-action-btn-bg: transparent;--ms-action-btn-color: inherit;--ms-action-btn-bg-hover: var(--ms-primary-bg);--ms-action-btn-border-color-hover: var(--ms-accent-color);--ms-transform-scale-active: .98;--ms-options-padding: 0;--ms-group-border-top: 1px solid var(--ms-group-border-color);--ms-group-margin-top: calc(.4 * var(--ms-rem));--ms-group-padding-top: calc(.4 * var(--ms-rem));--ms-group-label-padding: calc(.4 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-group-label-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-group-label-font-weight: var(--base-font-weight-semibold, 600);--ms-group-label-color: var(--ms-text-color-3);--ms-group-label-transform: uppercase;--ms-group-label-letter-spacing: .05em;--ms-option-gap: calc(.8 * var(--ms-rem));--ms-option-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-option-padding-h: calc(1.2 * var(--ms-rem));--ms-option-min-height: auto;--ms-option-outline-focused: 2px solid var(--ms-option-outline-color-focused);--ms-option-focus-outline-offset: -2px;--ms-option-border-matched: 3px solid var(--ms-option-border-matched-color);--ms-option-bg-focused-hover: var(--ms-primary-bg);--ms-option-bg-matched-hover: color-mix(in srgb, var(--ms-accent-color) 12%, transparent);--ms-option-bg-selected-focused: color-mix(in srgb, var(--ms-accent-color) 15%, transparent);--ms-option-bg-selected-matched: color-mix(in srgb, var(--ms-accent-color) 15%, transparent);--ms-option-disabled-bg: var(--base-disabled-bg, transparent);--ms-option-bg-disabled-selected: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-disabled-opacity: .5;--ms-option-content-gap: calc(.8 * var(--ms-rem));--ms-option-icon-size: calc(2 * var(--ms-rem));--ms-option-icon-font-size: calc(var(--base-font-size-base, 1.6) * var(--ms-rem));--ms-option-title-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-option-mark-font-weight: var(--base-font-weight-semibold, 600);--ms-option-title-white-space: normal;--ms-option-title-overflow: visible;--ms-option-title-text-overflow: clip;--ms-option-subtitle-margin-top: calc(.4 * var(--ms-rem));--ms-option-subtitle-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-option-subtitle-line-height: var(--base-line-height-tight, 1.25);--ms-checkbox-margin-top: calc(.2 * var(--ms-rem));--ms-checkbox-margin-right: 0;--ms-checkbox-margin-bottom: 0;--ms-checkbox-margin-left: 0;--ms-checkbox-size: calc(1.6 * var(--ms-rem));--ms-checkbox-scale: 1;--ms-checkbox-align: center;--ms-checkbox-bg: var(--ms-input-bg);--ms-checkbox-border-width: 1px;--ms-checkbox-border-color: var(--base-checkbox-border-color, #8f8f8f);--ms-checkbox-border: var(--ms-checkbox-border-width) solid var(--ms-checkbox-border-color);--ms-checkbox-border-radius: calc(.3 * var(--ms-rem));--ms-checkbox-checkmark-thickness: 2.5px;--ms-checkbox-checked-bg: var(--ms-accent-color);--ms-checkbox-checked-border: var(--ms-checkbox-border-width) solid var(--ms-accent-color);--ms-checkbox-checkmark-color: var(--ms-text-color-on-accent);--ms-checkbox-hover-border-color: var(--ms-accent-color);--ms-checkbox-disabled-bg: var(--ms-primary-bg);--ms-checkbox-disabled-border: var(--ms-checkbox-border-width) solid var(--ms-border-color);--ms-checkbox-checked-bg-hover: var(--ms-accent-color-hover);--ms-checkbox-checked-border-color-hover: var(--ms-accent-color-hover);--ms-state-min-height: calc(8 * var(--ms-rem));--ms-empty-padding: calc(1.6 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-empty-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-empty-color: var(--ms-text-color-3);--ms-loader-padding: calc(1.6 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-loader-gap: calc(.8 * var(--ms-rem));--ms-loading-text-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-loading-text-color: var(--ms-text-color-3);--ms-badges-gap: calc(.8 * var(--ms-rem));--ms-badges-margin-bottom: calc(.8 * var(--ms-rem));--ms-badges-margin-top: calc(.8 * var(--ms-rem));--ms-badges-margin-left: calc(.4 * var(--ms-rem));--ms-badges-margin-right: calc(.4 * var(--ms-rem));--ms-inline-align: center;--ms-badge-gap: calc(.8 * var(--ms-rem));--ms-badge-height: calc(2.7 * var(--ms-rem));--ms-badge-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-badge-font-weight: var(--base-font-weight-semibold, 600);--ms-badge-border-radius: var(--ms-border-radius-sm);--ms-order-first: -1;--ms-badge-text-padding: 0 calc(.8 * var(--ms-rem));--ms-badge-text-bg: var(--ms-accent-color-light);--ms-badge-text-color: var(--ms-accent-color);--ms-badge-text-border: none;--ms-badge-remove-width: calc(2.7 * var(--ms-rem));--ms-badge-remove-bg: var(--ms-accent-color);--ms-badge-remove-color: var(--ms-text-color-on-accent);--ms-badge-remove-border: none;--ms-badge-remove-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-badge-remove-bg-hover: var(--ms-accent-color-hover);--ms-badge-remove-box-shadow-focus: 0 0 0 2px color-mix(in srgb, var(--ms-accent-color) 50%, transparent);--ms-badge-remove-icon-size: calc(1 * var(--ms-rem));--ms-icon-remove: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M6 6L18 18M18 6L6 18' stroke='black' stroke-width='2.5' stroke-linecap='round' fill='none'/></svg>");--ms-badge-counter-bg: transparent;--ms-badge-counter-border: 1px solid var(--ms-badge-counter-border-color);--ms-badge-counter-border-radius: var(--ms-border-radius-sm);--ms-more-badge-bg: var(--ms-accent-color-light);--ms-more-badge-hover-bg: var(--ms-badge-bg-hover);--ms-more-badge-active-bg: var(--ms-accent-color-light-hover);--ms-count-display-margin-bottom: calc(.8 * var(--ms-rem));--ms-count-display-margin-top: calc(.8 * var(--ms-rem));--ms-count-display-margin-left: calc(.8 * var(--ms-rem));--ms-count-display-margin-right: calc(.8 * var(--ms-rem));--ms-counter-wrapper-bg: transparent;--ms-counter-wrapper-border: var(--ms-border);--ms-counter-wrapper-border-radius: var(--ms-border-radius-sm);--ms-counter-wrapper-padding: calc(.4 * var(--ms-rem)) calc(.8 * var(--ms-rem));--ms-counter-wrapper-gap: calc(.4 * var(--ms-rem));--ms-counter-wrapper-bg-hover: var(--ms-primary-bg);--ms-counter-wrapper-border-color-hover: var(--ms-accent-color);--ms-count-text-bg: transparent;--ms-count-text-border: none;--ms-count-text-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-count-text-color: var(--ms-text-color-1);--ms-count-clear-size: calc(1.6 * var(--ms-rem));--ms-count-clear-bg: transparent;--ms-count-clear-color: var(--ms-text-color-3);--ms-count-clear-font-size: calc(var(--base-font-size-lg, 1.8) * var(--ms-rem));--ms-count-clear-border-radius: var(--ms-border-radius-sm);--ms-count-clear-bg-hover: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-count-clear-color-hover: var(--ms-accent-color);--ms-count-clear-icon-size: calc(1.4 * var(--ms-rem));--ms-icon-clear: var(--ms-icon-remove);--ms-tooltip-color: var(--ms-tooltip-text-color);--ms-tooltip-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-tooltip-border-radius: var(--ms-border-radius-lg);--ms-tooltip-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-tooltip-max-width: calc(32 * var(--ms-rem));--ms-tooltip-shadow: 0 2px 8px rgba(0, 0, 0, .15);--ms-tooltip-z-index: 10000;--ms-option-tooltip-bg: var(--ms-tooltip-bg);--ms-option-tooltip-text-color: var(--ms-tooltip-text-color);--ms-option-tooltip-padding: var(--ms-tooltip-padding);--ms-option-tooltip-border-radius: var(--ms-tooltip-border-radius);--ms-option-tooltip-font-size: var(--ms-tooltip-font-size);--ms-option-tooltip-max-width: var(--ms-tooltip-max-width);--ms-option-tooltip-shadow: var(--ms-tooltip-shadow);--ms-option-tooltip-z-index: var(--ms-tooltip-z-index);--ms-z-index-popover: 10000;--ms-selected-popover-width: calc(32 * var(--ms-rem));--ms-selected-popover-max-height: calc(32 * var(--ms-rem));--ms-selected-popover-border: 1px solid var(--ms-selected-popover-border-color);--ms-selected-popover-border-radius: var(--ms-border-radius-lg);--ms-selected-popover-box-shadow: 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1);--ms-selected-popover-header-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-selected-popover-header-bg: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-selected-popover-header-border-bottom: 1px solid var(--ms-selected-popover-header-border-color);--ms-selected-popover-header-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-selected-popover-header-font-weight: var(--base-font-weight-semibold, 600);--ms-selected-popover-header-color: var(--ms-text-color-1);--ms-popover-close-size: calc(2.4 * var(--ms-rem));--ms-selected-popover-close-bg: transparent;--ms-selected-popover-close-color: var(--ms-text-color-3);--ms-selected-popover-close-font-size: calc(var(--base-font-size-xl, 2) * var(--ms-rem));--ms-selected-popover-close-border-radius: var(--ms-border-radius-sm);--ms-selected-popover-close-bg-hover: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-selected-popover-close-color-hover: var(--ms-accent-color);--ms-selected-popover-close-icon-size: calc(1.4 * var(--ms-rem));--ms-selected-popover-body-gap: calc(.4 * var(--ms-rem));--ms-selected-popover-body-padding: calc(.8 * var(--ms-rem));--ms-selected-popover-body-max-height: calc(28.8 * var(--ms-rem));--ms-font-size-2xs: calc(var(--base-font-size-2xs, 1) * var(--ms-rem));--ms-font-size-xs: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-font-size-sm: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-font-size-base: calc(var(--base-font-size-base, 1.6) * var(--ms-rem));--ms-font-size-lg: calc(var(--base-font-size-lg, 1.8) * var(--ms-rem));--ms-font-weight-normal: var(--base-font-weight-normal, 400);--ms-font-weight-medium: var(--base-font-weight-medium, 500);--ms-font-weight-semibold: var(--base-font-weight-semibold, 600);--ms-line-height-none: 1;--ms-line-height-tight: var(--base-line-height-tight, 1.25);--ms-line-height-normal: var(--base-line-height-normal, 1.5);--ms-line-height-relaxed: var(--base-line-height-relaxed, 1.75);--ms-border-radius-sm: calc(var(--base-border-radius-sm, .4) * var(--ms-rem));--ms-border-radius-md: calc(var(--base-border-radius-md, .6) * var(--ms-rem));--ms-border-radius-lg: calc(var(--base-border-radius-lg, .8) * var(--ms-rem));--ms-border-radius: var(--ms-border-radius-md);--ms-spacing-xs: calc(.4 * var(--ms-rem));--ms-spacing-sm: calc(.8 * var(--ms-rem));--ms-spacing-md: calc(1.2 * var(--ms-rem));--ms-spacing-lg: calc(1.6 * var(--ms-rem));--ms-transition-fast: .15s;--ms-transition-normal: .2s;--ms-easing-snappy: cubic-bezier(.4, 0, .2, 1);--ms-placeholder-opacity: .6;--ms-disabled-input-opacity: .6;--ms-scrollbar-width: 8px;--ms-scrollbar-track-bg: transparent;--ms-scrollbar-thumb-bg: var(--ms-border-color);--ms-scrollbar-thumb-bg-hover: var(--ms-text-color-3);--ms-scrollbar-thumb-border-radius: 4px;--ms-debug-bg: var(--base-elevated-bg, light-dark(#f9fafb, #2b2b2b));--ms-debug-border-color: var(--ms-border-color);--ms-debug-text-color: var(--ms-text-color-1);--ms-debug-border-radius: var(--ms-border-radius-md);--ms-debug-summary-color: var(--ms-accent-color);--ms-debug-summary-bg-hover: var(--ms-primary-bg);--ms-debug-summary-outline-color: var(--ms-accent-color);--ms-debug-summary-border-radius: var(--ms-border-radius-sm);--ms-debug-stats-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-debug-stats-border-radius: var(--ms-border-radius-sm);--ms-debug-bullet-color: var(--ms-accent-color)}}@layer component{web-multiselect:not(:defined){display:block;min-height:calc(3.5 * var(--ms-rem));color:transparent!important;background:transparent}.ms__wrapper{display:flex;flex-direction:column;align-items:stretch}.ms__wrapper--inline{flex-direction:row;align-items:var(--ms-inline-align, center)}.ms{position:relative;width:100%}}@layer component{.ms__input-wrapper{position:relative;display:flex;align-items:center}.ms__input{box-sizing:border-box;width:100%;font-family:inherit;height:var(--ms-input-height);padding:var(--ms-input-padding);padding-right:var(--ms-input-padding-right);font-size:var(--ms-input-font-size);border:var(--ms-input-border);border-radius:var(--ms-input-border-radius);background:var(--ms-input-bg);color:var(--ms-input-color);cursor:pointer;transition:border var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__input:hover:not(:focus):not(:disabled){border:var(--ms-input-border-hover)}.ms__input:focus{outline:none;border:var(--ms-input-border-focus)}.ms__input::placeholder{color:var(--ms-input-placeholder-color);opacity:0;transition:opacity var(--ms-transition-fast) var(--ms-easing-snappy)}:host([data-ready]) .ms__input::placeholder{opacity:var(--ms-placeholder-opacity)}.ms__toggle{position:absolute;right:var(--ms-toggle-right);top:50%;transform:var(--ms-transform-center-y);pointer-events:none;color:var(--ms-toggle-icon-color);transition:transform var(--ms-transition-fast) var(--ms-easing-snappy)}.ms--open .ms__toggle{transform:var(--ms-transform-center-y) rotate(var(--ms-transform-rotate-180));color:var(--ms-toggle-icon-color-open)}.ms__counter{position:absolute;right:var(--ms-counter-offset);top:50%;transform:var(--ms-transform-center-y);padding:var(--ms-counter-padding);background:var(--ms-counter-badge-bg);color:var(--ms-counter-badge-color);font-size:var(--ms-counter-font-size);font-weight:var(--ms-counter-font-weight);border-radius:var(--ms-counter-border-radius);cursor:pointer;transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__counter:hover{background:var(--ms-counter-badge-bg-hover);transform:var(--ms-transform-center-y) scale(var(--ms-transform-scale-hover))}.ms__actions{display:flex;flex-direction:column;gap:var(--ms-actions-gap);padding:var(--ms-actions-padding)}.ms__actions--top{border-bottom:var(--ms-actions-border-bottom)}.ms__actions--bottom{flex-direction:column-reverse;border-top:var(--ms-actions-border-bottom)}.ms__actions-row{display:flex;flex-wrap:nowrap;gap:var(--ms-actions-gap)}.ms__actions--wrap .ms__actions-row{flex-wrap:wrap}.ms__actions--sticky{position:sticky;z-index:var(--ms-z-index-sticky);background:var(--ms-actions-bg)}.ms__actions--sticky.ms__actions--top{top:0}.ms__actions--sticky.ms__actions--bottom{bottom:0}.ms__actions--align-stretch .ms__action-btn{flex:1}.ms__actions--align-left .ms__actions-row{justify-content:flex-start}.ms__actions--align-right .ms__actions-row{justify-content:flex-end}.ms__actions--align-center .ms__actions-row{justify-content:center}.ms__actions--align-space-between .ms__actions-row{justify-content:space-between}.ms__action-btn{font-family:inherit;padding:var(--ms-action-btn-padding);font-size:var(--ms-action-btn-font-size);border:var(--ms-action-btn-border);border-radius:var(--ms-action-btn-border-radius);background:var(--ms-action-button-bg);color:var(--ms-action-button-color);cursor:pointer;transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__action-btn:hover{background:var(--ms-action-button-bg-hover);border-color:var(--ms-action-button-border-color-hover)}.ms__action-btn:active{transform:scale(var(--ms-transform-scale-active))}.ms__action-btn:disabled,.ms__action-btn[disabled]{opacity:var(--ms-disabled-opacity);cursor:not-allowed;pointer-events:none}}@layer component{.ms__hint{display:none;position:fixed;z-index:var(--ms-z-index-popover);padding:var(--ms-hint-padding);background:var(--ms-hint-bg);border:var(--ms-hint-border);border-radius:var(--ms-hint-border-radius);box-shadow:var(--ms-hint-box-shadow);font-size:var(--ms-hint-font-size);color:var(--ms-hint-color);line-height:var(--ms-line-height-relaxed);max-width:100%}.ms__hint--visible{display:block}.ms__dropdown{display:none;position:fixed;font-family:inherit;z-index:var(--ms-z-index-dropdown);background:var(--ms-dropdown-bg);border:var(--ms-dropdown-border);border-radius:var(--ms-dropdown-border-radius);box-shadow:var(--ms-dropdown-box-shadow);width:var(--ms-dropdown-width);max-height:var(--ms-options-max-height);overflow:hidden;color:var(--ms-dropdown-text-color)}.ms__dropdown--visible{display:flex;flex-direction:column}.ms__dropdown-inner{flex:1;overflow-y:auto;overscroll-behavior:contain;touch-action:pan-y;-webkit-overflow-scrolling:touch;scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__dropdown-inner::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__dropdown-inner::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__dropdown-inner::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__dropdown-inner::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__dropdown--virtual{max-height:none}.ms__dropdown--virtual .ms__dropdown-inner{overflow-y:visible}.ms__badge-tooltip{position:fixed;z-index:var(--ms-tooltip-z-index);opacity:0;visibility:hidden;transition:opacity var(--ms-transition-normal) ease,visibility var(--ms-transition-normal) ease;background:var(--ms-tooltip-bg);color:var(--ms-tooltip-text-color);padding:var(--ms-tooltip-padding);border-radius:var(--ms-tooltip-border-radius);font-size:var(--ms-tooltip-font-size);line-height:var(--ms-line-height-relaxed);max-width:var(--ms-tooltip-max-width);word-wrap:break-word;white-space:pre-wrap;box-shadow:var(--ms-tooltip-shadow);pointer-events:none}.ms__badge-tooltip--visible{opacity:1;visibility:visible}.ms__option-tooltip{position:fixed;z-index:var(--ms-option-tooltip-z-index);opacity:0;visibility:hidden;transition:opacity var(--ms-transition-normal) ease,visibility var(--ms-transition-normal) ease;background:var(--ms-option-tooltip-bg);color:var(--ms-option-tooltip-text-color);padding:var(--ms-option-tooltip-padding);border-radius:var(--ms-option-tooltip-border-radius);font-size:var(--ms-option-tooltip-font-size);line-height:var(--ms-line-height-relaxed);max-width:var(--ms-option-tooltip-max-width);word-wrap:break-word;white-space:pre-wrap;box-shadow:var(--ms-option-tooltip-shadow);pointer-events:none}.ms__option-tooltip--visible{opacity:1;visibility:visible}.ms__selected-popover{display:none;position:fixed;z-index:var(--ms-z-index-popover);background:var(--ms-selected-popover-bg);border:var(--ms-selected-popover-border);border-radius:var(--ms-selected-popover-border-radius);box-shadow:var(--ms-selected-popover-box-shadow);width:var(--ms-selected-popover-width);max-height:var(--ms-selected-popover-max-height);overflow:hidden}.ms__selected-popover--visible{display:flex;flex-direction:column}.ms__selected-popover--virtual{display:block;overflow:visible;max-height:none}.ms__selected-popover-header{display:flex;align-items:center;justify-content:space-between;padding:var(--ms-selected-popover-header-padding);background:var(--ms-selected-popover-header-bg);border-bottom:var(--ms-selected-popover-header-border-bottom);font-size:var(--ms-selected-popover-header-font-size);font-weight:var(--ms-selected-popover-header-font-weight);color:var(--ms-selected-popover-header-color)}.ms__selected-popover-close{display:flex;align-items:center;justify-content:center;width:var(--ms-popover-close-size);height:var(--ms-popover-close-size);padding:0;border:none;background:var(--ms-selected-popover-close-bg);color:var(--ms-selected-popover-close-color);font-size:var(--ms-selected-popover-close-font-size);line-height:var(--ms-line-height-none);cursor:pointer;border-radius:var(--ms-selected-popover-close-border-radius);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__selected-popover-close:hover{background:var(--ms-selected-popover-close-bg-hover);color:var(--ms-selected-popover-close-color-hover)}.ms__selected-popover-close:before{content:"";display:block;width:var(--ms-selected-popover-close-icon-size);height:var(--ms-selected-popover-close-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-remove) center / contain no-repeat;mask:var(--ms-icon-remove) center / contain no-repeat}.ms__selected-popover-body{display:flex;flex-direction:column;gap:var(--ms-selected-popover-body-gap);padding:var(--ms-selected-popover-body-padding);overflow-y:auto;max-height:var(--ms-selected-popover-body-max-height);scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__selected-popover-body::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__selected-popover-body::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__selected-popover-body::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__selected-popover-body::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__selected-popover-body .ms__badge{width:100%;min-height:fit-content;line-height:var(--ms-line-height-relaxed)}.ms__selected-popover-body .ms__badge-text{flex:1;min-width:0;white-space:normal;word-wrap:break-word}.ms__selected-popover-body--virtual{display:block;max-height:none;padding:0}.ms__selected-popover-body--virtual .ms__badge{height:var(--ms-badge-height-virtual, 36px);min-height:var(--ms-badge-height-virtual, 36px);max-height:var(--ms-badge-height-virtual, 36px);margin-bottom:var(--ms-selected-popover-body-gap);overflow:hidden;box-sizing:border-box}.ms__selected-popover-body--virtual .ms__badge-text{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}}@layer component{.ms--disabled .ms__input{opacity:var(--ms-disabled-input-opacity);cursor:not-allowed;background:var(--ms-input-bg-disabled)}.ms--disabled .ms__toggle{opacity:var(--ms-disabled-input-opacity)}.ms--no-checkboxes .ms__option{gap:0;padding-left:var(--ms-option-padding-h)}.ms--no-checkboxes .ms__option-content{padding-left:0}}@layer component;@layer component{.ms__badges{display:flex;flex-wrap:wrap;gap:var(--ms-badges-gap);padding:0}.ms__badges:empty{display:none}.ms__badges--bottom{margin-top:var(--ms-badges-margin-bottom)}.ms__badges--top{margin-bottom:var(--ms-badges-margin-top);order:var(--ms-order-first)}.ms__badges--left{order:var(--ms-order-first);margin-right:var(--ms-badges-margin-left);justify-content:flex-end}.ms__badges--right{margin-left:var(--ms-badges-margin-right);justify-content:flex-start}.ms__badge{display:inline-flex;align-items:center;height:var(--ms-badge-height);font-size:var(--ms-badge-font-size);font-weight:var(--ms-badge-font-weight);line-height:var(--ms-line-height-none);border-radius:var(--ms-badge-border-radius);overflow:hidden;max-width:100%}.ms__badge-text{display:flex;align-items:center;box-sizing:border-box;height:100%;padding:var(--ms-badge-text-padding);background:var(--ms-badge-text-bg);color:var(--ms-badge-text-color);border:var(--ms-badge-text-border);border-right:none;border-radius:var(--ms-badge-border-radius) 0 0 var(--ms-badge-border-radius);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;transition:background-color var(--ms-transition-normal) ease,color var(--ms-transition-normal) ease}.ms__badge:hover .ms__badge-text{background:var(--ms-badge-text-bg-hover, var(--ms-badge-text-bg));color:var(--ms-badge-text-color-hover, var(--ms-badge-text-color))}.ms__badge-remove{display:flex;align-items:center;justify-content:center;box-sizing:border-box;font-family:inherit;width:var(--ms-badge-remove-width);height:100%;flex-shrink:0;background:var(--ms-badge-remove-bg);color:var(--ms-badge-remove-color);border:var(--ms-badge-remove-border);border-left:none;border-radius:0 var(--ms-badge-border-radius) var(--ms-badge-border-radius) 0;cursor:pointer;transition:background-color var(--ms-transition-normal) ease;font-size:var(--ms-badge-remove-font-size)}.ms__badge-remove:hover{background:var(--ms-badge-remove-bg-hover)}.ms__badge-remove:focus{outline:none}.ms__badge-remove:focus-visible{outline:none;box-shadow:var(--ms-badge-remove-box-shadow-focus)}.ms__badge-remove:before{content:"";display:block;width:var(--ms-badge-remove-icon-size);height:var(--ms-badge-remove-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-remove) center / contain no-repeat;mask:var(--ms-icon-remove) center / contain no-repeat}.ms__badge--counter{cursor:pointer}.ms__badge--counter .ms__badge-text{background:var(--ms-badge-counter-text-bg);color:var(--ms-badge-counter-text-color);border:var(--ms-badge-counter-border);border-right:none}.ms__badge--counter .ms__badge-remove{background:var(--ms-badge-counter-remove-bg);color:var(--ms-badge-counter-remove-color);border:var(--ms-badge-counter-border);border-left:none}.ms__badge--counter .ms__badge-remove:hover{background:var(--ms-badge-counter-remove-bg-hover)}.ms__badge--more,.ms__badge[data-action=show-selected]{cursor:pointer}}@layer component{.ms__count-display{display:flex;align-items:center}.ms__count-display:empty{display:none}.ms__count-display--bottom{margin-top:var(--ms-count-display-margin-bottom)}.ms__count-display--top{margin-bottom:var(--ms-count-display-margin-top);order:var(--ms-order-first)}.ms__count-display--left{order:var(--ms-order-first);margin-right:var(--ms-count-display-margin-left);justify-content:flex-start}.ms__count-display--right{margin-left:var(--ms-count-display-margin-right);justify-content:flex-end}.ms__counter-wrapper{display:inline-flex;align-items:center;gap:var(--ms-counter-wrapper-gap);background:var(--ms-counter-wrapper-bg);border:var(--ms-counter-wrapper-border);border-radius:var(--ms-counter-wrapper-border-radius);padding:var(--ms-counter-wrapper-padding);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__counter-wrapper:hover{background:var(--ms-counter-wrapper-bg-hover);border-color:var(--ms-counter-wrapper-border-color-hover)}.ms__count-text{display:inline-flex;align-items:center;background:var(--ms-count-text-bg);border:var(--ms-count-text-border);padding:0;font-size:var(--ms-count-text-font-size);color:var(--ms-count-text-color);cursor:pointer;transition:color var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__count-clear{flex-shrink:0;display:flex;align-items:center;justify-content:center;width:var(--ms-count-clear-size);height:var(--ms-count-clear-size);padding:0;border:none;background:var(--ms-count-clear-bg);color:var(--ms-count-clear-color);font-size:var(--ms-count-clear-font-size);line-height:var(--ms-line-height-none);cursor:pointer;border-radius:var(--ms-count-clear-border-radius);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__count-clear:hover{background:var(--ms-count-clear-bg-hover);color:var(--ms-count-clear-color-hover)}.ms__count-clear:before{content:"";display:block;width:var(--ms-count-clear-icon-size);height:var(--ms-count-clear-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-clear) center / contain no-repeat;mask:var(--ms-icon-clear) center / contain no-repeat}}@layer component{.ms__debug-info{margin-top:calc(.4 * var(--ms-rem));padding:calc(.4 * var(--ms-rem));background-color:var(--ms-debug-bg);border:1px solid var(--ms-debug-border-color);border-radius:var(--ms-debug-border-radius);font-size:calc(1.2 * var(--ms-rem));color:var(--ms-debug-text-color)}.ms__debug-info details summary{cursor:pointer;font-weight:600;color:var(--ms-debug-summary-color);-webkit-user-select:none;user-select:none;padding:calc(.4 * var(--ms-rem));border-radius:var(--ms-debug-summary-border-radius)}.ms__debug-info details summary:hover{background-color:var(--ms-debug-summary-bg-hover)}.ms__debug-info details summary:focus{outline:2px solid var(--ms-debug-summary-outline-color);outline-offset:2px}.ms__debug-info .ms__debug-stats{display:flex;flex-direction:column;gap:calc(.4 * var(--ms-rem));margin-top:calc(.4 * var(--ms-rem));padding:calc(.4 * var(--ms-rem));background-color:var(--ms-debug-stats-bg);border-radius:var(--ms-debug-stats-border-radius)}.ms__debug-info .ms__debug-stats span{display:flex;justify-content:space-between;padding:2px 4px;font-family:monospace;font-size:calc(1 * var(--ms-rem))}.ms__debug-info .ms__debug-stats span:before{content:"•";margin-right:calc(.4 * var(--ms-rem));color:var(--ms-debug-bullet-color)}}@layer component{.ms__options{padding:var(--ms-options-padding);scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__options::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__options::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__options::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__options::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__options--virtual .ms__option,.ms__options--fixed-height .ms__option{height:var(--ms-option-height, 50px);min-height:var(--ms-option-height, 50px);max-height:var(--ms-option-height, 50px);overflow:hidden;box-sizing:border-box}.ms__group+.ms__group{border-top:var(--ms-group-border-top);margin-top:var(--ms-group-margin-top);padding-top:var(--ms-group-padding-top)}.ms__group-label{padding:var(--ms-group-label-padding);font-size:var(--ms-group-label-font-size);font-weight:var(--ms-group-label-font-weight);color:var(--ms-group-label-color);text-transform:var(--ms-group-label-transform);letter-spacing:var(--ms-group-label-letter-spacing)}.ms__option{display:flex;align-items:var(--ms-checkbox-align, center);gap:var(--ms-option-gap);padding:var(--ms-option-padding);min-height:var(--ms-option-min-height, auto);color:var(--ms-option-text-color);background:var(--ms-option-bg);cursor:pointer;user-select:none;-webkit-user-select:none}.ms__option:hover{background:var(--ms-option-bg-hover);color:var(--ms-option-color-hover, inherit)}.ms__option--focused{background:var(--ms-option-bg-focused);color:var(--ms-option-color-focused, inherit);outline:var(--ms-option-outline-focused);outline-offset:var(--ms-option-focus-outline-offset)}.ms__option--matched{background:var(--ms-option-bg-matched);color:var(--ms-option-color-matched, inherit);border-left:var(--ms-option-border-matched)}.ms__option--selected{background:var(--ms-option-bg-selected)}.ms__option--selected:hover{background:var(--ms-option-bg-selected-hover, var(--ms-option-bg-selected))}.ms__option--disabled{opacity:var(--ms-disabled-opacity);cursor:not-allowed;background:var(--ms-option-disabled-bg)}.ms__option--disabled:hover{background:var(--ms-option-disabled-bg)}.ms__option--focused:hover{background:var(--ms-option-bg-focused-hover);color:var(--ms-option-color-focused-hover, var(--ms-option-color-focused, var(--ms-option-text-color)))}.ms__option--matched:hover{background:var(--ms-option-bg-matched-hover);color:var(--ms-option-color-matched-hover, var(--ms-option-color-matched, var(--ms-option-text-color)))}.ms__option--selected.ms__option--focused{background:var(--ms-option-bg-selected-focused);outline:var(--ms-option-outline-focused);outline-offset:var(--ms-option-focus-outline-offset)}.ms__option--selected.ms__option--matched{background:var(--ms-option-bg-selected-matched);border-left:var(--ms-option-border-matched)}.ms__option--disabled.ms__option--selected{background:var(--ms-option-bg-disabled-selected)}.ms__option--disabled.ms__option--focused{outline:none}.ms__option[data-checkbox-align=top]{--ms-checkbox-align: flex-start}.ms__option[data-checkbox-align=bottom]{--ms-checkbox-align: flex-end}.ms__checkbox{appearance:none;-webkit-appearance:none;-moz-appearance:none;flex-shrink:0;position:relative;margin-top:var(--ms-checkbox-margin-top);margin-right:var(--ms-checkbox-margin-right);margin-bottom:var(--ms-checkbox-margin-bottom);margin-left:var(--ms-checkbox-margin-left);width:var(--ms-checkbox-size);height:var(--ms-checkbox-size);transform:scale(var(--ms-checkbox-scale));transform-origin:top left;cursor:pointer;background:var(--ms-checkbox-bg);border:var(--ms-checkbox-border);border-radius:var(--ms-checkbox-border-radius);transition:background-color .15s ease,border-color .15s ease}.ms__checkbox:after{content:"";position:absolute;display:none;left:50%;top:40%;width:30%;height:55%;transform:translate(-50%,-50%) rotate(45deg);border:solid var(--ms-checkbox-checkmark-color);border-width:0 var(--ms-checkbox-checkmark-thickness, 2px) var(--ms-checkbox-checkmark-thickness, 2px) 0}.ms__checkbox:hover:not(:disabled){border-color:var(--ms-checkbox-hover-border-color)}.ms__checkbox:checked{background:var(--ms-checkbox-checked-bg);border:var(--ms-checkbox-checked-border)}.ms__checkbox:checked:after{display:block}.ms__checkbox--indeterminate{background:var(--ms-checkbox-checked-bg);border:var(--ms-checkbox-checked-border)}.ms__checkbox--indeterminate:after{display:block;top:50%;left:50%;width:55%;height:0;transform:translate(-50%,-50%);border:none;border-bottom:var(--ms-checkbox-checkmark-thickness, 2px) solid var(--ms-checkbox-checkmark-color)}.ms__checkbox--indeterminate:hover:not(:disabled){background:var(--ms-checkbox-checked-bg-hover);border-color:var(--ms-checkbox-checked-border-color-hover)}.ms__checkbox:checked:hover:not(:disabled){background:var(--ms-checkbox-checked-bg-hover);border-color:var(--ms-checkbox-checked-border-color-hover)}.ms__checkbox:focus-visible{outline:2px solid var(--ms-checkbox-checked-bg);outline-offset:2px}.ms__checkbox:disabled{cursor:not-allowed;background:var(--ms-checkbox-disabled-bg);border:var(--ms-checkbox-disabled-border);opacity:.6}.ms__checkbox:disabled:checked{background:var(--ms-checkbox-disabled-bg)}.ms__option--disabled .ms__checkbox{cursor:not-allowed}.ms__option-content{flex:1;display:flex;align-items:center;gap:var(--ms-option-content-gap);min-width:0}.ms__option-icon{flex-shrink:0;width:var(--ms-option-icon-size);height:var(--ms-option-icon-size);display:flex;align-items:center;justify-content:center;font-size:var(--ms-option-icon-font-size)}.ms__option-icon svg{width:100%;height:100%;fill:currentColor}.ms__option-text{flex:1;min-width:0}.ms__option-title{font-size:var(--ms-option-title-font-size);color:var(--ms-option-title-color);line-height:var(--ms-line-height-relaxed);white-space:var(--ms-option-title-white-space, normal);overflow:var(--ms-option-title-overflow, visible);text-overflow:var(--ms-option-title-text-overflow, clip)}.ms__option:hover .ms__option-title{color:var(--ms-option-title-color-hover, var(--ms-option-title-color))}.ms__option--selected .ms__option-title{color:var(--ms-option-title-color-selected, var(--ms-option-title-color))}.ms__option--selected:hover .ms__option-title{color:var(--ms-option-title-color-selected-hover, var(--ms-option-title-color-selected, var(--ms-option-title-color)))}.ms__option-title mark{background:var(--ms-option-mark-bg);color:var(--ms-option-mark-color);font-weight:var(--ms-option-mark-font-weight)}.ms__option-subtitle{margin-top:var(--ms-option-subtitle-margin-top);font-size:var(--ms-option-subtitle-font-size);color:var(--ms-option-subtitle-color);line-height:var(--ms-option-subtitle-line-height)}.ms__option:hover .ms__option-subtitle{color:var(--ms-option-subtitle-color-hover, var(--ms-option-subtitle-color))}.ms__option--selected .ms__option-subtitle{color:var(--ms-option-subtitle-color-selected, var(--ms-option-subtitle-color))}.ms__option--selected:hover .ms__option-subtitle{color:var(--ms-option-subtitle-color-selected-hover, var(--ms-option-subtitle-color-selected, var(--ms-option-subtitle-color)))}.ms__empty{display:flex;align-items:center;justify-content:center;min-height:var(--ms-state-min-height);padding:var(--ms-empty-padding);text-align:center;font-size:var(--ms-empty-font-size);color:var(--ms-empty-color)}.ms__loader{display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:var(--ms-state-min-height);padding:var(--ms-loader-padding);gap:var(--ms-loader-gap)}.ms__loading-text{font-size:var(--ms-loading-text-font-size);color:var(--ms-loading-color)}}@layer component{.ms--rtl .ms__input-wrapper{direction:rtl}.ms--rtl .ms__input{text-align:right;padding-left:var(--ms-input-padding-right);padding-right:var(--ms-input-padding-h)}.ms--rtl .ms__toggle{left:var(--ms-toggle-right)!important;right:auto!important}.ms--rtl .ms__counter{left:var(--ms-counter-offset)!important;right:auto!important}.ms--rtl .ms__dropdown{direction:rtl;text-align:right}.ms--rtl .ms__option{flex-direction:row-reverse}.ms--rtl .ms__checkbox{margin-left:var(--ms-spacing-sm);margin-right:0}.ms--rtl .ms__option-content{text-align:right}.ms--rtl .ms__option-icon{margin-left:var(--ms-spacing-xs);margin-right:0}.ms--rtl .ms__badges{direction:rtl}.ms--rtl .ms__badges--right{margin-left:0;margin-right:var(--ms-badges-margin-right)}.ms--rtl .ms__badges--left{margin-right:0;margin-left:var(--ms-badges-margin-left)}.ms--rtl .ms__badge{flex-direction:row-reverse}.ms--rtl .ms__badge-remove{border-radius:var(--ms-badge-border-radius) 0 0 var(--ms-badge-border-radius);border-left:var(--ms-badge-remove-border);border-right:none}.ms--rtl .ms__badge-text{border-radius:0 var(--ms-badge-border-radius) var(--ms-badge-border-radius) 0;border-right:var(--ms-badge-text-border);border-left:none}.ms--rtl .ms__count-display{direction:rtl}.ms--rtl .ms__count-display--right{margin-left:0;margin-right:var(--ms-count-display-margin-right)}.ms--rtl .ms__count-display--left{margin-right:0;margin-left:var(--ms-count-display-margin-left)}.ms--rtl .ms__counter-wrapper{flex-direction:row-reverse}.ms--rtl .ms__selected-popover{direction:rtl;text-align:right}.ms--rtl .ms__actions{direction:rtl}.ms--rtl .ms__group-label,.ms--rtl .ms__empty{text-align:right}.ms--rtl .ms__hint{direction:rtl;text-align:right}}@layer component{.ms__option--tree{padding-inline-start:calc(var(--ms-tree-base-indent, .75rem) + var(--ms-tree-depth, 0) * var(--ms-tree-indent, 1.25rem))}.ms__option--tree-unselectable{cursor:default}.ms__option--tree-unselectable:hover{background:transparent}}@layer overrides{:host-context([data-theme="dark"]),:host-context([data-bs-theme="dark"]),:host-context(.dark){color-scheme:dark}:host-context([data-theme="light"]),:host-context([data-bs-theme="light"]),:host-context(.light){color-scheme:light}:host([data-theme="dark"]){color-scheme:dark}:host([data-theme="light"]){color-scheme:light}}`, io = [
  "top",
  "top-start",
  "top-end",
  "bottom",
  "bottom-start",
  "bottom-end",
  "left",
  "left-start",
  "left-end",
  "right",
  "right-start",
  "right-end"
], D = () => Wo(), Vi = [
  // ── Strings (cosmetic → update). Optional ones are nullable: absent → null ─
  { configKey: "searchHint", attribute: "search-hint", converter: E({ isNullable: !0 }), on: "update", description: "Small hint text shown beneath the search input." },
  { configKey: "searchPlaceholder", attribute: "search-placeholder", converter: E({ default: "Search..." }), on: "update", description: "Placeholder text for the search input." },
  { configKey: "selectPlaceholder", attribute: "select-placeholder", converter: E({ default: "Pick an option..." }), on: "update", description: "Placeholder shown on the control when nothing is selected." },
  { configKey: "noDataPlaceholder", attribute: "no-data-placeholder", converter: E({ isNullable: !0 }), on: "update", description: "Text shown when there are no options at all." },
  { configKey: "dropdownMinWidth", attribute: "dropdown-min-width", converter: E({ isNullable: !0 }), on: "update", description: "Minimum width of the dropdown panel (any CSS length)." },
  { configKey: "dropdownMaxWidth", attribute: "dropdown-max-width", converter: E({ isNullable: !0 }), on: "update", description: "Maximum width of the dropdown panel (any CSS length)." },
  { configKey: "maxHeight", attribute: "max-height", converter: E({ default: "20rem" }), on: "update", description: "Maximum height of the dropdown list before it scrolls." },
  { configKey: "emptyMessage", attribute: "empty-message", converter: E({ default: "No results found" }), on: "update", description: "Message shown when a search yields no matches." },
  { configKey: "loadingMessage", attribute: "loading-message", converter: E({ default: "Loading..." }), on: "update", description: "Message shown while options are loading." },
  { configKey: "removeButtonTooltipText", attribute: "remove-button-tooltip-text", converter: E({ isNullable: !0 }), on: "update", description: "Tooltip text for a badge remove (×) button." },
  { configKey: "formFieldId", attribute: "name", converter: E({ isNullable: !0 }), on: "reinit", description: "HTML form field name/id used for the hidden input(s)." },
  // ── CSS-var sugar (mirrored to a host style prop in reinit()/update()) ────
  { configKey: "dropdownWidth", attribute: "dropdown-width", converter: E({ isNullable: !0 }), on: "update", description: "Fixed dropdown width; mirrored to the `--ms-dropdown-width` CSS variable." },
  { configKey: "selectedPopoverWidth", attribute: "selected-popover-width", converter: E({ isNullable: !0 }), on: "update", description: "Selected-items popover width; mirrored to `--ms-selected-popover-width`." },
  // ── Member properties (structural → reinit; optional → nullable) ─────────
  { configKey: "valueMember", attribute: "value-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name on an option object that holds its value." },
  { configKey: "displayValueMember", attribute: "display-value-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name that holds an option display label." },
  { configKey: "searchValueMember", attribute: "search-value-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name searched against (falls back to the display value)." },
  { configKey: "iconMember", attribute: "icon-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name that holds an option icon." },
  { configKey: "subtitleMember", attribute: "subtitle-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name that holds an option subtitle." },
  { configKey: "fullTitleMember", attribute: "full-title-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name that holds an option full/long title." },
  { configKey: "groupMember", attribute: "group-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name used to group options under headers." },
  { configKey: "disabledMember", attribute: "disabled-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name that marks an option disabled." },
  // ── Tree of options (structural → reinit; optional → nullable) ───────────
  { configKey: "pathMember", attribute: "path-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name holding a node materialized tree path." },
  { configKey: "parentPathMember", attribute: "parent-path-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name holding a node parent path." },
  { configKey: "levelMember", attribute: "level-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name holding a node depth level." },
  { configKey: "hasChildrenMember", attribute: "has-children-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name flagging that a node has children." },
  { configKey: "isSelectableMember", attribute: "is-selectable-member", converter: E({ isNullable: !0 }), reflect: !0, on: "reinit", description: "Property name marking whether a node can be selected." },
  { configKey: "treePathSeparator", attribute: "tree-path-separator", converter: E({ default: "." }), reflect: !0, on: "reinit", description: "Separator between segments in a materialized tree path." },
  { configKey: "isTreeEnabled", converter: K("tristate"), on: "reinit", type: "boolean", description: "Force tree mode on/off. Property-only; when unset (null) tree mode auto-enables if a path source (path-member / getPathCallback) is present." },
  {
    configKey: "checkboxMode",
    attribute: "checkbox-mode",
    converter: W(["independent", "cascade"], { default: "independent" }),
    reflect: !0,
    on: "update",
    description: "Tree checkbox interaction.\n- `independent` (default) — toggles only the clicked node.\n- `cascade` — checks a node whole subtree and shows a tristate (checked / indeterminate / unchecked) box on branches.\n\nTree + multiple only."
  },
  {
    configKey: "cascadeSelectPolicy",
    attribute: "cascade-select-policy",
    converter: W(["rolled-up", "leaves", "all"], { default: "rolled-up" }),
    reflect: !0,
    on: "update",
    description: "In `cascade` mode, which values a selection emits (badges / form / change):\n- `rolled-up` (default) — minimal cover: a fully-selected subtree collapses to its root; partially-selected branches emit their individually-checked descendants.\n- `leaves` — only the checked leaf-level nodes.\n- `all` — every fully-checked node (branches and leaves)."
  },
  // ── Enums ────────────────────────────────────────────────────────────────
  { configKey: "badgesDisplayMode", attribute: "badges-display-mode", converter: W(["badges", "count", "compact", "partial", "none"], { default: "badges" }), on: "reinit", description: "How the current selection is shown in the control." },
  { configKey: "badgesPosition", attribute: "badges-position", converter: W(["top", "bottom", "left", "right"], { default: "bottom" }), on: "reinit", description: "Where the badges/selection appear relative to the input." },
  { configKey: "badgesThresholdMode", attribute: "badges-threshold-mode", converter: W(["count", "partial"], { default: "count" }), on: "update", description: 'How `badgesThreshold` is interpreted: collapse to a count badge, or keep partial badges + a "more" badge.' },
  { configKey: "searchInputMode", attribute: "search-input-mode", converter: W(["normal", "readonly", "hidden"], { default: "normal" }), on: "reinit", description: "Search field mode: editable, read-only, or hidden." },
  { configKey: "searchMode", attribute: "search-mode", converter: W(["filter", "navigate"], { default: "filter" }), on: "reinit", description: "Whether typing filters the list or navigates it." },
  { configKey: "actionsLayout", attribute: "actions-layout", converter: W(["nowrap", "wrap"], { default: "nowrap" }), on: "reinit", description: "Whether the action bar wraps or stays on one line." },
  { configKey: "actionsPosition", attribute: "actions-position", converter: W(["top", "bottom"], { default: "top" }), on: "reinit", description: "Whether the action bar sits above or below the list." },
  { configKey: "actionsAlign", attribute: "actions-align", converter: W(["stretch", "left", "right", "center", "space-between"], { default: "stretch" }), on: "update", description: "Horizontal alignment of the action buttons." },
  { configKey: "checkboxAlign", attribute: "checkbox-align", converter: W(["top", "center", "bottom"], { default: "center" }), on: "update", description: "Vertical alignment of an option checkbox." },
  { configKey: "valueFormat", attribute: "value-format", converter: W(["json", "csv", "array"], { default: "json" }), on: "reinit", description: "Serialization format the control emits its value in." },
  { configKey: "badgeTooltipPlacement", attribute: "badge-tooltip-placement", converter: W(io, { default: "top" }), on: "update", description: "Preferred placement of a badge tooltip relative to its badge (floating-ui placement)." },
  { configKey: "optionTooltipPlacement", attribute: "option-tooltip-placement", converter: W(io, { default: "top-start" }), on: "update", description: "Preferred placement of an option tooltip (floating-ui placement)." },
  // ── Numbers ──────────────────────────────────────────────────────────────
  { configKey: "badgesThreshold", attribute: "badges-threshold", converter: G(), on: "update", description: "Threshold at which badges collapse to a count/compact view." },
  { configKey: "badgesMaxVisible", attribute: "badges-max-visible", converter: G(), on: "update", description: "Maximum number of badges rendered before overflow." },
  { configKey: "minSearchLength", attribute: "min-search-length", converter: G({ default: 0 }), on: "update", description: "Minimum characters before searching/filtering starts." },
  { configKey: "searchDebounce", attribute: "search-debounce", converter: G({ default: 0 }), on: "update", description: "Debounce delay in ms applied to the search input." },
  { configKey: "virtualScrollThreshold", attribute: "virtual-scroll-threshold", converter: G({ default: 100 }), on: "reinit", description: "Option count above which virtual scrolling turns on." },
  { configKey: "optionHeight", attribute: "option-height", converter: G({ default: 50 }), on: "update", description: "Fixed row height in px used by virtual scrolling." },
  { configKey: "badgeHeight", attribute: "badge-height", converter: G({ default: 36 }), on: "update", description: "Fixed badge height in px used for layout/virtualization." },
  { configKey: "virtualScrollBuffer", attribute: "virtual-scroll-buffer", converter: G({ default: 10 }), on: "update", description: "Extra rows rendered above/below the viewport when virtualizing." },
  { configKey: "badgeTooltipDelay", attribute: "badge-tooltip-delay", converter: G({ default: 100 }), on: "update", description: "Delay in ms before a badge tooltip appears." },
  { configKey: "badgeTooltipOffset", attribute: "badge-tooltip-offset", converter: G({ default: 8 }), on: "update", description: "Gap in px between a badge and its tooltip." },
  { configKey: "optionTooltipDelay", attribute: "option-tooltip-delay", converter: G(), on: "update", description: "Delay in ms before an option tooltip appears (falls back to badgeTooltipDelay)." },
  { configKey: "optionTooltipOffset", attribute: "option-tooltip-offset", converter: G(), on: "update", description: "Gap in px between an option and its tooltip." },
  // ── Booleans (default true) ──────────────────────────────────────────────
  { configKey: "isMultipleEnabled", attribute: "multiple", converter: K("default-true"), on: "reinit", description: "Allow selecting multiple options. When off, selecting one replaces the previous." },
  { configKey: "isGroupsAllowed", attribute: "allow-groups", converter: K("default-true"), on: "reinit", description: "Allow grouping options under group headers." },
  { configKey: "isCheckboxesShown", attribute: "show-checkboxes", converter: K("default-true"), on: "reinit", description: "Show a checkbox on each option." },
  { configKey: "isActionsSticky", attribute: "sticky-actions", converter: K("default-true"), on: "update", description: "Keep the action bar pinned while the list scrolls." },
  { configKey: "isPlacementLocked", attribute: "lock-placement", converter: K("default-true"), on: "update", description: "Keep the dropdown initial placement instead of flipping when it fits." },
  { configKey: "isSearchEnabled", attribute: "enable-search", converter: K("default-true"), on: "reinit", description: "Show the search input." },
  { configKey: "isKeepOptionsOnSearch", attribute: "keep-options-on-search", converter: K("default-true"), on: "update", description: "Keep already-selected options visible while filtering." },
  { configKey: "shouldKeepSearchOnClose", attribute: "should-keep-search-on-close", converter: K("default-true"), on: "update", description: "Preserve the search text after the dropdown closes." },
  // ── Booleans (default false) ─────────────────────────────────────────────
  { configKey: "isCloseOnSelect", attribute: "close-on-select", converter: K("default-false"), on: "update", description: "Close the dropdown immediately after a selection." },
  { configKey: "isAddNewAllowed", attribute: "allow-add-new", converter: K("default-false"), on: "reinit", description: "Allow adding a new option from the search text." },
  { configKey: "isCounterShown", attribute: "show-counter", converter: K("default-false"), on: "update", description: "Show a selected-count indicator." },
  { configKey: "isBadgeFullTitleShown", attribute: "show-badge-full-title", converter: K("default-false"), on: "update", description: "Show the full title on badges instead of the short label." },
  { configKey: "isVirtualScrollEnabled", attribute: "enable-virtual-scroll", converter: K("default-false"), on: "reinit", description: "Force virtual scrolling on regardless of the threshold." },
  { configKey: "isBadgeTooltipsEnabled", attribute: "enable-badge-tooltips", converter: K("default-false"), on: "update", description: "Enable tooltips on badges." },
  { configKey: "isOptionTooltipsEnabled", attribute: "enable-option-tooltips", converter: K("default-false"), on: "update", description: "Enable tooltips on options." },
  { configKey: "isOptionTooltipFollowCursor", attribute: "option-tooltip-follow-cursor", converter: K("default-false"), on: "update", description: "Make option tooltips follow the pointer." },
  // ── Special attributes ───────────────────────────────────────────────────
  { configKey: "initialValues", attribute: "initial-values", converter: Oi(), default: [], on: "reinit", type: "Array<string | number>", description: 'Values selected on first render. Accepts a JSON array (`["a","b"]`) or a bare CSV (`a,b,c`).' },
  { configKey: "showDebugInfo", attribute: "show-debug-info", converter: K("default-false"), on: "update", description: "Render an in-component debug panel.", deprecated: "Use per-instance logging (el.enableLogging()) instead." },
  // ── Complex property (data) ──────────────────────────────────────────────
  { configKey: "options", converter: Fo(), on: "reinit", type: "ReadonlyArray<Record<string, unknown>>", description: "The array of option objects to render. The JS API — assign `el.options` directly. For HTML authoring use the `data-options` attribute (parsed per `data-options-format`) or declarative <option> children; both feed the same list and take precedence over this property in the order: <option> children > property > data-options." },
  { configKey: "optionsSource", attribute: "data-options", converter: E({ isNullable: !0 }), on: "reinit", type: "string", description: "HTML-authoring source for the option list, parsed per `data-options-format`. Reactive: changing either attribute re-renders. Prefer the `options` property in JS; a set `options` property and declarative <option> children both win over this." },
  { configKey: "optionsFormat", attribute: "data-options-format", converter: W(Pi, { default: "json" }), on: "reinit", type: "'json' | 'csv' | 'plain'", description: "How to parse the `data-options` attribute: `json` (a JSON array of objects or [value, label] tuples), `csv` (rows split on `data-options-row-splitter`, cells on `data-options-splitter`; the first row is a header — map columns via *-member), or `plain` (bare values split on both splitters -> [value, label] tuples, value === label). Default `json`." },
  { configKey: "optionsSplitter", attribute: "data-options-splitter", converter: E({ default: "," }), on: "reinit", type: "string", description: 'Field/cell delimiter for the `csv` and `plain` `data-options` formats. Default `,`. Escapes `\\t` `\\n` `\\r` are honoured (e.g. `data-options-splitter="\\t"` for TSV). Ignored for `json`.' },
  { configKey: "optionsRowSplitter", attribute: "data-options-row-splitter", converter: E({ default: `
` }), on: "reinit", type: "string", description: 'Row/record delimiter for the `csv` and `plain` `data-options` formats. Default newline. Escapes honoured (e.g. `data-options-row-splitter=";"` for single-line data). Ignored for `json`.' },
  { configKey: "actionButtons", converter: Ho({ validate: (o) => Array.isArray(o) }), on: "reinit", type: "Array<Record<string, unknown>>", description: "Custom action buttons for the dropdown footer/header. Property-only; when unset the default Select-All / Clear buttons apply." },
  // ── Callbacks: data shape (structural → reinit) ──────────────────────────
  { configKey: "getValueCallback", converter: D(), on: "reinit", type: "(item: unknown) => string | number", description: "Extract an option value (overrides valueMember)." },
  { configKey: "getPathCallback", converter: D(), on: "reinit", type: "(item: unknown) => string", description: "Extract a node tree path (enables tree mode; overrides pathMember)." },
  { configKey: "getGroupCallback", converter: D(), on: "reinit", type: "(item: unknown) => string", description: "Extract the group name from an option (overrides groupMember)." },
  { configKey: "getDisabledCallback", converter: D(), on: "reinit", type: "(item: unknown) => boolean", description: "Whether an option is disabled (overrides disabledMember)." },
  { configKey: "getIsSelectableCallback", converter: D(), on: "reinit", type: "(node: unknown) => boolean", description: "Whether a tree node can be selected (overrides is-selectable-member)." },
  { configKey: "getSearchValueCallback", converter: D(), on: "reinit", type: "(item: unknown) => string", description: "Text an option is searched against (overrides searchValueMember)." },
  { configKey: "searchCallback", converter: D(), on: "reinit", type: "(searchTerm: string, signal?: AbortSignal) => Promise<unknown[]>", description: "Custom / async search; return the filtered options." },
  // ── Callbacks: display / render (cosmetic → update) ──────────────────────
  { configKey: "getDisplayValueCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Compute the display label for an option (overrides displayValueMember)." },
  { configKey: "getBadgeDisplayCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Compute the text shown on an option badge." },
  { configKey: "getBadgeClassCallback", converter: D(), on: "update", type: "(item: unknown) => string | string[]", description: "Extra CSS class(es) for an option badge." },
  { configKey: "getIconCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Icon for an option (overrides iconMember)." },
  { configKey: "getSubtitleCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Subtitle for an option (overrides subtitleMember)." },
  { configKey: "getFullTitleCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Full title for an option (used by badges when show-badge-full-title is on)." },
  { configKey: "getCounterCallback", converter: D(), on: "update", type: "(count: number, moreCount?: number) => string", description: "Render the selected-count label." },
  { configKey: "getValueFormatCallback", converter: D(), on: "update", type: "(selectedValues: (string | number)[]) => string", description: "Serialize the selected values for form submission." },
  { configKey: "getBadgeTooltipCallback", converter: D(), on: "update", type: "(item: unknown) => string | HTMLElement", description: "Tooltip content for an option badge." },
  { configKey: "getOptionTooltipCallback", converter: D(), on: "update", type: "(item: unknown) => string | HTMLElement", description: "Tooltip content for an option row." },
  { configKey: "getRemoveButtonTooltipCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Tooltip text for a badge remove button." },
  { configKey: "getSelectedItemClassCallback", converter: D(), on: "update", type: "(item: unknown) => string | string[]", description: "Extra CSS class(es) for a selected item." },
  { configKey: "renderOptionContentCallback", converter: D(), on: "update", type: "(item: unknown, context: OptionContentRenderContext) => string | HTMLElement", description: "Custom render for an option row; may return HTML or an element." },
  { configKey: "renderBadgeContentCallback", converter: D(), on: "update", type: "(item: unknown, context: BadgeContentRenderContext) => string | HTMLElement", description: "Custom render for a badge; may return HTML or an element." },
  { configKey: "renderGroupLabelContentCallback", converter: D(), on: "update", type: "(groupName: string) => string | HTMLElement", description: "Customize a group label; may return an HTML string or element." },
  { configKey: "renderSelectedContentCallback", converter: D(), on: "update", type: "(item: unknown) => string", description: "Custom render for the whole selected area." },
  { configKey: "renderSelectedItemContentCallback", converter: D(), on: "update", type: "(item: unknown) => string | HTMLElement", description: "Custom render for one selected item." },
  { configKey: "customStylesCallback", converter: D(), on: "update", type: "() => string", description: "Returns a CSS string injected into the component via a replaceable style slot (§12.8)." },
  // ── Callbacks: before-hooks (behavior-shaping) ───────────────────────────
  { configKey: "beforeSearchCallback", converter: D(), on: "update", type: "(searchTerm: string) => string | null", description: "Runs before a search; return a rewritten term or null to veto." },
  { configKey: "beforeSelectCallback", converter: D(), on: "update", type: "(option: unknown, selectedOptions: unknown[]) => boolean | void", description: "Runs before selecting; return false to veto." },
  { configKey: "beforeDeselectCallback", converter: D(), on: "update", type: "(option: unknown, selectedOptions: unknown[]) => boolean | void", description: "Runs before deselecting; return false to veto." },
  { configKey: "addNewCallback", converter: D(), on: "update", type: "(value: string) => unknown | Promise<unknown>", description: "Create a new option from the typed text." }
], Di = [
  { name: "select", description: "An option was selected. `detail.option` is the selected option; `detail.selectedOptions`/`detail.selectedValues` are the full selection." },
  { name: "deselect", description: "An option was removed from the selection. `detail.option` is that option." },
  { name: "change", description: "The selection changed. `detail.selectedOptions`/`detail.selectedValues` are the full selection." }
], ro = /* @__PURE__ */ new Set(["dropdownWidth", "selectedPopoverWidth", "showDebugInfo", "initialValues", "optionsSource", "optionsFormat", "optionsSplitter", "optionsRowSplitter"]), Ye = {
  dropdownWidth: "--ms-dropdown-width",
  selectedPopoverWidth: "--ms-selected-popover-width"
};
let zi = null;
function Ni() {
  return zi ?? (zi = ps(Oo, "--ms-"));
}
const Ri = [
  { key: "valueMember", member: "value", callbackKey: "getValueCallback" },
  { key: "displayValueMember", member: "label", callbackKey: "getDisplayValueCallback" },
  { key: "groupMember", member: "group", callbackKey: "getGroupCallback" },
  { key: "iconMember", member: "icon", callbackKey: "getIconCallback" },
  { key: "subtitleMember", member: "subtitle", callbackKey: "getSubtitleCallback" },
  { key: "disabledMember", member: "disabled", callbackKey: "getDisabledCallback" }
];
var X, N, pe, je, Ue, Ge, Ae, Le, we, O, _t, kt, Po, Mo, Ao, Qe, Ct, Lo, Eo, $o, St, Vo, Do, Tt, It;
class Re extends ut {
  constructor() {
    super();
    V(this, O);
    V(this, X);
    V(this, N);
    V(this, pe);
    V(this, je, null);
    // Dev-mode customStylesCallback lint: unknown --ms-* names already warned about.
    V(this, Ue, /* @__PURE__ */ new Set());
    // Declarative <option>/<optgroup> state (parsed once from light DOM).
    V(this, Ge, !1);
    V(this, Ae, !1);
    V(this, Le);
    V(this, we);
    z(this, X, this.attachShadow({ mode: "open" })), ds(f(this, X), Oo), typeof requestAnimationFrame == "function" ? requestAnimationFrame(() => this.setAttribute("data-ready", "")) : this.setAttribute("data-ready", "");
  }
  /**
   * Called by the browser when the surrounding <form> is reset. Clears the
   * picker's selection so the control participates in the standard reset.
   */
  formResetCallback() {
    var t;
    (t = f(this, N)) == null || t.clearAll();
  }
  // ── core lifecycle hooks ──────────────────────────────────────────────────
  /** Structural change (or first connect): mirror CSS vars, then (re)build the picker. */
  reinit() {
    C(this, O, Eo).call(this), this.isConnected && C(this, O, _t).call(this);
  }
  /** Cosmetic change: mirror CSS vars / custom styles / debug, patch the picker in place. */
  update(t) {
    C(this, O, $o).call(this, t), "customStylesCallback" in t && C(this, O, Ct).call(this), "showDebugInfo" in t && C(this, O, Tt).call(this);
    const s = {};
    for (const [i, r] of Object.entries(t))
      ro.has(i) || (s[i] = r === null ? void 0 : r);
    f(this, N) && Object.keys(s).length > 0 && (f(this, N).updateOptions(s) || C(this, O, _t).call(this));
  }
  /** Activate: ensure the picker exists (a DOM move destroyed it in disconnect()). */
  connect() {
    f(this, N) || C(this, O, kt).call(this);
  }
  /** Deactivate: tear the picker down (rebuilt on the next connect). */
  disconnect() {
    var t;
    (t = f(this, N)) == null || t.destroy(), z(this, N, void 0);
  }
  // ── non-input public API ──────────────────────────────────────────────────
  /** Form field name (mirrors the `name` attribute → `formFieldId`). */
  get name() {
    return this.getAttribute("name");
  }
  set name(t) {
    t ? this.setAttribute("name", t) : this.removeAttribute("name");
  }
  get selectedValue() {
    var t;
    return this.flush(), ((t = f(this, N)) == null ? void 0 : t.selectedValue) ?? null;
  }
  get selectedItem() {
    var t;
    return this.flush(), ((t = f(this, N)) == null ? void 0 : t.selectedItem) ?? null;
  }
  getSelected() {
    return this.flush(), f(this, N) ? f(this, N).getSelected() : [];
  }
  setSelected(t, s = {}) {
    var i;
    this.flush(), (i = f(this, N)) == null || i.setSelected(t, s);
  }
  getValue() {
    return this.flush(), f(this, N) ? f(this, N).getValue() : null;
  }
  destroy() {
    var t;
    (t = f(this, N)) == null || t.destroy();
  }
}
X = new WeakMap(), N = new WeakMap(), pe = new WeakMap(), je = new WeakMap(), Ue = new WeakMap(), Ge = new WeakMap(), Ae = new WeakMap(), Le = new WeakMap(), we = new WeakMap(), O = new WeakSet(), // ── picker lifecycle ──────────────────────────────────────────────────────
_t = function() {
  var t;
  (t = f(this, N)) == null || t.destroy(), z(this, N, void 0), C(this, O, kt).call(this);
}, kt = function() {
  C(this, O, Po).call(this), C(this, O, Vo).call(this);
  const t = C(this, O, Mo).call(this), s = C(this, O, Ao).call(this);
  s && s.length > 0 ? f(this, pe).dataset.initialValues = JSON.stringify(s) : delete f(this, pe).dataset.initialValues, z(this, N, new Ii(f(this, pe), t)), C(this, O, Ct).call(this), C(this, O, Tt).call(this);
}, Po = function() {
  if (f(this, pe)) return;
  const t = document.createElement("div");
  t.setAttribute("data-multiselect", ""), this.className && (t.className = this.className), f(this, X).appendChild(t), z(this, je, hs(f(this, X), { position: "first", className: "ms-custom-styles" })), z(this, pe, t);
}, /**
 * Build the picker config from the merged `this.config`, minus the keys the
 * picker doesn't own, plus the runtime wiring (event bridges, container, host,
 * declarative option data + member defaults, counter default).
 */
Mo = function() {
  const t = { ...this.config };
  for (const i of ro) delete t[i];
  for (const i of Object.keys(t))
    t[i] === null && delete t[i];
  let s = t.options;
  if (f(this, Ae) && f(this, Le))
    s && s.length > 0 && H.warn("[MultiSelectElement] Both declarative <option> elements and programmatic .options detected. Using declarative options."), s = f(this, Le);
  else if (!s || s.length === 0) {
    const i = this.config.optionsSource;
    if (i != null) {
      const r = this.config.optionsFormat ?? "json", { options: n, error: a } = Mi(i, r, {
        splitter: this.config.optionsSplitter,
        rowSplitter: this.config.optionsRowSplitter
      });
      a && H.error(`[MultiSelectElement] ${a}`), s = n;
    }
  }
  if (t.options = s, f(this, Ae))
    for (const { key: i, member: r, callbackKey: n } of Ri)
      t[i] === void 0 && !t[n] && (t[i] = r);
  return t.getCounterCallback || (t.getCounterCallback = (i, r) => r !== void 0 ? `+${r} more` : `${i} selected`), t.onSelect = (i) => {
    var r;
    this.emit("select", {
      option: i,
      selectedOptions: ((r = f(this, N)) == null ? void 0 : r.getSelected()) ?? [],
      selectedValues: C(this, O, Qe).call(this)
    });
  }, t.onDeselect = (i) => {
    var r;
    this.emit("deselect", {
      option: i,
      selectedOptions: ((r = f(this, N)) == null ? void 0 : r.getSelected()) ?? [],
      selectedValues: C(this, O, Qe).call(this)
    });
  }, t.onChange = (i) => {
    this.emit("change", {
      selectedOptions: i,
      selectedValues: C(this, O, Qe).call(this)
    });
  }, t.container = f(this, X), t.hostElement = this, t;
}, Ao = function() {
  if (f(this, we) && f(this, we).length > 0)
    return f(this, we);
  const t = this.config.initialValues;
  return t && t.length > 0 ? t : void 0;
}, Qe = function() {
  var s;
  const t = (s = f(this, N)) == null ? void 0 : s.getValue();
  return t == null ? [] : Array.isArray(t) ? t : [t];
}, // ── §12.8 custom styles ───────────────────────────────────────────────────
Ct = function() {
  const t = f(this, je);
  if (!t) return;
  const s = this.config.customStylesCallback;
  if (typeof s != "function") {
    t.clear();
    return;
  }
  try {
    const i = s();
    t.set(i), i && C(this, O, Lo).call(this, i);
  } catch (i) {
    H.warn("[MultiSelectElement] customStylesCallback threw", i), t.clear();
  }
}, /**
 * Dev-only lint: warn when `customStylesCallback` *sets* a `--ms-*` variable
 * that no web-multiselect style ever reads (`var(--ms-…)`) — a misspelled or
 * renamed variable fails silently otherwise (e.g. `--ms-badge-text-background`
 * instead of `--ms-badge-text-bg`). Guarded by `import.meta.env.DEV`, so it's
 * stripped from the production build and never fires for shipped consumers.
 * De-duped per instance. If you genuinely define a `--ms-*` var for your own
 * custom-rendered content, ignore the warning (or use a different prefix).
 */
Lo = function(t) {
  const s = Ni();
  if (s.size !== 0)
    for (const { name: i, suggestions: r } of fs(t, { prefix: "--ms-", consumed: s }))
      f(this, Ue).has(i) || (f(this, Ue).add(i), console.warn(
        `[web-multiselect] customStylesCallback sets "${i}", which no web-multiselect style consumes — it will have no effect.` + (r.length ? ` Did you mean: ${r.join(", ")}?` : "") + " (If it's for your own custom-rendered content, ignore this.)"
      ));
}, // ── CSS-var sugar ─────────────────────────────────────────────────────────
Eo = function() {
  for (const t of Object.keys(Ye)) C(this, O, St).call(this, Ye[t], this.config[t]);
}, $o = function(t) {
  for (const s of Object.keys(Ye))
    s in t && C(this, O, St).call(this, Ye[s], t[s]);
}, St = function(t, s) {
  s == null || s === "" ? this.style.removeProperty(t) : this.style.setProperty(t, String(s));
}, // ── declarative <option> parsing (light DOM, once) ────────────────────────
Vo = function() {
  if (f(this, Ge)) return;
  z(this, Ge, !0);
  const t = C(this, O, Do).call(this);
  t && (z(this, Le, t), z(this, Ae, !0));
}, Do = function() {
  const t = Array.from(this.children);
  if (t.length === 0) return null;
  const s = [];
  let i = !1;
  const r = (n, a) => {
    var c, d;
    const l = {
      value: n.value || ((c = n.textContent) == null ? void 0 : c.trim()) || "",
      label: ((d = n.textContent) == null ? void 0 : d.trim()) || n.value || ""
    };
    a && (l.group = a), n.hasAttribute("selected") && (f(this, we) ?? z(this, we, [])).push(l.value), n.hasAttribute("disabled") && (l.disabled = !0), n.hasAttribute("data-icon") && (l.icon = n.getAttribute("data-icon")), n.hasAttribute("data-subtitle") && (l.subtitle = n.getAttribute("data-subtitle")), s.push(l), i = !0;
  };
  for (const n of t)
    if (n.tagName === "OPTION")
      r(n);
    else if (n.tagName === "OPTGROUP") {
      const a = n, l = a.label || a.getAttribute("label") || "Group";
      for (const c of Array.from(a.querySelectorAll("option")))
        r(c, l);
    }
  if (!i) return null;
  H.debug(`[MultiSelectElement] Parsed ${s.length} declarative options from Light DOM`);
  for (const n of t)
    (n.tagName === "OPTION" || n.tagName === "OPTGROUP") && n.remove();
  return s;
}, // ── debug panel (deprecated; kept for back-compat) ────────────────────────
Tt = function() {
  const t = f(this, X).querySelector(".ms__debug-info");
  if (t && t.remove(), !this.config.showDebugInfo) return;
  const s = document.createElement("div");
  s.className = "ms__debug-info";
  const i = document.createElement("details"), r = document.createElement("summary");
  r.textContent = "Debug Info";
  const n = document.createElement("div");
  n.className = "ms__debug-stats", i.appendChild(r), i.appendChild(n), s.appendChild(i), f(this, X).appendChild(s), C(this, O, It).call(this);
}, It = function() {
  var l, c, d, h;
  const t = f(this, X).querySelector(".ms__debug-stats");
  if (!t || !f(this, N)) return;
  const s = "2.0.0-rc02", i = typeof window < "u" && ((c = (l = window.components) == null ? void 0 : l["web-multiselect"]) == null ? void 0 : c.getInstances().length) || 0, r = f(this, N).getSelected().length, n = ((d = this.config.options) == null ? void 0 : d.length) || 0, a = f(this, N);
  t.innerHTML = `
      <span>Version: ${s}</span>
      <span>Total Instances: ${i}</span>
      <span>Options: ${n}</span>
      <span>Filtered: ${((h = a.filteredOptions) == null ? void 0 : h.length) || 0}</span>
      <span>Selected: ${r}</span>
      <span>Dropdown: ${a.isOpen ? "Open" : "Closed"}</span>
      <span>Search: ${a.searchTerm || "none"}</span>
      <span>Loading: ${a.isLoading ? "Yes" : "No"}</span>
    `, setTimeout(() => {
    this.config.showDebugInfo && C(this, O, It).call(this);
  }, 500);
}, // Opt into the form-associated custom element lifecycle so form.reset() and
// form.elements see the control.
y(Re, "formAssociated", !0), y(Re, "inputs", Vi), y(Re, "events", Di);
typeof customElements < "u" && !customElements.get("web-multiselect") && customElements.define("web-multiselect", Re);
ls("web-multiselect", Re, {
  config: {
    name: "@keenmate/web-multiselect",
    version: "2.0.0-rc02",
    author: "Keenmate",
    license: "MIT",
    repository: "git+https://github.com/keenmate/web-multiselect.git",
    homepage: "https://web-multiselect.keenmate.dev"
  },
  logging: ae
});
export {
  Ki as LOGGING_CATEGORIES,
  Re as MultiSelectElement,
  Pi as OPTIONS_FORMATS,
  Ii as WebMultiSelect,
  H as dataLogger,
  Fi as disableLogging,
  Hi as enableLogging,
  Xe as initLogger,
  j as interactionLogger,
  Mi as parseOptionsData,
  ji as setCategoryLevel,
  Wi as setLogLevel,
  Y as uiLogger
};
