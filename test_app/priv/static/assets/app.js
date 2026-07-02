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

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { KeenWebMultiselectHook, LvReady },
  params: { _csrf_token: csrfToken }
});

liveSocket.connect();
window.liveSocket = liveSocket;
