defmodule Keenmate.WebMultiselect do
  @moduledoc """
  Phoenix wrapper for the [`@keenmate/web-multiselect`](https://github.com/keenmate/web-multiselect)
  custom element.

  See `Keenmate.WebMultiselect.Components.web_multiselect/1` for the component, and the README
  for how to wire up the bundled JS, CSS, and the optional LiveView hook.
  """

  @upstream_version "1.12.0-rc08"

  @doc """
  The version of `@keenmate/web-multiselect` bundled with this release.
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
end
