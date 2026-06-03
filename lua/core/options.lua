local opt = vim.opt -- raccourci pour un peu plus de concision

-- Mouse enable/disable
opt.mouse = ""

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

