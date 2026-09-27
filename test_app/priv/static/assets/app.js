// Boot the LiveSocket, register the wrapper's hook, and load the upstream
// custom element. No bundler — everything resolves through the importmap
// declared in the root layout.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import KeenWebMultiselectHook from "keen_web_multiselect/hook";
import "keen_web_multiselect";

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

// Flip __phxReady once the layout's marker hook mounts — i.e. once LV has
// processed the page and run hook lifecycles. The e2e suite waits on this
// before interacting so clicks don't race the initial mount morph.
window.__phxReady = false;
const LvReady = {
  mounted() { window.__phxReady = true; }
};

// ServerMonitor — powers the floating "server round-trip" panel on every demo
// page. Listens for select / deselect / change on EVERY <web-multiselect> and
// forwards each to the ServerEventsPanel LiveComponent (via phx-target on
// this.el), so picking an option anywhere makes the server-rendered counter
// tick up. Mirrors the wrapper hook's detail contract: `change` carries
// detail.selectedValues; select/deselect carry detail.option + selectedOptions.
const ServerMonitor = {
  mounted() {
    this._forward = (kind) => (e) => {
      const el = e.target;
      if (!el || el.tagName !== "WEB-MULTISELECT") return;
      const detail = e.detail || {};
      if (kind === "change") {
        const values = detail.selectedValues || [];
        this.pushEventTo(this.el, "web_multiselect:change", { id: el.id || "(unnamed)", values });
      } else {
        const option = detail.option || null;
        const value = option && (option.value ?? option.id ?? option);
        this.pushEventTo(this.el, "web_multiselect:" + kind, { id: el.id || "(unnamed)", value });
      }
    };
    this._handlers = {
      change: this._forward("change"),
      select: this._forward("select"),
      deselect: this._forward("deselect")
    };

    // Delegate at the document level. select / deselect / change bubble AND are
    // composed, so a single set of document listeners catches EVERY <web-multiselect>
    // on the page — including pickers added after this hook mounted, or ones on a
    // page reached via LiveView navigation (the monitor lives in the persistent
    // layout, so the old per-element attach-on-mount silently missed those). The
    // _forward guard ignores any non-multiselect event that happens to bubble up.
    document.addEventListener("change", this._handlers.change);
    document.addEventListener("select", this._handlers.select);
    document.addEventListener("deselect", this._handlers.deselect);
  },

  destroyed() {
    document.removeEventListener("change", this._handlers.change);
    document.removeEventListener("select", this._handlers.select);
    document.removeEventListener("deselect", this._handlers.deselect);
  }
};

// Bu03Callbacks — BU03 (Groups) on the Basic Usage page. renderGroupLabelContentCallback
// and getCountLabelCallback are function props with no attribute equivalent, so the demo's
// live controls can't drive them via LiveView attrs. The control choices ride in on
// data-custom-labels / data-count-format, and this hook installs the callbacks on (re)mount
// — the card re-keys the element on any control change, so mounted() re-runs with the fresh
// dataset. Both props are `on: 'update'`, so assigning them re-renders in place.
const Bu03Callbacks = {
  mounted() {
    const el = this.el;
    el.renderGroupLabelContentCallback =
      el.dataset.customLabels === "true"
        ? (groupName, ctx) => {
            const remaining = (ctx.selectableCount ?? ctx.memberCount ?? 0) - (ctx.selectedCount ?? 0);
            // GroupLabelRenderContext carries the presentation (it's re-invoked when it
            // changes). On the phone fullscreen overlay the base rem scales UP for touch, so
            // render the custom label a notch smaller to keep "NAME — N remaining" on one line.
            const scale = ctx.isFullscreen ? ' style="font-size:0.8em"' : '';
            return `<span class="js-custom-label"${scale}><strong>${(groupName || "").toUpperCase()}</strong> — ${remaining} remaining</span>`;
          }
        : null;
    el.getCountLabelCallback =
      el.dataset.countFormat === "ratio" ? (s, t) => `${s}/${t}` : null;
  }
};

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { KeenWebMultiselectHook, LvReady, ServerMonitor, Bu03Callbacks },
  params: { _csrf_token: csrfToken }
});

liveSocket.connect();
window.liveSocket = liveSocket;
