-- grug-far.nvim : chercher-remplacer dans tout le projet, avec un panneau
-- dédié, preview de tous les changements avant application, et filtres
-- (par type de fichier, glob, sensibilité à la casse, mot entier, regex).
-- S'appuie sur ripgrep (déjà installé pour Telescope).
--
-- Dans le panneau :
--   - Search   : le motif à chercher
--   - Replace  : le remplacement
--   - Files Filter / Flags : restreindre (ex: *.py, ou -w pour mot entier)
--   - <leader>r (dans le buffer) : appliquer tous les remplacements
--     (redéfini ci-dessous ; la valeur par défaut de grug-far est <localleader>r)
return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar" },
  keys = {
    {
      "<leader>sr",
      function() require("grug-far").open() end,
      mode = { "n" },
      desc = "Chercher-remplacer dans le projet (grug-far)",
    },
    {
      "<leader>sr",
      function() require("grug-far").open({ visualSelectionUsage = "operate-within-range" }) end,
      mode = { "x" },
      desc = "Chercher-remplacer dans la sélection (grug-far)",
    },
    {
      "<leader>sw",
      function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
      mode = { "n" },
      desc = "Remplacer le mot sous le curseur (grug-far)",
    },
  },
  opts = {
    -- Touche plus pratique pour appliquer tous les remplacements depuis le
    -- panneau (défaut grug-far : <localleader>r). On garde le reste par défaut.
    keymaps = {
      replace = { n = "<leader>r" },
    },
  },
}
