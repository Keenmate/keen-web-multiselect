defmodule TestAppWeb.Api.ProductsController do
  @moduledoc """
  A tiny JSON endpoint the "Elixir Only" EO07 card fetches from the browser to
  demonstrate **client-side REST loading of an authenticated, same-origin API**.

  The key point is authentication. The browser calls this with
  `fetch(url, { credentials: "same-origin" })` (the wrapper's default), so the
  Phoenix **session cookie rides along automatically** — the same cookie every
  other request carries. That means an authed endpoint needs *no* token in the
  DOM: the ordinary session/auth plug pipeline gates it server-side. The `:api`
  pipeline here runs `:fetch_session`, and `authorize/1` reads it; the demo is
  intentionally permissive (any session is fine) but shows exactly where a real
  `if get_session(conn, :current_user)` check would live.
  """
  use TestAppWeb, :controller

  # Sample catalogue. `price` is what the `?q=price>N` filter compares; the rest
  # is option-shaped for the wrapper (value/label/subtitle) so no client mapping
  # is needed — value_member/display_value_member/subtitle_member read it directly.
  @products [
    %{value: "sku-01", label: "Mechanical Keyboard", price: 129, subtitle: "$129 · peripherals"},
    %{value: "sku-02", label: "USB-C Hub", price: 49, subtitle: "$49 · accessories"},
    %{value: "sku-03", label: "27\" 4K Monitor", price: 389, subtitle: "$389 · displays"},
    %{value: "sku-04", label: "Wireless Mouse", price: 39, subtitle: "$39 · peripherals"},
    %{value: "sku-05", label: "Laptop Stand", price: 65, subtitle: "$65 · accessories"},
    %{value: "sku-06", label: "Noise-cancelling Headphones", price: 249, subtitle: "$249 · audio"},
    %{value: "sku-07", label: "Webcam 1080p", price: 89, subtitle: "$89 · peripherals"},
    %{value: "sku-08", label: "Standing Desk", price: 549, subtitle: "$549 · furniture"},
    %{value: "sku-09", label: "Desk Lamp", price: 45, subtitle: "$45 · accessories"},
    %{value: "sku-10", label: "Ultrawide Monitor", price: 699, subtitle: "$699 · displays"},
    %{value: "sku-11", label: "Ergonomic Chair", price: 899, subtitle: "$899 · furniture"},
    %{value: "sku-12", label: "Cable Organizer", price: 19, subtitle: "$19 · accessories"}
  ]

  def index(conn, params) do
    case authorize(conn) do
      :ok ->
        products = @products |> filter(params["q"]) |> Enum.map(&Map.delete(&1, :price))
        json(conn, products)

      :unauthorized ->
        conn |> put_status(:unauthorized) |> json(%{error: "unauthorized"})
    end
  end

  # Where a real app gates on the session-authenticated user. The cookie is already
  # available here (the :api pipeline ran :fetch_session), so this reads it directly —
  # exactly how a same-origin authed API works. The demo stays permissive by default;
  # set TESTAPP_REQUIRE_AUTH=1 to exercise the 401 path (no session user → unauthorized).
  defp authorize(conn) do
    if System.get_env("TESTAPP_REQUIRE_AUTH") && get_session(conn, :current_user) == nil,
      do: :unauthorized,
      else: :ok
  end

  # Minimal `q` grammar for the demo: `price>100` / `price>=100` / `price<50`.
  # Anything unrecognized (or missing) returns the full list.
  defp filter(list, nil), do: list

  defp filter(list, q) when is_binary(q) do
    case Regex.run(~r/^\s*price\s*(>=|<=|>|<)\s*(\d+)\s*$/, q) do
      [_, op, n] ->
        n = String.to_integer(n)
        Enum.filter(list, &compare(&1.price, op, n))

      _ ->
        list
    end
  end

  defp compare(price, ">", n), do: price > n
  defp compare(price, ">=", n), do: price >= n
  defp compare(price, "<", n), do: price < n
  defp compare(price, "<=", n), do: price <= n
end
