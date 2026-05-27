-- vim-flog : graph git interactif, façon `git log --graph` mais navigable.
-- Dépend de vim-fugitive (déjà installé) pour les actions sur les commits.
return {
  "rbong/vim-flog",
  dependencies = { "tpope/vim-fugitive" },
  cmd = { "Flog", "Flogsplit", "Floggit" },
  keys = {
    { "<leader>gL", "<cmd>Flog<cr>",                          desc = "Git graph (toutes branches)" },
    { "<leader>gF", "<cmd>Flogsplit -path=%<cr>",             desc = "Git graph (fichier courant)" },
  },
  init = function()
    vim.g.flog_default_opts = {
      max_count = 2000,
      all = true,
    }
  end,
}
