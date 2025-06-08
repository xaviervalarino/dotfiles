if not vim.g.vscode then
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
end

require("grapple").setup({
    scope = "git_branch",
    icons = not vim.g.vscode,
})

vim.keymap.set("n", "<leader>m", "<cmd>Grapple tag<cr>", { desc = "Grapple add tag" })
vim.keymap.set("n", "<leader>dm", "<cmd>Grapple untag<cr>", { desc = "Grapple remove tag" })
vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
vim.keymap.set("n", "<leader>n", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" })
vim.keymap.set("n", "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", { desc = "Grapple cycle previous tag" })

vim.keymap.set("n", "<leader>h", "<cmd>Grapple select index=1<cr>", { desc = "Grapple select tag 1" })
vim.keymap.set("n", "<leader>j", "<cmd>Grapple select index=2<cr>", { desc = "Grapple select tag 2" })
vim.keymap.set("n", "<leader>k", "<cmd>Grapple select index=3<cr>", { desc = "Grapple select tag 3" })
vim.keymap.set("n", "<leader>l", "<cmd>Grapple select index=4<cr>", { desc = "Grapple select tag 4" })
