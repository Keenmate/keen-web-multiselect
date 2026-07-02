defmodule Mix.Tasks.KeenWebMultiselect.Install do
  @shortdoc "Wires the bundled JS/CSS and the LiveView hook into an esbuild Phoenix app"

  @moduledoc """
  Wires `keen_web_multiselect` into a standard esbuild-based Phoenix app.

      mix keen_web_multiselect.install

  It edits three things, idempotently (re-running is safe):

    * `assets/js/app.js` — imports the bundled `multiselect.js` and the
      `KeenWebMultiselectHook`, and registers the hook on your `LiveSocket`.
    * `assets/css/app.css` — imports the bundled `multiselect.css`.

  Anything it can't confidently patch (an unusual `LiveSocket` setup, an importmap
  app with no `assets/js/app.js`, etc.) is left untouched and printed as a manual
  step instead — the task never rewrites code it doesn't understand.

  ## Options

    * `--dry-run` — print what would change without writing any files.
  """

  use Mix.Task

  @hook_import ~s(import KeenWebMultiselectHook from "../../deps/keen_web_multiselect/priv/static/keen_web_multiselect_hook.js")
  @js_import ~s(import "../../deps/keen_web_multiselect/priv/static/multiselect.js")
  @css_import ~s(@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";)

  @impl Mix.Task
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, switches: [dry_run: :boolean])
    dry_run? = Keyword.get(opts, :dry_run, false)

    Mix.shell().info("keen_web_multiselect installer\n")

    manual =
      []
      |> handle_file("assets/js/app.js", &patch_app_js/1, dry_run?)
      |> handle_file("assets/css/app.css", &patch_app_css/1, dry_run?)

    print_manual(manual)
    :ok
  end

  # -- file orchestration ----------------------------------------------------

  defp handle_file(manual, path, patch_fun, dry_run?) do
    case File.read(path) do
      {:ok, content} ->
        apply_patch(manual, path, content, patch_fun.(content), dry_run?)

      {:error, :enoent} ->
        Mix.shell().info([:yellow, "  skip  ", :reset, path, " not found"])
        [{path, :missing} | manual]
    end
  end

  defp apply_patch(manual, path, _content, {:present, _new}, _dry_run?) do
    Mix.shell().info([:cyan, "  ok    ", :reset, path, " already wired"])
    manual
  end

  defp apply_patch(manual, path, _content, {status, new}, dry_run?)
       when status in [:patched, :partial] do
    unless dry_run?, do: File.write!(path, new)
    tag = if dry_run?, do: "would patch", else: "patched"
    Mix.shell().info([:green, "  #{tag}  ", :reset, path])

    case status do
      :partial -> [{path, :partial} | manual]
      :patched -> manual
    end
  end

  defp print_manual([]) do
    Mix.shell().info([:green, "\nDone — everything wired automatically."])
  end

  defp print_manual(manual) do
    Mix.shell().info([:yellow, "\nFinish these steps manually:\n"])

    Enum.each(Enum.reverse(manual), fn
      {"assets/js/app.js", :partial} ->
        Mix.shell().info("""
          • Register the hook on your LiveSocket (couldn't find a hooks object to merge into):

              let liveSocket = new LiveSocket("/live", Socket, {
                hooks: { KeenWebMultiselectHook },
                params: { _csrf_token: csrfToken }
              })
        """)

      {"assets/js/app.js", :missing} ->
        Mix.shell().info("""
          • No assets/js/app.js — if you use an importmap or serve assets directly, wire
            multiselect.js / multiselect.css / keen_web_multiselect_hook.js per the README
            "serve directly from the dep's priv/static" path.
        """)

      {"assets/css/app.css", :missing} ->
        Mix.shell().info("""
          • No assets/css/app.css — add the stylesheet import wherever your CSS entrypoint lives:

              #{@css_import}
        """)

      {_path, _} ->
        :ok
    end)
  end

  # -- pure transforms (unit-tested) -----------------------------------------

  @doc false
  # Returns {:present | :patched | :partial, content}.
  def patch_app_js(content) do
    {import_status, content} = ensure_js_imports(content)
    {hook_status, content} = ensure_hook_registered(content)

    status =
      cond do
        hook_status == :manual -> :partial
        import_status == :present and hook_status == :present -> :present
        true -> :patched
      end

    {status, content}
  end

  @doc false
  def patch_app_css(content) do
    if String.contains?(content, "multiselect.css") do
      {:present, content}
    else
      {:patched, insert_after_last(content, ~r/^\s*@import\b/m, @css_import)}
    end
  end

  defp ensure_js_imports(content) do
    if String.contains?(content, "keen_web_multiselect_hook.js") do
      {:present, content}
    else
      block = @hook_import <> "\n" <> @js_import
      {:added, insert_after_last(content, ~r/^\s*import\b/m, block)}
    end
  end

  # Registers KeenWebMultiselectHook on the LiveSocket. Handles the two common
  # shapes; anything else is reported as :manual rather than risk a bad edit.
  defp ensure_hook_registered(content) do
    cond do
      Regex.match?(~r/hooks:\s*\{[^}]*KeenWebMultiselectHook/s, content) ->
        {:present, content}

      # Existing object-literal hooks — merge ours in.
      Regex.match?(~r/hooks:\s*\{/, content) ->
        {:patched,
         String.replace(content, ~r/hooks:\s*\{/, "hooks: {KeenWebMultiselectHook, ", global: false)}

      # A hooks key exists but isn't an object literal (e.g. `hooks: Hooks`) —
      # merging is unsafe, so leave it for the user.
      Regex.match?(~r/hooks:/, content) ->
        {:manual, content}

      # Default Phoenix LiveSocket with no hooks key — add one.
      Regex.match?(~r/new LiveSocket\([^,]+,\s*[A-Za-z_$][\w$]*,\s*\{/, content) ->
        {:patched,
         String.replace(
           content,
           ~r/(new LiveSocket\([^,]+,\s*[A-Za-z_$][\w$]*,\s*\{)/,
           "\\1\n  hooks: {KeenWebMultiselectHook},",
           global: false
         )}

      true ->
        {:manual, content}
    end
  end

  # Inserts `insertion` on its own line after the last line matching `anchor`.
  # Falls back to prepending when the anchor is absent.
  defp insert_after_last(content, anchor, insertion) do
    lines = String.split(content, "\n")

    last =
      lines
      |> Enum.with_index()
      |> Enum.filter(fn {line, _i} -> Regex.match?(anchor, line) end)
      |> List.last()

    case last do
      {_line, idx} ->
        {before, rest} = Enum.split(lines, idx + 1)
        Enum.join(before ++ [insertion] ++ rest, "\n")

      nil ->
        insertion <> "\n" <> content
    end
  end
end
