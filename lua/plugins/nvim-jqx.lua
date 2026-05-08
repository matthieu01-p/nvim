-- nvim-jqx : explorer interactif pour les fichiers JSON / JSONL via jq.
-- Pré-requis système : le binaire `jq` (sudo apt install jq).
--
-- Usage :
--   :JqxList   → panneau navigable avec tous les keys du JSON
--   :JqxQuery  → te demande un filtre jq et l'applique
return {
  "gennaro-tedesco/nvim-jqx",
  ft = { "json", "jsonl", "yaml" },
  cmd = { "JqxList", "JqxQuery" },
  -- Pour les .jsonl : on définit un filetype dédié `jsonl` (au lieu de
  -- `json`) pour que le LSP jsonls ne s'attache PAS — il essaierait de
  -- valider le fichier comme un seul document JSON et émettrait
  -- "End of file expected" après le premier objet. On démarre quand
  -- même le parser treesitter `json` à la main pour avoir la coloration.
  init = function()
    vim.filetype.add({ extension = { jsonl = "jsonl" } })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "jsonl",
      callback = function(args)
        pcall(vim.treesitter.start, args.buf, "json")
      end,
    })
  end,
  keys = {
    { "<leader>jl", "<cmd>JqxList<cr>",  desc = "JSON : explorer les clés (jqx)" },
    { "<leader>jq", "<cmd>JqxQuery<cr>", desc = "JSON : filtre jq interactif (jqx)" },
  },
}
