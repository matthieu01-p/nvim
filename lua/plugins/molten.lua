-- Exécution de cellules dans un kernel Jupyter, sorties affichées dans le buffer.
-- Sorties texte -> virtual text (marche dans tmux). Plots/images -> via image.nvim
-- (fiable seulement hors tmux, cf. lua/plugins/image.lua).
--
-- Workflow .ipynb :
--   1. ouvrir le .ipynb (jupytext.nvim le montre en cellules `# %%`)
--   2. <leader>ji  -> choisir le kernel (ex. le venv du projet, voir README repo)
--   3. <leader>je + mouvement / <leader>jl / <leader>jc  -> évaluer
--
-- Pré-requis kernel : dans le venv du projet -> `pip install ipykernel` puis
--   `python -m ipykernel install --user --name <nom>` pour qu'il apparaisse.
return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  dependencies = { "3rd/image.nvim" },
  init = function()
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false   -- requis pour un rendu image.nvim correct
    vim.g.molten_virt_text_output = true     -- sorties en virtual text (visible dans tmux)
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_wrap_output = true
  end,
  keys = {
    { "<leader>ji", ":MoltenInit<CR>", desc = "Molten: init kernel" },
    { "<leader>je", ":MoltenEvaluateOperator<CR>", desc = "Molten: évaluer (opérateur)" },
    { "<leader>jl", ":MoltenEvaluateLine<CR>", desc = "Molten: évaluer la ligne" },
    { "<leader>jc", ":MoltenReevaluateCell<CR>", desc = "Molten: réévaluer la cellule" },
    { "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Molten: évaluer la sélection" },
    { "<leader>jo", ":MoltenShowOutput<CR>", desc = "Molten: voir la sortie" },
    { "<leader>jh", ":MoltenHideOutput<CR>", desc = "Molten: cacher la sortie" },
    { "<leader>jd", ":MoltenDelete<CR>", desc = "Molten: supprimer la cellule" },
    { "<leader>jr", ":MoltenRestart!<CR>", desc = "Molten: redémarrer le kernel" },
  },
}
