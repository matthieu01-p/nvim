return {
  "nvim-telescope/telescope.nvim",
  -- On utilise `master` (et non la branche 0.1.x conseillée par le README) :
  -- 0.1.x n'est plus maintenue depuis longtemps, et le bug d'incompatibilité
  -- avec la nouvelle API de nvim-treesitter (branche `main`, qui a supprimé
  -- `parsers.ft_to_lang`) n'est corrigé que sur master.
  -- Référence : https://github.com/nvim-telescope/telescope.nvim/issues/3487
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- fzf implémentation en C pour plus de rapidité
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    -- live_grep avec arguments rg (mot exact, sensible casse, types, etc.)
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {

        -- Parce que c'est joli
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },

        -- Args ripgrep utilisés par live_grep, grep_string, etc.
        -- --smart-case : insensible si query tout en minuscules,
        -- sensible si une majuscule apparaît (donc "Candidate" ne
        -- matche que Candidate, pas candidate ou Candidates).
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set(
      "n",
      "<leader>ff",
      "<cmd>Telescope find_files<cr>",
      { desc = "Recherche de chaînes de caractères dans les noms de fichiers" }
    )
    -- Live grep classique : preview surlignée, smart-case (Candidate avec
    -- C majuscule est traité case-sensitive, candidate est insensible).
    keymap.set(
      "n",
      "<leader>fg",
      "<cmd>Telescope live_grep<cr>",
      { desc = "Live grep (smart-case, preview surlignée)" }
    )
    -- Live grep avec args ripgrep : utiliser "pattern" -ws pour flags.
    -- Preview surlignage moins propre mais permet flags arbitraires.
    keymap.set(
      "n",
      "<leader>fG",
      function() require("telescope").extensions.live_grep_args.live_grep_args() end,
      { desc = "Live grep avec args rg (\"pattern\" -ws -t py ...)" }
    )
    keymap.set(
      "n",
      "<leader>fb",
      "<cmd>Telescope buffers<cr>",
      { desc = "Recherche de chaînes de caractères dans les noms de buffers" }
    )
    keymap.set(
      "n",
      "<leader>fx",
      "<cmd>Telescope grep_string<cr>",
      { desc = "Recherche de la chaîne de caractères sous le curseur" }
    )
  end,
}

