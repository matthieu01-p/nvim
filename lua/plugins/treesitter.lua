-- Configuration pour la branche `main` de nvim-treesitter (Neovim 0.12+).
-- Doc officielle : https://github.com/nvim-treesitter/nvim-treesitter
--
-- Pré-requis système :
--   - tree-sitter CLI >= 0.26.1 (installé dans ~/.local/bin)
--   - gcc (compile chaque parser)
--
-- L'API a totalement changé par rapport à master : plus de .configs.setup{},
-- on déclare l'install_dir, on installe les parsers, on active la coloration
-- via une autocmd FileType.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,        -- la doc précise que ce plugin ne supporte pas le lazy-loading
  build = ":TSUpdate", -- met à jour les parsers lors d'un :Lazy update
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Détection de filetype Jinja. Neovim reconnaît déjà `.jinja` comme `jinja`,
    -- mais pas `.j2` / `.jinja2` : on les mappe sur le même filetype pour
    -- bénéficier du parser treesitter `jinja` ci-dessous.
    vim.filetype.add({
      extension = {
        j2 = "jinja",
        jinja2 = "jinja",
      },
    })

    -- Parsers à installer / maintenir
    local parsers = {
      "bash",
      "dockerfile",
      "gitignore",
      "html",
      "javascript",
      "jinja",
      "jinja_inline",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rst",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    -- Installation asynchrone des parsers manquants au démarrage
    require("nvim-treesitter").install(parsers)

    -- Active la coloration treesitter + l'indentation pour ces filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function(args)
        -- Coloration syntaxique
        pcall(vim.treesitter.start, args.buf)
        -- Folding sémantique : treesitter découpe fonctions, classes, boucles,
        -- conditions, etc. (foldlevelstart global = 99 → tout déplié à
        -- l'ouverture, voir core/options.lua). On plie/déplie à la demande
        -- avec za/zc/zo/zR/zM.
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- Indentation treesitter (branche main) DÉSACTIVÉE : expérimentale et
        -- buggée, elle décale l'indentation d'un espace à chaque retour à la
        -- ligne. On retombe sur l'indentation native (autoindent + indent
        -- plugins du filetype), qui copie proprement la ligne précédente.
        -- vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
