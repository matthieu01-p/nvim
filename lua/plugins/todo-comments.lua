return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next todo comment" })

    keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous todo comment" })

    -- Liste tous les TODO/FIXME/HACK/… du projet dans Telescope.
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Lister les TODO/FIXME (Telescope)" })

    todo_comments.setup()
  end,
}
