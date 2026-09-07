defmodule TestAppWeb.RedirectController do
  @moduledoc """
  Permanent redirects from the pre-rc10 example URLs to their renamed targets.

  Upstream `@keenmate/web-multiselect` renamed several example pages in `2.0.0-rc10`
  (classic → basic + data-api, performance → virtual-scrolling, search-index →
  external-search, templating → custom-rendering). The demo site mirrors that, and
  these keep old bookmarks working.
  """
  use TestAppWeb, :controller

  def basic(conn, _params), do: moved(conn, "/examples/basic")
  def data_api(conn, _params), do: moved(conn, "/examples/data-api")
  def external_search(conn, _params), do: moved(conn, "/examples/external-search")
  def virtual_scrolling(conn, _params), do: moved(conn, "/examples/virtual-scrolling")
  def custom_rendering(conn, _params), do: moved(conn, "/examples/custom-rendering")

  defp moved(conn, to) do
    conn
    |> put_status(:moved_permanently)
    |> redirect(to: to)
  end
end
