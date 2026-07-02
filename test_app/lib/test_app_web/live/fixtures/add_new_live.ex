defmodule TestAppWeb.Fixtures.AddNewLive do
  use TestAppWeb, :live_view

  import Keenmate.WebMultiselect.Components

  @fruits [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, fruits: @fruits)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>add-new (tag creation)</h1>
    <p>Targeted by <code>e2e/add_new.spec.ts</code>.</p>

    <div class="fixture">
      <div class="fixture-label">
        allow_add_new + JS addNewCallback — typing an unknown term and pressing Enter creates it
      </div>
      <.web_multiselect id="tagger" options={@fruits} allow_add_new={true} />
    </div>

    <script type="module">
      const wait = (id) => new Promise((resolve) => {
        const check = () => {
          const el = document.getElementById(id);
          if (el && el.tagName.toLowerCase() === 'web-multiselect') resolve(el);
          else requestAnimationFrame(check);
        };
        check();
      });

      // addNewCallback receives the typed term and returns the new option.
      // Upstream pushes it into allOptions, selects it, and clears the input.
      wait('tagger').then((el) => {
        el.addNewCallback = (term) => ({ value: term.toLowerCase(), label: term });
      });
    </script>
    """
  end
end
