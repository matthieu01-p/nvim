-- Écran d'accueil (nvim lancé sans fichier). Thème "startify" : liste
-- automatiquement les fichiers récents (MRU) + quelques raccourcis.
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local startify = require("alpha.themes.startify")
    startify.section.top_buttons.val = {
      startify.button("f", "  Chercher un fichier", "<cmd>Telescope find_files<CR>"),
      startify.button("e", "  Nouveau fichier", "<cmd>ene<CR>"),
      startify.button("c", "  Config nvim", "<cmd>cd ~/.config/nvim | Telescope find_files<CR>"),
      startify.button("q", "  Quitter", "<cmd>qa<CR>"),
    }
    require("alpha").setup(startify.config)
  end,
}
