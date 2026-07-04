defmodule TestAppWeb.Examples.EventsCallbacksLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # 1:1 mirror of upstream examples-events-callbacks.html. Demonstrates the DOM
  # events, their `on*` property twins, and the before* veto interceptors. Every
  # handler/interceptor is a JS-only property with no wrapper attribute, so they
  # (and the option data + live logging) are wired in the trailing inline script.
  #
  # NOTE: this page wires events directly on the element (addEventListener / on*),
  # NOT through the LiveView hook. It's a pure custom-element demo mirroring
  # upstream — the wrapper's KeenWebMultiselectHook is the LV-native path for
  # forwarding these same events to the server (see /test/events).

  @code_events ~S"""
  // Property handlers (the on* form) — return value ignored
  el.onSelect   = (option)          => log('prop', 'onSelect', option.label);
  el.onDeselect = (option)          => log('prop', 'onDeselect', option.label);
  el.onChange   = (selectedOptions) => log('prop', 'onChange', selectedOptions.map(o => o.value));

  // The very same notifications as bubbling DOM events
  el.addEventListener('change', (e) => {
    // e.detail = { option, selectedOptions, selectedValues }
    log('event', 'change', e.detail.selectedValues);
  });
  """

  @code_before_select ~S"""
  const EXCLUSIVE = ['full', 'part'];

  el.beforeSelectCallback = (option, selected) => {
    // block if the option conflicts with something already selected
    const conflict = EXCLUSIVE.includes(option.value)
      && selected.find(o => EXCLUSIVE.includes(o.value) && o.value !== option.value);
    if (conflict) {
      showMessage(`Blocked: can't pick ${option.label} while ${conflict.label} is selected`);
      return false;            // ← veto
    }
    // return undefined ⇒ allow
  };
  """

  @code_before_deselect ~S"""
  el.beforeDeselectCallback = (option) => {
    if (option.value === 'lead') {
      showMessage('Team Lead is required — cannot be removed');
      return false;            // ← veto removal
    }
  };
  el.setSelected(['lead']);    // pre-select (bypasses the veto)
  """

  # Server-side (hook-bound) demos. A small catalog with a `price` the browser
  # never sees — the point is that the total is derived on the server.
  @catalog [
    %{value: "laptop", label: "Laptop", price: 1200},
    %{value: "monitor", label: "Monitor", price: 300},
    %{value: "keyboard", label: "Keyboard", price: 90},
    %{value: "mouse", label: "Mouse", price: 40},
    %{value: "headset", label: "Headset", price: 150},
    %{value: "webcam", label: "Webcam", price: 80}
  ]

  @code_server_state ~S"""
  # app.js:  hooks: { KeenWebMultiselectHook }

  <.web_multiselect id="srv-cart" hook={true} options={@catalog} />

  # The change event crosses the wire; the server owns the state:
  def handle_event("web_multiselect:change", %{"id" => "srv-cart", "values" => values}, socket) do
    {:noreply, assign(socket, :cart, values)}
  end

  # ...the total is then derived server-side from a catalog the client never sees.
  """

  @code_server_limit ~S"""
  # Server-authoritative "max 3": allow optimistically, then correct.
  # push_update/3 is the sanctioned server→client channel (wraps push_event).
  def handle_event("web_multiselect:change", %{"id" => "srv-limit", "values" => values}, socket)
      when length(values) > 3 do
    kept = Enum.take(values, 3)

    {:noreply,
     socket
     |> assign(:limit_msg, "Rejected #{length(values)} > 3 — reverted to the first 3")
     |> Keenmate.WebMultiselect.push_update("srv-limit", value: kept)}
  end
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Events, Handlers & Interceptors — keen_web_multiselect")
     |> assign(:code_events, @code_events)
     |> assign(:code_before_select, @code_before_select)
     |> assign(:code_before_deselect, @code_before_deselect)
     |> assign(:code_server_state, @code_server_state)
     |> assign(:code_server_limit, @code_server_limit)
     |> assign(:catalog, @catalog)
     |> assign(:cart, [])
     |> assign(:log, [])
     |> assign(:log_seq, 0)
     |> assign(:limit_msg, nil)}
  end

  def render(assigns) do
    ~H"""
    <style>
      .log {
        background: #f9f9f9;
        padding: 1rem;
        border-radius: 4px;
        margin-top: 1rem;
        font-family: monospace;
        font-size: 0.8125rem;
        max-height: 200px;
        overflow-y: auto;
      }
      .log .muted { color: #666; }
      .tag-prop  { color: #9b1d8e; font-weight: 600; }
      .tag-event { color: #0066cc; font-weight: 600; }
      .tag-block { color: #c0392b; font-weight: 600; }
      .tag-ok    { color: #1e7e34; font-weight: 600; }
      .legend { font-size: 0.8125rem; margin-top: 0.25rem; display: block; }
    </style>

    <.example_page
      icon="🔔"
      title="Events, Handlers & Interceptors"
      subtitle="DOM events, the on* property twin, and before* veto interceptors"
    >
      <.card title="1 · Events — addEventListener & the on* twin">
        <.tip>Client-only: DOM <code>change</code>/<code>select</code>/<code>deselect</code> events and their <code>on*</code> property twins — wired in JS, no wrapper attribute.</.tip>
        <p>
          Every notification is available two ways and <strong>both fire for the same action</strong>:
          the bubbling DOM events <code>select</code> / <code>deselect</code> / <code>change</code>,
          and the JS properties <code>onSelect</code> / <code>onDeselect</code> / <code>onChange</code>.
          They're <em>events</em>, not callbacks — the return value is ignored. This picker wires both
          so you can watch them pair up.
        </p>
        <.form_group>
          <label>Pick a few</label>
          <.web_multiselect id="events-select" search_placeholder="Select skills..." />
          <small class="form-text legend">
            <span class="tag-prop">[prop]</span>
            = <code>on*</code> property handler &nbsp;·&nbsp;
            <span class="tag-event">[event]</span> = <code>addEventListener</code>
          </small>
        </.form_group>
        <div id="events-log" class="log" phx-update="ignore">
          <div class="muted">Pick an option — [prop] and [event] entries log here…</div>
        </div>
        <details style="margin-top: 1rem;">
          <summary>Show code</summary>
          <.code_block lang="js">{@code_events}</.code_block>
        </details>
      </.card>

      <.card title="2 · beforeSelectCallback — block a selection">
        <.tip>Client-only interceptor: set <code>el.beforeSelectCallback</code> in JS and return <code>false</code> to veto — no wrapper attribute.</.tip>
        <p>
          An <strong>interceptor</strong>: runs <em>before</em> an option is added and returns
          <code>false</code> to block it. Here <strong>Full-time</strong> and <strong>Part-time</strong>
          are mutually exclusive — picking one while the other is selected is vetoed. The veto is silent
          (no event fires); the message below is produced by the callback itself.
        </p>
        <.form_group>
          <label>Availability</label>
          <.web_multiselect id="exclusive-select" search_placeholder="Choose availability..." />
          <small class="form-text">Try selecting Full-time, then Part-time.</small>
        </.form_group>
        <div id="exclusive-log" class="log" phx-update="ignore">
          <div class="muted">Selections and blocks log here…</div>
        </div>
        <details style="margin-top: 1rem;">
          <summary>Show code</summary>
          <.code_block lang="js">{@code_before_select}</.code_block>
        </details>
      </.card>

      <.card title="3 · beforeDeselectCallback — protect a required item">
        <.tip>Client-only interceptor: set <code>el.beforeDeselectCallback</code> in JS and return <code>false</code> to protect an item — no wrapper attribute.</.tip>
        <p>
          The mirror interceptor on the way out. <strong>Team Lead</strong> is pre-selected and required
          — trying to remove it is vetoed, while the other members can be toggled freely. Note the veto
          applies only to interactive removal: programmatic <code>setSelected()</code> and the Clear-All
          button bypass it.
        </p>
        <.form_group>
          <label>Team</label>
          <.web_multiselect id="required-select" search_placeholder="Build the team..." />
          <small class="form-text">Team Lead can't be removed; the others can.</small>
        </.form_group>
        <div id="required-log" class="log" phx-update="ignore">
          <div class="muted">Try removing Team Lead, then a developer…</div>
        </div>
        <details style="margin-top: 1rem;">
          <summary>Show code</summary>
          <.code_block lang="js">{@code_before_deselect}</.code_block>
        </details>
      </.card>

      <.card title="Callback vs event — the one rule">
        <p>The line is drawn by <strong>whether the component uses the return value</strong>:</p>
        <ul>
          <li>
            <strong>Event</strong> (fire-and-forget, return ignored): <code>onSelect</code>,
            <code>onDeselect</code>, <code>onChange</code>, and the bare DOM
            <code>select</code>/<code>deselect</code>/<code>change</code> events.
          </li>
          <li>
            <strong>Interceptor callback</strong> (return consumed to cancel): <code>before*Callback</code>
            — <code>beforeSelectCallback</code>, <code>beforeDeselectCallback</code>,
            <code>beforeSearchCallback</code>.
          </li>
          <li>
            <strong>Data/behavior callback</strong> (return consumed as a value):
            <code>get*Callback</code> / <code>render*Callback</code> / <code>searchCallback</code>.
          </li>
        </ul>
        <.note title="Wrapper note:">
          In rc05 the fire-and-forget notifications were renamed from <code>*Callback</code> to
          <code>on*</code> (breaking, no alias), and the action-button predicates from
          <code>isVisibleCallback</code>/<code>isDisabledCallback</code> to
          <code>getIsVisibleCallback</code>/<code>getIsDisabledCallback</code>. The DOM event names
          (<code>select</code>/<code>deselect</code>/<code>change</code>) are unchanged, so the
          <code>KeenWebMultiselectHook</code> is unaffected.
        </.note>
      </.card>

      <.card title="🔌 Server-side binding — crossing to LiveView">
        <p>
          Everything above is <strong>client-only</strong>. The wrapper's
          <code>KeenWebMultiselectHook</code> is the LiveView-native path: add
          <code>hook={true}</code> and the same
          <code>select</code>/<code>deselect</code>/<code>change</code> events cross the wire to
          your <code>handle_event/3</code> as <code>"web_multiselect:select"</code> /
          <code>":deselect"</code> / <code>":change"</code> (payloads
          <code>%&lbrace;"id" =&gt; id, "value" =&gt; v, "values" =&gt; vs&rbrace;</code>). From there
          the server owns the state — no JavaScript.
        </p>
        <.note title="What can and can't cross the wire:">
          <ul>
            <li>
              <span class="tag-event">[event]</span>
              The three <strong>fire-and-forget</strong> notifications forward automatically — the
              server reacts <em>after</em> the fact.
            </li>
            <li>
              <span class="tag-block">[interceptor]</span>
              <code>beforeSelect</code>/<code>beforeDeselect</code> do <strong>not</strong> — a veto
              is <em>synchronous</em> and a server round-trip can't answer in time. For
              server-authoritative rules you enforce <em>after</em> the change and correct the
              element with <code>Keenmate.WebMultiselect.push_update/3</code> (last demo below).
            </li>
          </ul>
        </.note>
      </.card>

      <.keen_card title="Live server state — derived on the server">
        <.tip><code>{"hook={true}"}</code> forwards <code>change</code> to <code>handle_event("web_multiselect:change", …)</code> — the server owns the state.</.tip>
        <p>
          The server receives every <code>change</code>, keeps the selection in assigns, and renders
          data the client never had: a price lookup and total from a server-side catalog.
        </p>
        <.form_group>
          <label>Build a cart (hook-bound)</label>
          <.web_multiselect
            id="srv-cart"
            hook={true}
            options={@catalog}
            search_placeholder="Add products..."
          />
        </.form_group>
        <div class="log">
          <div :if={@cart == []} class="muted">
            Select products — the server looks up prices and totals them…
          </div>
          <div :if={@cart != []}>
            <div :for={item <- cart_items(@cart)} style="margin-bottom: 0.25rem;">
              <span class="tag-ok">{item.label}</span> {"$#{item.price}"}
            </div>
            <div style="margin-top: 0.5rem;">
              <strong>{length(@cart)} item(s) · server total {"$#{cart_total(@cart)}"}</strong>
            </div>
          </div>
        </div>
        <details style="margin-top: 1rem;">
          <summary>Show server code</summary>
          <.code_block lang="elixir">{@code_server_state}</.code_block>
        </details>
      </.keen_card>

      <.keen_card title="Server event log — select / deselect / change">
        <.tip><code>{"hook={true}"}</code> — all three events land in <code>handle_event("web_multiselect:select|deselect|change", …)</code> on the server.</.tip>
        <p>
          All three events land in <code>handle_event/3</code>. Here the server stamps each with a
          sequence number and renders them newest-first — proof they're genuinely server-side, not
          the browser console.
        </p>
        <.form_group>
          <label>Toggle a few (hook-bound)</label>
          <.web_multiselect id="srv-log" hook={true} options={@catalog} />
        </.form_group>
        <div class="log">
          <div :if={@log == []} class="muted">
            Select / deselect — server-logged entries appear here…
          </div>
          <div :for={e <- @log} style="margin-bottom: 0.4rem;">
            <span class={log_tag(e.name)}>{"##{e.seq}"} {e.name}</span>
            <code>{inspect(e.payload)}</code>
          </div>
        </div>
      </.keen_card>

      <.keen_card title="Server-authoritative rule — enforce &amp; correct via push_update/3">
        <.tip><code>{"hook={true}"}</code> forwards <code>change</code>; the server corrects the element with <code>Keenmate.WebMultiselect.push_update/3</code>.</.tip>
        <p>
          The closest thing to a server veto. The server allows the change optimistically, then if
          the rule is violated it corrects the element with
          <code>Keenmate.WebMultiselect.push_update(socket, "srv-limit", value: kept)</code>. Here:
          <strong>pick at most 3</strong>, enforced entirely on the server.
        </p>
        <.form_group>
          <label>Pick up to 3 (server-enforced)</label>
          <.web_multiselect id="srv-limit" hook={true} options={@catalog} />
        </.form_group>
        <div class="log">
          <div :if={is_nil(@limit_msg)} class="muted">Selecting a 4th item is reverted by the server…</div>
          <div :if={@limit_msg}><span class="tag-block">{@limit_msg}</span></div>
        </div>
        <details style="margin-top: 1rem;">
          <summary>Show server code</summary>
          <.code_block lang="elixir">{@code_server_limit}</.code_block>
        </details>
      </.keen_card>

      <script type="module">
        const wait = (id) => new Promise((resolve) => {
          const check = () => {
            const el = document.getElementById(id);
            if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
            else requestAnimationFrame(check);
          };
          check();
        });

        const stamp = () => new Date().toLocaleTimeString();
        function logger(el) {
          return (cls, label, text) => {
            if (el.querySelector('.muted')) el.innerHTML = '';
            const row = document.createElement('div');
            row.style.marginBottom = '0.4rem';
            row.innerHTML = `<span class="${cls}">[${stamp()}] ${label}</span> ${text ?? ''}`;
            el.appendChild(row);
            el.scrollTop = el.scrollHeight;
          };
        }

        // --- 1. Events + on* twin ---------------------------------
        const skills = [
          { value: 'js', label: 'JavaScript' },
          { value: 'ts', label: 'TypeScript' },
          { value: 'py', label: 'Python' },
          { value: 'go', label: 'Go' },
          { value: 'rust', label: 'Rust' }
        ];
        wait('events-select').then((eventsSelect) => {
          const eventsLog = logger(document.getElementById('events-log'));
          eventsSelect.options = skills;
          eventsSelect.onSelect   = (option) => eventsLog('tag-prop', '[prop] onSelect', option.label);
          eventsSelect.onDeselect = (option) => eventsLog('tag-prop', '[prop] onDeselect', option.label);
          eventsSelect.onChange   = (selectedOptions) =>
            eventsLog('tag-prop', '[prop] onChange', JSON.stringify(selectedOptions.map(o => o.value)));
          eventsSelect.addEventListener('change', (e) =>
            eventsLog('tag-event', '[event] change', JSON.stringify(e.detail.selectedValues)));
        });

        // --- 2. beforeSelectCallback (mutually exclusive) ---------
        const availability = [
          { value: 'full', label: 'Full-time' },
          { value: 'part', label: 'Part-time' },
          { value: 'contract', label: 'Contract' },
          { value: 'remote', label: 'Remote OK' }
        ];
        const EXCLUSIVE = ['full', 'part'];
        wait('exclusive-select').then((exclusiveSelect) => {
          const exclusiveLog = logger(document.getElementById('exclusive-log'));
          exclusiveSelect.options = availability;
          exclusiveSelect.beforeSelectCallback = (option, selected) => {
            const conflict = EXCLUSIVE.includes(option.value)
              && selected.find(o => EXCLUSIVE.includes(o.value) && o.value !== option.value);
            if (conflict) {
              exclusiveLog('tag-block', '[blocked] beforeSelect',
                `can't pick ${option.label} while ${conflict.label} is selected`);
              return false;
            }
            // allow
          };
          exclusiveSelect.onSelect = (option) => exclusiveLog('tag-ok', '[allowed] onSelect', option.label);
        });

        // --- 3. beforeDeselectCallback (required item) ------------
        const team = [
          { value: 'lead', label: 'Team Lead' },
          { value: 'dev-a', label: 'Developer A' },
          { value: 'dev-b', label: 'Developer B' },
          { value: 'qa', label: 'QA Engineer' }
        ];
        wait('required-select').then((requiredSelect) => {
          const requiredLog = logger(document.getElementById('required-log'));
          requiredSelect.options = team;
          requiredSelect.beforeDeselectCallback = (option) => {
            if (option.value === 'lead') {
              requiredLog('tag-block', '[blocked] beforeDeselect', 'Team Lead is required — cannot be removed');
              return false;
            }
          };
          requiredSelect.onDeselect = (option) => requiredLog('tag-ok', '[removed] onDeselect', option.label);
          requiredSelect.setSelected(['lead']); // pre-select; bypasses the veto
        });
      </script>
    </.example_page>
    """
  end

  # --- Server-side binding: the forwarded events land here -------------------

  # Cart: keep the change's value list; the total is derived at render time.
  def handle_event("web_multiselect:change", %{"id" => "srv-cart", "values" => values}, socket) do
    {:noreply, assign(socket, :cart, values)}
  end

  # Server-authoritative "max 3": correct the element when the rule is broken.
  def handle_event("web_multiselect:change", %{"id" => "srv-limit", "values" => values}, socket)
      when length(values) > 3 do
    kept = Enum.take(values, 3)

    {:noreply,
     socket
     |> assign(:limit_msg, "Server rejected #{length(values)} selections (max 3) — reverted to the first 3.")
     |> Keenmate.WebMultiselect.push_update("srv-limit", value: kept)}
  end

  def handle_event("web_multiselect:change", %{"id" => "srv-limit"}, socket) do
    {:noreply, assign(socket, :limit_msg, nil)}
  end

  # Event log: stamp select/deselect/change with a sequence number, newest first.
  def handle_event("web_multiselect:" <> kind = name, %{"id" => "srv-log"} = payload, socket)
      when kind in ["select", "deselect", "change"] do
    seq = socket.assigns.log_seq + 1
    entry = %{seq: seq, name: name, payload: payload}
    {:noreply, assign(socket, log: Enum.take([entry | socket.assigns.log], 12), log_seq: seq)}
  end

  # Fire-and-forget events we don't act on (e.g. select/deselect on cart/limit).
  def handle_event("web_multiselect:" <> _kind, _payload, socket), do: {:noreply, socket}

  # Resolve selected values to catalog rows (order-preserving), for the total.
  defp cart_items(values) do
    Enum.flat_map(values, fn v ->
      case Enum.find(@catalog, &(&1.value == v)) do
        nil -> []
        item -> [item]
      end
    end)
  end

  defp cart_total(values), do: values |> cart_items() |> Enum.map(& &1.price) |> Enum.sum()

  defp log_tag("web_multiselect:select"), do: "tag-ok"
  defp log_tag("web_multiselect:deselect"), do: "tag-block"
  defp log_tag("web_multiselect:change"), do: "tag-event"
end
