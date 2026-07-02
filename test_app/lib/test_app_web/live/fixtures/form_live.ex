defmodule TestAppWeb.Fixtures.FormLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"fruits" => []}, as: "basket")
    # Separate form that ships a FormField with a default value, so the spec
    # can verify the initial selection is rendered as a badge post-mount (not
    # only present in the form params).
    prefilled = to_form(%{"fruits" => ["banana", "cherry"]}, as: "prefilled")
    {:ok, assign(socket, form: form, prefilled: prefilled, fruits: @fruits, last_params: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>form integration via Phoenix.HTML.FormField</h1>
    <p>Targeted by <code>e2e/form.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">field=@form[:fruits] — id, name, initial-values come from the FormField</div>
      <form id="basket-form" phx-change="validate" phx-submit="save">
        <.web_multiselect
          field={@form[:fruits]}
          options={@fruits}
          hook="KeenWebMultiselectHook"
        />
        <button type="submit" id="submit-btn">Submit</button>
      </form>
    </div>

    <div class="fixture">
      <div class="fixture-label">
        field with a pre-set value — initial selection must render as a badge after mount,
        not only appear in the form params
      </div>
      <form id="prefilled-form" phx-change="ignore">
        <.web_multiselect
          id="prefilled"
          field={@prefilled[:fruits]}
          options={@fruits}
          hook="KeenWebMultiselectHook"
        />
      </form>
    </div>

    <div class="fixture">
      <div class="fixture-label">params received by phx-change / phx-submit</div>
      <pre data-testid="form-params">{inspect(@last_params)}</pre>
    </div>
    """
  end

  @impl true
  def handle_event("validate", params, socket) do
    {:noreply, assign(socket, last_params: params)}
  end

  def handle_event("save", params, socket) do
    {:noreply, assign(socket, last_params: {:submitted, params})}
  end

  def handle_event("ignore", _params, socket), do: {:noreply, socket}

  # Ignore hook-forwarded events on this fixture — the form's hidden input
  # is what e2e asserts against, not the JS events.
  def handle_event("web_multiselect:" <> _, _payload, socket), do: {:noreply, socket}
end
