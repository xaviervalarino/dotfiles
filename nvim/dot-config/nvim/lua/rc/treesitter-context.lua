local ts_context = require("treesitter-context")

ts_context.setup({
    multiline_threshold = 3,
})

-- Apply lighter Statusline background to context
local statusline_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
if statusline_bg then
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = statusline_bg })
end

vim.keymap.set("n", "[c", function()
    ts_context.go_to_context(vim.v.count1)
end, { silent = true })
