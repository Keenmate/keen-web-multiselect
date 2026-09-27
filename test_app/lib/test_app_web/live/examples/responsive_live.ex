defmodule TestAppWeb.Examples.ResponsiveLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Mirrors upstream @keenmate/web-multiselect examples-responsive.html (RS01–RS09):
  # the two responsive axes — mobile-presentation (device → floating/fullscreen) and
  # collapse-badges-below (element box → badge display).

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Responsive & Mobile — keen_web_multiselect")}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="📱"
      title="Responsive & Mobile"
      subtitle="Two independent axes: mobile_presentation (device → floating vs fullscreen overlay) and collapse_badges_below (the element's own box → badge display)."
    >
      <style>
        .rs-preview {
          display: inline-flex;
          gap: 0.4rem;
          align-items: center;
          margin: 0.5rem 0 0.75rem;
          font-size: 0.9rem;
          color: #4a5568;
        }
        .rs-resize {
          resize: horizontal;
          overflow: auto;
          min-width: 240px;
          max-width: 100%;
          width: 520px;
          padding: 1rem;
          border: 1px dashed #cbd5e1;
          border-radius: 10px;
          background: #f8fafc;
        }
        .rs-sidebar-layout {
          display: grid;
          grid-template-columns: 260px 1fr;
          gap: 1.25rem;
          align-items: start;
        }
        .rs-sidebar {
          padding: 1rem;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          background: #fff;
        }
        .rs-main {
          padding: 1rem;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          background: #fafafa;
          color: #64748b;
          min-height: 140px;
        }
        @media (max-width: 640px) {
          .rs-sidebar-layout { grid-template-columns: 1fr; }
        }
      </style>

      <.note title="Preview the phone UI without a phone">
        On a real phone-sized touch device these pickers open as a full-screen overlay. The
        <strong>Preview as fullscreen</strong> toggles below force <code>mobile_presentation="fullscreen"</code>
        on the demo so the overlay is inspectable on desktop; unchecking restores
        <code>mobile_presentation="auto"</code> (floating here).
      </.note>

      <.card title="RS01 · mobile-presentation — floating vs fullscreen">
        <.tip><code>mobile_presentation="auto | floating | fullscreen"</code></.tip>
        <p>
          <code>auto</code> keeps the floating panel on desktop/tablet and switches to a full-screen
          overlay on phone-sized touch devices; <code>floating</code> forces the anchored panel
          everywhere; <code>fullscreen</code> forces the overlay on any device.
        </p>
        <.form_group>
          <label>Cloud services — <code>mobile_presentation="auto"</code></label>
          <.web_multiselect id="intro-select" multiple={true} mobile_presentation="auto" />
        </.form_group>
        <label class="rs-preview">
          <input type="checkbox" data-preview="intro-select" /> Preview as fullscreen
        </label>
        <.code_block lang="heex">&lt;.web_multiselect mobile_presentation="fullscreen" /&gt;</.code_block>
      </.card>

      <.card title="RS02 · fullscreen-autofocus — soft keyboard on phones">
        <.tip><code>{"fullscreen_autofocus={true}"}</code></.tip>
        <p>
          By default the fullscreen sheet opens with the list visible and the keyboard closed — it
          appears only when you tap the search field. Set <code>{"fullscreen_autofocus={true}"}</code>
          to focus the search (and pop the keyboard) immediately.
        </p>
        <.grid_2>
          <.form_group>
            <label>Default — keyboard closed</label>
            <.web_multiselect id="kb-off-select" multiple={true} mobile_presentation="auto" />
          </.form_group>
          <.form_group>
            <label>Opt-in — <code>{"fullscreen_autofocus={true}"}</code></label>
            <.web_multiselect
              id="kb-on-select"
              multiple={true}
              mobile_presentation="auto"
              fullscreen_autofocus={true}
              search_placeholder="Search…"
            />
          </.form_group>
        </.grid_2>
        <label class="rs-preview">
          <input type="checkbox" data-preview="kb-off-select kb-on-select" /> Preview as fullscreen
        </label>
      </.card>

      <.card title="RS03 · filter vs navigate — live switch">
        <.tip><code>search_mode="navigate"</code> · <code>show_search_mode_toggle</code></.tip>
        <p>
          In <code>navigate</code> mode the list stays whole and typing jumps focus between matches.
          <code>{"show_search_mode_toggle={true}"}</code> adds a clickable icon in the phone fullscreen
          search header that flips the mode in place, without closing the overlay.
        </p>
        <div class="controls" style="margin-bottom:0.75rem;">
          <label><input type="radio" name="nav-fs-mode" value="filter" /> filter</label>
          <label><input type="radio" name="nav-fs-mode" value="navigate" checked /> navigate</label>
        </div>
        <.form_group>
          <.web_multiselect
            id="nav-fs-select"
            multiple={true}
            search_mode="navigate"
            show_search_mode_toggle={true}
            badges_display_mode="partial"
            badges_max_visible={2}
            show_counter={true}
          />
        </.form_group>
        <label class="rs-preview">
          <input type="checkbox" data-preview="nav-fs-select" /> Preview as fullscreen
        </label>
      </.card>

      <.card title="RS04 · Responsive rendering — rich on desktop, lean on the phone">
        <.tip>JS callback: <code>el.renderOptionContentCallback = (item, ctx) => …</code> reads <code>ctx.isFullscreen</code></.tip>
        <p>
          The render-callback context now carries the resolved <code>presentation</code>
          (<code>isFullscreen</code> / <code>isModal</code>), so one callback can draw a rich row on the
          desktop dropdown and a leaner one in the phone sheet — no <code>matchMedia</code>/resize wiring.
        </p>
        <.form_group>
          <label>Choose a plan</label>
          <.web_multiselect id="responsive-select" multiple={true} option_height={56} />
        </.form_group>
        <label class="rs-preview">
          <input type="checkbox" data-preview="responsive-select" /> Preview as fullscreen
        </label>
        <.code_block lang="js">picker.renderOptionContentCallback = (item, ctx) =&gt; ctx.isFullscreen ? leanRow(item) : richRow(item);</.code_block>
      </.card>

      <.card title="RS05 · RTL — right-to-left, overlay included">
        <.tip><code>dir="rtl"</code> (on the element or any ancestor)</.tip>
        <p>
          The whole component mirrors via CSS logical properties — the input, dropdown, checkboxes,
          badges, and the fullscreen overlay chrome. Runtime <code>dir</code> switching re-mirrors the
          live picker without a rebuild.
        </p>
        <.form_group>
          <.web_multiselect
            id="rtl-select"
            dir="rtl"
            multiple={true}
            search_mode="navigate"
            show_checkboxes={true}
            allow_groups={true}
          />
        </.form_group>
        <label class="rs-preview">
          <input type="checkbox" data-preview="rtl-select" /> Preview as fullscreen
        </label>
      </.card>

      <.card title="RS06 · Own box vs. the window">
        <p>
          <code>collapse_badges_below</code> is a <strong>different axis</strong> from
          <code>mobile_presentation</code>. It keys off the element's <strong>own border box</strong>
          (via a shared <code>ResizeObserver</code>), not the viewport — so a picker in a narrow column
          collapses its badges to the <code>count</code> mode ("N selected") even on a wide monitor,
          where a viewport check would read "desktop". Widening the box past the threshold restores the
          configured badges mode. The two axes compose.
        </p>
      </.card>

      <.card title={"RS07 · Drag the box — collapse-badges-below=\"360\""}>
        <.tip><code>{"collapse_badges_below={360}"}</code></.tip>
        <p>Drag the resize handle at the box's corner: below 360px wide the badges collapse to a count.</p>
        <div class="rs-resize">
          <.form_group>
            <label>Resize me →</label>
            <.web_multiselect
              id="drag-select"
              multiple={true}
              collapse_badges_below={360}
              badges_display_mode="badges"
            />
          </.form_group>
        </div>
      </.card>

      <.card title="RS08 · A picker in a narrow sidebar (window stays wide)">
        <.tip><code>{"collapse_badges_below={300}"}</code></.tip>
        <p>The window is wide, but the sidebar column is narrow — so the sidebar picker collapses while a wide-column one wouldn't.</p>
        <div class="rs-sidebar-layout">
          <div class="rs-sidebar">
            <label>Filters</label>
            <.web_multiselect
              id="sidebar-select"
              multiple={true}
              collapse_badges_below={300}
              badges_display_mode="badges"
            />
          </div>
          <div class="rs-main">Main content area — plenty of room here.</div>
        </div>
      </.card>

      <.card title="RS09 · How it resolves">
        <table class="reference-table" style="width:100%;border-collapse:collapse;">
          <thead>
            <tr>
              <th style="text-align:left;padding:0.4rem;border-bottom:1px solid #e2e8f0;">Axis</th>
              <th style="text-align:left;padding:0.4rem;border-bottom:1px solid #e2e8f0;">Keys off</th>
              <th style="text-align:left;padding:0.4rem;border-bottom:1px solid #e2e8f0;">Decides</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td style="padding:0.4rem;"><code>mobile_presentation</code></td>
              <td style="padding:0.4rem;">the device (touch + shorter viewport side &lt; 600px)</td>
              <td style="padding:0.4rem;">floating panel vs. full-screen overlay</td>
            </tr>
            <tr>
              <td style="padding:0.4rem;"><code>collapse_badges_below</code></td>
              <td style="padding:0.4rem;">the element's own border box</td>
              <td style="padding:0.4rem;">full badges vs. a "N selected" count</td>
            </tr>
          </tbody>
        </table>
      </.card>

      <script type="module">
        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        // A flat list of cloud-service options shared by most sections.
        const services = [
          'App Service', 'Container Apps', 'Kubernetes', 'Functions', 'Batch',
          'Blob Storage', 'File Shares', 'Managed Disks', 'Data Lake', 'Backup Vault',
          'Virtual Network', 'DNS', 'VPN Gateway', 'Firewall', 'NAT Gateway',
          'SQL Database', 'NoSQL Store', 'In-Memory Cache', 'Data Warehouse', 'Graph Database',
          'Identity & Access', 'Secrets Manager', 'Key Vault', 'Web App Firewall', 'DDoS Protection',
          'Data Streams', 'BI Dashboards', 'ETL Pipelines', 'Event Bus', 'Metrics',
          'CI/CD Pipelines', 'Source Repos', 'Artifact Registry', 'API Gateway', 'Feature Flags',
          'Message Queue', 'Pub/Sub', 'Transactional Email', 'SMS', 'Push Notifications'
        ].map((label, i) => ({ value: 'svc-' + i, label }));

        // Preview-as-fullscreen: flip mobile-presentation between 'fullscreen' and 'auto'.
        // Delegated on document so the listener survives LiveView's DOM patch on connect.
        document.addEventListener('change', (e) => {
          const cb = e.target;
          if (cb && cb.matches('input[type="checkbox"][data-preview]')) {
            const ids = cb.dataset.preview.split(/\s+/);
            const mode = cb.checked ? 'fullscreen' : 'auto';
            ids.forEach((id) => {
              const el = document.getElementById(id);
              if (el) el.setAttribute('mobile-presentation', mode);
            });
          }
        });

        // RS01 / RS02
        for (const id of ['intro-select', 'kb-off-select', 'kb-on-select']) {
          wait(id).then((el) => { el.options = services; });
        }

        // RS03 — navigate mode + live search-mode radios; preselect a few for the counter.
        wait('nav-fs-select').then((el) => {
          el.options = services;
          el.setSelected(services.slice(0, 4).map((o) => o.value));
          // Delegated change listener (kept in this closure so it can reference `el`)
          // so the radios keep working after LiveView patches the DOM on connect.
          document.addEventListener('change', (e) => {
            const r = e.target;
            if (r && r.name === 'nav-fs-mode' && r.checked) {
              el.setAttribute('search-mode', r.value);
            }
          });
        });

        // RS04 — presentation-aware rendering.
        wait('responsive-select').then((el) => {
          const plans = [
            { value: 'starter',    label: 'Starter',    price: '$9/mo',   popularity: '4.2', tier: 'Basic' },
            { value: 'pro',        label: 'Pro',        price: '$29/mo',  popularity: '4.8', tier: 'Popular' },
            { value: 'team',       label: 'Team',       price: '$79/mo',  popularity: '4.6', tier: 'Growth' },
            { value: 'business',   label: 'Business',   price: '$149/mo', popularity: '4.5', tier: 'Scale' },
            { value: 'enterprise', label: 'Enterprise', price: 'Custom',  popularity: '4.9', tier: 'Premium' }
          ];
          el.options = plans;
          el.renderOptionContentCallback = (item, ctx) => ctx.isFullscreen
            ? `<div style="display:flex;justify-content:space-between;align-items:center;gap:.6rem;width:100%;">
                   <strong>${item.label}</strong>
                   <span style="color:#667eea;">${item.price}</span>
               </div>`
            : `<div style="display:flex;align-items:center;gap:.6rem;width:100%;">
                   <strong>${item.label}</strong>
                   <small style="color:#718096;">${item.price} · ⭐${item.popularity}</small>
                   <span style="margin-inline-start:auto;background:#eef2ff;color:#4338ca;padding:.1rem .45rem;border-radius:.3rem;font-size:.72rem;">${item.tier}</span>
               </div>`;
          el.setSelected(['pro']);
        });

        // RS05 — RTL, grouped Arabic options.
        wait('rtl-select').then((el) => {
          const groups = {
            'الخدمات': ['التطبيقات', 'الحاويات', 'الوظائف', 'قواعد البيانات'],
            'التخزين': ['التخزين الثنائي', 'الأقراص', 'النسخ الاحتياطي'],
            'الشبكات': ['الشبكة الافتراضية', 'جدار الحماية', 'بوابة VPN']
          };
          el.options = Object.entries(groups).flatMap(([group, items]) =>
            items.map((label, i) => ({ value: group + '-' + i, label, group }))
          );
          el.setSelected(['الخدمات-0', 'التخزين-0']);
        });

        // RS07 / RS08 — collapse-badges-below; preselect several so pills overflow.
        for (const id of ['drag-select', 'sidebar-select']) {
          wait(id).then((el) => {
            el.options = services;
            el.setSelected(services.slice(0, 5).map((o) => o.value));
          });
        }
      </script>
    </.example_page>
    """
  end
end
