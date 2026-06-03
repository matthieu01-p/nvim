-- nvim-spider : w / e / b s'arrêtent sur les SOUS-MOTS d'un identifiant.
-- Sur `total_rows_processed` ou `getUserName`, on navigue dans le nom au lieu
-- de le sauter d'un bloc. Marche en normal, visuel ET opérateur (dw, ce, ...).
return {
  "chrisgrieser/nvim-spider",
  keys = {
    { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w (sous-mot)" },
    { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e (sous-mot)" },
    { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b (sous-mot)" },
  },
  opts = {},
}
