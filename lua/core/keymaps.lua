-- On définit notre touche leader sur espace
vim.g.mapleader = " "

-- Raccourci pour la fonction set
local keymap = vim.keymap.set

-- on utilise ;; pour sortir du monde insertion
keymap("i", ";;", "<ESC>", { desc = "Sortir du mode insertion avec ;;" })

-- Folding (replis de code via treesitter, voir plugins/treesitter.lua).
-- Touches natives : za = toggle le repli sous le curseur, zo/zc = ouvrir/fermer,
-- zj/zk = saut au repli suivant/précédent. On ajoute juste de quoi tout
-- ouvrir / tout fermer facilement (en doublon discoverable des zR/zM natifs).
keymap("n", "<leader>za", "zR", { desc = "Folds : tout déplier" })
keymap("n", "<leader>zm", "zM", { desc = "Folds : tout replier" })

-- Requête SQL DuckDB sur le fichier CSV/JSON/Parquet courant.
-- Tape ta requête en utilisant `t` comme nom de table (DuckDB lit
-- automatiquement le fichier). Résultat dans un nouveau buffer.
keymap("n", "<leader>sq", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Aucun fichier dans le buffer courant", vim.log.levels.WARN)
    return
  end
  local ext = file:match("%.(%w+)$") or ""
  local reader
  if ext == "csv" or ext == "tsv" then
    reader = string.format("read_csv_auto('%s')", file)
  elseif ext == "json" or ext == "jsonl" then
    reader = string.format("read_json_auto('%s')", file)
  elseif ext == "parquet" then
    reader = string.format("'%s'", file)
  else
    vim.notify("Type non supporté : ." .. ext, vim.log.levels.ERROR)
    return
  end
  local query = vim.fn.input({ prompt = "SQL (t = table) : ", cancelreturn = "__CANCEL__" })
  if query == "__CANCEL__" or query == "" then return end
  -- Remplace `t` par le reader DuckDB
  query = query:gsub("([%s,])t([%s,])", "%1" .. reader .. "%2")
                :gsub("FROM%s+t%f[%W]", "FROM " .. reader)
                :gsub("from%s+t%f[%W]", "from " .. reader)
  -- -csv : sortie CSV (pas de troncature à 40 lignes comme le mode box).
  -- On peut ainsi voir tous les résultats et même les enregistrer.
  vim.cmd("vnew")
  vim.cmd("0read !duckdb -csv -c " .. vim.fn.shellescape(query))
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = "csv"
end, { desc = "DuckDB SQL sur le fichier courant (t = table)" })

-- Quand on sauvegarde un .gitignore, rafraîchit automatiquement gitsigns
-- et nvim-tree pour que les signes/couleurs reflètent les nouvelles règles
-- d'ignore (sinon il faut redémarrer nvim).
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".gitignore", "**/.gitignore" },
  callback = function()
    pcall(vim.cmd, "Gitsigns refresh")
    pcall(function()
      require("nvim-tree.api").tree.reload()
    end)
    vim.notify(".gitignore mis à jour : gitsigns + nvim-tree rafraîchis")
  end,
  desc = "Refresh gitsigns/nvim-tree quand .gitignore change",
})

-- Activer le wrap uniquement pour JSON et JSONL (lignes souvent très
-- longues, et l'indentation n'est pas significative comme en Python).
-- Ailleurs on garde wrap=false (défini dans options.lua).
-- On active aussi le folding treesitter pour pouvoir replier/déplier
-- chaque objet et array avec za / zc / zo / zR / zM.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonl" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- coupe sur les espaces, pas en plein milieu d'un mot
    -- Folding via treesitter (granularité sémantique : objets, arrays, etc.)
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel = 99 -- tout déplié au démarrage, on plie à la demande
  end,
})

-- Vérifie si le fichier a été modifié à l'extérieur de nvim et recharge
-- (couplé à autoread). Sans ces autocmds, autoread ne se déclenche que
-- rarement et on rate les modifs de Claude / formatters / git checkout.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() !~ '\\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
  desc = "Recharge auto les fichiers modifiés à l'extérieur",
})

-- Notifie quand un fichier a été rechargé en arrière-plan
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  command = "echohl WarningMsg | echo 'Fichier modifié à l\\'extérieur, rechargé' | echohl None",
})

-- Double Esc pour sortir du mode terminal (sinon il faut faire <C-\><C-n>)
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sortir du mode terminal" })

-- Navigation entre fenêtres directement depuis un buffer terminal :
-- en une frappe, on sort du mode terminal ET on change de fenêtre.
-- Évite la séquence <Esc><Esc> + <C-l> + retour qui décale le curseur.
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Fenêtre de gauche depuis le terminal" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Fenêtre du bas depuis le terminal" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Fenêtre du haut depuis le terminal" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Fenêtre de droite depuis le terminal" })

-- Quand on (re)rentre dans un buffer terminal, on repasse automatiquement
-- en mode insertion : le curseur saute pile sur la zone de frappe au lieu
-- de rester figé à sa dernière position en mode normal.
-- vim.schedule différé pour que la fenêtre soit complètement prête (sinon
-- le startinsert est avalé quand <leader>ac re-toggle la fenêtre).
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.schedule(function()
        if vim.bo.buftype == "terminal" then
          vim.cmd("startinsert")
        end
      end)
    end
  end,
  desc = "Auto-insertion dans les buffers terminal",
})

-- on efface le surlignage de la recherche
keymap("n", "<leader>/", ":nohl<CR>", { desc = "Effacer le surlignage de la recherche" })

-- Navigation entre fonctions et classes via treesitter.
-- Marche pour tout langage qui a des nodes nommés function_*/method_*/class_*
-- (Python, Lua, JS/TS, Rust, etc.). Utilisable en mode normal ET visuel
-- (en visuel, ça étend la sélection jusqu'à la cible).
local function ts_jump(direction, type_pattern)
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then
    vim.notify("Treesitter parser indisponible pour ce buffer", vim.log.levels.WARN)
    return
  end
  local root = parser:parse()[1]:root()
  local cur = vim.api.nvim_win_get_cursor(0)
  local cur_row, cur_col = cur[1] - 1, cur[2]

  local matches = {}
  local function visit(node)
    if node:type():match(type_pattern) then
      local r, c = node:range()
      table.insert(matches, { row = r, col = c })
    end
    for child in node:iter_children() do
      visit(child)
    end
  end
  visit(root)
  table.sort(matches, function(a, b)
    if a.row ~= b.row then return a.row < b.row end
    return a.col < b.col
  end)

  if direction == "next" then
    for _, m in ipairs(matches) do
      if m.row > cur_row or (m.row == cur_row and m.col > cur_col) then
        vim.api.nvim_win_set_cursor(0, { m.row + 1, m.col })
        return
      end
    end
  else
    for i = #matches, 1, -1 do
      local m = matches[i]
      if m.row < cur_row or (m.row == cur_row and m.col < cur_col) then
        vim.api.nvim_win_set_cursor(0, { m.row + 1, m.col })
        return
      end
    end
  end
end

-- Fin du node englobant (fonction ou classe qui contient le curseur).
-- Pratique combiné au mode visuel : `V<leader>ef` sélectionne du curseur
-- jusqu'à la fin de la fonction courante.
local function ts_jump_to_enclosing_end(type_pattern)
  local ok = pcall(vim.treesitter.get_parser, 0)
  if not ok then
    vim.notify("Treesitter parser indisponible pour ce buffer", vim.log.levels.WARN)
    return
  end
  local node = vim.treesitter.get_node()
  while node do
    if node:type():match(type_pattern) then
      local _, _, end_row, end_col = node:range()
      -- Si end_col == 0, le node finit en début de ligne suivante :
      -- on remonte d'une ligne pour cibler la dernière ligne réelle.
      if end_col == 0 and end_row > 0 then
        end_row = end_row - 1
        local line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1] or ""
        end_col = #line
      end
      vim.api.nvim_win_set_cursor(0, { end_row + 1, math.max(0, end_col - 1) })
      return
    end
    node = node:parent()
  end
  vim.notify("Aucune " .. type_pattern .. " englobante trouvée", vim.log.levels.INFO)
end

local nx = { "n", "x" }
keymap(nx, "<leader>nf", function() ts_jump("next", "function") end, { desc = "Fonction suivante" })
keymap(nx, "<leader>Nf", function() ts_jump("prev", "function") end, { desc = "Fonction précédente" })
keymap(nx, "<leader>nc", function() ts_jump("next", "class") end, { desc = "Classe suivante" })
keymap(nx, "<leader>Nc", function() ts_jump("prev", "class") end, { desc = "Classe précédente" })
keymap(nx, "<leader>ef", function() ts_jump_to_enclosing_end("function") end, { desc = "Fin de la fonction courante" })
keymap(nx, "<leader>ec", function() ts_jump_to_enclosing_end("class") end, { desc = "Fin de la classe courante" })

-- Indenter / désindenter en visuel sans perdre la sélection (gv = re-select last visual)
keymap("v", ">", ">gv", { desc = "Indenter et garder la sélection" })
keymap("v", "<", "<gv", { desc = "Désindenter et garder la sélection" })

-- En mode visuel, p colle SANS écraser le presse-papier avec le texte
-- remplacé (qui est envoyé dans le black hole register "_).
-- Permet de coller la même chose plusieurs fois d'affilée.
keymap("x", "p", '"_dP', { desc = "Coller sans yanker le texte remplacé" })
keymap("x", "P", '"_dP', { desc = "Coller sans yanker le texte remplacé" })

-- Déplace la sélection visuelle vers le haut / bas. Mode "x" : couvre le
-- visuel caractère, ligne ET bloc (inutile de doubler avec "v", qui inclurait
-- aussi le mode select où ça n'a pas de sens).
-- gv=gv : réétend la sélection (gv) puis la ré-indente (=) après le déplacement.
keymap("x", "K", ":move '<-2<CR>gv=gv", { desc = "Déplacer la sélection vers le haut" })
keymap("x", "J", ":move '>+1<CR>gv=gv", { desc = "Déplacer la sélection vers le bas" })

-- Navigation entre fenêtres (<C-h/j/k/l>) : gérée par smart-splits.nvim
-- (lua/plugins/smart-splits.lua), avec traversée tmux transparente.

-- Gestion des splits sous le préfixe <leader>w (w = window)
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
keymap("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
keymap("n", "<leader>wq", "<C-w>q", { desc = "Fermer la fenêtre" })
-- "only" maison : ferme les autres fenêtres SAUF l'explorateur nvim-tree
-- (le <C-w>o natif fermerait aussi l'arbre, ce qui n'est pas voulu).
keymap("n", "<leader>wo", function()
  local cur = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= cur then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if ft ~= "NvimTree" then
        pcall(vim.api.nvim_win_close, win, false)
      end
    end
  end
end, { desc = "Fermer les autres fenêtres (garde l'explorateur)" })
keymap("n", "<leader>w=", "<C-w>=", { desc = "Égaliser la taille des fenêtres" })

-- Maximiser/restaurer la fenêtre courante (toggle). On mémorise la disposition
-- via winrestcmd() pour pouvoir la rejouer telle quelle au retour.
keymap("n", "<leader>wm", function()
  if vim.t.maximized_restore_cmd then
    vim.cmd(vim.t.maximized_restore_cmd)
    vim.t.maximized_restore_cmd = nil
  else
    vim.t.maximized_restore_cmd = vim.fn.winrestcmd()
    vim.cmd("resize | vertical resize")
  end
end, { desc = "Maximiser/restaurer la fenêtre (toggle)" })

-- Couper la ligne au curseur (inverse de J natif qui joint les lignes)
keymap("n", "<leader>J", "i<CR><Esc>", { desc = "Couper la ligne au curseur" })

-- Navigation entre les buffers
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Buffer suivant" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Buffer précédent" })
keymap("n", "<leader>bd", ":bp<bar>bd #<CR>", { desc = "Fermer le buffer sans fermer la fenêtre" })
