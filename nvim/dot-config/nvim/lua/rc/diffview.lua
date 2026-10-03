require("diffview").setup({
    enhanced_diff_hl = true,
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "[g]it [d]iffview tab" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "[g]it [D]iffview close" })
