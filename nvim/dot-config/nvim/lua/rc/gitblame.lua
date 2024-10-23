local function get_hl_color(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    local color = hl[attr]
    if color then
        return string.format("#%06x", color)
    end
end

local comment_fg = get_hl_color("Comment", "fg")
local cursor_bg = get_hl_color("CursorLine", "bg")

vim.api.nvim_set_hl(0, "CursorComment", { fg = comment_fg, bg = cursor_bg })

require("gitblame").setup({
    highlight_group = "CursorComment",
    ignored_filetypes = { "gitcommit" },
})
