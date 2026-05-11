return {
  "stevearc/conform.nvim",
  opts = {},
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        css = { "prettier" },
        elm = { "elm_format" },
        graphql = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        -- ruff_fix corrige les erreurs de lint (imports inutilisés, etc.) au save.
        -- ruff_format est désactivé : il reformatait la présentation (longueur
        -- de ligne, retours) ce qui était gênant. Pour formater à la main,
        -- utiliser <leader>mp ou <leader>F.
        python = { "ruff_fix" },
        rust = { "rustfmt" },
        svelte = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
