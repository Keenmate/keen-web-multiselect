defmodule Keenmate.WebMultiselect.OptionHelpersTest do
  use ExUnit.Case, async: true

  alias Keenmate.WebMultiselect.OptionHelpers

  describe "to_html_attributes/1" do
    test "drops nil values" do
      assigns = %{multiple: nil, search_placeholder: "Search…"}
      attrs = OptionHelpers.to_html_attributes(assigns)
      # nil-valued assigns are omitted entirely...
      refute Map.has_key?(attrs, "multiple")
      # ...while real values pass through. (The canonical member defaults are
      # emitted unconditionally on top — asserted separately below.)
      assert attrs["search-placeholder"] == "Search…"
    end

    test "converts snake_case keys to kebab-case" do
      assigns = %{badges_display_mode: "compact", badge_tooltip_delay: 150}
      attrs = OptionHelpers.to_html_attributes(assigns)
      assert attrs["badges-display-mode"] == "compact"
      assert attrs["badge-tooltip-delay"] == "150"
    end

    test "renders booleans as explicit strings" do
      attrs = OptionHelpers.to_html_attributes(%{multiple: false, show_counter: true})
      assert attrs["multiple"] == "false"
      assert attrs["show-counter"] == "true"
    end

    test "skips passthrough keys handled by the template" do
      assigns = %{id: "x", name: "tags", class: "foo", hook: "H", options: nil, rest: %{}}
      attrs = OptionHelpers.to_html_attributes(assigns)
      refute Map.has_key?(attrs, "id")
      refute Map.has_key?(attrs, "name")
      refute Map.has_key?(attrs, "class")
      refute Map.has_key?(attrs, "hook")
    end

    test "skips Phoenix.Component internals (:__given__, :__changed__)" do
      assigns = %{
        __given__: %{multiple: false},
        __changed__: nil,
        multiple: false
      }

      attrs = OptionHelpers.to_html_attributes(assigns)
      refute Map.has_key?(attrs, "--given--")
      refute Map.has_key?(attrs, "--changed--")
      assert attrs["multiple"] == "false"
    end

    test "encodes :options as JSON onto data-options" do
      assigns = %{options: [%{value: "a", label: "A"}, {"b", "B"}]}
      attrs = OptionHelpers.to_html_attributes(assigns)
      refute Map.has_key?(attrs, "options")

      assert Jason.decode!(attrs["data-options"]) == [
               %{"value" => "a", "label" => "A"},
               %{"value" => "b", "label" => "B"}
             ]
    end

    test "always defaults the six canonical member attrs (regardless of :options)" do
      # Whether options arrive via HEEx, async search, JS-side assignment, or
      # declarative <option> children, the wrapper emits the canonical-shape
      # member attrs so upstream knows which keys to read.
      for assigns <- [
            %{options: [%{value: "a", label: "A"}]},
            %{value: ["a"]},
            %{}
          ] do
        attrs = OptionHelpers.to_html_attributes(assigns)
        assert attrs["value-member"] == "value"
        assert attrs["display-value-member"] == "label"
        assert attrs["icon-member"] == "icon"
        assert attrs["subtitle-member"] == "subtitle"
        assert attrs["group-member"] == "group"
        assert attrs["disabled-member"] == "disabled"
      end
    end

    test "preserves explicit *_member overrides against the defaults" do
      assigns = %{
        options: [%{id: 1, name: "A"}],
        value_member: "id",
        display_value_member: "name",
        icon_member: "emoji",
        subtitle_member: "tagline",
        group_member: "category",
        disabled_member: "locked"
      }

      attrs = OptionHelpers.to_html_attributes(assigns)
      assert attrs["value-member"] == "id"
      assert attrs["display-value-member"] == "name"
      assert attrs["icon-member"] == "emoji"
      assert attrs["subtitle-member"] == "tagline"
      assert attrs["group-member"] == "category"
      assert attrs["disabled-member"] == "locked"
    end

    test "search-value-member is not defaulted (no obvious canonical key name)" do
      attrs = OptionHelpers.to_html_attributes(%{options: [%{value: "a", label: "A"}]})
      refute Map.has_key?(attrs, "search-value-member")
    end

    test "encodes a list :value into initial-values" do
      assigns = %{value: ["js", "py"]}
      attrs = OptionHelpers.to_html_attributes(assigns)
      assert Jason.decode!(attrs["initial-values"]) == ["js", "py"]
    end

    test "wraps a scalar :value into a single-item initial-values list" do
      assigns = %{value: "js"}
      attrs = OptionHelpers.to_html_attributes(assigns)
      assert Jason.decode!(attrs["initial-values"]) == ["js"]
    end

    test "passes through a binary :value that already looks like JSON" do
      assigns = %{value: ~s(["js","py"])}
      attrs = OptionHelpers.to_html_attributes(assigns)
      assert attrs["initial-values"] == ~s(["js","py"])
    end

    test "explicit :initial_values wins over :value" do
      assigns = %{value: ["js"], initial_values: ["py"]}
      attrs = OptionHelpers.to_html_attributes(assigns)
      assert Jason.decode!(attrs["initial-values"]) == ["py"]
    end

    test "includes :placeholder when set" do
      attrs = OptionHelpers.to_html_attributes(%{placeholder: "Pick one"})
      assert attrs["placeholder"] == "Pick one"
    end
  end

  describe "encode_options/1" do
    test "encodes nil as empty JSON array" do
      assert OptionHelpers.encode_options(nil) == "[]"
    end

    test "normalizes {value, label} tuples" do
      json = OptionHelpers.encode_options([{"js", "JavaScript"}])
      assert Jason.decode!(json) == [%{"value" => "js", "label" => "JavaScript"}]
    end

    test "preserves extra map keys" do
      json = OptionHelpers.encode_options([%{value: "js", label: "JS", icon: "🟨"}])
      assert Jason.decode!(json) == [%{"value" => "js", "label" => "JS", "icon" => "🟨"}]
    end
  end
end
