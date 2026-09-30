defmodule Keenmate.WebMultiselect do
  @moduledoc """
  Phoenix wrapper for the [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect)
  custom element.

  See `Keenmate.WebMultiselect.Components.web_multiselect/1` for the component, and the README
  for how to wire up the bundled JS, CSS, and the optional LiveView hook.
  """

  @upstream_version "2.2.0"

  @doc """
  The version of `@keenmate/web-multiselect` bundled with this release.

  ## Example

      iex> Keenmate.WebMultiselect.upstream_version()
      "2.2.0"

  """
  @spec upstream_version() :: String.t()
  def upstream_version, do: @upstream_version

  @doc """
  Absolute on-disk path to a file shipped in `priv/static/`.

  Useful for setup tasks that copy assets into a host application's `assets/` folder.

      Keenmate.WebMultiselect.asset_path("multiselect.js")
      #=> "/.../keen_web_multiselect/priv/static/multiselect.js"
  """
  @spec asset_path(String.t()) :: String.t()
  def asset_path(filename) when is_binary(filename) do
    :keen_web_multiselect
    |> :code.priv_dir()
    |> to_string()
    |> Path.join(["static/", filename])
  end

  # The client-side defaults registry, compile-embedded so `shadow_styles_js/0` can
  # inline it into the page without runtime IO. `@external_resource` recompiles this
  # module when the shipped file changes.
  @defaults_js_path Path.join(__DIR__, "../../priv/static/keen_web_multiselect_defaults.js")
  @external_resource @defaults_js_path
  @defaults_js File.read!(@defaults_js_path)

  @doc """
  Resolves the project-wide shadow-DOM CSS from application config, or `nil` when
  none is configured.

  Configure it once — the `Keenmate.WebMultiselect.Components.shadow_styles/1` component
  compiles it into one stylesheet and adopts it into every `<web-multiselect>` shadow root
  on the page. Accepted shapes:

    * a binary — treated as inline CSS
    * `{:inline, css}` — inline CSS (explicit)
    * `{:file, path}` — read the CSS from a file at **runtime, on every render**, with
      `path` used as given (relative to the current working directory unless absolute)
    * a 0-arity function or `{module, function, args}` — called to produce the CSS
      string (computed on the server, e.g. from theme config)

  > #### `{:file, path}` breaks in a release {: .warning}
  >
  > `{:file, path}` runs `File.read!(path)` at runtime. A **relative** path resolves
  > against the OS process's current working directory — your project root under
  > `mix phx.server`, but the *release root* in a deployed release, where `priv` lives
  > under `Application.app_dir/2` (e.g. `/app/lib/my_app-x.y.z/priv/…`), not `./priv`.
  > So `{:file, "priv/static/…"}` works in dev and then crashes the release with
  > `** (File.Error) could not read file …`. Use one of the release-safe patterns below.

  ## Examples

      # Release-safe: read + inline the CSS at COMPILE time (no runtime file IO). `__DIR__`
      # makes the path independent of the working directory the build runs from.
      config :keen_web_multiselect,
        shadow_styles: File.read!(Path.join(__DIR__, "../priv/static/assets/ms-shadow.css"))

      # Release-safe: an ABSOLUTE path resolved at runtime from the app's priv dir. Put this
      # in runtime.exs so Application.app_dir/2 resolves against the real release layout.
      config :keen_web_multiselect,
        shadow_styles: {:file, Application.app_dir(:my_app, "priv/static/assets/ms-shadow.css")}

      # Computed on the server (e.g. from theme config).
      config :keen_web_multiselect, shadow_styles: {MyApp.Theme, :multiselect_css, []}

      # ⚠️ Dev-only: a relative {:file, …} crashes in a release — see the warning above.
      config :keen_web_multiselect, shadow_styles: {:file, "assets/ms-shadow.css"}
  """
  @spec shadow_styles_css() :: String.t() | nil
  def shadow_styles_css do
    case Application.get_env(:keen_web_multiselect, :shadow_styles) do
      nil -> nil
      css when is_binary(css) -> css
      {:inline, css} when is_binary(css) -> css
      {:file, path} when is_binary(path) -> File.read!(path)
      fun when is_function(fun, 0) -> fun.()
      {mod, fun, args} when is_atom(mod) and is_atom(fun) and is_list(args) -> apply(mod, fun, args)
    end
  end

  @doc """
  Whether project-wide shared shadow styles are configured (`:shadow_styles` is set).

  A cheap presence check that — unlike `shadow_styles_css/0` — never resolves the value
  (no `File.read!`, no function call). The component uses it to decide whether to emit the
  `defer` attribute automatically: when a shared sheet is in play, deferring the first render
  until the sheet is adopted closes the upgrade-then-restyle flash (the client registry from
  `shadow_styles/1` releases the gate after adopting). No shared styles → no `defer`, so
  behaviour is unchanged for consumers that don't use the feature.
  """
  @spec shadow_styles_configured?() :: boolean()
  def shadow_styles_configured? do
    Application.get_env(:keen_web_multiselect, :shadow_styles) != nil
  end

  @doc """
  The client-side defaults-registry JavaScript (contents of the shipped
  `keen_web_multiselect_defaults.js`). Inlined by `shadow_styles/1`; also useful if
  you serve it yourself.
  """
  @spec defaults_js() :: String.t()
  def defaults_js, do: @defaults_js

  @doc """
  Pushes an update to a mounted `<web-multiselect>` from the server.

  This is the sanctioned way to change a multiselect's option list or selection
  from the LiveView process. The component renders `phx-update="ignore"`, so LV's
  DOM patcher won't propagate attribute changes to it — this helper sends the
  `"web_multiselect:update"` event that `KeenWebMultiselectHook` listens for and
  applies via `el.options = ...` / `el.setSelected(...)`.

  Requires the target element to have `hook={true}` (or `hook="KeenWebMultiselectHook"`)
  and a matching `id`.

  ## Options

    * `:options` — replace the option list (any shape the component accepts).
    * `:value` — replace the selection. A list sets multiple; a scalar wraps to a
      single selection; `nil` or `[]` clears it.

  Only the keys you pass are sent, so `push_update(socket, "id", value: [])` clears
  the selection without touching the options, and `push_update(socket, "id", options: opts)`
  swaps options while leaving the selection to the component.

  ## Examples

      # Cascade: parent changed, load and push the child's options, reset selection
      def handle_event("web_multiselect:change", %{"id" => "country", "values" => [c]}, socket) do
        {:noreply, Keenmate.WebMultiselect.push_update(socket, "region", options: regions(c), value: [])}
      end

      # Server-authoritative correction
      Keenmate.WebMultiselect.push_update(socket, "tags", value: Enum.take(values, 3))
  """
  @spec push_update(Phoenix.LiveView.Socket.t(), String.t(), keyword()) ::
          Phoenix.LiveView.Socket.t()
  def push_update(socket, id, opts \\ []) when is_binary(id) and is_list(opts) do
    payload =
      %{id: id}
      |> maybe_put(opts, :options)
      |> maybe_put(opts, :value)

    Phoenix.LiveView.push_event(socket, "web_multiselect:update", payload)
  end

  defp maybe_put(payload, opts, key) do
    case Keyword.fetch(opts, key) do
      {:ok, value} -> Map.put(payload, key, value)
      :error -> payload
    end
  end

  # Keys accepted by push_command/3, each mapping to an element method the hook calls.
  @command_keys ~w(open close toggle search clear_search scroll_to_value scroll_to_group scroll_to_index)a

  @doc """
  Drives a mounted `<web-multiselect>` imperatively from the server — open/close the
  dropdown, scroll to an option or group, or set the search text — without changing its
  options or selection (use `push_update/3` for those).

  Sends the `"web_multiselect:command"` event that `KeenWebMultiselectHook` listens for and
  dispatches to the matching element method. Requires the target element to have `hook={true}`
  (or `hook="KeenWebMultiselectHook"`) and a matching `id`.

  ## Options

    * `:open` — open the dropdown (truthy).
    * `:close` — close the dropdown (truthy).
    * `:toggle` — toggle open/closed (truthy).
    * `:search` — set the search box text and filter as if typed (`""` clears it).
    * `:clear_search` — clear the search box and restore the full list (truthy).
    * `:scroll_to_value` — scroll the open dropdown to the option with this value.
    * `:scroll_to_group` — scroll to this group's header (first option in virtual mode).
    * `:scroll_to_index` — scroll to the option at this index in the filtered list.

  Only the keys you pass are sent. Scroll/`search` act on the currently open, filtered list;
  pair them with `:open` (or `:clear_search`) in a prior/same call as needed — the element
  defers `scroll_to_*` one frame so `open: true` in the same payload works.

  ## Examples

      # Open and jump to a group
      Keenmate.WebMultiselect.push_command(socket, "skills", open: true, scroll_to_group: "backend")

      # Reveal a filtered-out option, then scroll to it
      socket
      |> Keenmate.WebMultiselect.push_command("skills", clear_search: true)
      |> Keenmate.WebMultiselect.push_command("skills", scroll_to_value: "py")

      # Preset the search box from the server
      Keenmate.WebMultiselect.push_command(socket, "skills", search: "back")
  """
  @spec push_command(Phoenix.LiveView.Socket.t(), String.t(), keyword()) ::
          Phoenix.LiveView.Socket.t()
  def push_command(socket, id, opts \\ []) when is_binary(id) and is_list(opts) do
    payload = Enum.reduce(@command_keys, %{id: id}, &maybe_put(&2, opts, &1))
    Phoenix.LiveView.push_event(socket, "web_multiselect:command", payload)
  end
end
