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
        -- Colore le NOM du fichier selon son état git (vert stagé, rouge
        -- modifié, etc.) en plus du symbole.
        highlight_git = "name",
        icons = {
          git_placement = "after", -- symbole git APRÈS le nom (sinon "before"/"signcolumn"/"right_align")
          show = {
            git = true, -- afficher les symboles git (mettre false pour les masquer)
          },
          glyphs = {
            -- Codes lettres à la lazygit (au lieu d'icônes). La couleur
            -- (rouge=unstaged, vert=staged, etc.) vient de highlight_git.
            git = {
              untracked = "??", -- nouveau fichier (non suivi)
              unstaged = "M", -- modifié, pas encore `git add`
              staged = "A", -- stagé (`git add` fait)
              renamed = "R", -- renommé
              deleted = "D", -- supprimé
              unmerged = "U", -- conflit de merge
              ignored = "!!", -- ignoré (gitignore)
            },
          },
        },
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

    -- Couleurs des marqueurs git (lettre + nom du fichier). Palette distincte
    -- et sans bleu, pour ne pas se fondre dans le texte bleu clair de base.
    -- On colore les 3 groupes par état : *Icon (la lettre), GitFile*HL (le nom
    -- de fichier), GitFolder*HL (les dossiers). Réappliqué sur ColorScheme.
    local function set_tree_git_colors()
      local colors = {
        New = "#9ece6a", -- nouveau / untracked  (??)  → vert
        Dirty = "#ff9e64", -- modifié / unstaged   (M)   → orange
        Staged = "#73daca", -- stagé                (A)   → vert d'eau
        Renamed = "#bb9af7", -- renommé              (R)   → violet
        Deleted = "#f7768e", -- supprimé             (D)   → rouge
        Merge = "#ff007c", -- conflit / unmerged   (U)   → magenta
        Ignored = "#565f89", -- ignoré               (!!)  → gris
      }
      for name, fg in pairs(colors) do
        vim.api.nvim_set_hl(0, "NvimTreeGit" .. name .. "Icon", { fg = fg })
        vim.api.nvim_set_hl(0, "NvimTreeGitFile" .. name .. "HL", { fg = fg })
        vim.api.nvim_set_hl(0, "NvimTreeGitFolder" .. name .. "HL", { fg = fg })
      end
    end
    set_tree_git_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_tree_git_colors,
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

