-- coder/claudecode.nvim : intégration native de Claude Code via WebSocket/MCP.
-- Permet d'envoyer la sélection visuelle, d'ajouter des fichiers au contexte,
-- et de reviewer les diffs proposés par Claude directement dans Neovim.
--
-- Pré-requis : la CLI `claude` (https://docs.anthropic.com/claude/docs/claude-code).
--   Installation : npm install -g @anthropic-ai/claude-code
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    auto_start = true,
    track_selection = true,
    terminal = {
      split_side = "right",          -- panneau Claude à droite
      split_width_percentage = 0.35, -- 35 % de la largeur
      auto_close = true,
    },
    diff_opts = {
      layout = "horizontal",   -- diffs en split horizontal (l'un au dessus de l'autre)
      open_in_new_tab = false, -- dans la fenêtre courante
    },
  },
  keys = {
    -- Préfixe pour which-key
    { "<leader>a", nil, desc = "AI / Claude Code" },

    -- Session
    { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume une conversation" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue la dernière conversation" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Choisir le modèle Claude" },

    -- Contexte
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",  desc = "Ajouter le buffer courant au contexte" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",   desc = "Envoyer la sélection à Claude",         mode = "v" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Ajouter le fichier au contexte (depuis l'arborescence)",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },

    -- Review des diffs proposés par Claude
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accepter le diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Refuser le diff" },
  },
}
