defmodule Mix.Tasks.KeenWebMultiselect.InstallTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.KeenWebMultiselect.Install

  describe "patch_app_js/1 — imports" do
    test "adds both imports after the existing import block" do
      src = """
      import "phoenix_html"
      import {Socket} from "phoenix"
      import {LiveSocket} from "phoenix_live_view"

      let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: token}})
      """

      {:patched, out} = Install.patch_app_js(src)

      assert out =~
               ~s(import KeenWebMultiselectHook from "../../deps/keen_web_multiselect/priv/static/keen_web_multiselect_hook.js")

      assert out =~ ~s(import "../../deps/keen_web_multiselect/priv/static/multiselect.js")
      # inserted after the last import, before the LiveSocket line
      assert String.split(out, "\n") |> Enum.find_index(&(&1 =~ "phoenix_live_view")) <
               String.split(out, "\n") |> Enum.find_index(&(&1 =~ "multiselect.js"))
    end

    test "prepends imports when the file has none" do
      {:patched, out} = Install.patch_app_js("let liveSocket = new LiveSocket(\"/live\", Socket, {})\n")
      assert String.starts_with?(out, "import KeenWebMultiselectHook")
    end
  end

  describe "patch_app_js/1 — hook registration" do
    test "adds a hooks key to a default Phoenix LiveSocket" do
      src = """
      import {Socket} from "phoenix"
      let liveSocket = new LiveSocket("/live", Socket, {
        longPollFallbackMs: 2500,
        params: {_csrf_token: csrfToken}
      })
      """

      {:patched, out} = Install.patch_app_js(src)
      assert out =~ ~r/hooks:\s*\{KeenWebMultiselectHook\}/
    end

    test "merges into an existing object-literal hooks" do
      src = """
      import {Socket} from "phoenix"
      let liveSocket = new LiveSocket("/live", Socket, {
        hooks: {MyHook, OtherHook},
        params: {_csrf_token: csrfToken}
      })
      """

      {:patched, out} = Install.patch_app_js(src)
      assert out =~ "hooks: {KeenWebMultiselectHook, MyHook, OtherHook}"
    end

    test "flags :partial when hooks is a non-literal reference" do
      src = """
      import {Socket} from "phoenix"
      import Hooks from "./hooks"
      let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {}})
      """

      {:partial, out} = Install.patch_app_js(src)
      # imports still added, but registration left for the user
      assert out =~ "multiselect.js"
      refute out =~ "hooks: {KeenWebMultiselectHook"
    end

    test "flags :partial when there is no LiveSocket at all" do
      {:partial, _out} = Install.patch_app_js("console.log('no socket here')\n")
    end
  end

  describe "idempotency" do
    test "a fully wired app.js reports :present and is unchanged" do
      src = """
      import KeenWebMultiselectHook from "../../deps/keen_web_multiselect/priv/static/keen_web_multiselect_hook.js"
      import "../../deps/keen_web_multiselect/priv/static/multiselect.js"
      let liveSocket = new LiveSocket("/live", Socket, {
        hooks: {KeenWebMultiselectHook},
        params: {_csrf_token: csrfToken}
      })
      """

      assert {:present, ^src} = Install.patch_app_js(src)
    end

    test "re-running the patch is stable (patch twice == patch once)" do
      src = """
      import {Socket} from "phoenix"
      let liveSocket = new LiveSocket("/live", Socket, {params: {}})
      """

      {_, once} = Install.patch_app_js(src)
      assert {:present, ^once} = Install.patch_app_js(once)
    end
  end

  describe "patch_app_css/1" do
    test "adds the stylesheet import after existing @imports" do
      src = ~s(@import "tailwindcss";\n\nbody { margin: 0; }\n)
      {:patched, out} = Install.patch_app_css(src)

      assert out =~ ~s(@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";)
      lines = String.split(out, "\n")

      assert Enum.find_index(lines, &(&1 =~ "tailwindcss")) <
               Enum.find_index(lines, &(&1 =~ "multiselect.css"))
    end

    test "prepends when there is no @import" do
      {:patched, out} = Install.patch_app_css("body { margin: 0; }\n")
      assert String.starts_with?(out, ~s(@import "../../deps/keen_web_multiselect))
    end

    test "is idempotent" do
      src = ~s(@import "../../deps/keen_web_multiselect/priv/static/multiselect.css";\n)
      assert {:present, ^src} = Install.patch_app_css(src)
    end
  end
end
