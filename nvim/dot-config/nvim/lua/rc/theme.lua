local M = {}

--------------------------------------------------------------------------------
-- Color Management System:
--   COLOR_MODE:    Polarity ("dark" | "light") - controls background luminance,
--                  statusline contrast, diffs, and prompt indicators.
--   COLOR_PALETTE: Theme family ("github" | "rose-pine") - controls the syntax
--                  palette and colorscheme plugin.
--------------------------------------------------------------------------------

--- Get the desired mode ("dark" or "light") based on COLOR_MODE or macOS appearance
function M.get_mode()
    local mode = vim.env.COLOR_MODE
    if mode == "dark" or mode == "light" then
        return mode
    end

    -- Query macOS system appearance
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    local style = handle and handle:read("*a")
    if handle then
        handle:close()
    end
    if style and style:find("Dark") then
        return "dark"
    end
    return "light"
end

--- Get the desired palette ("github", "rose-pine", etc.) based on COLOR_PALETTE
function M.get_palette()
    local palette = vim.env.COLOR_PALETTE
    if palette and palette ~= "" then
        return palette:lower():gsub("%s+", "")
    end
    return "github"
end

--- Apply theme based on mode ("dark" or "light") and palette ("github", "rose-pine")
function M.apply_theme(mode, palette)
    mode = mode or M.get_mode()
    palette = palette or M.get_palette()
    vim.o.background = mode

    if palette == "rose-pine" then
        local has_rp, rp = pcall(require, "rose-pine")
        if has_rp then
            rp.setup({
                styles = {
                    transparency = true,
                },
            })
        end
        local scheme = mode == "dark" and "rose-pine" or "rose-pine-dawn"
        if not pcall(vim.cmd.colorscheme, scheme) then
            palette = "github"
        end
    end

    if palette == "github" then
        local has_github, github_theme = pcall(require, "github-theme")
        if has_github then
            github_theme.setup({
                options = {
                    transparent = true,
                },
                groups = {
                    all = {
                        StatusLine = { bg = "NONE", fg = "fg2" },
                        StatusLineNC = { bg = "NONE", fg = "fg3" },
                        NormalFloat = { bg = "bg0", fg = "fg1" },
                        FloatBorder = { bg = "bg0", fg = "palette.border.default" },
                        FloatTitle = { bg = "bg0", fg = "palette.accent.fg", bold = true },
                        CursorLine = { bg = "bg2" },
                        WinbarPath = { fg = "fg2" },
                        WinbarFile = { fg = "fg1", bold = true },
                        WinbarMod = { fg = "palette.attention.fg", bold = true },
                        TelescopeResultsDiffAdd = { fg = "palette.success.fg", bold = true },
                        TelescopeResultsDiffChange = { fg = "palette.attention.fg", bold = true },
                        TelescopeResultsDiffDelete = { fg = "palette.danger.fg", bold = true },
                        TelescopeResultsDiffUntracked = { fg = "fg3" },
                        diffAdded = { fg = "palette.success.fg" },
                        diffRemoved = { fg = "palette.danger.fg" },
                        diffChanged = { fg = "palette.attention.fg" },
                        diffLine = { fg = "palette.accent.fg" },
                    },
                },
            })
        end

        local scheme = mode == "dark" and "github_dark" or "github_light"
        local has_github_theme = pcall(vim.cmd.colorscheme, scheme)
        if not has_github_theme then
            pcall(vim.cmd.colorscheme, "default")
        end
    end
end

function M.setup()
    M.apply_theme()

    -- User command: :Theme [dark|light|auto] [github|rose-pine]
    vim.api.nvim_create_user_command("Theme", function(opts)
        local args = vim.split(vim.trim(opts.args), "%s+")
        local arg_mode = args[1] and args[1]:lower() or ""
        local arg_palette = args[2] and args[2]:lower() or nil

        -- Allow passing palette as first arg: :Theme rose-pine
        if arg_mode == "rose-pine" or arg_mode == "github" then
            arg_palette = arg_mode
            arg_mode = ""
        end

        if arg_palette and arg_palette ~= "" then
            vim.env.COLOR_PALETTE = arg_palette
            io.stdout:write("\027]1337;SetUserVar=COLOR_PALETTE=" .. vim.base64.encode(arg_palette) .. "\007")
        end

        if arg_mode == "dark" or arg_mode == "light" then
            vim.env.COLOR_MODE = arg_mode
            M.apply_theme(arg_mode, arg_palette)
            io.stdout:write("\027]1337;SetUserVar=COLOR_MODE=" .. vim.base64.encode(arg_mode) .. "\007")
            print("Theme set to " .. (arg_palette or M.get_palette()) .. " (" .. arg_mode .. ")")
        elseif arg_mode == "auto" or arg_mode == "system" or arg_mode == "reset" then
            vim.env.COLOR_MODE = nil
            local detected = M.get_mode()
            M.apply_theme(detected, arg_palette)
            io.stdout:write("\027]1337;SetUserVar=COLOR_MODE=" .. vim.base64.encode("auto") .. "\007")
            print("Theme reset to auto (macOS appearance: " .. detected .. ")")
        elseif arg_palette then
            M.apply_theme(nil, arg_palette)
            print("Palette set to " .. arg_palette .. " (" .. M.get_mode() .. ")")
        else
            print(
                "Current: "
                    .. M.get_palette()
                    .. " ("
                    .. (vim.env.COLOR_MODE or ("auto (" .. M.get_mode() .. ")"))
                    .. ")"
            )
            print("Usage: :Theme [dark|light|auto] [github|rose-pine]")
        end
    end, {
        nargs = "*",
        complete = function(_, line)
            local words = vim.split(line, "%s+")
            if #words <= 2 then
                return { "dark", "light", "auto", "github", "rose-pine" }
            else
                return { "github", "rose-pine" }
            end
        end,
        desc = "Set or reset Neovim theme mode (dark, light, auto) and palette (github, rose-pine)",
    })

    -- When returning focus to Neovim, if mode is auto, sync with macOS appearance
    vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("ThemeSync", { clear = true }),
        callback = function()
            if not vim.env.COLOR_MODE then
                M.apply_theme()
            end
        end,
    })
end

return M
