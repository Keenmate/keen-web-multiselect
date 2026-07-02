defmodule TestAppWeb.Fixtures.DeclarativeLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <h1>declarative inner_block options</h1>
    <p>Targeted by <code>e2e/declarative.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        bare &lt;option&gt; children — upstream's declarative path, no JSON encoding by the wrapper
      </div>
      <.web_multiselect id="bare">
        <option value="apple">Apple</option>
        <option value="banana">Banana</option>
        <option value="cherry">Cherry</option>
      </.web_multiselect>
    </div>

    <div class="fixture">
      <div class="fixture-label">
        &lt;optgroup&gt; + selected — group, pre-selected option, and one disabled row
      </div>
      <.web_multiselect id="grouped">
        <optgroup label="Citrus">
          <option value="lemon">Lemon</option>
          <option value="orange" selected>Orange</option>
        </optgroup>
        <optgroup label="Berries">
          <option value="strawberry">Strawberry</option>
          <option value="raspberry" disabled>Raspberry</option>
        </optgroup>
      </.web_multiselect>
    </div>

    <div class="fixture">
      <div class="fixture-label">
        per-option data-icon / data-subtitle — upstream's declarative parser maps
        these onto the option object (icon / subtitle members)
      </div>
      <.web_multiselect id="rich">
        <option value="apple" data-icon="🍎" data-subtitle="Crisp and red">Apple</option>
        <option value="banana" data-icon="🍌" data-subtitle="Rich in potassium">Banana</option>
      </.web_multiselect>
    </div>
    """
  end
end
