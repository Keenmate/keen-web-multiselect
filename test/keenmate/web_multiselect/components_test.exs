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

  test "emits tree attributes as kebab-case (tree mode)" do
    html =
      render_multiselect(
        id: "cats",
        path_member: "path",
        parent_path_member: "parent",
        level_member: "lvl",
        has_children_member: "kids",
        tree_path_separator: "/"
      )

    assert html =~ ~s(path-member="path")
    assert html =~ ~s(parent-path-member="parent")
    assert html =~ ~s(level-member="lvl")
    assert html =~ ~s(has-children-member="kids")
    assert html =~ ~s(tree-path-separator="/")
  end

  test "emits is-selectable-member (tree per-node selectability)" do
    html = render_multiselect(id: "cats", path_member: "path", is_selectable_member: "selectable")

    assert html =~ ~s(path-member="path")
    assert html =~ ~s(is-selectable-member="selectable")
  end

  test "emits dropdown-width and selected-popover-width (independent panel sizing)" do
    html = render_multiselect(id: "sz", dropdown_width: "60rem", selected_popover_width: "30rem")

    assert html =~ ~s(dropdown-width="60rem")
    assert html =~ ~s(selected-popover-width="30rem")
  end

  test "emits checkbox-mode and cascade-select-policy (cascade checkboxes)" do
    html =
      render_multiselect(
        id: "cats",
        path_member: "path",
        checkbox_mode: "cascade",
        cascade_select_policy: "rolled-up"
      )

    assert html =~ ~s(checkbox-mode="cascade")
    assert html =~ ~s(cascade-select-policy="rolled-up")
  end

  test "omits tree attributes when not set (stays a flat list)" do
    html = render_multiselect(id: "flat", options: [%{value: "a", label: "A"}])
    refute html =~ "path-member"
    refute html =~ "tree-path-separator"
    refute html =~ "is-selectable-member"
    refute html =~ "checkbox-mode"
    refute html =~ "cascade-select-policy"
  end

  test "emits full-title-member and show-badge-full-title" do
    html =
      render_multiselect(
        id: "ft",
        full_title_member: "fullTitle",
        show_badge_full_title: true
      )

    assert html =~ ~s(full-title-member="fullTitle")
    assert html =~ ~s(show-badge-full-title="true")
  end
end
