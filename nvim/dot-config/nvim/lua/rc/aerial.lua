require("aerial").setup({
    layout = {
        width = 0.2,
        default_direction = "prefer_left",
    },
    attach_mode = "global",
    on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>ns", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Go to [n]ext [s]ymbol" })
        vim.keymap.set("n", "<leader>ps", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Go to [p]revious [s]ymbol" })
    end,
})

vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Open code [o]utline" })
