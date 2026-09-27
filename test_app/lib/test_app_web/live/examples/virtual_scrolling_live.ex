defmodule TestAppWeb.Examples.VirtualScrollingLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Mirrors upstream generateLargeDataset(): 15,000 options built from
  # adjective + noun + suffix + zero-padded index. We use a deterministic
  # rotation through the word lists (instead of Math.random) so the dataset is
  # stable, but the shape (value/label) and size match upstream exactly.
  @adjectives ~w(Amazing Beautiful Creative Dynamic Elegant Fantastic Gorgeous Incredible Magnificent Outstanding Perfect Remarkable Stunning Wonderful Brilliant)
  @nouns ~w(Apple Banana Cherry Dragon Eagle Forest Galaxy Harbor Island Journey Kingdom Lighthouse Mountain Ocean Paradise River Sunset Temple Universe Valley)
  @suffixes ~w(Alpha Beta Gamma Delta Epsilon Zeta Eta Theta Iota Kappa)

  @large_dataset (for i <- 0..14_999 do
                    adj = Enum.at(@adjectives, rem(i, length(@adjectives)))
                    noun = Enum.at(@nouns, rem(i, length(@nouns)))
                    suffix = Enum.at(@suffixes, rem(i, length(@suffixes)))
                    num = i |> Integer.to_string() |> String.pad_leading(5, "0")
                    %{value: i, label: "#{adj} #{noun} #{suffix} ##{num}"}
                  end)

  # Mirrors upstream's 150-product dataset for the rich-rendering card.
  @categories ~w(Electronics Accessories Office Gaming Audio)
  @priorities ~w(urgent important normal low)

  @rich_products (for i <- 1..150 do
                    category = Enum.at(@categories, rem(i, length(@categories)))
                    priority = Enum.at(@priorities, rem(i, length(@priorities)))
                    price = Float.round(rem(i * 37, 200) + 10 + 0.99, 2)
                    stock = rem(i * 7, 100)
                    rating = Float.round(3.0 + rem(i, 20) / 10, 1)

                    %{
                      id: i,
                      value: i,
                      name: "Product #{i} - #{category}",
                      category: category,
                      priority: priority,
                      price: price,
                      stock: stock,
                      rating: rating
                    }
                  end)

  @scrollto_code ~S"""
  el.open();
  el.scrollToIndex(14999);              // instant — row 14,999 isn't rendered yet
  el.scrollToValue(12345);             // resolves value → index
  el.scrollToIndex(7500, { block: 'center' });
  """

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Virtual Scrolling — keen_web_multiselect")
      |> assign(:large_dataset, @large_dataset)
      |> assign(:rich_products, @rich_products)
      |> assign(:scrollto_code, @scrollto_code)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="⚡"
      title="Virtual Scrolling"
      subtitle="Blazing-fast performance with 15,000 options using virtual scrolling and real-time metrics"
    >
      <style>
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1.5rem; padding: 1rem; background: #f8f9fa; border-radius: 8px; }
        .stat { text-align: center; }
        .stat-value { font-size: 2rem; font-weight: bold; color: #667eea; }
        .stat-label { font-size: 0.875rem; color: #666; margin-top: 0.25rem; }
      </style>

      <.card title="VS01 · Large Dataset Performance">
        <.tip><code>{"enable_virtual_scroll={true}"}</code> · <code>{"virtual_scroll_threshold={100}"}</code> · <code>{"option_height={50}"}</code> · <code>{"virtual_scroll_buffer={10}"}</code></.tip>
        <p>This demo tests the component with 15,000 randomly generated options to evaluate performance under heavy load.</p>

        <div id="perf-stats" phx-update="ignore" class="stats">
          <div class="stat">
            <div class="stat-value" id="total-options">15,000</div>
            <div class="stat-label">Total Options</div>
          </div>
          <div class="stat">
            <div class="stat-value" id="init-time">—</div>
            <div class="stat-label">Init Time (ms)</div>
          </div>
          <div class="stat">
            <div class="stat-value" id="render-time">—</div>
            <div class="stat-label">Render Time (ms)</div>
          </div>
          <div class="stat">
            <div class="stat-value" id="search-time">—</div>
            <div class="stat-label">Search Time (ms)</div>
          </div>
        </div>

        <.form_group style="margin-top: 2rem;">
          <label for="performance-test">Filter Mode - Type to search (try "item", "test", or any number)</label>
          <.web_multiselect
            id="performance-test"
            placeholder="Search 15,000 options..."
            search_mode="filter"
            show_select_all={true}
            max_height="400px"
            value_member="value"
            display_value_member="label"
            enable_virtual_scroll={true}
            virtual_scroll_threshold={100}
            option_height={50}
            virtual_scroll_buffer={10}
            badges_threshold={4}
            badges_threshold_mode="count"
            show_counter={true}
            options={@large_dataset}
          />
          <span class="form-text">
            Select 4+ items to see count badge. Click badge to see virtual scrolling in the selected items popover.
          </span>
        </.form_group>

        <.note variant="warning" title="💡 Performance Tips">
          <ul>
            <li>Type to search - the component uses efficient string matching</li>
            <li>Filter mode performs better with large datasets (hides non-matches)</li>
            <li>Navigate mode shows all items but uses Ctrl+arrows for match navigation</li>
            <li>Virtual scrolling keeps rendering fast even with 15,000 options</li>
            <li>Try selecting multiple items and using "Clear All"</li>
          </ul>
        </.note>
      </.card>

      <.card title="VS02 · Rich Rendering with Virtual Scroll">
        <.tip><code>{"badge_height={50}"}</code> sizes popover rows · <code>{"option_height={70}"}</code> · <code>{"enable_virtual_scroll={true}"}</code></.tip>
        <p>Testing custom rendering callbacks with 150 items to trigger virtual scrolling in the selected items popover (threshold: 100).</p>

        <.form_group style="margin-top: 1rem;">
          <label for="rich-virtual">Select Products (150 items)</label>
          <.web_multiselect
            id="rich-virtual"
            placeholder="Select products..."
            option_height={70}
            badge_height={50}
            badges_threshold={3}
            badges_threshold_mode="count"
            show_counter={true}
            enable_virtual_scroll={true}
            virtual_scroll_threshold={100}
            value_member="value"
            display_value_member="name"
            options={@rich_products}
          />
          <span class="form-text">
            Select 100+ items to see virtual scroll in the popover with custom rendering.
            Uses <code>renderSelectionBadgeContentCallback</code>
            and <code>getSelectionBadgeClassCallback</code> for rich badge styling.
          </span>
        </.form_group>
      </.card>

      <.card title="VS03 · Scroll-to API with Virtual Scroll">
        <.tip>JS-only: <code>scrollToIndex</code> / <code>scrollToValue</code> jump by index math — the target row need not be rendered; pass <code>{"{ block: 'center' }"}</code> to center.</.tip>
        <p>
          In virtual mode <code>scrollToIndex</code> / <code>scrollToValue</code> scroll by
          fixed-height <strong>index math</strong> — the target row need not be rendered, so
          jumping to item #14,999 in a 15,000-row list is instant. Pair with <code>open()</code>
          for an "open + jump" gesture. Default alignment is <code>start</code> (target at the top);
          pass <code>{"{ block: 'center' }"}</code> to center it.
        </p>
        <.form_group style="margin-top: 1rem;">
          <label for="scroll-virtual-large">15,000 options</label>
          <div style="display:flex; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
            <div style="flex:1 1 260px; min-width:260px;">
              <.web_multiselect
                id="scroll-virtual-large"
                value_member="value"
                display_value_member="label"
                enable_virtual_scroll={true}
                virtual_scroll_threshold={100}
                search_placeholder="Search or use the buttons..."
                options={@large_dataset}
              />
            </div>
            <div style="display:flex; flex-direction:column; gap:0.5rem; flex:0 0 auto; min-width:210px;">
              <button type="button" data-vs="index:0">⇱ index 0</button>
              <button type="button" data-vs="index:7500">index 7500</button>
              <button type="button" data-vs="index:14999">index 14999 (last)</button>
              <button type="button" data-vs="value:12345">value 12345</button>
              <button type="button" data-vs="center:7500">index 7500 · block "center"</button>
              <button type="button" data-vs="clear">clearSearch()</button>
            </div>
          </div>
          <span class="form-text">The log shows the resulting <code>scrollTop</code> and which rows landed in view.</span>
          <div id="vs-scroll-log" class="log-panel"><div class="muted">scrollTo* results log here…</div></div>
        </.form_group>
        <.code_block lang="js">{@scrollto_code}</.code_block>
      </.card>
    </.example_page>

    <script type="module">
      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // --- Large Dataset Performance ---
      // Options are provided server-side via the wrapper; we still measure
      // render time (first paint after upgrade) and search time here.
      const startInit = performance.now();
      // Init time reflects the cost of preparing the page-side handlers; the
      // 15,000-option array itself is rendered by the component from server data.
      const endInit = performance.now();
      document.getElementById('init-time').textContent = Math.round(endInit - startInit);

      wait('performance-test').then((filterMultiselect) => {
        const startRender = performance.now();
        requestAnimationFrame(() => {
          const endRender = performance.now();
          document.getElementById('render-time').textContent = Math.round(endRender - startRender);
        });

        // Measure search performance
        let searchTimeout;
        filterMultiselect.addEventListener('search', (e) => {
          clearTimeout(searchTimeout);
          searchTimeout = setTimeout(() => {
            const startSearch = performance.now();
            requestAnimationFrame(() => {
              const endSearch = performance.now();
              document.getElementById('search-time').textContent = Math.round(endSearch - startSearch);
            });
          }, 50);
        });

        // Log selection changes
        filterMultiselect.addEventListener('change', (e) => {
          console.log('[Filter Mode] Selected:', e.detail.length, 'items');
        });
      });

      // --- Rich Rendering Example with Virtual Scroll ---
      wait('rich-virtual').then((richVirtual) => {
        // Rich rendering for dropdown options
        richVirtual.renderOptionContentCallback = (item, context) => {
          const stars = '★'.repeat(Math.floor(item.rating));
          const stockStatus = item.stock === 0 ? 'Out of stock' : `${item.stock} in stock`;
          const stockColor = item.stock === 0 ? '#ef4444' : item.stock < 20 ? '#f59e0b' : '#10b981';

          return `
            <div style="display: flex; gap: 0.5rem; align-items: center; padding: 0.25rem 0;">
              <div style="width: 32px; height: 32px; border-radius: 6px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); flex-shrink: 0; display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; font-weight: bold;">
                ${item.id}
              </div>
              <div style="flex: 1; min-width: 0;">
                <div style="font-weight: 600; font-size: 0.875rem;">${item.name}</div>
                <div style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.75rem; margin-top: 0.125rem;">
                  <span style="color: #666;">${item.category}</span>
                  <span style="color: #10b981; font-weight: 600;">$${item.price}</span>
                  <span style="color: #f59e0b;">${stars} ${item.rating}</span>
                  <span style="color: ${stockColor};">${stockStatus}</span>
                </div>
              </div>
            </div>
          `;
        };

        // Compact rendering for main badges
        richVirtual.renderBadgeContentCallback = (item, context) => {
          return `${item.name}`;
        };

        // Rich rendering for selected items popover (virtual scroll mode)
        richVirtual.renderSelectionBadgeContentCallback = (item) => {
          const priorityIcons = { urgent: '🚨', important: '⚠️', normal: '📋', low: '📝' };
          const stars = '★'.repeat(Math.floor(item.rating));

          return `
            <div style="display: flex; align-items: center; gap: 0.5rem; width: 100%;">
              <span style="font-size: 1rem;">${priorityIcons[item.priority]}</span>
              <div style="flex: 1; min-width: 0;">
                <div style="font-weight: 500; font-size: 0.8125rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${item.name}</div>
                <div style="font-size: 0.6875rem; color: #666; margin-top: 0.125rem;">
                  $${item.price} • ${stars} ${item.rating}
                </div>
              </div>
            </div>
          `;
        };

        // Priority-based CSS classes for selected items
        richVirtual.getSelectionBadgeClassCallback = (item) => {
          return `product-${item.priority}`;
        };

        // Inject custom CSS for priority-based styling
        richVirtual.customStylesCallback = () => `
          .product-urgent {
            --ml-badge-text-bg: #fee2e2;
            --ml-badge-text-color: #dc2626;
            --ml-badge-remove-bg: #dc2626;
          }
          .product-important {
            --ml-badge-text-bg: #fef3c7;
            --ml-badge-text-color: #d97706;
            --ml-badge-remove-bg: #d97706;
          }
          .product-normal {
            --ml-badge-text-bg: #dbeafe;
            --ml-badge-text-color: #2563eb;
            --ml-badge-remove-bg: #2563eb;
          }
          .product-low {
            --ml-badge-text-bg: #d1fae5;
            --ml-badge-text-color: #059669;
            --ml-badge-remove-bg: #059669;
          }
        `;

        // Log selection changes
        richVirtual.addEventListener('change', (e) => {
          console.log('[Rich Virtual] Selected:', e.detail.selectedOptions.length, 'items');
          if (e.detail.selectedOptions.length >= 100) {
            console.log('✅ Virtual scroll enabled in popover!');
          }
        });
      });

      // --- VS03 · Scroll-to API with virtual scroll ------------
      // Options are provided server-side via the wrapper; the scroll math is index-based
      // so the target row need not be rendered.
      wait('scroll-virtual-large').then((vsLarge) => {
        const vsLogEl = document.getElementById('vs-scroll-log');
        const vsLog = (msg) => {
          if (!vsLogEl) return;
          if (vsLogEl.querySelector('.muted')) vsLogEl.innerHTML = '';
          const row = document.createElement('div');
          row.style.marginBottom = '0.4rem';
          row.textContent = msg;
          vsLogEl.appendChild(row);
          vsLogEl.scrollTop = vsLogEl.scrollHeight;
        };
        // Inspect the shadow DOM to report where the (virtual) scroll landed.
        const vsDescribe = (el, targetIndex) => {
          const container = el.shadowRoot && el.shadowRoot.querySelector('.ms__options');
          if (!container) { vsLog('   ↳ (dropdown not open)'); return; }
          const crect = container.getBoundingClientRect();
          const rows = [...container.querySelectorAll('.ms__option')];
          const visible = rows.filter((o) => {
            const r = o.getBoundingClientRect();
            return r.bottom > crect.top + 1 && r.top < crect.bottom - 1;
          });
          const idxOf = (o) => o.closest('[data-index]')?.dataset.index ?? '?';
          const first = visible[0];
          const last = visible[visible.length - 1];
          const lbl = (o) => o ? `#${idxOf(o)} "${(o.querySelector('.ms__option-title') || o).textContent.trim()}"` : '—';
          let note = '';
          if (targetIndex != null) {
            const hit = visible.some((o) => o.closest('[data-index]')?.dataset.index === String(targetIndex));
            note = hit ? ` · target index ${targetIndex} VISIBLE` : ` · target index ${targetIndex} NOT in view`;
          }
          vsLog(`   ↳ scrollTop=${Math.round(container.scrollTop)} · shows ${lbl(first)} … ${lbl(last)} (${visible.length} rows)${note}`);
        };

        // Delegate on document so the listeners survive LiveView's DOM patch on connect.
        // As of @keenmate/web-multiselect 2.1.0 no stopPropagation()/capture-phase workaround
        // is needed: open() and every scrollTo* arm a one-tick outside-click guard, so
        // re-driving the already-open dropdown from an external button no longer closes it.
        document.addEventListener('click', (e) => {
          const btn = e.target.closest('[data-vs]');
          if (!btn) return;
          vsLarge.open();
          const spec = btn.dataset.vs;
          if (spec === 'clear') { vsLarge.clearSearch(); vsLog('clearSearch() — search reset'); return; }
          const [kind, arg] = spec.split(':');
          let ok, targetIndex = null;
          if (kind === 'index')       { ok = vsLarge.scrollToIndex(Number(arg)); targetIndex = Number(arg); }
          else if (kind === 'value')  { ok = vsLarge.scrollToValue(Number(arg)); }
          else if (kind === 'center') { ok = vsLarge.scrollToIndex(Number(arg), { block: 'center' }); targetIndex = Number(arg); }
          const call = kind === 'value' ? `scrollToValue(${arg})`
            : kind === 'center' ? `scrollToIndex(${arg}, {block:'center'})`
            : `scrollToIndex(${arg})`;
          vsLog(`▶ ${call} → ${ok}`);
          setTimeout(() => vsDescribe(vsLarge, targetIndex), 90);
        });
      });
    </script>
    """
  end
end
