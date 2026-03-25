local ts_context = require("treesitter-context")

ts_context.setup({
    multiline_threshold = 3,
})

vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLine" })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "CursorLine" })
    end,
})

vim.keymap.set("n", "[c", function()
    ts_context.go_to_context(vim.v.count1)
end, { silent = true })
