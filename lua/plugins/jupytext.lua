-- Ouvre/sauve les .ipynb comme un fichier "percent" (cellules `# %%`),
-- au lieu du JSON brut. Le buffer prend le filetype du langage du notebook
-- (python -> pyright/ruff/cmp marchent normalement).
-- NB : le plugin appelle le binaire `jupytext` EN DUR depuis le PATH (aucune
-- option de chemin). bootstrap.sh crée un symlink ~/.local/bin/jupytext -> venv hôte.
return {
  "GCBallesteros/jupytext.nvim",
  lazy = false, -- doit intercepter l'ouverture du .ipynb dès le départ
  opts = {
    style = "percent",
    output_extension = "auto",
    force_ft = nil,
  },
}
