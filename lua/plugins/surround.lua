return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "folke/which-key.nvim" },
  config = function()
    require("nvim-surround").setup({})

    -- Descriptions affichées dans which-key
    local wk = require("which-key")
    wk.add({
      -- mode normal
      { "ys",  desc = "Entourer (you surround)",                      mode = "n" },
      { "yss", desc = "Entourer la ligne entière",                    mode = "n" },
      { "ds",  desc = "Supprimer l'entourage",                        mode = "n" },
      { "cs",  desc = "Changer l'entourage",                          mode = "n" },
      -- mode visuel
      { "S",   desc = "Entourer la sélection",                        mode = "x" },
      { "gS",  desc = "Entourer la sélection (sur nouvelles lignes)", mode = "x" },
    })
  end,
}
