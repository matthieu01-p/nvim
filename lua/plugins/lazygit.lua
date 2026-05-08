-- lazygit.nvim : ouvre lazygit dans une fenêtre flottante nvim.
-- Pré-requis système : le binaire `lazygit` (sudo apt install lazygit).
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>",            desc = "LazyGit (UI complète)" },
    { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (fichier courant)" },
    { "<leader>gl", "<cmd>LazyGitFilter<cr>",      desc = "LazyGit log du repo" },
  },
}
