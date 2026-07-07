defmodule TestApp.Isco08 do
  @moduledoc """
  Full **ISCO-08** occupation classification, shaped for the tree-mode multiselect.

  619 groups across four levels — 10 major (1-digit) → 43 sub-major (2-digit) →
  130 minor (3-digit) → 436 unit (4-digit) — loaded from `priv/data/isco08.tsv`
  at compile time and turned into option maps carrying a materialized dot-`path`,
  a breadcrumb `full_title`, and a leaves-only `selectable` flag.

  The ISCO code IS the hierarchy: a 4-digit unit group's ancestors are just its
  1/2/3-character prefixes, so `path` for `"2211"` is `"2.22.221.2211"` and its
  `full_title` is `"Professionals / Health Professionals / Medical Doctors /
  Generalist Medical Practitioners"`. Unit groups (4-digit) are the leaves and the
  only selectable rows — pick an occupation, not a category.

  Source: *International Standard Classification of Occupations, ISCO-08*
  (© International Labour Organization). Used here as demo data only.
  """

  @external_resource tsv_path = Path.join([__DIR__, "..", "..", "priv", "data", "isco08.tsv"])

  # {code, title} in source (depth-first) order.
  rows =
    tsv_path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [code, title] = String.split(line, "\t", parts: 2)
      {code, title}
    end)

  title_by_code = Map.new(rows, fn {code, title} -> {code, title} end)

  # A code is a branch when it is the (length-1) prefix of some other code.
  parent_codes =
    for {code, _} <- rows, String.length(code) > 1, into: MapSet.new() do
      String.slice(code, 0, String.length(code) - 1)
    end

  @occupations Enum.map(rows, fn {code, title} ->
                 ancestors = for len <- 1..String.length(code), do: String.slice(code, 0, len)

                 %{
                   value: code,
                   label: title,
                   path: Enum.join(ancestors, "."),
                   full_title: ancestors |> Enum.map(&Map.fetch!(title_by_code, &1)) |> Enum.join(" / "),
                   selectable: not MapSet.member?(parent_codes, code)
                 }
               end)

  @doc "All 619 ISCO-08 groups as tree-ready option maps (depth-first order)."
  def all, do: @occupations

  @doc "Count of groups (619)."
  def count, do: length(@occupations)
end
