local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance --

--------------------------------------------------------------------------------
-- Color Management System:
--   COLOR_MODE:    Polarity ("dark" | "light") - controls background luminance,
--                  tab bar contrast, and terminal process environment.
--   COLOR_PALETTE: Theme family ("github" | "rose-pine" | "tokyonight") -
--                  selects the specific active colorscheme.
--------------------------------------------------------------------------------

local palette_schemes = {
    github = { dark = "GitHub Dark", light = "Github" },
    ["rose-pine"] = { dark = "rose-pine", light = "rose-pine-dawn" },
    tokyonight = { dark = "Tokyo Night", light = "Tokyo Night Day" },
}

local function scheme_for_mode_and_palette(mode, palette)
    palette = palette or "github"
    mode = mode or "dark"
    local entry = palette_schemes[palette] or palette_schemes["github"]
    return entry[mode] or entry["dark"]
end

local function detect_mode_and_palette(scheme_name)
    if not scheme_name or scheme_name == "" then
        return "dark", "github"
    end
    for pal, entry in pairs(palette_schemes) do
        if scheme_name == entry.dark then
            return "dark", pal
        elseif scheme_name == entry.light then
            return "light", pal
        end
    end
    local is_dark = not (scheme_name:find("Light") or scheme_name:find("dawn") or scheme_name:find("Day"))
    local pal = scheme_name:find("rose%-pine") and "rose-pine" or "github"
    return is_dark and "dark" or "light", pal
end

local function read_theme_file(filename)
    local state_dir = os.getenv("XDG_STATE_HOME") or ((os.getenv("HOME") or "") .. "/.local/state")
    local f = io.open(state_dir .. "/theme/" .. filename, "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    if content then
        content = content:gsub("%s+", "")
        if content ~= "" then
            return content
        end
    end
    return nil
end

local function scheme_for_appearance(appearance)
    local mode = read_theme_file("mode")
    if mode ~= "dark" and mode ~= "light" then
        mode = "dark"
    end
    local palette = read_theme_file("palette") or "github"
    return scheme_for_mode_and_palette(mode, palette)
end

local function get_effective_color_state(window, pane)
    local user_vars = pane and (type(pane.get_user_vars) == "function" and pane:get_user_vars() or pane.user_vars) or {}
    local overrides = window
            and (type(window.get_config_overrides) == "function" and window:get_config_overrides() or window.config_overrides)
        or {}
    local eff = window and (type(window.effective_config) == "function" and window:effective_config())
    local active_scheme = overrides.color_scheme or (eff and eff.color_scheme) or config.color_scheme or ""

    local fallback_mode, fallback_palette = detect_mode_and_palette(active_scheme)

    local mode = user_vars.COLOR_MODE or fallback_mode
    local palette = user_vars.COLOR_PALETTE or fallback_palette

    if mode == "auto" or mode == "" then
        mode = fallback_mode
    end
    if palette == "" then
        palette = fallback_palette
    end

    return mode, palette
end

local function tab_bar_colors_for_scheme(scheme_name)
    local schemes = wezterm.color.get_builtin_schemes()
    local s = (config.color_schemes and config.color_schemes[scheme_name]) or schemes[scheme_name]
    if not s then
        return nil
    end

    local is_dark = true
    if s.background then
        local ok, c = pcall(wezterm.color.parse, s.background)
        if ok and c then
            local _, _, l, _ = c:hsla()
            is_dark = l < 0.5
        end
    else
        is_dark = scheme_name:find("Dark") ~= nil
    end

    local bg = s.background
    local fg = s.foreground

    return {
        background = bg,
        inactive_tab = {
            bg_color = bg,
            fg_color = is_dark and "#7d8590" or "#6e7781",
        },
        active_tab = {
            bg_color = bg,
            fg_color = is_dark and "#e3b341" or "#9a6700",
            intensity = "Bold",
        },
        inactive_tab_hover = {
            bg_color = bg,
            fg_color = is_dark and "#7d8590" or "#6e7781",
        },
        new_tab = {
            bg_color = bg,
            fg_color = is_dark and "#7d8590" or "#6e7781",
        },
    }
end

local builtin_schemes = wezterm.color.get_builtin_schemes()
local github_light = builtin_schemes["Github"]
if github_light then
    local light_copy = {}
    for k, v in pairs(github_light) do
        light_copy[k] = v
    end
    light_copy.ansi = {
        github_light.ansi[1],
        github_light.ansi[2],
        github_light.ansi[3],
        "#9a6700",
        github_light.ansi[5],
        github_light.ansi[6],
        "#0969da",
        github_light.ansi[8],
    }
    light_copy.brights = {
        github_light.brights[1],
        github_light.brights[2],
        github_light.brights[3],
        "#bf8700",
        github_light.brights[5],
        github_light.brights[6],
        "#0969da",
        github_light.brights[8],
    }
    config.color_schemes = {
        ["Github"] = light_copy,
    }
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.colors = {
    tab_bar = tab_bar_colors_for_scheme(config.color_scheme),
}

local function update_global_color_state(scheme, mode, palette)
    if not scheme or scheme == "" then
        return
    end
    wezterm.GLOBAL.last_color_scheme = scheme
    if not mode or not palette then
        mode, palette = detect_mode_and_palette(scheme)
    end
    wezterm.GLOBAL.last_mode = mode
    wezterm.GLOBAL.last_palette = palette
end

if not wezterm.GLOBAL.last_color_scheme then
    update_global_color_state(config.color_scheme)
end

config.font = wezterm.font("JetBrains Mono", { weight = "Book" })
config.font_size = 14.5
config.line_height = 1.25
config.force_reverse_video_cursor = true

-- Window --

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
-- config.window_content_alignment = {
--     horizontal = "Center",
--     vertical = "Bottom",
-- }
config.window_padding = {
    left = 16,
    right = 16,
    top = 16,
    bottom = 16,
}

-- Tabs --

config.tab_bar_at_bottom = true
config.mouse_wheel_scrolls_tabs = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 135

-- Bell --

config.audible_bell = "Disabled"
config.visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
    target = "CursorColor",
}

-- Keys --

local function spawn_tab_next_to_active(window, pane)
    local mux_window = window:mux_window()
    local current_idx = 0
    for i, tab_info in ipairs(mux_window:tabs_with_info()) do
        if tab_info.is_active then
            current_idx = tab_info.tab_index or (i - 1)
            break
        end
    end
    local mode, palette = get_effective_color_state(window, pane)
    local _, new_pane = mux_window:spawn_tab({
        domain = "CurrentPaneDomain",
        set_environment_variables = {
            COLOR_MODE = mode,
            COLOR_PALETTE = palette,
        },
    })
    window:perform_action(wezterm.action.MoveTab(current_idx + 1), new_pane or pane)
end

config.keys = {
    {
        key = "n",
        mods = "SUPER",
        action = wezterm.action_callback(function(window, pane)
            local mode, palette = get_effective_color_state(window, pane)
            local _, _, new_window = wezterm.mux.spawn_window({
                domain = "CurrentPaneDomain",
                set_environment_variables = {
                    COLOR_MODE = mode,
                    COLOR_PALETTE = palette,
                },
            })
            local scheme = scheme_for_mode_and_palette(mode, palette)
            if scheme and new_window then
                local gui_win = new_window:gui_window()
                if gui_win then
                    local overrides = gui_win:get_config_overrides() or {}
                    overrides.color_scheme = scheme
                    overrides.colors = {
                        tab_bar = tab_bar_colors_for_scheme(scheme),
                    }
                    gui_win:set_config_overrides(overrides)
                end
            end
        end),
    },
    {
        key = "d",
        mods = "SUPER",
        action = wezterm.action_callback(function(window, pane)
            local mode, palette = get_effective_color_state(window, pane)
            pane:split({
                direction = "Right",
                domain = "CurrentPaneDomain",
                set_environment_variables = {
                    COLOR_MODE = mode,
                    COLOR_PALETTE = palette,
                },
            })
        end),
    },
    {
        key = "d",
        mods = "SUPER|SHIFT",
        action = wezterm.action_callback(function(window, pane)
            local mode, palette = get_effective_color_state(window, pane)
            pane:split({
                direction = "Bottom",
                domain = "CurrentPaneDomain",
                set_environment_variables = {
                    COLOR_MODE = mode,
                    COLOR_PALETTE = palette,
                },
            })
        end),
    },
    {
        key = "t",
        mods = "SUPER",
        action = wezterm.action_callback(spawn_tab_next_to_active),
    },
    { key = "[", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(-1) },
    { key = "]", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(1) },
    { key = "r", mods = "SUPER", action = wezterm.action.ReloadConfiguration },
    {
        -- Shrinks the window to fit the active screen, then centers it.
        key = "c",
        mods = "SUPER|CTRL",
        action = wezterm.action_callback(function(window)
            local screen = wezterm.gui.screens().active
            local dims = window:get_dimensions()
            local width = math.min(dims.pixel_width, math.floor(screen.width * 0.9))
            local height = math.min(dims.pixel_height, math.floor(screen.height * 0.9))
            window:set_inner_size(width, height)
            window:set_position(
                screen.x + math.floor((screen.width - width) / 2),
                screen.y + math.floor((screen.height - height) / 2)
            )
        end),
    },
    {
        key = "r",
        mods = "SUPER|SHIFT",
        action = wezterm.action.PromptInputLine({
            description = "Enter new tab name:",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
    {
        key = "r",
        mods = "SUPER|CTRL",
        action = wezterm.action.PromptInputLine({
            description = "Enter new tab name:",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
}

-- Mouse --

config.mouse_bindings = {
    -- Cmd-click opens links in your default browser, even inside TUI apps
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CMD",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- Event handlers --

--- Return true if any pattern in `patterns` matches anywhere in `haystack`.
--- @param haystack string|string[] String, or list of strings, to search in.
--- @param patterns string[] Lua patterns to test against the haystack.
--- @return boolean
local function find_any(haystack, patterns)
    if not haystack then
        return false
    end
    local strs = type(haystack) == "string" and { haystack } or haystack --[[@as string[] ]]
    for _, str in ipairs(strs) do
        for _, p in ipairs(patterns) do
            if str:find(p) then
                return true
            end
        end
    end
    return false
end

-- Full-screen TUI apps that show in tab titles.
local tui_apps = { "nvim", "opencode", "claude" }

--- Identify whether the foreground process in `pane` is a known TUI app.
--- Falls back to inspecting argv so apps wrapped by a runtime are matched correctly.
--- @param pane table A wezterm pane or PaneInformation object.
--- @return string|nil
local function get_tui_app(pane)
    if not pane then
        return nil
    end

    local mux_pane = nil
    pcall(function()
        if pane.pane_id then
            mux_pane = wezterm.mux.get_pane(pane.pane_id)
        elseif type(pane.get_foreground_process_name) == "function" then
            mux_pane = pane
        end
    end)

    local process = nil
    if mux_pane then
        pcall(function()
            process = mux_pane:get_foreground_process_name()
        end)
    end

    if process and #process > 0 then
        for _, app in ipairs(tui_apps) do
            if process:find(app) then
                return app
            end
        end
    end

    if mux_pane then
        local info = nil
        pcall(function()
            info = mux_pane:get_foreground_process_info()
        end)
        if info and info.argv then
            for _, arg in ipairs(info.argv) do
                for _, app in ipairs(tui_apps) do
                    if arg:find(app) then
                        return app
                    end
                end
            end
        end
    end

    local title = nil
    pcall(function()
        title = pane.title
    end)
    if title and #title > 0 then
        for _, app in ipairs(tui_apps) do
            if title:find(app) then
                return app
            end
        end
    end

    return nil
end

--- Detect whether the foreground process in `pane` is a full-screen TUI app.
--- @param pane table A wezterm pane object.
--- @return boolean
local function is_tui(pane)
    return get_tui_app(pane) ~= nil
end

--- Shorten path components in Vim style (e.g. ~/dotfiles/wezterm -> ~/d/wezterm)
--- @param path string
--- @return string
local function path_shorten(path)
    if not path or path == "" then
        return ""
    end
    local home = os.getenv("HOME") or ""
    if home ~= "" and path:sub(1, #home) == home then
        path = "~" .. path:sub(#home + 1)
    end
    local parts = {}
    for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
    end
    if #parts == 0 then
        return path
    end
    local is_absolute = path:sub(1, 1) == "/"
    local starts_with_tilde = parts[1] == "~"
    local start_idx = starts_with_tilde and 2 or 1
    for i = start_idx, #parts - 1 do
        local p = parts[i]
        if p:sub(1, 1) == "." and #p > 1 then
            parts[i] = p:sub(1, 2)
        else
            parts[i] = p:sub(1, 1)
        end
    end
    local result = table.concat(parts, "/")
    if is_absolute and not starts_with_tilde then
        result = "/" .. result
    end
    return result
end

--- Extract the current working directory from pane URL.
--- @param pane table A wezterm pane or PaneInformation object.
--- @return string|nil
local function get_pane_cwd(pane)
    if not pane then
        return nil
    end
    local url = nil
    pcall(function()
        url = pane.current_working_dir
    end)
    if not url then
        local mux_pane = nil
        pcall(function()
            if pane.pane_id then
                mux_pane = wezterm.mux.get_pane(pane.pane_id)
            elseif type(pane.get_current_working_dir) == "function" then
                mux_pane = pane
            end
            if mux_pane then
                url = mux_pane:get_current_working_dir()
            end
        end)
    end
    if not url then
        return nil
    end
    local file_path = nil
    pcall(function()
        file_path = url.file_path
    end)
    if file_path and #file_path > 0 then
        return file_path
    end
    if type(url) == "string" then
        local raw_path = url:gsub("^file://[^/]*", "")
        return raw_path:gsub("%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end)
    end
    return nil
end

--- Get a clean display title for a tab.
--- @param tab_info table A wezterm TabInformation object.
--- @return string
local function get_tab_title(tab_info)
    local title = nil
    pcall(function()
        title = tab_info.tab_title
    end)
    if title and #title > 0 then
        return title
    end
    local pane = tab_info.active_pane
    if not pane then
        return "tab"
    end
    local tui = get_tui_app(pane)
    if tui == "claude" then
        local p_title = nil
        pcall(function()
            p_title = pane.title
        end)
        if not p_title or p_title == "" then
            local mux_pane = nil
            pcall(function()
                if pane.pane_id then
                    mux_pane = wezterm.mux.get_pane(pane.pane_id)
                end
            end)
            if mux_pane then
                pcall(function()
                    p_title = mux_pane:get_title()
                end)
            end
        end
        if p_title and #p_title > 0 then
            p_title = p_title:match("^%s*(.-)%s*$") or p_title
            if not p_title:match("^%d+%.%d+") and not p_title:find("/versions/") and #p_title > 0 then
                return p_title
            end
        end
        return "claude"
    elseif tui then
        return tui
    end
    local cwd = get_pane_cwd(pane)
    if cwd and #cwd > 0 then
        return path_shorten(cwd)
    end
    local p_title = nil
    pcall(function()
        p_title = pane.title
    end)
    if p_title and #p_title > 0 then
        return path_shorten(p_title)
    end
    return "tab"
end

-- Bell & Alert Tracking --

local bell_panes = {}

wezterm.on("bell", function(window, pane)
    local pane_id = nil
    pcall(function()
        pane_id = type(pane.pane_id) == "function" and pane:pane_id() or pane.pane_id
    end)
    if pane_id then
        bell_panes[pane_id] = true
    end
end)

--- Return true if the tab has an unseen alert.
--- @param tab_info table A wezterm TabInformation object.
--- @return boolean
local function tab_has_alert(tab_info)
    local pane = tab_info.active_pane
    if not pane then
        return false
    end

    local pane_id = nil
    pcall(function()
        pane_id = pane.pane_id
    end)

    if tab_info.is_active then
        if pane_id then
            bell_panes[pane_id] = nil
        end
        return false
    end

    if pane_id and bell_panes[pane_id] then
        return true
    end

    return false
end

--- Get non-title width (padding, indicators, index) for a tab.
local function tab_chrome_width(tab_info, has_alert)
    local idx = 0
    pcall(function()
        idx = tab_info.tab_index or tab_info.index or 0
    end)
    local index = idx + 1
    local index_len = #tostring(index)
    local left_pad = idx == 0 and 2 or 0
    return (has_alert and 5 or 3) + index_len + left_pad
end

--- Get terminal window width in columns.
local function get_window_cols(tab_info)
    local max_col = 0
    pcall(function()
        if tab_info.panes then
            for _, p in ipairs(tab_info.panes) do
                local left, width = 0, 0
                pcall(function()
                    left = p.left or 0
                end)
                pcall(function()
                    width = p.width or 0
                end)
                local right = left + width
                if right > max_col then
                    max_col = right
                end
            end
        end
    end)
    if max_col > 0 then
        return max_col
    end
    local pane = tab_info.active_pane
    if pane then
        local width = 0
        pcall(function()
            width = pane.width or 0
        end)
        if width > 0 then
            return width
        end
    end
    return 120
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config_handle, hover, max_width)
    local ok, result = pcall(function()
        local raw_title = get_tab_title(tab)
        local title = raw_title:gsub("^%d+:%s*", "")
        local is_active = tab.is_active
        local num_tabs = #tabs

        -- Tabs are max 120 chars by default with an ellipsis if they overflow.
        -- If there are too many tabs open that 120 doesn't fit, prioritize the active tab.
        -- On hover the sizing does not change (only changes on selection/active).
        local limit = 120
        if num_tabs > 1 then
            local total_cols = get_window_cols(tab)
            local has_alerts = {}
            local tab_titles = {}
            local total_needed = 0
            local active_tab_info = nil

            for _, t in ipairs(tabs) do
                local alert = tab_has_alert(t)
                has_alerts[t.tab_id] = alert
                local t_title = get_tab_title(t)
                tab_titles[t.tab_id] = t_title
                local chrome = tab_chrome_width(t, alert)
                local natural_len = math.min(120, wezterm.column_width(t_title))
                total_needed = total_needed + natural_len + chrome
                if t.is_active then
                    active_tab_info = t
                end
            end

            if total_needed > total_cols then
                local num_inactive = num_tabs - 1
                local min_inactive_title = 2
                local reserved_for_inactive = 0
                for _, t in ipairs(tabs) do
                    if not t.is_active then
                        reserved_for_inactive = reserved_for_inactive
                            + tab_chrome_width(t, has_alerts[t.tab_id])
                            + min_inactive_title
                    end
                end

                local active_chrome = active_tab_info
                        and tab_chrome_width(active_tab_info, has_alerts[active_tab_info.tab_id])
                    or 6
                local active_available = math.max(active_chrome + 3, total_cols - reserved_for_inactive)
                local active_title_limit = math.min(120, active_available - active_chrome)

                local active_title_text = active_tab_info
                        and (tab_titles[active_tab_info.tab_id] or get_tab_title(active_tab_info))
                    or ""
                local active_title_len = math.min(active_title_limit, wezterm.column_width(active_title_text))
                local active_used = active_title_len + active_chrome

                local remaining_for_inactive = math.max(0, total_cols - active_used)
                local avg_inactive_slot = math.floor(remaining_for_inactive / num_inactive)

                if is_active then
                    limit = active_title_limit
                else
                    local my_chrome = tab_chrome_width(tab, has_alerts[tab.tab_id])
                    limit = math.max(min_inactive_title, avg_inactive_slot - my_chrome)
                    limit = math.min(120, limit)
                end
            else
                limit = 120
            end
        else
            limit = 120
        end

        local width = wezterm.column_width(title)
        if width > limit then
            if limit <= 1 then
                title = "…"
            else
                title = wezterm.truncate_right(title, limit - 1) .. "…"
            end
        end

        local idx = 0
        pcall(function()
            idx = tab.tab_index or tab.index or 0
        end)
        local index = idx + 1
        local is_dark = true
        local tab_bg = nil
        pcall(function()
            if config_handle and config_handle.resolved_palette then
                local pal = config_handle.resolved_palette
                tab_bg = pal.tab_bar and pal.tab_bar.background or pal.background
            end
        end)
        if not tab_bg then
            local schemes = wezterm.color.get_builtin_schemes()
            local s = (config.color_schemes and config.color_schemes[config.color_scheme])
                or schemes[config.color_scheme or "GitHub Dark"]
            tab_bg = s and s.background or "#0d1117"
        end
        local ok_parse, c = pcall(wezterm.color.parse, tab_bg)
        if ok_parse and c then
            local _, _, l, _ = c:hsla()
            is_dark = l < 0.5
        end

        local left_pad = idx == 0 and "  " or ""

        if tab_has_alert(tab) then
            local dot_color = is_dark and "#f85149" or "#cf222e"
            local num_color = is_dark and "#484f58" or "#afb8c1"
            local title_color = is_dark and "#7d8590" or "#6e7781"
            return {
                { Background = { Color = tab_bg } },
                { Foreground = { Color = dot_color } },
                { Text = left_pad .. "● " },
                { Foreground = { Color = num_color } },
                { Text = index .. " " },
                { Foreground = { Color = title_color } },
                { Text = title .. "  " },
            }
        end

        local num_color = is_active and (is_dark and "#8b949e" or "#8c959f") or (is_dark and "#484f58" or "#afb8c1")
        local title_color = is_active and (is_dark and "#e3b341" or "#9a6700") or (is_dark and "#7d8590" or "#6e7781")

        return {
            { Background = { Color = tab_bg } },
            { Foreground = { Color = num_color } },
            { Text = left_pad .. index .. " " },
            { Attribute = { Intensity = is_active and "Bold" or "Normal" } },
            { Foreground = { Color = title_color } },
            { Text = title .. "  " },
        }
    end)

    if not ok then
        wezterm.log_error("format-tab-title error: " .. tostring(result))
        return {
            { Foreground = { Color = "#ff5555" } },
            { Text = " [TAB_ERR: " .. tostring(result):sub(1, 60) .. "] " },
        }
    end
    return result
end)

wezterm.on("window-config-reloaded", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local changed = false
    if overrides.window_padding ~= nil then
        overrides.window_padding = nil
        changed = true
    end

    local target_scheme = wezterm.GLOBAL.last_color_scheme
    if target_scheme and overrides.color_scheme == nil and target_scheme ~= config.color_scheme then
        overrides.color_scheme = target_scheme
        overrides.colors = {
            tab_bar = tab_bar_colors_for_scheme(target_scheme),
        }
        changed = true
    end

    if changed then
        window:set_config_overrides(overrides)
    end
end)

wezterm.on("window-focus-changed", function(window, pane)
    if window:is_focused() then
        local overrides = window:get_config_overrides() or {}
        local eff = window:effective_config()
        local active_scheme = overrides.color_scheme or (eff and eff.color_scheme) or config.color_scheme
        update_global_color_state(active_scheme)
    end
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
    if name == "COLOR_MODE" or name == "COLOR_PALETTE" then
        local user_vars = pane and (type(pane.get_user_vars) == "function" and pane:get_user_vars() or pane.user_vars)
            or {}
        local overrides = window:get_config_overrides() or {}
        local current_mode, current_palette = detect_mode_and_palette(overrides.color_scheme or config.color_scheme)

        local mode = current_mode
        local palette = current_palette

        if name == "COLOR_MODE" then
            local val = (value and value ~= "") and value or user_vars[name]
            val = val and val:gsub("%s+", "")
            if val == "auto" then
                local auto_mode = wezterm.gui.get_appearance():find("Light") and "light" or "dark"
                local auto_scheme = scheme_for_mode_and_palette(auto_mode, palette)
                overrides.color_scheme = auto_scheme
                overrides.colors = {
                    tab_bar = tab_bar_colors_for_scheme(auto_scheme),
                }
                window:set_config_overrides(overrides)
                update_global_color_state(auto_scheme, auto_mode, palette)
                return
            elseif val == "dark" or val == "light" then
                mode = val
            end
        elseif name == "COLOR_PALETTE" then
            local val = (value and value ~= "") and value or user_vars.COLOR_PALETTE
            val = val and val:gsub("%s+", "")
            if val and val ~= "" then
                palette = val
            end
        end

        local scheme = scheme_for_mode_and_palette(mode, palette)
        overrides.color_scheme = scheme
        if scheme then
            overrides.colors = {
                tab_bar = tab_bar_colors_for_scheme(scheme),
            }
        else
            overrides.colors = nil
        end
        window:set_config_overrides(overrides)

        update_global_color_state(scheme, mode, palette)
    end
end)

wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
    spawn_tab_next_to_active(window, pane)
    return false
end)

return config
