defmodule Keenmate.WebMultiselect.FormHelpers do
  @moduledoc """
  Binds a `Phoenix.HTML.FormField` to the `<.web_multiselect>` component's
  `:id`, `:name`, and `:value` assigns.
  """

  alias Phoenix.HTML.FormField

  @doc """
  Resolves the `field` assign into concrete `id`, `name`, and `value` assigns.

  When `assigns.field` is a `Phoenix.HTML.FormField`, its `id`, `name`, and `value`
  fill in any unset assign. Explicit assigns win — passing both `field` and `id`
  keeps the explicit `id`.
  """
  @spec assign_from_field(map()) :: map()
  def assign_from_field(%{field: %FormField{} = field} = assigns) do
    assigns
    |> default_assign(:id, field.id)
    |> default_assign(:name, field.name)
    |> default_assign(:value, field.value)
    |> Map.put(:field, nil)
  end

  def assign_from_field(assigns), do: assigns

  defp default_assign(assigns, key, value) do
    case Map.get(assigns, key) do
      nil -> Map.put(assigns, key, value)
      _ -> assigns
    end
  end
end
