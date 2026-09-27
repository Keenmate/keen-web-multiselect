defmodule TestAppWeb.Examples.PositioningLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  @drift_warning_text """
  [@keenmate/web-multiselect] Dropdown panel rendered Npx / 0px away from where the
  library positioned it. Most likely culprit: <div.form-group#drift-wrapper> (has
  contain: paint). An ancestor of <web-multiselect> establishes a fixed-positioning
  containing block that the library's heuristic doesn't recognize. Fix on your side:
  replace the property with `transform: translateZ(0)` on that ancestor, OR move the
  trigger out of that ancestor's subtree. If neither is acceptable, please file an
  issue at https://github.com/keenmate/web-multiselect/issues with the ancestor's
  computed CSS.\
  """

  @fullscreen_warning_text """
  [@keenmate/web-multiselect] Fullscreen overlay is anchored to an ancestor
  <div.wrap-transform> (has transform) instead of the viewport, so it may not cover
  the screen (offset, clipped, or mis-sized). An ancestor of <web-multiselect>
  establishes a fixed-positioning containing block (transform / perspective / filter /
  backdrop-filter / will-change). Fix on your side: move the component out of that
  ancestor's subtree, OR remove/replace that property. If neither is acceptable, please
  file an issue at https://github.com/keenmate/web-multiselect/issues with the
  ancestor's computed CSS.\
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Positioning Edge Cases — keen_web_multiselect")
     |> assign(:drift_warning_text, @drift_warning_text)
     |> assign(:fullscreen_warning_text, @fullscreen_warning_text)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="📐"
      title="Positioning Edge Cases"
      subtitle="How the dropdown anchors across CSS containing-block scenarios, and what the library does when it can't position the panel correctly on its own."
    >
      <style>
        /* Page-specific only — these three wrapper classes are the actual subject of the
           demo: applying one containing-block-establishing CSS property each, so the
           multiselect dropdown positions against that property. */
        .wrap-plain          { /* baseline — no CB property */ }
        .wrap-transform      { transform: translateZ(0); }
        .wrap-container-type { container-type: inline-size; }
        .wrap-contain-paint  { contain: paint; }

        /* Tiny status pill — sits inline with the multiselect to reflect live drift state. */
        .status {
            font-family: ui-monospace, Consolas, monospace;
            font-size: 0.85rem;
            padding: 8px 10px;
            border-radius: 4px;
            background: #edf2f7;
            color: #2d3748;
            margin-top: 0.75rem;
            min-height: 1.2em;
        }
        .status.ok      { background: #d6fbd6; color: #1a4d1a; }
        .status.drifted { background: #fbd6d6; color: #6a1a1a; }
      </style>

      <.card title="PO01 · Baseline (no special ancestor CSS)">
        <.tip>Ancestor CSS under test: <code>(none)</code> — dropdown anchors to the viewport</.tip>
        <p>
          The simplest case: no ancestor establishes a containing block for fixed positioning. The
          dropdown anchors to the viewport and sits under the input.
        </p>
        <div class="form-group wrap-plain">
          <label>Pick a fruit</label>
          <.web_multiselect
            id="ms-plain"
            value_member="value"
            display_value_member="label"
            search_placeholder="Pick something…"
          >
            <option value="a">Apple</option>
            <option value="b">Banana</option>
            <option value="c">Cherry</option>
            <option value="d">Date</option>
          </.web_multiselect>
          <small class="form-text">wrapper CSS: <code>(none)</code></small>
        </div>
      </.card>

      <.card title="PO02 · Ancestor with <code>transform</code> (works correctly)">
        <.tip>Ancestor CSS under test: <code>transform: translateZ(0)</code></.tip>
        <p>
          <code>transform</code>, <code>perspective</code>, <code>filter</code>, <code>backdrop-filter</code>,
          and qualifying <code>will-change</code>
          values establish a containing block for fixed-positioned
          descendants in every browser. Floating UI detects them, the browser honors them, and the dropdown
          anchors to the wrapper — under the input, as expected.
        </p>
        <div class="form-group wrap-transform">
          <label>Pick a fruit</label>
          <.web_multiselect
            id="ms-transform"
            value_member="value"
            display_value_member="label"
            search_placeholder="Pick something…"
          >
            <option value="a">Apple</option>
            <option value="b">Banana</option>
            <option value="c">Cherry</option>
            <option value="d">Date</option>
          </.web_multiselect>
          <small class="form-text">wrapper CSS: <code>transform: translateZ(0)</code></small>
        </div>
      </.card>

      <.card title="PO03 · Ancestor with <code>container-type</code> (the heuristic-override case)">
        <.tip>Ancestor CSS under test: <code>container-type: inline-size</code></.tip>
        <p>
          <code>container-type</code>
          establishes a containing block per spec, and Floating UI's default
          <code>getOffsetParent</code>
          walks up to use the wrapper. But for some real-world layouts
          (notably pure-admin's <code>.pa-layout__main</code>
          wrapping a shadow-DOM component), the browser
          does <strong>not</strong>
          actually anchor the fixed panel there — and Floating UI's coordinates
          end up offset by the wrapper's viewport-x, leaving the dropdown stranded to the side of the input.
        </p>
        <p>
          Since v1.10.1 the library installs a custom <code>getOffsetParent</code>
          that ignores
          <code>container-type</code>
          and <code>contain</code>
          in favor of properties the browser reliably
          honors. The dropdown lands under the input even in this configuration.
        </p>
        <div class="form-group wrap-container-type">
          <label>Pick a fruit</label>
          <.web_multiselect
            id="ms-container-type"
            value_member="value"
            display_value_member="label"
            search_placeholder="Pick something…"
          >
            <option value="a">Apple</option>
            <option value="b">Banana</option>
            <option value="c">Cherry</option>
            <option value="d">Date</option>
          </.web_multiselect>
          <small class="form-text">
            wrapper CSS: <code>container-type: inline-size</code> (same as <code>.pa-layout__main</code>)
          </small>
        </div>
      </.card>

      <.card title="PO04 · The drift-detection warning (interactive)">
        <.tip>Ancestor CSS under test: <code>contain: paint</code> — toggle it to trigger a <code>console.warn</code></.tip>
        <p>
          The library's containing-block heuristic isn't bulletproof — an ancestor can genuinely anchor
          fixed positioning (per spec) without being on the library's reliable-properties list. Every
          dropdown position pass verifies the panel landed where the library told the browser to put it.
          If it drifts, a <code>console.warn</code>
          fires once per multiselect instance with the likely
          culprit element and its responsible CSS property.
        </p>
        <p>
          Open DevTools → Console <em>before</em>
          toggling the wrapper, then open the dropdown. With
          <code>contain: paint</code> applied, the dropdown drifts and the warning fires.
        </p>

        <div class="form-group wrap-plain" id="drift-wrapper">
          <label>Pick a fruit</label>
          <.web_multiselect
            id="ms-drift"
            value_member="value"
            display_value_member="label"
            search_placeholder="Pick something…"
          >
            <option value="a">Apple</option>
            <option value="b">Banana</option>
            <option value="c">Cherry</option>
            <option value="d">Date</option>
          </.web_multiselect>
          <small class="form-text">wrapper CSS: <code id="drift-current-css">(plain)</code></small>
          <div class="controls" style="margin-top: 0.75rem; margin-bottom: 0;">
            <button class="btn-outline is-client" id="toggle-drift">Toggle <code>contain: paint</code></button>
            <button class="btn-outline is-client" id="reset-warning">Reset (re-arm warning)</button>
          </div>
          <div id="drift-status" class="status">
            Open the dropdown to position it, then toggle the wrapper CSS.
          </div>
        </div>

        <.note variant="warning" title="What the warning looks like">
          <pre>{@drift_warning_text}</pre>
        </.note>
      </.card>

      <.card title="PO05 · Fullscreen overlay & containing blocks (mobile)">
        <p>
          On phones the dropdown switches to a <code>position: fixed</code>, full-viewport
          <strong>sheet</strong>
          (see <.link navigate="/examples/responsive">Responsive & Mobile</.link>) instead of
          anchoring under the input. The same containing-block rule applies — but the failure mode is worse.
          A fixed element whose ancestor establishes a containing block is anchored to <em>that ancestor's box</em>,
          not the viewport, so the sheet no longer covers the screen: it ends up offset, clipped, or mis-sized.
        </p>
        <p>
          Note the asymmetry with PO02: an ancestor <code>transform</code>
          is <em>harmless</em>
          for the floating
          dropdown (it just anchors under the input), but it <em>breaks</em>
          the fullscreen sheet, because the sheet
          needs the viewport as its containing block to span it. The properties that trigger this are the ones
          browsers reliably honor — <code>transform</code>, <code>perspective</code>, <code>filter</code>,
          <code>backdrop-filter</code>, and qualifying <code>will-change</code>. <code>contain</code>
          and
          <code>container-type</code>
          do <strong>not</strong>
          break the sheet (browsers don't honor them for fixed
          positioning), which is exactly why the floating path has to override them but the sheet doesn't care.
        </p>
        <p>
          Because nothing anchors the sheet, there's no drift to measure the way PO04 does. Instead the library
          asks its containing-block heuristic, when the sheet opens, whether the true offset parent is the viewport
          or an element — and if it's an element, fires a <code>console.warn</code>
          once per instance pointing at
          the culprit. The consumer-side fixes are the same: move the <code>&lt;web-multiselect&gt;</code>
          out of
          that subtree, or remove the property.
        </p>

        <.note variant="warning" title="What the fullscreen warning looks like">
          <pre>{@fullscreen_warning_text}</pre>
        </.note>
      </.card>

      <.card title="PO06 · Background">
        <p>
          The CSS spec lists seven properties as containing-block-establishing for fixed positioning:
          <code>transform</code>, <code>perspective</code>, <code>filter</code>,
          <code>backdrop-filter</code>, qualifying <code>will-change</code>,
          <code>contain</code> (<code>layout|paint|strict|content</code>), and <code>container-type</code>.
          In isolation, browsers honor all of them.
        </p>
        <p>
          But in some shadow-DOM scenarios — a <code>web-multiselect</code>
          dropdown lives inside the
          shadow root of a custom element, while the containment-establishing ancestor is in light DOM —
          the browser's actual <code>position: fixed</code>
          layout disagrees with Floating UI's prediction
          for <code>contain</code> and <code>container-type</code>.
          The library resolves that disagreement
          in favor of what every browser <em>reliably</em>
          does, and the drift detector catches whatever
          falls through.
        </p>
        <p>If you hit the warning in your own app, the two consumer-side fixes are:</p>
        <ul>
          <li>
            Replace <code>contain: …</code> or <code>container-type: …</code>
            on the ancestor with
            <code>transform: translateZ(0)</code>
            — same containing-block effect, but the browser
            definitively anchors fixed positioning to it.
          </li>
          <li>
            Move the <code>&lt;web-multiselect&gt;</code>
            to a different subtree that doesn't have the
            problematic ancestor.
          </li>
        </ul>
      </.card>
    </.example_page>

    <script type="module">
      const driftWrapper = document.getElementById('drift-wrapper');
      const driftLabel = document.getElementById('drift-current-css');
      const driftStatus = document.getElementById('drift-status');

      // Delegated on document so the buttons keep working after LiveView patches
      // the DOM on connect (plain <button>s are re-rendered, losing direct listeners).
      let containPaint = false;
      document.addEventListener('click', (e) => {
          if (e.target.closest('#toggle-drift')) {
              containPaint = !containPaint;
              driftWrapper.classList.toggle('wrap-contain-paint', containPaint);
              driftWrapper.classList.toggle('wrap-plain', !containPaint);
              driftLabel.textContent = containPaint ? 'contain: paint' : '(plain)';
              measureDrift();
              return;
          }

          // Reset: replace the multiselect with a fresh clone so its once-per-instance warning re-arms.
          if (e.target.closest('#reset-warning')) {
              const current = document.getElementById('ms-drift');
              const next = current.cloneNode(true);
              current.replaceWith(next);
              attachOpenListener(next);
              driftStatus.className = 'status';
              driftStatus.textContent = 'Multiselect reinitialized — open the dropdown to re-arm.';
          }
      });

      function attachOpenListener(el) {
          el.addEventListener('click', () => requestAnimationFrame(measureDrift), { capture: true });
      }
      attachOpenListener(document.getElementById('ms-drift'));

      function measureDrift() {
          const host = document.getElementById('ms-drift');
          if (!host?.shadowRoot) return;
          const panel = host.shadowRoot.querySelector('.ms__dropdown');
          const input = host.shadowRoot.querySelector('.ms__input');
          if (!panel || !input) return;
          requestAnimationFrame(() => {
              const inputRect = input.getBoundingClientRect();
              const panelRect = panel.getBoundingClientRect();
              if (panelRect.width === 0 || panelRect.height === 0) return;
              const driftX = panelRect.x - inputRect.x;
              if (Math.abs(driftX) < 1) {
                  driftStatus.className = 'status ok';
                  driftStatus.textContent = `OK — panel anchored under input (panel.x=${panelRect.x.toFixed(1)}, input.x=${inputRect.x.toFixed(1)}).`;
              } else {
                  driftStatus.className = 'status drifted';
                  driftStatus.textContent = `DRIFT — panel is ${driftX.toFixed(0)}px from input (panel.x=${panelRect.x.toFixed(1)}, input.x=${inputRect.x.toFixed(1)}). Check the console for the library's warning.`;
              }
          });
      }
    </script>
    """
  end
end
