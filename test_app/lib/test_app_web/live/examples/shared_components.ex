defmodule TestAppWeb.Examples.SharedComponents do
  @moduledoc """
  HEEx primitives shared across demo pages.

  Mirrors the layout shapes from upstream's `examples-*.html` so the demo gallery
  has a consistent shell: container chrome with a back-link header, white cards,
  notes, code blocks, and a read-only output panel for showing event payloads.
  """

  use Phoenix.Component

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  attr :back_to, :string, default: "/"
  slot :inner_block, required: true

  def example_page(assigns) do
    ~H"""
    <div class="container">
      <header>
        <a href={@back_to} class="back-link">← Back to Examples</a>
        <h1>{@icon} {@title}</h1>
        <p class="subtitle">{@subtitle}</p>
      </header>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={["card", @class]} {@rest}>
      <h2 :if={@title}>{@title}</h2>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :title, :string, default: nil
  attr :variant, :string, default: nil, values: [nil, "warning"]
  slot :inner_block, required: true

  def note(assigns) do
    ~H"""
    <div class={["note", @variant]}>
      <div :if={@title} class="note-title">{@title}</div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :lang, :string, default: "html"
  slot :inner_block, required: true

  def code_block(assigns) do
    ~H"""
    <div class="code-block">
      <pre><code class={"language-#{@lang}"}>{render_slot(@inner_block)}</code></pre>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, default: "Result"
  attr :placeholder, :string, default: "No selection yet."

  def output_panel(assigns) do
    ~H"""
    <div class="output">
      <div class="output-label">{@label}</div>
      <pre id={@id} phx-update="ignore">{@placeholder}</pre>
    </div>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  def form_group(assigns) do
    ~H"""
    <div class="form-group" {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  def grid(assigns) do
    ~H"""
    <div class="grid" {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  def grid_2(assigns) do
    ~H"""
    <div class="grid-2" {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
