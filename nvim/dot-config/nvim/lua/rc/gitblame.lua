local function setup_highlight()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    local cursor_hl = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
    vim.api.nvim_set_hl(0, "CursorComment", {
        fg = comment_hl.fg,
        bg = cursor_hl.bg,
    })
end

setup_highlight()

vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlight })

require("gitblame").setup({
    highlight_group = "CursorComment",
    set_extmark_options = { hl_mode = "combine" },
    ignored_filetypes = { "gitcommit" },
})
