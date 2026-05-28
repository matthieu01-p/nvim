return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },

  config = function()
    local noice = require("noice")

    noice.setup({
      -- Désactive les popups de notifications en haut à droite.
      -- Les messages restent accessibles via :messages.
      notify = {
        enabled = false,
      },
      -- Désactive le routage des messages Vim (et messages LSP en echomsg)
      -- vers la mini-popup flottante en haut à droite. Les messages reviennent
      -- en bas dans la zone cmdline d'origine.
      messages = {
        enabled = false,
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        -- Désactivé : redirigeait la sortie de :! et autres messages
        -- longs dans un split éphémère qui disparaissait avant qu'on
        -- ait le temps de lire. Les messages reviennent en bas comme avant.
        -- Pour voir les anciens : :messages. Pour lancer un shell, :terminal.
        long_message_to_split = false,
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    })

    -- Renvoie vim.notify dans la zone des messages plutôt que dans un popup
    -- flottant. nvim-notify est chargé par noice et écrase vim.notify ; on le
    -- restaure après coup. Les notifications restent consultables via :messages.
    vim.notify = function(msg, level, _)
      local hl = "Normal"
      if level == vim.log.levels.ERROR then
        hl = "ErrorMsg"
      elseif level == vim.log.levels.WARN then
        hl = "WarningMsg"
      end
      vim.api.nvim_echo({ { tostring(msg), hl } }, true, {})
    end
  end,
}
