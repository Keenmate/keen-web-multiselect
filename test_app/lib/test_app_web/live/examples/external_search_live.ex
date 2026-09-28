defmodule TestAppWeb.Examples.ExternalSearchLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components
  import TestAppWeb.Examples.SharedComponents

  # Accented city names — to show FlexSearch's accent folding vs the built-in
  # substring search.
  @cities [
            "Zürich",
            "São Paulo",
            "Kraków",
            "München",
            "Málaga",
            "Düsseldorf",
            "Reykjavík",
            "Bogotá",
            "Medellín",
            "Łódź",
            "Gdańsk",
            "Tromsø",
            "Chișinău",
            "Timișoara",
            "Košice",
            "Plzeň",
            "Brno",
            "Genève",
            "Montréal",
            "Québec",
            "Đà Nẵng",
            "Nürnberg",
            "Örebro",
            "Bratislava",
            "Ljubljana",
            "Zagreb",
            "Poznań"
          ]
          |> Enum.with_index()
          |> Enum.map(fn {name, i} -> %{value: to_string(i), label: name} end)

  @wire_code ~S"""
  // FlexSearch lives entirely in your app — never in the multiselect bundle.
  import FlexSearch from "https://esm.sh/flexsearch@0.8.212";

  // Fold diacritics so accented labels match plain ASCII (ü→u, é→e), applied to
  // both the indexed text and the query so they meet on the same normalized form.
  const fold = (s) => String(s || "").normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();

  // The wrapper feeds options via the `data-options` attribute, which upstream parses
  // into `optionsSource` — read that when the JS `options` property is empty.
  const opts = (Array.isArray(el.options) && el.options.length)
    ? el.options
    : JSON.parse(el.optionsSource || "[]");

  const index = new FlexSearch.Index({ tokenize: "full" }); // "full" = substring matching
  opts.forEach((o, i) => index.add(i, fold(`${o.label} ${o.value} ${o.full_title}`)));

  el.searchCallback = (term) =>
    (index.search(fold(term), { limit: 80 }) || []).map((i) => opts[i]);
  """

  # Server-side catalog for ES03. The whole point of the server route is that this
  # list lives on the server and is NEVER shipped to the browser — only the matches
  # for each query cross the wire. In a real app this would be a DB / API / search
  # index; here it's an in-memory list so the demo is self-contained.
  @catalog [
             {"elixir", "Elixir", "functional · BEAM"},
             {"erlang", "Erlang", "functional · BEAM"},
             {"gleam", "Gleam", "functional · BEAM"},
             {"rust", "Rust", "systems · ownership"},
             {"go", "Go", "systems · goroutines"},
             {"zig", "Zig", "systems · comptime"},
             {"c", "C", "systems · procedural"},
             {"cpp", "C++", "systems · multi-paradigm"},
             {"csharp", "C#", "OOP · .NET"},
             {"fsharp", "F#", "functional · .NET"},
             {"java", "Java", "OOP · JVM"},
             {"kotlin", "Kotlin", "OOP · JVM"},
             {"scala", "Scala", "functional · JVM"},
             {"clojure", "Clojure", "functional · JVM"},
             {"groovy", "Groovy", "scripting · JVM"},
             {"python", "Python", "scripting · dynamic"},
             {"ruby", "Ruby", "scripting · dynamic"},
             {"perl", "Perl", "scripting · dynamic"},
             {"php", "PHP", "scripting · web"},
             {"javascript", "JavaScript", "scripting · web"},
             {"typescript", "TypeScript", "typed · web"},
             {"dart", "Dart", "typed · Flutter"},
             {"swift", "Swift", "typed · Apple"},
             {"objectivec", "Objective-C", "OOP · Apple"},
             {"haskell", "Haskell", "functional · lazy"},
             {"ocaml", "OCaml", "functional · ML"},
             {"reason", "ReasonML", "functional · ML"},
             {"elm", "Elm", "functional · web"},
             {"purescript", "PureScript", "functional · web"},
             {"lisp", "Common Lisp", "functional · macros"},
             {"scheme", "Scheme", "functional · minimal"},
             {"racket", "Racket", "functional · Lisp"},
             {"julia", "Julia", "numeric · JIT"},
             {"r", "R", "statistics · vectors"},
             {"matlab", "MATLAB", "numeric · matrices"},
             {"fortran", "Fortran", "numeric · legacy"},
             {"cobol", "COBOL", "business · legacy"},
             {"nim", "Nim", "systems · Python-ish"},
             {"crystal", "Crystal", "systems · Ruby-ish"},
             {"lua", "Lua", "scripting · embeddable"}
           ]
           |> Enum.map(fn {value, label, subtitle} ->
             %{value: value, label: label, subtitle: subtitle}
           end)

  @server_code ~S"""
  # 1. Opt in — the hook installs a searchCallback that tunnels each query to the server.
  <.web_multiselect
    id="server-langs"
    hook={true}
    search_event="lang_search"
    search_debounce={200}
    min_search_length={1}
  />

  # 2. Handle the query — you MUST reply with %{results: [...]} (not {:noreply, ...}).
  def handle_event("lang_search", %{"id" => "server-langs", "query" => q}, socket) do
    results = MyApp.Catalog.search(q)   # your DB / API / index — stays on the server
    {:reply, %{results: results}, socket}
  end
  """

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "External Search (FlexSearch) — keen_web_multiselect")
     |> assign(:cities, @cities)
     |> assign(:isco, TestApp.Isco08.all())
     |> assign(:isco_count, TestApp.Isco08.count())
     |> assign(:catalog_count, length(@catalog))
     |> assign(:wire_code, @wire_code)
     |> assign(:server_code, @server_code)
     |> assign(:last_query, nil)
     |> assign(:query_count, 0)}
  end

  def render(assigns) do
    ~H"""
    <.example_page
      icon="🔎"
      title="External Search (FlexSearch)"
      subtitle="Externalize the whole search with a searchCallback — the library stays lean"
    >
      <.card title="ES01 · Fuzzy & Accent-Insensitive (flat list)">
        <.tip>Set <code>el.searchCallback</code> (JS) to delegate the entire search to your own engine — here, a FlexSearch index.</.tip>
        <p>
          The built-in search is a lean case-insensitive <strong>substring</strong> match. When you need
          <strong>fuzzy / partial / accent-insensitive / ranked</strong> matching, don't bloat the component —
          externalize the whole search via <code>searchCallback</code> and back it with your own index. Here that's
          <a href="https://github.com/nextapps-de/flexsearch" target="_blank">FlexSearch</a> (the same indexer
          <code>@keenmate/web-treeview</code> uses), loaded client-side. It is <strong>never part of the
          <code>keen_web_multiselect</code> bundle</strong>. From LiveView you can also handle search server-side
          via the hook's <code>search</code> event — this page shows the client-side route.
        </p>
        <.code_block>{@wire_code}</.code_block>
        <p>
          The demo below is a flat list of cities with accented names. FlexSearch <code>Charset.Normalize</code> folds
          accents; <code>tokenize: "full"</code> matches partial tokens. Try <code>zurich</code> → <em>Zürich</em>,
          <code>sao</code> → <em>São Paulo</em>, <code>krak</code> → <em>Kraków</em>, <code>munch</code> →
          <em>München</em>. The built-in substring search would miss all of these.
        </p>
        <.web_multiselect
          id="flex-cities"
          placeholder="Search accent-free…"
          options={@cities}
        />
      </.card>

      <.card title={"ES02 · External Search on a Tree (full ISCO-08, #{@isco_count} groups)"}>
        <.tip>External search now composes with tree mode — matches keep their ancestors, and the index covers title + code + breadcrumb.</.tip>
        <p>
          The whole ISCO-08 occupation tree, searched through FlexSearch. The component rebuilds the hierarchy from
          the returned matches, keeping each match's <strong>ancestors</strong> so indentation stays coherent. The
          index covers each occupation's title, <strong>ISCO code, and full breadcrumb</strong> — search
          <code>2211 non</code>, <code>welder</code>, or <code>health</code>. Only unit groups (leaves) are selectable.
        </p>
        <.web_multiselect
          id="flex-isco"
          placeholder="Search by title, code, or breadcrumb…"
          options={@isco}
          path_member="path"
          is_selectable_member="selectable"
          enable_virtual_scroll={true}
          option_height={32}
          style="--ms-option-padding: 0.3rem 0.85rem; --ms-option-title-white-space: nowrap; --ms-option-title-overflow: hidden; --ms-option-title-text-overflow: ellipsis;"
        />
        <small class="form-text">
          Source: <em>International Standard Classification of Occupations, ISCO-08</em>
          (© International Labour Organization) — demo data.
        </small>
      </.card>

      <.keen_card
        id="es03-server-side-search"
        title="ES03 · Server-Side Search (LiveView, zero JS)"
      >
        <.tip>
          Set <code>search_event="…"</code> (with <code>hook={true}</code>) and the wrapper installs the
          <code>searchCallback</code> for you — each query is tunneled to <code>handle_event/3</code>. No JavaScript.
        </.tip>
        <p>
          The two demos above search <strong>in the browser</strong> (you set <code>el.searchCallback</code> in JS).
          This one searches <strong>on the server</strong>: every keystroke is debounced, pushed to this LiveView,
          matched against a catalog the browser <strong>never receives</strong>, and the dropdown is filled from your
          <code>{"{:reply, %{results: [...]}, socket}"}</code>. It's the same request/reply the hook uses for async
          search — one attribute, one handler. Stale queries auto-drop via the upstream <code>AbortSignal</code>
          contract, so a slow reply never overwrites fresher results.
        </p>
        <p>
          The catalog is programming languages, matched on name <em>and</em> paradigm. Try <code>beam</code> →
          Elixir/Erlang/Gleam, <code>jvm</code> → Kotlin/Scala/Clojure, <code>functional</code>,
          <code>systems</code>, or just <code>rust</code>.
        </p>
        <.code_block lang="elixir">{@server_code}</.code_block>
        <.web_multiselect
          id="server-langs"
          hook={true}
          search_event="lang_search"
          search_debounce={200}
          min_search_length={1}
          multiple={true}
          placeholder="Search languages on the server…"
          search_placeholder="Try beam, jvm, functional, rust…"
        />
        <small class="form-text">
          Server saw: <code>{inspect(@last_query)}</code> · <strong>{@query_count}</strong>
          {if @query_count == 1, do: "query", else: "queries"} handled. The full
          <strong>{@catalog_count}</strong>-item catalog stays on the server — only matches cross the wire.
        </small>
      </.keen_card>
    </.example_page>

    <script type="module">
      import FlexSearch from "https://esm.sh/flexsearch@0.8.212";

      // Fold diacritics to plain ASCII (ü→u, é→e, ł→l…) deterministically, rather
      // than relying on a FlexSearch encoder preset — this is what makes "zur" find
      // "Zürich" and "sao" find "São Paulo". Applied to BOTH the indexed text and the
      // query so they meet on the same normalized form.
      const fold = (s) =>
        String(s || "").normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();

      // Resolve the option list. The wrapper feeds options via the `data-options`
      // attribute, which upstream 2.0.0 parses into `optionsSource` — NOT the JS
      // `options` property (that only reflects a direct `el.options = …` assignment).
      // So read `el.options` when it's populated, otherwise parse `optionsSource`.
      const optionsOf = (el) => {
        if (Array.isArray(el.options) && el.options.length) return el.options;
        try { return JSON.parse(el.optionsSource || "[]"); } catch { return []; }
      };

      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect' && optionsOf(el).length) resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // Route an element's search through FlexSearch (fuzzy text) + an optional
      // plain-JS exact/prefix matcher for codes (ranked first — FlexSearch ranks
      // numeric codes poorly). `text(o)` is indexed; `code(o)` (optional) is matched exactly.
      const wireFlexSearch = (el, { text, code }, limit) => {
        const opts = optionsOf(el);
        const index = new FlexSearch.Index({ tokenize: "full" }); // "full" = substring matching
        const codes = code ? opts.map((o) => fold(code(o))) : null;
        opts.forEach((o, i) => index.add(i, fold(text(o))));
        el.searchCallback = (term) => {
          const t = fold(term).trim();
          if (!t) return opts;
          const seen = new Set(), out = [];
          const push = (i) => { if (!seen.has(i)) { seen.add(i); out.push(opts[i]); } };
          // Purely-numeric query = code lookup → exact/prefix only (no digit-substring
          // text noise, which in tree mode would drag in every stray match's ancestors).
          if (codes && /^\d+$/.test(t)) {
            codes.forEach((c, i) => { if (c === t) push(i); });
            codes.forEach((c, i) => { if (c !== t && c.startsWith(t)) push(i); });
            return out.slice(0, limit);
          }
          if (codes) {
            codes.forEach((c, i) => { if (c === t) push(i); });                    // exact code first
            codes.forEach((c, i) => { if (c !== t && c.startsWith(t)) push(i); }); // then prefix
          }
          (index.search(t, { limit }) || []).forEach(push);                        // then fuzzy text
          return out.slice(0, limit);
        };
      };

      wait('flex-cities').then((el) => wireFlexSearch(el, { text: (o) => o.label }, 20));
      wait('flex-isco').then((el) => wireFlexSearch(el, { text: (o) => `${o.label} ${o.value} ${o.full_title}`, code: (o) => o.value }, 80));
    </script>
    """
  end

  # ES03 · Server-side search. The hook (hook={true} + search_event="lang_search")
  # installs a searchCallback that pushes each query here and awaits the reply. We
  # MUST answer with {:reply, %{results: [...]}, socket} — {:noreply, ...} would leave
  # the in-flight search promise hanging. Match case-insensitively on label + subtitle
  # so "beam" finds the BEAM languages and "web" finds the web ones.
  def handle_event("lang_search", %{"id" => "server-langs", "query" => query}, socket) do
    q = query |> String.trim() |> String.downcase()

    results =
      if q == "" do
        []
      else
        Enum.filter(@catalog, fn %{label: label, subtitle: subtitle} ->
          String.contains?(String.downcase(label), q) or
            String.contains?(String.downcase(subtitle), q)
        end)
      end

    # Tunnel this round-trip into the floating "Server round-trip" panel. Search
    # isn't a select/deselect/change DOM event, so the ServerMonitor JS hook can't
    # see it — push it in via send_update/3, same as EO04's GitHub search.
    send_update(TestAppWeb.Examples.ServerEventsPanel,
      id: "server-events-panel",
      monitor_event: %{kind: "search", id: "server-langs", shown: "#{query} → #{length(results)} hit(s)"}
    )

    {:reply, %{results: results},
     socket
     |> assign(:last_query, query)
     |> update(:query_count, &(&1 + 1))}
  end

  # The bundled hook forwards select/deselect/change/add unconditionally once mounted.
  # This page doesn't act on them server-side, but a LiveView that omits a matching
  # clause crashes on the first selection — so absorb them here.
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}
end
