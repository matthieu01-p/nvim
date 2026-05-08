return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      -- On affiche TOUT : dotfiles, gitignored, untracked, sans filtre.
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
      view = {
        width = 30, -- largeur fixe
        cursorline = true,
      },
      renderer = {
        -- Quand un nom de fichier est tronqué (plus long que la largeur),
        -- affiche le nom complet dans une popup flottante au survol.
        full_name = true,
        highlight_opened_files = "name", -- met en gras les fichiers ouverts
      },
    })

    -- Couleur flashy pour la ligne sélectionnée dans nvim-tree.
    -- Réappliquée à chaque changement de colorscheme pour ne pas être
    -- écrasée par le thème.
    local function set_tree_cursorline()
      vim.api.nvim_set_hl(0, "NvimTreeCursorLine", {
        bg = "#7aa2f7", -- bleu vif (palette tokyonight)
        fg = "#1a1b26", -- texte sombre pour contraster
        bold = true,
      })
    end
    set_tree_cursorline()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_tree_cursorline,
    })

    -- Le surlignage flashy n'apparaît que quand nvim-tree a le focus.
    -- Quand on quitte le tree (Enter sur un fichier, <C-l>, etc.),
    -- on désactive le cursorline pour ne pas garder une ligne en
    -- surbrillance dans un panneau qui n'a plus le focus.
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "NvimTree" then
          vim.wo.cursorline = true
        end
      end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "NvimTree" then
          vim.wo.cursorline = false
        end
      end,
    })

    -- On utilise <leader>e pour ouvrir/fermer l'explorateur
    vim.keymap.set(
      "n",
      "<leader>e",
      "<cmd>NvimTreeFindFileToggle<CR>",
      { desc = "Ouverture/fermeture de l'explorateur de fichiers" }
    )
  end,
}

