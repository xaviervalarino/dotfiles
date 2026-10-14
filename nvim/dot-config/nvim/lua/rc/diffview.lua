require("diffview").setup({
    enhanced_diff_hl = true,
})

vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { desc = "[g]it [v]iew tab" })
vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewClose<cr>", { desc = "[g]it [V]iew close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "[g]it file [h]istory" })
