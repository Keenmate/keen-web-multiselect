defmodule Keenmate.WebMultiselect.ComponentsTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias Keenmate.WebMultiselect.Components

  defp render_multiselect(attrs) do
    render_component(&Components.web_multiselect/1, attrs)
  end

  test "renders a <web-multiselect> element with an id" do
    html = render_multiselect(id: "tags")
    assert html =~ "<web-multiselect"
    assert html =~ ~s(id="tags")
  end

  test "emits booleans as explicit string values" do
    html = render_multiselect(id: "x", multiple: false, show_counter: true)
    assert html =~ ~s(multiple="false")
    assert html =~ ~s(show-counter="true")
  end

  test "encodes options as JSON onto data-options (upstream reads data-options, not options)" do
    html =
      render_multiselect(
        id: "x",
        options: [%{value: "a", label: "A"}, %{value: "b", label: "B"}]
      )

    assert html =~ ~s(data-options=)
    refute html =~ ~r/\soptions="/
    assert html =~ "value"
    assert html =~ "label"
  end

  test "wires up phx-hook when :hook is set" do
    html = render_multiselect(id: "x", hook: "KeenWebMultiselectHook")
    assert html =~ ~s(phx-hook="KeenWebMultiselectHook")
  end

  test "hook={true} resolves to the bundled hook name" do
    html = render_multiselect(id: "x", hook: true)
    assert html =~ ~s(phx-hook="KeenWebMultiselectHook")
  end

  test "hook={false} renders no phx-hook" do
    html = render_multiselect(id: "x", hook: false)
    refute html =~ "phx-hook"
  end

  test "renders no phx-hook when :hook is nil" do
    html = render_multiselect(id: "x")
    refute html =~ "phx-hook"
  end

  test "passes through arbitrary :rest attributes" do
    html = render_multiselect(id: "x", "data-testid": "tags-select")
    assert html =~ ~s(data-testid="tags-select")
  end

  test "renders cleanly when bound to a Phoenix.HTML.FormField" do
    form = Phoenix.Component.to_form(%{"tags" => ["a", "b"]}, as: "basket")
    html = render_multiselect(field: form[:tags])

    assert html =~ ~s(id="basket_tags")
    assert html =~ ~s(name="basket[tags]")
    assert html =~ ~s(initial-values="[&quot;a&quot;,&quot;b&quot;]")
    refute html =~ "FormField"
  end
end
