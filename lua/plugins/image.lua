-- Rendu d'images inline (utilisé par molten pour afficher les plots).
-- Backend "kitty" (ghostty l'implémente). Processeur "magick_cli" : utilise le
-- binaire ImageMagick directement -> pas besoin du rock luarocks `magick`.
-- ATTENTION : à l'intérieur de tmux, le protocole graphique Kitty passe mal.
-- Les sorties TEXTE de molten marchent dans tmux ; les IMAGES/plots ne
-- s'affichent de façon fiable qu'en lançant nvim directement dans ghostty
-- (hors tmux). Voir `:checkhealth image`.
return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
      markdown = { enabled = false },
      neorg = { enabled = false },
    },
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
}
