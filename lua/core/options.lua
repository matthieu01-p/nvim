local opt = vim.opt -- raccourci pour un peu plus de concision

-- Mouse enable/disable
opt.mouse = ""

-- Kitty keyboard protocol : sous kitty, Neovim 0.12 active automatiquement
-- l'encodage "CSI u" (en envoyant `CSI > 1 u` au démarrage, cf. :help tui-csiu).
-- Effet de bord : dans nvim-tree/netrw, Entrée sur un dossier le déplie PUIS
-- le replie aussitôt (double déclenchement). On dépile le mode poussé par
-- Neovim pour revenir à l'encodage clavier classique.
-- Ça n'affecte pas Ctrl+Tab : c'est kitty qui l'intercepte côté terminal.
if vim.env.TERM == "xterm-kitty" or vim.env.KITTY_WINDOW_ID then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- différé pour passer APRÈS la séquence d'activation de Neovim
      vim.schedule(function()
        io.write("\27[<u") -- CSI < u : pop des flags du kitty keyboard protocol
        io.flush()
      end)
    end,
  })
end

-- numéros de ligne
opt.relativenumber = true -- affichage des numéros de ligne relatives à la position actuelle du curseur
opt.number = true -- affiche le numéro absolu de la ligne active lorsque que relativenumber est activé

-- tabs & indentation
opt.tabstop = 2 -- 2 espaces pour les tabulations
opt.shiftwidth = 2 -- 2 espaces pour la taille des indentations
opt.expandtab = true -- change les tabulations en espaces (don't feed the troll please ;) )
opt.autoindent = true -- on garde l'indentation actuelle à la prochaine ligne

-- recherche
opt.ignorecase = true -- ignore la casse quand on recherche
opt.smartcase = true -- sauf quand on fait une recherche avec des majuscules, on rebascule en sensible à la casse
opt.hlsearch = true -- surlignage de toutes les occurences de la recherche en cours

-- ligne du curseur
opt.cursorline = true -- surlignage de la ligne active

-- apparence

-- termguicolors est nécessaire pour que les thèmes modernes fonctionnent
opt.termguicolors = true
opt.background = "dark" -- cohérent avec le thème tokyonight-storm chargé (sombre)
opt.signcolumn = "yes" -- affiche une colonne en plus à gauche pour afficher les signes (évite de décaler le texte)

-- retour
opt.backspace = "indent,eol,start" -- on autorise l'utilisation de retour quand on indente, à la fin de ligne ou au début

-- presse papier
opt.clipboard = "unnamedplus" -- on utilise le presse papier du système par défaut

-- split des fenêtres
opt.splitright = true -- le split vertical d'une fenêtre s'affiche à droite
opt.splitbelow = true -- le split horizontal d'une fenêtre s'affiche en bas

-- pas de retour à la ligne automatique : on scrolle horizontalement à la place.
-- Indispensable pour les diffs (sinon les deux côtés se décalent visuellement)
-- et plus lisible pour du code en split étroit.
opt.wrap = false

-- Recharge automatiquement le fichier si modifié sur le disque par un outil
-- externe (formatter, claude code, git checkout, etc.). Évite le warning
-- W12 'file has changed since reading it' quand on accepte un diff Claude.
opt.autoread = true

opt.swapfile = false -- on supprime le pénible fichier de swap

opt.undofile = true -- on autorise l'undo à l'infini (même quand on revient sur un fichier qu'on avait fermé)

-- opt.iskeyword:append("-") -- on traite les mots avec des - comme un seul mot

-- affichage des caractères spéciaux
opt.list = true
opt.listchars:append({ nbsp = "␣", trail = "•", precedes = "«", extends = "»", tab = "> " })

-- Folding : la granularité (fonction, classe, boucle, condition…) vient de
-- treesitter, activé par buffer dans plugins/treesitter.lua. Ici on règle le
-- comportement global et l'affichage.
opt.foldlevelstart = 99 -- tout déplié à l'ouverture d'un fichier, on plie à la demande
opt.foldenable = true
opt.foldcolumn = "1" -- petite colonne à gauche qui indique où sont les replis
opt.fillchars:append({ fold = " ", foldopen = "v", foldclose = ">", foldsep = " " })

-- Auto-activation d'un venv .venv présent dans le cwd, dans l'environnement de
-- Neovim lui-même (PATH + VIRTUAL_ENV). Indépendant du shell de lancement, donc
-- survit aux restore tmux (resurrect relance nvim sans venv activé).
-- ponytail: ne cherche que ./.venv à la racine du cwd.
local function activate_venv()
  local venv = vim.fn.getcwd() .. "/.venv"
  if vim.env.VIRTUAL_ENV ~= venv and vim.fn.isdirectory(venv .. "/bin") == 1 then
    vim.env.VIRTUAL_ENV = venv
    vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
  end
end
activate_venv()
vim.api.nvim_create_autocmd("DirChanged", { callback = activate_venv })

