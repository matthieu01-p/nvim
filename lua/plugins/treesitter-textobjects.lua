-- nvim-treesitter-textobjects : ajoute des text objects sémantiques basés sur
-- treesitter (fonction, classe, argument, conditionnel, boucle, commentaire).
--
-- Branche `main` : alignée sur la nouvelle API de nvim-treesitter (branche
-- `main` elle aussi, cf. treesitter.lua). L'ancienne API (modules dans
-- configs.setup) n'existe plus ; on déclare les keymaps à la main via les
-- modules `select` et `move`.
--
-- Convention des objets (i = inner / contenu, a = around / + délimiteurs) :
--   f = function   c = class   a = argument/param   o = conditionnel (if)
--   l = loop       k = comment
-- Exemples : dif (corps de fonction), daf (fonction entière),
--            daa (un argument + sa virgule), vac (classe entière).
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- saute en avant jusqu'au prochain objet si le curseur n'est pas
        -- déjà dessus (ex: cif marche même avant la fonction)
        lookahead = true,
      },
      move = {
        set_jumps = true, -- ajoute les sauts à la jumplist (Ctrl-o / Ctrl-i)
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")

    -- Sélection : opérateur + objet (d/c/y/v × i/a + type)
    local sel = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["ao"] = "@conditional.outer",
      ["io"] = "@conditional.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["ak"] = "@comment.outer",
    }
    for lhs, query in pairs(sel) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = "Text object " .. query })
    end

    -- Déplacement : saut au début/fin de l'objet suivant/précédent
    local function map_move(lhs, fn, query, desc)
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        fn(query, "textobjects")
      end, { desc = desc })
    end
    map_move("]f", move.goto_next_start, "@function.outer", "Fonction suivante (début)")
    map_move("[f", move.goto_previous_start, "@function.outer", "Fonction précédente (début)")
    map_move("]F", move.goto_next_end, "@function.outer", "Fonction suivante (fin)")
    map_move("[F", move.goto_previous_end, "@function.outer", "Fonction précédente (fin)")
    map_move("]c", move.goto_next_start, "@class.outer", "Classe suivante (début)")
    map_move("[c", move.goto_previous_start, "@class.outer", "Classe précédente (début)")
    map_move("]a", move.goto_next_start, "@parameter.inner", "Argument suivant")
    map_move("[a", move.goto_previous_start, "@parameter.inner", "Argument précédent")
  end,
}
