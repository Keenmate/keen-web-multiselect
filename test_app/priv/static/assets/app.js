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

    this._attach = () => {
      document.querySelectorAll("web-multiselect").forEach((el) => {
        // idempotent — addEventListener dedupes identical (type, fn) pairs
        el.addEventListener("change", this._handlers.change);
        el.addEventListener("select", this._handlers.select);
        el.addEventListener("deselect", this._handlers.deselect);
      });
    };

    // Attach now and again once the element is upgraded (covers both orders).
    this._attach();
    customElements.whenDefined("web-multiselect").then(this._attach);
  },

  destroyed() {
    document.querySelectorAll("web-multiselect").forEach((el) => {
      el.removeEventListener("change", this._handlers.change);
      el.removeEventListener("select", this._handlers.select);
      el.removeEventListener("deselect", this._handlers.deselect);
    });
  }
};

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { KeenWebMultiselectHook, LvReady, ServerMonitor },
  params: { _csrf_token: csrfToken }
});

liveSocket.connect();
window.liveSocket = liveSocket;
