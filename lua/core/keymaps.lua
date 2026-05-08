-- On définit notre touche leader sur espace
vim.g.mapleader = " "

-- Raccourci pour la fonction set
local keymap = vim.keymap.set

-- on utilise ;; pour sortir du monde insertion
keymap("i", ";;", "<ESC>", { desc = "Sortir du mode insertion avec ;;" })

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
-- Utile pour reprendre la main sur nvim quand on est dans un :terminal
-- ou dans le panneau Claude.
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sortir du mode terminal" })

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

-- K déplace le texte sélectionné vers le haut en mode visuel (activé avec v)
keymap("v", "<S-k>", ":m .-2<CR>==", { desc = "Déplace le texte sélectionné vers le haut en mode visuel" })
-- J déplace le texte sélectionné vers le bas en mode visuel (activé avec v)
keymap("v", "<S-j>", ":m .+1<CR>==", { desc = "Déplace le texte sélectionné vers le bas en mode visuel" })

-- K déplace le texte sélectionné vers le haut en mode visuel bloc (activé avec V)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", { desc = "Déplace le texte sélectionné vers le haut en mode visuel bloc" })
-- J déplace le texte sélectionné vers le bas en mode visuel (activé avec V)
keymap("x", "<S-J>", ":move '>+1<CR>gv-gv", { desc = "Déplace le texte sélectionné vers le bas en mode visuel bloc" })

-- Changement de fenêtre avec Ctrl + déplacement uniquement au lieu de Ctrl-w + déplacement
keymap("n", "<C-h>", "<C-w>h", { desc = "Déplace le curseur dans la fenêtre de gauche" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Déplace le curseur dans la fenêtre du bas" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Déplace le curseur dans la fenêtre du haut" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Déplace le curseur dans la fenêtre droite" })

-- Couper la ligne au curseur (inverse de J qui joint les lignes)
keymap("n", "<leader>j", "i<CR><Esc>", { desc = "Couper la ligne au curseur" })

-- Navigation entre les buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bp<bar>bd #<CR>", { desc = "Fermer le buffer sans fermer la fenêtre" })
