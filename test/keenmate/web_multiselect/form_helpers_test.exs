defmodule Keenmate.WebMultiselect.FormHelpersTest do
  use ExUnit.Case, async: true

  alias Keenmate.WebMultiselect.FormHelpers
  alias Phoenix.HTML.FormField

  defp field(opts \\ []) do
    %FormField{
      id: Keyword.get(opts, :id, "form_tags"),
      name: Keyword.get(opts, :name, "form[tags][]"),
      value: Keyword.get(opts, :value, ["js", "py"]),
      errors: [],
      field: :tags,
      form: %Phoenix.HTML.Form{}
    }
  end

  test "fills in id, name, value from a FormField" do
    assigns = %{field: field(), id: nil, name: nil, value: nil}
    result = FormHelpers.assign_from_field(assigns)

    assert result.id == "form_tags"
    assert result.name == "form[tags][]"
    assert result.value == ["js", "py"]
    assert result.field == nil
  end

  test "explicit assigns win over the FormField defaults" do
    assigns = %{field: field(), id: "custom", name: "custom_name", value: nil}
    result = FormHelpers.assign_from_field(assigns)

    assert result.id == "custom"
    assert result.name == "custom_name"
    assert result.value == ["js", "py"]
  end

  test "passes assigns through when no field is set" do
    assigns = %{field: nil, id: "x", name: "y", value: nil}
    assert FormHelpers.assign_from_field(assigns) == assigns
  end
end
