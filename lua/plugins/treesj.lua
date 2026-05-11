-- treesj : split/join intelligent basé sur treesitter.
-- Place le curseur dans une expression compactée et appelle :TSJToggle pour
-- la passer en multi-lignes (ou inverse). Marche sur les listes, dicts,
-- arguments de fonction, accolades, etc., en Python/JS/TS/Lua/Rust/etc.
return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
  keys = {
    { "<leader>ts", "<cmd>TSJSplit<cr>",  desc = "Split (un élément par ligne)" },
    { "<leader>tj", "<cmd>TSJJoin<cr>",   desc = "Join (tout sur une ligne)" },
    { "<leader>tt", "<cmd>TSJToggle<cr>", desc = "Toggle split/join (auto)" },
  },
  opts = {
    use_default_keymaps = false, -- on définit les nôtres ci-dessus
    max_join_length = 200,       -- longueur max d'une ligne après join
  },
}
