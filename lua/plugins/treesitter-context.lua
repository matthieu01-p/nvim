-- nvim-treesitter-context : épingle l'en-tête de la fonction/classe/bloc
-- courant en haut de la fenêtre quand on scrolle dedans.
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    enable = true,
    max_lines = 4,        -- max de lignes de contexte épinglées (0 = illimité)
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 1, -- combien de lignes max d'une signature multi-lignes
    trim_scope = "outer",    -- si trop de contextes : "outer" coupe les plus larges, "inner" les plus proches
    mode = "cursor",         -- "cursor" : contexte de la position du curseur ; "topline" : du haut de la fenêtre
    separator = nil,         -- caractère de séparation entre contexte et code (ex: "─")
    zindex = 20,
  },
  keys = {
    {
      "<leader>tc",
      function() require("treesitter-context").toggle() end,
      desc = "Toggle contexte treesitter (sticky header)",
    },
    {
      "[x",
      function() require("treesitter-context").go_to_context(vim.v.count1) end,
      desc = "Sauter au contexte parent",
    },
  },
}