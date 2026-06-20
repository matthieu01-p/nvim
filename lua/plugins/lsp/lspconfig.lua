return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Va permettre de remplir le plugin de complétion automatique nvim-cmp
    -- avec les résultats des LSP
    "hrsh7th/cmp-nvim-lsp",
    -- Ajoute les « code actions » de type renommage de fichiers intelligent, etc
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- Utile pour éditer les fichiers lua spécifiques à la config neovim
    -- Notamment pour éviter le "Undefined global `vim`"
    { "folke/lazydev.nvim", opts = {} },
  },
  keys = {
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    { "gR", "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references", mode = "n" },
    { "gD", vim.lsp.buf.declaration, desc = "Go to declaration", mode = "n" },
    { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions", mode = "n" },
    {
      "<leader>gd",
      function()
        vim.cmd("split")
        vim.lsp.buf.definition()
      end,
      desc = "Définition dans split horizontal",
      mode = "n",
    },
    {
      "<leader>gD",
      function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
      end,
      desc = "Définition dans split vertical",
      mode = "n",
    },
    {
      "<leader>gR",
      function()
        local params = vim.lsp.util.make_position_params(0, "utf-8")
        params.context = { includeDeclaration = true }
        vim.lsp.buf_request(0, "textDocument/references", params, function(err, result)
          if err or not result or vim.tbl_isempty(result) then
            vim.notify("Aucune référence trouvée", vim.log.levels.INFO)
            return
          end
          vim.cmd("vsplit")
          vim.cmd("Telescope lsp_references")
        end)
      end,
      desc = "Références dans split vertical",
      mode = "n",
    },
    { "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "Show LSP implementations", mode = "n" },
    { "gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions", mode = "n" },
    { "gs", vim.lsp.buf.signature_help, desc = "Show LSP signature help", mode = "n" },
    { "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename", mode = "n" },
    { "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics", mode = "n" },
    { "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics", mode = "n" },
    {
      "<leader>Nd",
      function()
        vim.diagnostic.jump({ count = -1, float = true })
      end,
      desc = "Diagnostic précédent",
      mode = { "n", "x" },
    },
    {
      "<leader>nd",
      function()
        vim.diagnostic.jump({ count = 1, float = true })
      end,
      desc = "Diagnostic suivant",
      mode = { "n", "x" },
    },
    { "K", vim.lsp.buf.hover, desc = "Show documentation for what is under cursor", mode = "n" },
    { "<leader>F", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", desc = "Format buffer", mode = { "n", "x" } },
    -- Neovim 0.12+ : commande native (nvim-lspconfig n'enregistre plus :LspRestart)
    { "<leader>rs", "<cmd>lsp restart<CR>", desc = "Restart LSP", mode = "n" },
  },
  config = function()
    -- Capabilities enrichies par cmp-nvim-lsp (snippets serveur, auto-imports
    -- via additionalTextEdits, résolution de la doc des items, etc.).
    -- Appliquées à TOUS les serveurs via la config générique "*".
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- Customize error signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "󰌵",
        },
      },
      virtual_text = {
        prefix = "●",
        spacing = 2,
        source = "if_many",
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "if_many",
      },
    })
    -- Python : pyright pour le type checking + navigation,
    -- ruff pour le linting, le formatage et le tri des imports.
    vim.lsp.config("pyright", {
      settings = {
        pyright = {
          -- On laisse ruff gérer le tri des imports (organize imports)
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            typeCheckingMode = "basic", -- "off" | "basic" | "strict"
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    })

    -- pylsp : utilisé UNIQUEMENT pour les refactors Rope (inline variable,
    -- extract method, etc.) exposés en code actions sur <leader>ca.
    -- Tout le reste (completion, hover, definition, lint, format) est
    -- désactivé pour ne pas faire doublon avec pyright + ruff.
    -- Requiert l'installation du plugin pylsp-rope dans le venv Mason :
    --   ~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/pip install pylsp-rope
    vim.lsp.config("pylsp", {
      settings = {
        pylsp = {
          plugins = {
            -- Linters/formatters : off (ruff s'en charge)
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
            pylint = { enabled = false },
            mccabe = { enabled = false },
            flake8 = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            black = { enabled = false },
            -- Jedi : off (pyright s'en charge)
            jedi_completion = { enabled = false },
            jedi_definition = { enabled = false },
            jedi_hover = { enabled = false },
            jedi_references = { enabled = false },
            jedi_signature_help = { enabled = false },
            jedi_symbols = { enabled = false },
            rope_completion = { enabled = false },
            rope_autoimport = { enabled = false },
            -- Le seul qu'on garde : les code actions de refactoring Rope
            pylsp_rope = { enabled = true },
          },
        },
      },
      on_attach = function(client, _)
        -- Ceinture + bretelles : on coupe aussi côté client les capacités
        -- qui pourraient encore polluer pyright (hover, goto, etc.)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.documentSymbolProvider = false
        client.server_capabilities.completionProvider = nil
        client.server_capabilities.signatureHelpProvider = nil
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    vim.lsp.config("ruff", {
      init_options = {
        settings = {
          -- on ajoute le tri des imports (règles "I")
          args = { "--extend-select", "I" },
        },
      },
      on_attach = function(client, _)
        -- Désactive le hover de ruff pour laisser pyright fournir la doc
        client.server_capabilities.hoverProvider = false
      end,
    })

    -- Rust
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
          },
          inlayHints = {
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
          diagnostics = {
            enable = true,
            styleLints = {
              enable = true,
            },
          },
        },
      },
    })
  end,
}
