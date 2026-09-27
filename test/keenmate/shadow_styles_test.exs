defmodule Keenmate.WebMultiselect.ShadowStylesTest do
  # async: false — these mutate the global :shadow_styles application env.
  use ExUnit.Case, async: false

  import Phoenix.LiveViewTest

  alias Keenmate.WebMultiselect
  alias Keenmate.WebMultiselect.Components

  setup do
    prev = Application.get_env(:keen_web_multiselect, :shadow_styles)

    on_exit(fn ->
      if prev do
        Application.put_env(:keen_web_multiselect, :shadow_styles, prev)
      else
        Application.delete_env(:keen_web_multiselect, :shadow_styles)
      end
    end)

    :ok
  end

  describe "shadow_styles_css/0" do
    test "nil when unconfigured" do
      Application.delete_env(:keen_web_multiselect, :shadow_styles)
      assert WebMultiselect.shadow_styles_css() == nil
    end

    test "a binary is treated as inline CSS" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".ms__badge{border-radius:999px}")
      assert WebMultiselect.shadow_styles_css() == ".ms__badge{border-radius:999px}"
    end

    test "{:inline, css}" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, {:inline, ".a{color:red}"})
      assert WebMultiselect.shadow_styles_css() == ".a{color:red}"
    end

    test "{:file, path} reads the file contents" do
      path = Path.join(System.tmp_dir!(), "kwms_#{System.unique_integer([:positive])}.css")
      File.write!(path, ".from-file{color:red}")
      on_exit(fn -> File.rm_rf(path) end)

      Application.put_env(:keen_web_multiselect, :shadow_styles, {:file, path})
      assert WebMultiselect.shadow_styles_css() == ".from-file{color:red}"
    end

    test "a 0-arity function is called" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, fn -> ".fn{}" end)
      assert WebMultiselect.shadow_styles_css() == ".fn{}"
    end

    test "a {mod, fun, args} tuple is applied" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, {String, :duplicate, [".x", 2]})
      assert WebMultiselect.shadow_styles_css() == ".x.x"
    end
  end

  describe "defaults_js/0" do
    test "carries the client registry API" do
      js = WebMultiselect.defaults_js()
      assert js =~ "window.KeenWebMultiselect"
      assert js =~ "registerShadowStyles"
      assert js =~ "getShadowStyles"
      assert js =~ "adoptedStyleSheets"
    end

    test "releases auto defer gates after adopting, but not manual ones" do
      js = WebMultiselect.defaults_js()
      assert js =~ "releaseDefer"
      # Everything deferred is released EXCEPT elements flagged data-kwms-manual.
      assert js =~ "data-kwms-manual"
      assert js =~ ~s|removeAttribute("defer")|
    end
  end

  describe "shadow_styles_configured?/0" do
    test "false when unconfigured" do
      Application.delete_env(:keen_web_multiselect, :shadow_styles)
      refute WebMultiselect.shadow_styles_configured?()
    end

    test "true when :shadow_styles is set" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".a{}")
      assert WebMultiselect.shadow_styles_configured?()
    end
  end

  describe "auto defer gate (web_multiselect/1 + shared styles)" do
    defp render_ms(attrs), do: render_component(&Components.web_multiselect/1, attrs)

    test "auto-emits a bare defer (no manual flag) when shared styles are configured" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".a{}")
      html = render_ms(id: "x")
      assert html =~ ~r/\sdefer[\s>]/
      refute html =~ "data-kwms-manual"
    end

    test "defer={false} opts a single select out of the auto gate" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".a{}")
      html = render_ms(id: "x", defer: false)
      refute html =~ ~r/\sdefer[\s>]/
      refute html =~ "data-kwms-manual"
    end

    test "defer={true} is a manual gate (defer + data-kwms-manual) even when configured" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".a{}")
      html = render_ms(id: "x", defer: true)
      assert html =~ ~r/\sdefer[\s>]/
      assert html =~ "data-kwms-manual"
    end
  end

  describe "shadow_styles/1 component" do
    test "renders the template + bootstrap when configured" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".ms__badge{border-radius:999px}")

      html = render_component(&Components.shadow_styles/1, %{})

      assert html =~ ~s(<template id="kwms-shadow-styles">)
      assert html =~ "border-radius:999px"
      assert html =~ "<script"
      assert html =~ "registerShadowStyles"
      assert html =~ "window.KeenWebMultiselect"
    end

    test "renders nothing when unconfigured" do
      Application.delete_env(:keen_web_multiselect, :shadow_styles)

      html = render_component(&Components.shadow_styles/1, %{})

      refute html =~ "kwms-shadow-styles"
      refute html =~ "<script"
    end

    test "puts a CSP nonce on the inline script" do
      Application.put_env(:keen_web_multiselect, :shadow_styles, ".a{}")

      html = render_component(&Components.shadow_styles/1, %{nonce: "abc123"})

      assert html =~ ~s(nonce="abc123")
    end
  end
end
