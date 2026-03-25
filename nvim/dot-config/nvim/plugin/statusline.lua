if vim.g.vscode then
    return
end

-- Statusline highlight groups: fg-only for git, filled bg for diagnostics
local function setup_highlights()
    local function fg_of(name)
        return vim.api.nvim_get_hl(0, { name = name }).fg
    end

    -- StatusLine uses `reverse`, so visual bg = fg and visual fg = bg
    local sl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
    local sl_bg = sl.reverse and sl.fg or sl.bg
    local sl_fg = sl.reverse and sl.bg or sl.fg

    -- Git: muted colored text on statusline bg
    local function dim(color)
        if not color then return sl_fg end
        local r = math.floor(bit.rshift(color, 16) * 0.6)
        local g = math.floor(bit.band(bit.rshift(color, 8), 0xFF) * 0.6)
        local b = math.floor(bit.band(color, 0xFF) * 0.6)
        return r * 65536 + g * 256 + b
    end
    vim.api.nvim_set_hl(0, "StGitAdd", { fg = dim(fg_of("Added")), bg = sl_bg, bold = true })
    vim.api.nvim_set_hl(0, "StGitChange", { fg = dim(fg_of("Changed")), bg = sl_bg, bold = true })
    vim.api.nvim_set_hl(0, "StGitDelete", { fg = dim(fg_of("Removed")), bg = sl_bg, bold = true })

    -- Diagnostics: filled bg with contrasting fg
    vim.api.nvim_set_hl(0, "StDiagError", { fg = sl_fg, bg = fg_of("DiagnosticError"), bold = true })
    vim.api.nvim_set_hl(0, "StDiagWarn", { fg = sl_fg, bg = fg_of("DiagnosticWarn"), bold = true })
    vim.api.nvim_set_hl(0, "StDiagHint", { fg = sl_fg, bg = fg_of("DiagnosticHint"), bold = true })
end

setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })

local function git_status()
    local git = vim.b.minigit_summary
    if not git or not git.head_name then return "" end

    local parts = { " " .. git.head_name }

    local diff = vim.b.minidiff_summary
    if diff then
        if (diff.add or 0) > 0 then table.insert(parts, "%#StGitAdd#+" .. diff.add .. "%*") end
        if (diff.change or 0) > 0 then table.insert(parts, "%#StGitChange#~" .. diff.change .. "%*") end
        if (diff.delete or 0) > 0 then table.insert(parts, "%#StGitDelete#-" .. diff.delete .. "%*") end
    end

    return table.concat(parts, " ")
end

local function diagnostics()
    local d = vim.diagnostic.count(0)
    local parts = {}
    local e = d[vim.diagnostic.severity.ERROR] or 0
    local w = d[vim.diagnostic.severity.WARN] or 0
    local h = d[vim.diagnostic.severity.HINT] or 0
    if e > 0 then table.insert(parts, "%#StDiagError# E:" .. e .. " %*") end
    if w > 0 then table.insert(parts, "%#StDiagWarn# W:" .. w .. " %*") end
    if h > 0 then table.insert(parts, "%#StDiagHint# I:" .. h .. " %*") end
    return table.concat(parts, "")
end

_G.Statusline = function()
    local git = git_status()
    local diag = diagnostics()
    local s = ""
    if git ~= "" then s = s .. " " .. git .. " │" end
    s = s .. " %f%m"
    s = s .. "%="
    if diag ~= "" then s = s .. diag end
    s = s .. " %l:%c "
    return s
end

vim.o.statusline = "%!v:lua.Statusline()"

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        vim.cmd.redrawstatus()
    end,
})
