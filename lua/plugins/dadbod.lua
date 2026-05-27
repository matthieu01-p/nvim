-- vim-dadbod + dadbod-ui : interface SQL avec sidebar, requêtes sauvegardées,
-- historique. Supporte DuckDB (via le binaire `duckdb` installé sur le système).
--
-- Workflow type :
--   <leader>du   → toggle l'UI (sidebar à gauche)
--   Dans la sidebar : Saved queries, History, Connections
--   Ouvrir une connexion → un buffer .sql s'ouvre, tu écris ton SQL
--   <leader>S    → exécute la query courante (mapping dadbod-ui)
--   :DBUIRenameBuffer → renomme la query (et la sauvegarde)
return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
    },
    init = function()
      -- Stockage des requêtes sauvegardées (versionnable avec git si tu veux)
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui_queries"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      -- Auto-exécution du SQL au :w sur les buffers de query temporaires
      vim.g.db_ui_execute_on_save = 0

      -- Connexions par défaut : DuckDB in-memory.
      -- Tu peux en ajouter d'autres (sqlite, postgres, etc.) via :DBUIAddConnection.
      vim.g.dbs = {
        duckdb_mem = "duckdb::memory:",
      }
    end,
    keys = {
      { "<leader>du", "<cmd>DBUIToggle<cr>",         desc = "Toggle DBUI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>",     desc = "DBUI : trouver buffer query" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>",   desc = "DBUI : renommer la query" },
    },
  },
}
