return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- import de mason
    local mason = require("mason")
    -- import de mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    -- Active mason et personnalise les icônes
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    mason_lspconfig.setup({
      automatic_enable = true,
      -- Liste des serveurs à installer par défaut
      -- List des serveurs possibles : https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      ensure_installed = {
        "lua_ls",      -- Lua (pour la config Neovim)
        "pyright",     -- Python (type checker + navigation)
        "ruff",        -- Linter/formatter Python
        "pylsp",       -- Python (uniquement pour les refactors Rope : inline variable, extract, etc.)
        "jsonls",      -- JSON
        "yamlls",      -- YAML
        "marksman",    -- Markdown
      },
    })
  end,
}
