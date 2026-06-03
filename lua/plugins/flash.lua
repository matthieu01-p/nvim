-- flash.nvim : navigation par « désignation ». Tape `s` puis les premières
-- lettres de ta cible : flash étiquette toutes les occurrences visibles à
-- l'écran, et l'étiquette te téléporte dessus. Améliore aussi f/t/F/T par
-- défaut (étiquettes sur les cibles multiples au lieu de marteler `;`).
--
-- NB : `s` natif (« substituer un caractère ») est remplacé par flash. Son
-- équivalent reste `cl`.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
  },
}
