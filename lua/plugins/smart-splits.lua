-- smart-splits : navigation, redimensionnement et échange de fenêtres,
-- avec intégration tmux transparente (les <C-h/j/k/l> traversent la frontière
-- nvim <-> tmux sans qu'on ait à y penser).
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- Navigation entre fenêtres (remplace <C-w>h/j/k/l, tmux-aware)
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Fenêtre de gauche" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Fenêtre du bas" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Fenêtre du haut" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Fenêtre de droite" },

    -- Redimensionnement avec Ctrl + flèches
    { "<C-Left>", function() require("smart-splits").resize_left() end, desc = "Réduire la largeur" },
    { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Agrandir la largeur" },
    { "<C-Down>", function() require("smart-splits").resize_down() end, desc = "Réduire la hauteur" },
    { "<C-Up>", function() require("smart-splits").resize_up() end, desc = "Agrandir la hauteur" },

    -- Échange de buffers entre fenêtres (HJKL majuscules sous <leader>w)
    { "<leader>wH", function() require("smart-splits").swap_buf_left() end, desc = "Échanger avec la fenêtre de gauche" },
    { "<leader>wJ", function() require("smart-splits").swap_buf_down() end, desc = "Échanger avec la fenêtre du bas" },
    { "<leader>wK", function() require("smart-splits").swap_buf_up() end, desc = "Échanger avec la fenêtre du haut" },
    { "<leader>wL", function() require("smart-splits").swap_buf_right() end, desc = "Échanger avec la fenêtre de droite" },
  },
  opts = {
    -- Au bord d'un split, continue dans tmux au lieu de boucler.
    at_edge = "wrap",
    -- Détection auto de tmux (déjà présent : /usr/bin/tmux).
    multiplexer_integration = "tmux",
  },
}
