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
        <p class="control-legend">
          <span class="control-legend__item">🌐 client — runs in the browser (element JS API)</span>
          <span class="control-legend__item">🖥️ server — LiveView round-trip</span>
        </p>
      </header>
      {render_slot(@inner_block)}
    </div>
    <.live_component module={TestAppWeb.Examples.ServerEventsPanel} id="server-events-panel" />
    """
  end

  attr :id, :string, default: nil
  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def card(assigns) do
    assigns = assign(assigns, :id, assigns[:id] || slug_id(assigns[:title]))

    ~H"""
    <div id={@id} class={["card", @class]} {@rest}>
      <h2 :if={@title}>{@title}</h2>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # Stable, server-rendered anchor id derived from a card title, so the floating
  # chapter-nav's #id jumps survive LiveView's morphdom (a client-assigned id would
  # be stripped when the static subtree is patched on connect). Nil title -> no id.
  defp slug_id(nil), do: nil

  defp slug_id(title) do
    slug =
      title
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]+/u, "-")
      |> String.trim("-")

    if slug == "", do: nil, else: slug
  end

  @doc """
  A card for demos of features that exist ONLY in the LiveView wrapper (not
  upstream). Renders with a dashed border and a "keen extra" badge so it's
  obvious at a glance in a side-by-side diff against the upstream examples.
  """
  attr :id, :string, default: nil
  attr :title, :string, required: true
  attr :badge, :string, default: "keen extra"
  attr :rest, :global
  slot :inner_block, required: true

  def keen_card(assigns) do
    assigns = assign(assigns, :id, assigns[:id] || slug_id(assigns[:title]))

    ~H"""
    <div id={@id} class="card card--keen" {@rest}>
      <h2>{@title} <span class="keen-badge">{@badge}</span></h2>
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

  @doc """
  A compact one-line hint showing the wrapper attribute(s) for a demo card.
  Shorter and lighter than `<.note>` — meant for a quick "here's how you'd do
  this in HEEx".
  """
  attr :rest, :global
  slot :inner_block, required: true

  def tip(assigns) do
    ~H"""
    <p class="tip" {@rest}>{render_slot(@inner_block)}</p>
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
