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
    { "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP", mode = "n" },
  },
  config = function()
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
