-- vim-fugitive : intégration git native dans nvim.
-- Toutes les commandes git via :Git <cmd>, plus UI dédiées pour status/commit/blame.
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>",          desc = "Git status (fugitive)" },
    { "<leader>gc", "<cmd>Git commit<cr>",   desc = "Git commit" },
    { "<leader>gp", "<cmd>Git push<cr>",     desc = "Git push" },
    { "<leader>gP", "<cmd>Git pull<cr>",     desc = "Git pull" },
    { "<leader>gB", "<cmd>Git blame<cr>",    desc = "Git blame (fichier complet)" },
  },
}
