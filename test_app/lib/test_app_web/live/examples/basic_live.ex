defmodule TestAppWeb.Examples.BasicLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  alias Keenmate.WebMultiselect

  # Datasets below mirror upstream's examples-classic.0.js verbatim so this page
  # can be diffed card-for-card against the upstream demo.

  @languages [
    %{value: "js", label: "JavaScript", icon: "🟨"},
    %{value: "ts", label: "TypeScript", icon: "🔷"},
    %{value: "python", label: "Python", icon: "🐍"},
    %{value: "java", label: "Java", icon: "☕"},
    %{value: "csharp", label: "C#", icon: "💜"},
    %{value: "php", label: "PHP", icon: "🐘"},
    %{value: "ruby", label: "Ruby", icon: "💎"},
    %{value: "go", label: "Go", icon: "🐹"}
  ]

  # `year` is the sort key behind BU02's selected-order="member" demo.
  @frameworks [
    %{value: "react", label: "React", icon: "⚛️", subtitle: "A JavaScript library for building user interfaces", year: 2013},
    %{value: "vue", label: "Vue.js", icon: "🖖", subtitle: "The Progressive JavaScript Framework", year: 2014},
    %{value: "angular", label: "Angular", icon: "🅰️", subtitle: "Platform for building web applications", year: 2016},
    %{value: "svelte", label: "Svelte", icon: "🔥", subtitle: "Cybernetically enhanced web apps", year: 2016},
    %{value: "solid", label: "Solid", icon: "💎", subtitle: "Simple and performant reactivity", year: 2021}
  ]

  @grouped_techs [
    %{value: "react", label: "React", icon: "⚛️", group: "frontend"},
    %{value: "vue", label: "Vue.js", icon: "🖖", group: "frontend"},
    %{value: "svelte", label: "Svelte", icon: "🔥", group: "frontend"},
    %{value: "angular", label: "Angular", icon: "🅰️", group: "frontend"},
    %{value: "nodejs", label: "Node.js", icon: "🟢", group: "backend"},
    %{value: "django", label: "Django", icon: "🐍", group: "backend"},
    %{value: "rails", label: "Ruby on Rails", icon: "💎", group: "backend"},
    %{value: "express", label: "Express", icon: "🚂", group: "backend"},
    %{value: "postgres", label: "PostgreSQL", icon: "🐘", group: "database"},
    %{value: "mongodb", label: "MongoDB", icon: "🍃", group: "database"},
    %{value: "redis", label: "Redis", icon: "🔴", group: "database"}
  ]

  @all_countries [
    %{value: "af", label: "Afghanistan"},
    %{value: "al", label: "Albania"},
    %{value: "dz", label: "Algeria"},
    %{value: "ar", label: "Argentina"},
    %{value: "am", label: "Armenia"},
    %{value: "au", label: "Australia"},
    %{value: "at", label: "Austria"},
    %{value: "az", label: "Azerbaijan"},
    %{value: "bh", label: "Bahrain"},
    %{value: "bd", label: "Bangladesh"},
    %{value: "by", label: "Belarus"},
    %{value: "be", label: "Belgium"},
    %{value: "bz", label: "Belize"},
    %{value: "bo", label: "Bolivia"},
    %{value: "br", label: "Brazil"},
    %{value: "bg", label: "Bulgaria"},
    %{value: "kh", label: "Cambodia"},
    %{value: "cm", label: "Cameroon"},
    %{value: "ca", label: "Canada"},
    %{value: "cl", label: "Chile"},
    %{value: "cn", label: "China"},
    %{value: "co", label: "Colombia"},
    %{value: "cr", label: "Costa Rica"},
    %{value: "hr", label: "Croatia"},
    %{value: "cu", label: "Cuba"},
    %{value: "cy", label: "Cyprus"},
    %{value: "cz", label: "Czech Republic"},
    %{value: "dk", label: "Denmark"},
    %{value: "ec", label: "Ecuador"},
    %{value: "eg", label: "Egypt"},
    %{value: "sv", label: "El Salvador"},
    %{value: "ee", label: "Estonia"},
    %{value: "et", label: "Ethiopia"},
    %{value: "fi", label: "Finland"},
    %{value: "fr", label: "France"},
    %{value: "ge", label: "Georgia"},
    %{value: "de", label: "Germany"},
    %{value: "gh", label: "Ghana"},
    %{value: "gr", label: "Greece"},
    %{value: "gt", label: "Guatemala"},
    %{value: "hn", label: "Honduras"},
    %{value: "hk", label: "Hong Kong"},
    %{value: "hu", label: "Hungary"},
    %{value: "is", label: "Iceland"},
    %{value: "in", label: "India"},
    %{value: "id", label: "Indonesia"},
    %{value: "ir", label: "Iran"},
    %{value: "iq", label: "Iraq"},
    %{value: "ie", label: "Ireland"},
    %{value: "il", label: "Israel"},
    %{value: "it", label: "Italy"},
    %{value: "jm", label: "Jamaica"},
    %{value: "jp", label: "Japan"},
    %{value: "jo", label: "Jordan"},
    %{value: "kz", label: "Kazakhstan"},
    %{value: "ke", label: "Kenya"},
    %{value: "kw", label: "Kuwait"},
    %{value: "lv", label: "Latvia"},
    %{value: "lb", label: "Lebanon"},
    %{value: "lt", label: "Lithuania"},
    %{value: "lu", label: "Luxembourg"},
    %{value: "my", label: "Malaysia"},
    %{value: "mt", label: "Malta"},
    %{value: "mx", label: "Mexico"},
    %{value: "ma", label: "Morocco"},
    %{value: "np", label: "Nepal"},
    %{value: "nl", label: "Netherlands"},
    %{value: "nz", label: "New Zealand"},
    %{value: "ng", label: "Nigeria"},
    %{value: "no", label: "Norway"},
    %{value: "om", label: "Oman"},
    %{value: "pk", label: "Pakistan"},
    %{value: "pa", label: "Panama"},
    %{value: "py", label: "Paraguay"},
    %{value: "pe", label: "Peru"},
    %{value: "ph", label: "Philippines"},
    %{value: "pl", label: "Poland"},
    %{value: "pt", label: "Portugal"},
    %{value: "qa", label: "Qatar"},
    %{value: "ro", label: "Romania"},
    %{value: "ru", label: "Russia"},
    %{value: "sa", label: "Saudi Arabia"},
    %{value: "rs", label: "Serbia"},
    %{value: "sg", label: "Singapore"},
    %{value: "sk", label: "Slovakia"},
    %{value: "si", label: "Slovenia"},
    %{value: "za", label: "South Africa"},
    %{value: "kr", label: "South Korea"},
    %{value: "es", label: "Spain"},
    %{value: "lk", label: "Sri Lanka"},
    %{value: "se", label: "Sweden"},
    %{value: "ch", label: "Switzerland"},
    %{value: "tw", label: "Taiwan"},
    %{value: "th", label: "Thailand"},
    %{value: "tr", label: "Turkey"},
    %{value: "ua", label: "Ukraine"},
    %{value: "ae", label: "United Arab Emirates"},
    %{value: "uk", label: "United Kingdom"},
    %{value: "us", label: "United States"},
    %{value: "uy", label: "Uruguay"},
    %{value: "ve", label: "Venezuela"},
    %{value: "vn", label: "Vietnam"}
  ]

  # Search Modes demo data — non-canonical keys (id/name/flag), so *_member attrs
  # are passed explicitly on those controls.
  @countries_with_flags [
    %{id: 1, name: "Canada", flag: "🇨🇦"},
    %{id: 2, name: "United States", flag: "🇺🇸"},
    %{id: 3, name: "Mexico", flag: "🇲🇽"},
    %{id: 4, name: "United Kingdom", flag: "🇬🇧"},
    %{id: 5, name: "France", flag: "🇫🇷"},
    %{id: 6, name: "Germany", flag: "🇩🇪"},
    %{id: 7, name: "Italy", flag: "🇮🇹"},
    %{id: 8, name: "Spain", flag: "🇪🇸"},
    %{id: 9, name: "Japan", flag: "🇯🇵"},
    %{id: 10, name: "China", flag: "🇨🇳"},
    %{id: 11, name: "India", flag: "🇮🇳"},
    %{id: 12, name: "Brazil", flag: "🇧🇷"},
    %{id: 13, name: "Argentina", flag: "🇦🇷"},
    %{id: 14, name: "Australia", flag: "🇦🇺"},
    %{id: 15, name: "New Zealand", flag: "🇳🇿"},
    %{id: 16, name: "South Africa", flag: "🇿🇦"},
    %{id: 17, name: "Egypt", flag: "🇪🇬"},
    %{id: 18, name: "Nigeria", flag: "🇳🇬"},
    %{id: 19, name: "Russia", flag: "🇷🇺"},
    %{id: 20, name: "Poland", flag: "🇵🇱"},
    %{id: 21, name: "Sweden", flag: "🇸🇪"},
    %{id: 22, name: "Norway", flag: "🇳🇴"},
    %{id: 23, name: "Denmark", flag: "🇩🇰"},
    %{id: 24, name: "Finland", flag: "🇫🇮"},
    %{id: 25, name: "Netherlands", flag: "🇳🇱"},
    %{id: 26, name: "Belgium", flag: "🇧🇪"},
    %{id: 27, name: "Switzerland", flag: "🇨🇭"},
    %{id: 28, name: "Austria", flag: "🇦🇹"},
    %{id: 29, name: "Portugal", flag: "🇵🇹"},
    %{id: 30, name: "Greece", flag: "🇬🇷"},
    %{id: 31, name: "Turkey", flag: "🇹🇷"},
    %{id: 32, name: "South Korea", flag: "🇰🇷"},
    %{id: 33, name: "Thailand", flag: "🇹🇭"},
    %{id: 34, name: "Vietnam", flag: "🇻🇳"},
    %{id: 35, name: "Indonesia", flag: "🇮🇩"},
    %{id: 36, name: "Philippines", flag: "🇵🇭"},
    %{id: 37, name: "Singapore", flag: "🇸🇬"},
    %{id: 38, name: "Malaysia", flag: "🇲🇾"},
    %{id: 39, name: "Pakistan", flag: "🇵🇰"},
    %{id: 40, name: "Bangladesh", flag: "🇧🇩"},
    %{id: 41, name: "Colombia", flag: "🇨🇴"},
    %{id: 42, name: "Chile", flag: "🇨🇱"},
    %{id: 43, name: "Peru", flag: "🇵🇪"},
    %{id: 44, name: "Venezuela", flag: "🇻🇪"},
    %{id: 45, name: "Saudi Arabia", flag: "🇸🇦"},
    %{id: 46, name: "United Arab Emirates", flag: "🇦🇪"},
    %{id: 47, name: "Israel", flag: "🇮🇱"},
    %{id: 48, name: "Iran", flag: "🇮🇷"},
    %{id: 49, name: "Iraq", flag: "🇮🇶"},
    %{id: 50, name: "Ukraine", flag: "🇺🇦"}
  ]

  # BU06b code sample — kept in a heredoc so the literal backticks / parens / JS
  # comments never hit the HEEx parser (which would try to read `{...}` as
  # interpolation). Rendered verbatim inside the card's <pre><code>.
  @bu06b_code """
  el.open();
  el.scrollToGroup('backend');   // header centered (or the group's first row in virtual mode)
  el.scrollToValue('redis');     // → false if filtered out by the current search
  el.scrollToIndex(0);

  // Reveal a filtered-out option, then scroll to it:
  el.clearSearch();
  el.scrollToValue('jp');\
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Basic Usage — keen_web_multiselect")
     |> assign(:languages, @languages)
     |> assign(:frameworks, @frameworks)
     |> assign(:grouped_techs, @grouped_techs)
     |> assign(:cmd_log, [])
     |> assign(:cmd_auto_opened, false)
     # Consolidated live-control cards (BU01–BU03). Each control panel is a
     # phx-change form; on change we rebuild the config and the picker is
     # re-keyed (its id encodes the config), so LiveView tears it down and
     # remounts it with the new attributes. This is the wrapper-side answer to
     # the upstream JS demos: phx-update="ignore" stops morphdom from patching
     # attributes onto a live element, so we remount instead of mutating.
     # The trade-off is that the selection resets to the seeded `value` on each
     # toggle — which is exactly what makes every attribute combination easy to
     # eyeball.
     |> assign(:bu01, %{
       multiple: true,
       show_clear: false,
       show_counter: false,
       close_on_select: false,
       sim: "normal",
       dir: "ltr"
     })
     |> assign(:bu02, %{
       icons: true,
       subtitles: true,
       mode: "badges",
       pos: "bottom",
       max_visible: 3,
       order: "as-selected"
     })
     |> assign(:bu03, %{mode: "none", custom_labels: false, count_format: "bracket"})
     |> assign(:all_countries, @all_countries)
     |> assign(:countries_with_flags, @countries_with_flags)
     |> assign(:bu06b_code, @bu06b_code)}
  end

  # -- BU06c · server-driven push_command/3 -----------------------------------

  def handle_event("cmd", %{"kind" => kind, "arg" => arg}, socket) do
    {:noreply, run_cmd(socket, "cmd-grouped", kind, arg)}
  end

  # Auto-open on entry: fires once when #cmd-onentry signals its first build is
  # done (opt-in via ready_event=). One-shot guard — the hook can replay it and
  # a reconnect re-mounts.
  def handle_event("web_multiselect:ready", %{"id" => "cmd-onentry"}, socket) do
    if socket.assigns.cmd_auto_opened do
      {:noreply, socket}
    else
      socket
      |> assign(:cmd_auto_opened, true)
      |> WebMultiselect.push_command("cmd-onentry", open: true, scroll_to_group: "database")
      |> log_cmd(~s|ready → push_command("cmd-onentry", open: true, scroll_to_group: "database")|)
      |> then(&{:noreply, &1})
    end
  end

  # The BU06c widgets carry the hook, so they forward select/deselect/change (and
  # #cmd-onentry's ready). Drain any we don't act on so an unhandled event can't
  # crash the page. (See ai/server-updates.txt — a new hook event must never be
  # left unhandled.)
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}

  # -- BU01–BU03 · live-control panels (remount on change) --------------------

  def handle_event("bu01", params, socket) do
    {:noreply,
     assign(socket, :bu01, %{
       multiple: params["multiple"] == "on",
       show_clear: params["show_clear"] == "on",
       show_counter: params["show_counter"] == "on",
       close_on_select: params["close_on_select"] == "on",
       sim: params["sim"] || "normal",
       dir: params["dir"] || "ltr"
     })}
  end

  def handle_event("bu02", params, socket) do
    {:noreply,
     assign(socket, :bu02, %{
       icons: params["icons"] == "on",
       subtitles: params["subtitles"] == "on",
       mode: params["mode"] || "badges",
       pos: params["pos"] || "bottom",
       max_visible: parse_max_visible(params["max_visible"]),
       order: params["order"] || "as-selected"
     })}
  end

  def handle_event("bu03", params, socket) do
    {:noreply,
     assign(socket, :bu03, %{
       mode: params["mode"] || "none",
       custom_labels: params["custom_labels"] == "on",
       count_format: params["count_format"] || "bracket"
     })}
  end

  defp parse_max_visible(nil), do: 3

  defp parse_max_visible(str) do
    case Integer.parse(str) do
      {n, _} when n >= 1 -> n
      _ -> 3
    end
  end

  # The element id encodes the config, so any control change yields a new id →
  # LiveView remounts the picker with the new attributes.
  defp bu01_sig(c),
    do: "#{flag(c.multiple)}#{flag(c.show_clear)}#{flag(c.show_counter)}#{flag(c.close_on_select)}-#{c.sim}-#{c.dir}"

  defp bu02_sig(c),
    do: "#{flag(c.icons)}#{flag(c.subtitles)}-#{c.mode}-#{c.pos}-#{c.max_visible}-#{c.order}"

  defp bu03_sig(c), do: "#{c.mode}-#{flag(c.custom_labels)}-#{c.count_format}"

  defp flag(true), do: "1"
  defp flag(false), do: "0"

  # The wrapper always defaults icon-member/subtitle-member, so the icons/subtitles
  # toggles work by stripping those keys from the data rather than unsetting the member.
  defp bu02_options(frameworks, bu02) do
    frameworks
    |> then(fn list -> if bu02.icons, do: list, else: Enum.map(list, &Map.delete(&1, :icon)) end)
    |> then(fn list -> if bu02.subtitles, do: list, else: Enum.map(list, &Map.delete(&1, :subtitle)) end)
  end

  defp run_cmd(socket, id, "group", g) do
    socket
    |> WebMultiselect.push_command(id, open: true, scroll_to_group: g)
    |> log_cmd(~s|push_command("#{id}", open: true, scroll_to_group: "#{g}")|)
  end

  defp run_cmd(socket, id, "value", v) do
    socket
    |> WebMultiselect.push_command(id, open: true, scroll_to_value: v)
    |> log_cmd(~s|push_command("#{id}", open: true, scroll_to_value: "#{v}")|)
  end

  defp run_cmd(socket, id, "index", i) do
    socket
    |> WebMultiselect.push_command(id, open: true, scroll_to_index: String.to_integer(i))
    |> log_cmd(~s|push_command("#{id}", open: true, scroll_to_index: #{i})|)
  end

  defp run_cmd(socket, id, "search", q) do
    socket
    |> WebMultiselect.push_command(id, open: true, search: q)
    |> log_cmd(~s|push_command("#{id}", open: true, search: "#{q}")|)
  end

  defp run_cmd(socket, id, "clear", _) do
    socket
    |> WebMultiselect.push_command(id, clear_search: true)
    |> log_cmd(~s|push_command("#{id}", clear_search: true)|)
  end

  defp run_cmd(socket, id, "close", _) do
    socket
    |> WebMultiselect.push_command(id, close: true)
    |> log_cmd(~s|push_command("#{id}", close: true)|)
  end

  defp log_cmd(socket, line), do: update(socket, :cmd_log, &Enum.take([line | &1], 8))

  def render(assigns) do
    ~H"""
    <.example_page
      icon="📦"
      title="Basic Usage"
      subtitle="The essentials, each as ONE live picker you configure with control switches — selection & input mode, content & display, and groups — plus declarative markup, the scroll-to API, and filter-vs-navigate search."
    >
      <.card title="BU01 · Selection & Input Mode">
        <p>
          One picker, many behaviors. Flip between multi- and single-select, add the inline
          clear (✕) and the count badge, change the <code>search_input_mode</code> (a
          <code>readonly</code> or <code>hidden</code> search gives keyboard-only navigation),
          toggle <code>close_on_select</code>, and switch text direction (LTR / RTL).
        </p>
        <.note variant="warning">
          The wrapper emits <code>phx-update="ignore"</code> so morphdom stays out of the
          component's shadow-managed DOM — which means a control change here
          <strong>remounts</strong> the element with the new attributes instead of patching
          them in place, so the selection resets to the seeded <code>{"value={~w(js ts)}"}</code>
          on each toggle. (For runtime option/value changes without a remount, use
          <code>push_update/3</code>; see BU05b.)
        </.note>

        <form phx-change="bu01" style="display: contents">
          <div class="controls">
            <label><input type="checkbox" name="multiple" checked={@bu01.multiple} /> <code>multiple</code></label>
            <label><input type="checkbox" name="show_clear" checked={@bu01.show_clear} /> <code>show_clear</code> (✕)</label>
            <label><input type="checkbox" name="show_counter" checked={@bu01.show_counter} /> <code>show_counter</code></label>
            <label><input type="checkbox" name="close_on_select" checked={@bu01.close_on_select} /> <code>close_on_select</code></label>
          </div>
          <div class="controls">
            <span><code>search_input_mode</code>:</span>
            <label><input type="radio" name="sim" value="normal" checked={@bu01.sim == "normal"} /> normal</label>
            <label><input type="radio" name="sim" value="readonly" checked={@bu01.sim == "readonly"} /> readonly</label>
            <label><input type="radio" name="sim" value="hidden" checked={@bu01.sim == "hidden"} /> hidden</label>
          </div>
          <div class="controls">
            <span><code>dir</code>:</span>
            <label><input type="radio" name="dir" value="ltr" checked={@bu01.dir == "ltr"} /> ltr</label>
            <label><input type="radio" name="dir" value="rtl" checked={@bu01.dir == "rtl"} /> rtl</label>
          </div>
        </form>

        <div class="demo-area">
          <.web_multiselect
            id={"ex-selection-" <> bu01_sig(@bu01)}
            multiple={@bu01.multiple}
            show_clear={@bu01.show_clear}
            show_counter={@bu01.show_counter}
            close_on_select={@bu01.close_on_select}
            search_input_mode={@bu01.sim}
            dir={@bu01.dir}
            options={@languages}
            value={~w(js ts)}
            icon_member="icon"
            search_placeholder="Search…"
            defer={false}
          />
        </div>
      </.card>

      <.card title="BU02 · Content & Display">
        <p>
          Icons and subtitles on the option rows, plus how the current selection is shown in the
          control: the <code>badges_display_mode</code>, where badges sit
          (<code>badges_position</code>), and the order the selected items appear in
          (<code>selected_order</code>).
        </p>

        <form phx-change="bu02" style="display: contents">
          <div class="controls">
            <label><input type="checkbox" name="icons" checked={@bu02.icons} /> icons</label>
            <label><input type="checkbox" name="subtitles" checked={@bu02.subtitles} /> subtitles</label>
          </div>
          <div class="controls">
            <span><code>badges_display_mode</code>:</span>
            <label :for={m <- ~w(badges count compact partial none)}>
              <input type="radio" name="mode" value={m} checked={@bu02.mode == m} /> {m}
            </label>
            <label :if={@bu02.mode == "partial"} style="margin-inline-start:1rem"><code>badges_max_visible</code>:
              <input type="number" name="max_visible" min="1" max="10" value={@bu02.max_visible} style="width:3.5rem" />
            </label>
          </div>
          <div class="controls">
            <span><code>badges_position</code>:</span>
            <label :for={p <- ~w(bottom top left right)}>
              <input type="radio" name="pos" value={p} checked={@bu02.pos == p} /> {p}
            </label>
          </div>
          <div class="controls">
            <span><code>selected_order</code>:</span>
            <label><input type="radio" name="order" value="as-selected" checked={@bu02.order == "as-selected"} /> as-selected</label>
            <label><input type="radio" name="order" value="label-asc" checked={@bu02.order == "label-asc"} /> label A→Z</label>
            <label><input type="radio" name="order" value="label-desc" checked={@bu02.order == "label-desc"} /> label Z→A</label>
            <label><input type="radio" name="order" value="member" checked={@bu02.order == "member"} /> member (year)</label>
            <span class="muted" style="margin-inline-start:0.5rem">selected badges reorder; the value stays as-picked</span>
          </div>
        </form>

        <div class="demo-area">
          <.web_multiselect
            id={"ex-display-" <> bu02_sig(@bu02)}
            options={bu02_options(@frameworks, @bu02)}
            value={~w(react vue svelte)}
            badges_display_mode={@bu02.mode}
            badges_position={@bu02.pos}
            badges_max_visible={@bu02.max_visible}
            selected_order={@bu02.order}
            selected_order_member={if @bu02.order == "member", do: "year"}
            search_placeholder="Search frameworks…"
            defer={false}
          />
        </div>
        <small class="form-text">
          <code>selected_order="custom"</code> needs a comparator (<code>selectedOrderCompareCallback</code>),
          a JS-only callback — see the Custom Rendering page. Same for the group custom-label and
          ratio-counter callbacks in BU03.
        </small>
      </.card>

      <.card title="BU03 · Groups">
        <p>
          Group options under headers with a <code>group</code> member. Each group header shows a
          <strong>count of that group's selected items</strong> (in any mode — open the dropdown
          to see it). Turn on <strong>per-group select-all</strong>
          (<code>group_select_mode="cascade"</code>) to also put a tristate checkbox on each
          header that toggles the whole group — the group name is never itself a value, so the
          selection carries member values only and a partially-selected group reads indeterminate.
          Turning on <strong>custom labels</strong> renders the header via
          <code>renderGroupLabelContentCallback</code>, whose 2nd arg carries the per-group
          selection — here it writes <code>GROUP — N remaining</code>
          (<code>selectableCount − selectedCount</code>).
        </p>

        <form phx-change="bu03" style="display: contents">
          <div class="controls">
            <span><code>group_select_mode</code>:</span>
            <label><input type="radio" name="mode" value="none" checked={@bu03.mode == "none"} /> none</label>
            <label><input type="radio" name="mode" value="cascade" checked={@bu03.mode == "cascade"} /> cascade</label>
            <label style="margin-inline-start:1rem"><input type="checkbox" name="custom_labels" checked={@bu03.custom_labels} /> custom labels (<code>renderGroupLabelContentCallback</code>)</label>
          </div>
          <div class="controls">
            <span><code>getCountLabelCallback</code>:</span>
            <label><input type="radio" name="count_format" value="bracket" checked={@bu03.count_format == "bracket"} /> <code>[x]</code> (default)</label>
            <label><input type="radio" name="count_format" value="ratio" checked={@bu03.count_format == "ratio"} /> <code>x/y</code></label>
            <span class="muted" style="margin-inline-start:0.5rem">drives the in-input counter <em>and</em> each group's count</span>
          </div>
        </form>

        <div class="demo-area">
          <.web_multiselect
            id={"ex-groups-" <> bu03_sig(@bu03)}
            hook="Bu03Callbacks"
            data-custom-labels={to_string(@bu03.custom_labels)}
            data-count-format={@bu03.count_format}
            options={@grouped_techs}
            value={~w(react nodejs)}
            allow_groups={true}
            group_select_mode={@bu03.mode}
            show_counter={true}
            icon_member="icon"
            search_placeholder="Search…"
            defer={false}
          />
        </div>
        <small class="form-text">
          <code>renderGroupLabelContentCallback</code> / <code>getCountLabelCallback</code> are
          JS function props (no attribute equivalent), installed here by a small
          <code>Bu03Callbacks</code> hook on (re)mount — see the Custom Rendering page for more
          callback examples.
        </small>
      </.card>

      <.card title="BU04 · Declarative Usage (No JavaScript)">
        <.tip>Pass inline <code>&lt;option&gt;</code>/<code>&lt;optgroup&gt;</code> children with <code>data-icon</code> · <code>data-subtitle</code> · <code>selected</code></.tip>
        <p>
          Use standard HTML <code>&lt;option&gt;</code>
          elements - no JavaScript needed for simple cases! The component reads <code>value</code>, <code>selected</code>, and <code>data-*</code> attributes from each option.
        </p>

        <.grid>
          <.form_group>
            <label>Simple Choice</label>
            <.web_multiselect
              id="declarative-single"
              multiple={false}
              search_placeholder="Select your answer..."
            >
              <option value="yes">Yes</option>
              <option value="no">No</option>
              <option value="maybe" selected>Maybe / I don't know</option>
            </.web_multiselect>
            <small class="form-text">No JavaScript required - pure HTML!</small>
          </.form_group>

          <.form_group>
            <label>Multiple Fruits</label>
            <.web_multiselect id="declarative-fruits" search_placeholder="Select fruits...">
              <option value="apple" data-icon="🍎">Apple</option>
              <option value="banana" data-icon="🍌" selected>Banana</option>
              <option value="orange" data-icon="🍊">Orange</option>
              <option value="grape" data-icon="🍇" selected>Grape</option>
              <option value="strawberry" data-icon="🍓">Strawberry</option>
            </.web_multiselect>
            <small class="form-text">Icons via <code>data-icon</code> attribute</small>
          </.form_group>
        </.grid>

        <.grid style="margin-top: 1.5rem;">
          <.form_group>
            <label>Grouped Options</label>
            <.web_multiselect
              id="declarative-grouped"
              search_placeholder="Select programming languages..."
            >
              <optgroup label="Frontend">
                <option value="js" data-icon="🟨">JavaScript</option>
                <option value="ts" data-icon="🔷">TypeScript</option>
                <option value="html" data-icon="📄">HTML</option>
              </optgroup>
              <optgroup label="Backend">
                <option value="python" data-icon="🐍" selected>Python</option>
                <option value="java" data-icon="☕">Java</option>
                <option value="go" data-icon="🐹">Go</option>
              </optgroup>
            </.web_multiselect>
            <small class="form-text">Use <code>&lt;optgroup&gt;</code> for grouping</small>
          </.form_group>

          <.form_group>
            <label>With Subtitles</label>
            <.web_multiselect id="declarative-subtitles" search_placeholder="Select framework...">
              <option
                value="react"
                data-icon="⚛️"
                data-subtitle="A JavaScript library for building UIs"
              >
                React
              </option>
              <option
                value="vue"
                data-icon="🖖"
                data-subtitle="The Progressive JavaScript Framework"
              >
                Vue.js
              </option>
              <option
                value="svelte"
                data-icon="🔥"
                data-subtitle="Cybernetically enhanced web apps"
                selected
              >
                Svelte
              </option>
            </.web_multiselect>
            <small class="form-text">Use <code>data-subtitle</code> for descriptions</small>
          </.form_group>

          <.form_group>
            <label>Custom Group Labels</label>
            <.web_multiselect
              id="custom-groups-classic"
              options={@grouped_techs}
              allow_groups={true}
              value={~w(react nodejs)}
            />
            <small class="form-text">
              Using <code>renderGroupLabelContentCallback</code>
              to customize group headers
            </small>
          </.form_group>
        </.grid>
      </.card>

      <.card title="BU05 · Scroll-to API — scrollToGroup / scrollToValue / scrollToIndex">
        <.tip>
          JS-only element methods (no wrapper attribute): <code>el.scrollToGroup(name)</code>
          · <code>el.scrollToValue(value)</code>
          · <code>el.scrollToIndex(i)</code>
          · <code>el.clearSearch()</code> — wired in the inline <code>&lt;script&gt;</code>
        </.tip>
        <p>
          Imperative commands that bring an option or group into view. Pair with <code>open()</code>
          for an "open + jump" gesture (deep-linking to a member, revealing the active row on open).
          They work in floating, mobile fullscreen, virtual-scroll and tree modes and return
          <code>false</code>
          when the target isn't in the current filtered list. A companion <code>clearSearch()</code>
          reveals an option a search had filtered out so you can then scroll to it.
        </p>
        <.grid>
          <.form_group>
            <label>Grouped (headers)</label>
            <div style="display:flex; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
              <div style="flex:1 1 220px; min-width:220px;">
                <.web_multiselect id="scroll-grouped" options={@grouped_techs} />
              </div>
              <div style="display:flex; flex-direction:column; gap:0.5rem; flex:0 0 auto; min-width:190px;">
                <button type="button" data-scroll-grouped="group:backend">▶ group "backend"</button>
                <button type="button" data-scroll-grouped="group:database">▶ group "database"</button>
                <button type="button" data-scroll-grouped="value:redis">◎ value "redis"</button>
                <button type="button" data-scroll-grouped="index:0">⇱ index 0</button>
              </div>
            </div>
            <small class="form-text"><code>scrollToGroup</code> centers the group header.</small>
          </.form_group>

          <.form_group>
            <label>Long list + virtual scroll</label>
            <div style="display:flex; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
              <div style="flex:1 1 220px; min-width:220px;">
                <.web_multiselect
                  id="scroll-virtual"
                  enable_virtual_scroll={true}
                  options={@all_countries}
                />
              </div>
              <div style="display:flex; flex-direction:column; gap:0.5rem; flex:0 0 auto; min-width:190px;">
                <button type="button" data-scroll-virtual="value:jp">Japan</button>
                <button type="button" data-scroll-virtual="value:us">United States</button>
                <button type="button" data-scroll-virtual="value:vn">Vietnam (last)</button>
                <button type="button" data-scroll-virtual="clear">clearSearch()</button>
              </div>
            </div>
            <small class="form-text">
              Virtual mode scrolls by index math — the row need not be rendered yet.
            </small>
          </.form_group>
        </.grid>
        <div id="scroll-log" class="log-panel">
          <div class="muted">scrollTo* return values log here…</div>
        </div>

        <details class="mt-1">
          <summary>Show code</summary>
          <pre><code>{@bu06b_code}</code></pre>
        </details>
      </.card>

      <.card title="BU05b · Server-driven Scroll-to — push_command/3 (Elixir-only, no JS)">
        <.tip>
          The SAME commands as BU05, but driven from the LiveView with
          <code>Keenmate.WebMultiselect.push_command/3</code> — no inline
          <code>&lt;script&gt;</code>. The element only needs <code>hook={true}</code>.
        </.tip>
        <p>
          Every button below is a plain <code>phx-click</code>: the server receives it and
          replies with a <code>push_command</code> that opens/closes/scrolls the widget. The
          "auto-open on entry" widget uses <code>ready_event=</code> — when the picker signals
          it has finished building, the server opens it and jumps to a group, with zero user
          interaction. This is the reliable "land on the page with it already open + scrolled"
          pattern.
        </p>
        <.grid>
          <.form_group>
            <label>Grouped — commanded from the server</label>
            <div style="display:flex; gap:1rem; align-items:flex-start; flex-wrap:wrap;">
              <div style="flex:1 1 220px; min-width:220px;">
                <.web_multiselect
                  id="cmd-grouped"
                  hook="KeenWebMultiselectHook"
                  options={@grouped_techs}
                  allow_groups={true}
                />
              </div>
              <div style="display:flex; flex-direction:column; gap:0.5rem; flex:0 0 auto; min-width:210px;">
                <button type="button" phx-click="cmd" phx-value-kind="group" phx-value-arg="backend">
                  ▶ open + group "backend"
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="group" phx-value-arg="database">
                  ▶ open + group "database"
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="value" phx-value-arg="redis">
                  ◎ open + value "redis"
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="index" phx-value-arg="0">
                  ⇱ open + index 0
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="search" phx-value-arg="back">
                  🔎 search "back"
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="clear" phx-value-arg="">
                  clear_search
                </button>
                <button type="button" phx-click="cmd" phx-value-kind="close" phx-value-arg="">
                  ✕ close
                </button>
              </div>
            </div>
            <small class="form-text">
              Each click round-trips to the server, which calls <code>push_command/3</code>.
            </small>
          </.form_group>

          <.form_group>
            <label>Auto-open on entry — ready_event → push_command</label>
            <div style="flex:1 1 220px; min-width:220px;">
              <.web_multiselect
                id="cmd-onentry"
                hook="KeenWebMultiselectHook"
                options={@grouped_techs}
                allow_groups={true}
                ready_event="web_multiselect:ready"
                mobile_presentation="floating"
              />
            </div>
            <small class="form-text">
              Opened and scrolled to group "database" by the server when its
              <code>ready</code> event fired — no click. (Reset by reloading the page.)
              Pinned to <code>mobile_presentation="floating"</code> so the automatic
              open-on-entry stays a dismissible dropdown on phones instead of taking over
              the screen with the fullscreen sheet.
            </small>
          </.form_group>
        </.grid>
        <div class="log-panel">
          <div :if={@cmd_log == []} class="muted">push_command/3 calls log here…</div>
          <div :for={line <- @cmd_log}>{line}</div>
        </div>
      </.card>

      <.card title="BU06 · Search Modes: Filter vs Navigate">
        <.tip><code>search_mode="filter"</code> hides non-matches · <code>search_mode="navigate"</code> jumps to matches while keeping all rows visible</.tip>
        <p>
          Choose between <strong>filter</strong>
          mode (hide non-matches) or <strong>navigate</strong>
          mode (jump to matches while keeping all visible)
        </p>

        <.grid>
          <.form_group>
            <label>Filter Mode (Default)</label>
            <.web_multiselect
              id="filter-mode-example"
              search_mode="filter"
              value_member="id"
              display_value_member="name"
              icon_member="flag"
              search_placeholder="Type to filter countries..."
              options={@countries_with_flags}
            />
            <small class="form-text">Hides non-matching options (standard behavior)</small>
          </.form_group>

          <.form_group>
            <label>Navigate Mode</label>
            <.web_multiselect
              id="navigate-mode-example"
              search_mode="navigate"
              value_member="id"
              display_value_member="name"
              icon_member="flag"
              search_hint="Ctrl/Cmd + ↓ / ↑ to jump between matches · Enter to select · Esc to clear"
              search_placeholder="Type to jump to country..."
              options={@countries_with_flags}
            />
            <small class="form-text">
              Keeps all options visible, jumps to matches (highlighted with left border)
            </small>
          </.form_group>
        </.grid>

        <.note>
          <p><strong>When to use each mode:</strong></p>
          <ul>
            <li>
              <strong>Filter Mode</strong>: Large lists where you want to narrow down options (e.g., product catalogs, user lists)
            </li>
            <li>
              <strong>Navigate Mode</strong>: Quick selection from known lists (e.g., country/state selectors)
            </li>
          </ul>
          <p><strong>Navigate-mode keyboard shortcuts:</strong></p>
          <ul>
            <li>
              <kbd>type</kbd> — first match becomes focused; all matches keep a left-border highlight
            </li>
            <li><kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>↓</kbd> — jump to next match</li>
            <li><kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>↑</kbd> — jump to previous match</li>
            <li><kbd>↑</kbd> / <kbd>↓</kbd> — move focus one option at a time</li>
            <li><kbd>Home</kbd> / <kbd>End</kbd> — jump to first / last option</li>
            <li><kbd>PageUp</kbd> / <kbd>PageDown</kbd> — move 10 options at a time</li>
            <li><kbd>Enter</kbd> — toggle selection of the focused option</li>
            <li><kbd>Esc</kbd> — clear the search (or close the dropdown if search is empty)</li>
          </ul>
        </.note>
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

      // Custom group label rendering (renderGroupLabelContentCallback).
      wait('custom-groups-classic').then((el) => {
        el.renderGroupLabelContentCallback = (groupName) => {
          const emojis = {
            'frontend': '🎨',
            'backend': '🔧',
            'database': '🗄️'
          };
          const emoji = emojis[groupName] || '📦';
          return `<strong>${emoji} ${groupName.toUpperCase()}</strong>`;
        };
      });

      // Scroll-to API (BU06b) — scrollToGroup / scrollToValue / scrollToIndex / clearSearch.
      // These are JS-only element methods with no wrapper attribute; reproduced verbatim
      // (adapted to the wrapper's element ids) from upstream examples-basic.
      Promise.all([wait('scroll-grouped'), wait('scroll-virtual')]).then(([scrollGrouped, scrollVirtual]) => {
        const scrollLogEl = document.getElementById('scroll-log');
        const scrollLog = (msg) => {
          if (!scrollLogEl) return;
          if (scrollLogEl.querySelector('.muted')) scrollLogEl.innerHTML = '';
          const row = document.createElement('div');
          row.style.marginBottom = '0.4rem';
          row.textContent = msg;
          scrollLogEl.appendChild(row);
          scrollLogEl.scrollTop = scrollLogEl.scrollHeight;
        };

        // Inspect the (open) shadow DOM and report which option rows are actually in view —
        // so we can SEE where a scrollTo* call landed. Runs after a tick so the scroll settles.
        const describeViewport = (el, targetValue) => {
          const container = el.shadowRoot && el.shadowRoot.querySelector('.ms__options');
          if (!container) { scrollLog('   ↳ (dropdown not open / no list)'); return; }
          const crect = container.getBoundingClientRect();
          const rows = [...container.querySelectorAll('.ms__option')];
          const visible = rows.filter((o) => {
            const r = o.getBoundingClientRect();
            return r.bottom > crect.top + 1 && r.top < crect.bottom - 1;
          });
          const label = (o) => (o.querySelector('.ms__option-title') || o).textContent.trim();
          const first = visible[0] ? label(visible[0]) : '—';
          const last = visible.length ? label(visible[visible.length - 1]) : '—';
          let targetNote = '';
          if (targetValue != null) {
            const hit = visible.find((o) => o.dataset.value === String(targetValue));
            targetNote = hit
              ? ` · target "${label(hit)}" VISIBLE`
              : ` · target "${targetValue}" NOT in view`;
          }
          scrollLog(`   ↳ scrollTop=${Math.round(container.scrollTop)} · shows "${first}" … "${last}" (${visible.length} rows)${targetNote}`);
        };

        const runScroll = (el, spec) => {
          el.open(); // scrollTo* defers internally, so open()+scroll in one gesture works
          if (spec === 'clear') { el.clearSearch(); scrollLog('clearSearch() — search reset, full list restored'); return; }
          const [kind, arg] = spec.split(':');
          let ok, target = null;
          if (kind === 'group')      { ok = el.scrollToGroup(arg); }
          else if (kind === 'value') { ok = el.scrollToValue(arg); target = arg; }
          else if (kind === 'index') { ok = el.scrollToIndex(Number(arg)); }
          const call = kind === 'index' ? `scrollToIndex(${arg})`
            : kind === 'group' ? `scrollToGroup('${arg}')`
            : `scrollToValue('${arg}')`;
          scrollLog(`▶ ${call} → ${ok}`);
          // Give the (possibly deferred) scroll a moment, then report where we landed.
          setTimeout(() => describeViewport(el, target), 90);
        };

        // Delegate on document so the listeners survive LiveView's DOM patch on connect
        // (plain <button>s bound directly lose their listeners; the <web-multiselect> is
        // protected by phx-update="ignore"). As of @keenmate/web-multiselect 2.1.0 no
        // stopPropagation()/capture-phase workaround is needed: open() and every scrollTo*
        // arm a one-tick outside-click guard, so re-driving an already-open dropdown from an
        // external button no longer closes it (the old "0 rows / 11 rows" alternation).
        document.addEventListener('click', (e) => {
          const gBtn = e.target.closest('[data-scroll-grouped]');
          if (gBtn) { runScroll(scrollGrouped, gBtn.dataset.scrollGrouped); return; }
          const vBtn = e.target.closest('[data-scroll-virtual]');
          if (vBtn) { runScroll(scrollVirtual, vBtn.dataset.scrollVirtual); }
        });
      });
    </script>
    """
  end
end
