defmodule Keenmate.WebMultiselect.OptionHelpers do
  @moduledoc """
  Converts the `Components.web_multiselect/1` assigns into a map of HTML attributes
  shaped the way `<web-multiselect>` expects them.
  """

  # Assigns that the component handles directly (rendered as their own HTML attributes
  # in the template) and must NOT be re-emitted as data attributes.
  @passthrough_keys ~w(
    id name value field hook search_event options class style placeholder rest inner_block
    defer defer? __changed__ attributes
  )a

  @doc """
  Builds the map of HTML attributes for the underlying `<web-multiselect>` element.

  * Drops keys whose value is `nil`.
  * Renames `snake_case` keys to `kebab-case`.
  * Renders booleans as explicit `"true"` / `"false"` strings (the upstream component
    expects `multiple="false"`, not a missing attribute).
  * Encodes `options` and `initial_values` as JSON.
  """
  @spec to_html_attributes(map()) :: map()
  def to_html_attributes(assigns) when is_map(assigns) do
    assigns
    |> Map.drop(@passthrough_keys)
    |> Enum.reject(&internal_key?/1)
    |> Enum.reduce(%{}, fn {key, value}, acc -> put_attribute(acc, key, value) end)
    |> maybe_put_options(assigns)
    |> put_member_defaults()
    |> maybe_put_initial_values(assigns)
    |> maybe_put_placeholder(assigns)
  end

  # Phoenix.Component injects bookkeeping atoms like :__given__, :__changed__ into
  # the assigns map. They must never reach the rendered element.
  defp internal_key?({key, _}) when is_atom(key) do
    key |> Atom.to_string() |> String.starts_with?("__")
  end

  defp internal_key?(_), do: false

  @doc """
  Encodes an options list into the JSON shape `<web-multiselect>` reads from its
  `options` attribute.

  Accepts:
    * `[{value, label}, ...]` tuple lists,
    * `[%{value: ..., label: ...}, ...]` maps (extra keys preserved),
    * any list — passed through to `Jason.encode!/1` as-is.
  """
  @spec encode_options(term()) :: String.t()
  def encode_options(nil), do: "[]"

  def encode_options(list) when is_list(list) do
    list
    |> Enum.map(&normalize_option/1)
    |> Jason.encode!()
  end

  def encode_options(other), do: Jason.encode!(other)

  defp normalize_option({value, label}), do: %{value: value, label: label}
  defp normalize_option(%{} = map), do: map
  defp normalize_option(other), do: other

  defp put_attribute(acc, _key, nil), do: acc

  defp put_attribute(acc, key, value) do
    Map.put(acc, snake_to_kebab(key), encode_value(value))
  end

  defp encode_value(true), do: "true"
  defp encode_value(false), do: "false"
  defp encode_value(value) when is_atom(value), do: Atom.to_string(value)
  defp encode_value(value) when is_integer(value) or is_float(value), do: to_string(value)
  defp encode_value(value) when is_binary(value), do: value
  defp encode_value(value), do: Jason.encode!(value)

  defp snake_to_kebab(key) when is_atom(key) do
    key |> Atom.to_string() |> String.replace("_", "-")
  end

  defp snake_to_kebab(key) when is_binary(key), do: String.replace(key, "_", "-")

  # Upstream reads the JSON option list from `data-options` (the `options`
  # property is reserved for JS assignment). Writing to `options="..."` would
  # be silently ignored — see src/web-component.ts:561 in @keenmate/web-multiselect.
  defp maybe_put_options(attrs, %{options: nil}), do: attrs

  defp maybe_put_options(attrs, %{options: options}),
    do: Map.put(attrs, "data-options", encode_options(options))

  defp maybe_put_options(attrs, _), do: attrs

  # Member-attr defaults — unconditional.
  #
  # The wrapper's documented canonical option shape is
  #
  #     %{value:, label:, icon?:, subtitle?:, group?:, disabled?:}
  #
  # regardless of how options arrive (HEEx `options=` JSON, JS-side
  # `el.options = [...]`, declarative `<option>` children, or async
  # `searchCallback` results). Upstream's own auto-fallback for these
  # members (`Is` array in multiselect.js) only fires on the declarative
  # path; the JSON / JS / async paths leave `valueMember` / `displayValueMember`
  # as `undefined` and every row falls through to `[N/A]`.
  #
  # We default each member to the canonical key name once, on every render,
  # so consumers don't have to spell them out per multiselect. Explicit
  # `*_member` assigns still win — they land via `put_attribute` before this
  # function runs, and `Map.put_new` is a no-op on existing keys. Missing
  # keys on the data side are harmless — upstream just renders without that
  # field. `search-value-member` is intentionally not defaulted — defaulting
  # it would change which text the search matches against, and there's no
  # "obvious" name for it the way `value` / `label` are obvious.
  defp put_member_defaults(attrs) do
    attrs
    |> Map.put_new("value-member", "value")
    |> Map.put_new("display-value-member", "label")
    |> Map.put_new("icon-member", "icon")
    |> Map.put_new("subtitle-member", "subtitle")
    |> Map.put_new("group-member", "group")
    |> Map.put_new("disabled-member", "disabled")
  end

  defp maybe_put_initial_values(attrs, %{initial_values: values}) when not is_nil(values),
    do: put_initial_values(attrs, values)

  defp maybe_put_initial_values(attrs, %{value: value}) when not is_nil(value),
    do: put_initial_values(attrs, value)

  defp maybe_put_initial_values(attrs, _), do: attrs

  defp put_initial_values(attrs, value) when is_binary(value) do
    case String.starts_with?(String.trim_leading(value), ["[", "\""]) do
      true -> Map.put(attrs, "initial-values", value)
      false -> Map.put(attrs, "initial-values", Jason.encode!([value]))
    end
  end

  defp put_initial_values(attrs, value),
    do: Map.put(attrs, "initial-values", Jason.encode!(List.wrap(value)))

  defp maybe_put_placeholder(attrs, %{placeholder: nil}), do: attrs

  defp maybe_put_placeholder(attrs, %{placeholder: placeholder}),
    do: Map.put(attrs, "placeholder", placeholder)

  defp maybe_put_placeholder(attrs, _), do: attrs
end
