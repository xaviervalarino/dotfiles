local live_rename = require("live-rename")

vim.keymap.set("n", "<leader>r", live_rename.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>R", live_rename.map({ text = "", insert = true }), { desc = "LSP rename" })
