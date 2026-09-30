defmodule Keenmate.WebMultiselectTest do
  use ExUnit.Case, async: true

  doctest Keenmate.WebMultiselect

  alias Phoenix.LiveView.Utils

  defp events(socket), do: Utils.get_push_events(socket)

  test "upstream_version/0 reports the bundled component version" do
    assert Keenmate.WebMultiselect.upstream_version() =~ ~r/^\d+\.\d+\.\d+/
  end

  test "push_update/3 sends a web_multiselect:update event scoped to the id" do
    socket = Keenmate.WebMultiselect.push_update(%Phoenix.LiveView.Socket{}, "region", value: ["cz"])

    assert ["web_multiselect:update", %{id: "region", value: ["cz"]}] in events(socket)
  end

  test "push_update/3 only includes the keys that were passed" do
    opts_only =
      Keenmate.WebMultiselect.push_update(%Phoenix.LiveView.Socket{}, "region",
        options: [%{value: "a", label: "A"}]
      )

    assert [["web_multiselect:update", %{id: "region", options: [%{value: "a", label: "A"}]}]] =
             events(opts_only)

    value_only = Keenmate.WebMultiselect.push_update(%Phoenix.LiveView.Socket{}, "region", value: [])
    assert [["web_multiselect:update", %{id: "region", value: []}]] = events(value_only)
    refute match?([[_, %{options: _}]], events(value_only))
  end

  test "push_update/3 with no opts still targets the element (id-only payload)" do
    socket = Keenmate.WebMultiselect.push_update(%Phoenix.LiveView.Socket{}, "region")
    assert [["web_multiselect:update", %{id: "region"}]] = events(socket)
  end

  test "push_command/3 sends a web_multiselect:command event scoped to the id" do
    socket =
      Keenmate.WebMultiselect.push_command(%Phoenix.LiveView.Socket{}, "skills",
        open: true,
        scroll_to_group: "backend"
      )

    assert [["web_multiselect:command", %{id: "skills", open: true, scroll_to_group: "backend"}]] =
             events(socket)
  end

  test "push_command/3 only includes the command keys that were passed" do
    socket = Keenmate.WebMultiselect.push_command(%Phoenix.LiveView.Socket{}, "skills", search: "back")
    assert [["web_multiselect:command", payload]] = events(socket)
    assert payload == %{id: "skills", search: "back"}
  end

  test "push_command/3 with no opts still targets the element (id-only payload)" do
    socket = Keenmate.WebMultiselect.push_command(%Phoenix.LiveView.Socket{}, "skills")
    assert [["web_multiselect:command", %{id: "skills"}]] = events(socket)
  end
end
