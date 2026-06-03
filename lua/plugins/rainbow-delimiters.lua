-- rainbow-delimiters.nvim : colore les paires de délimiteurs (parenthèses,
-- crochets, accolades) par niveau d'imbrication, via treesitter.
-- S'active automatiquement au chargement ; aucun setup() requis.
return {
  "hiphish/rainbow-delimiters.nvim",
  event = { "BufReadPre", "BufNewFile" },
}
