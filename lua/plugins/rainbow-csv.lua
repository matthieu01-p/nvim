-- rainbow_csv : colore les colonnes d'un CSV/TSV et expose RBQL,
-- un SQL embarqué pour filtrer / trier / agréger.
-- Exemples :
--   :Select * where a3 > 100 order by a3 desc
--   :Select a1, count(*) group by a1
return {
  "cameron-wags/rainbow_csv.nvim",
  ft = { "csv", "tsv", "csv_semicolon", "csv_pipe", "rfc_csv", "rfc_semicolon" },
  config = true,
}
