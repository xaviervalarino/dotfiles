local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance --

local function scheme_for_appearance(appearance)
    if appearance:find("Light") then
        return "Github"
    else
        return "GitHub Dark"
    end
end

local function get_effective_scheme(pane)
    local user_vars = {}
    if pane then
        if type(pane.get_user_vars) == "function" then
            user_vars = pane:get_user_vars() or {}
        elseif type(pane.user_vars) == "table" then
            user_vars = pane.user_vars
        end
    end
    local theme = user_vars.THEME
    if theme == "dark" then
        return "GitHub Dark"
    elseif theme == "light" then
        return "Github"
    else
        return scheme_for_appearance(wezterm.gui.get_appearance())
    end
end

local function tab_bar_colors_for_scheme(scheme_name)
    local schemes = wezterm.color.get_builtin_schemes()
    local s = schemes[scheme_name]
    if not s then return nil end

    local is_dark = scheme_name:find("Dark") ~= nil
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
            bg_color = is_dark and "#161b22" or "#eaeef2",
            fg_color = fg,
        },
        new_tab = {
            bg_color = bg,
            fg_color = is_dark and "#7d8590" or "#6e7781",
        },
    }
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.colors = {
    tab_bar = tab_bar_colors_for_scheme(config.color_scheme),
}

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
    left = 36,
    right = 36,
    top = 32,
    bottom = 32,
}

-- Tabs --

config.tab_bar_at_bottom = true
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

config.keys = {
    { key = "[", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(-1) },
    { key = "]", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(1) },
    { key = "r", mods = "SUPER", action = wezterm.action.ReloadConfiguration },
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

--- Get a clean display title for a tab.
--- @param tab_info table A wezterm TabInformation object.
--- @return string
local function get_tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    local pane = tab_info.active_pane
    if pane and pane.title and #pane.title > 0 then
        return pane.title
    end
    if pane and pane.foreground_process_name then
        return pane.foreground_process_name:gsub("^.*/", "")
    end
    return "tab"
end

-- Bell & Alert Tracking --

local bell_panes = {}

wezterm.on("bell", function(window, pane)
    bell_panes[pane:pane_id()] = true
end)

--- Return true if the tab has an unseen alert or new output.
--- @param tab_info table A wezterm TabInformation object.
--- @return boolean
local function tab_has_alert(tab_info)
    local pane = tab_info.active_pane
    if not pane then
        return false
    end

    if tab_info.is_active then
        bell_panes[pane.pane_id] = nil
        return false
    end

    if pane.has_unseen_output or bell_panes[pane.pane_id] then
        return true
    end

    return false
end

--- Get non-title width (padding, indicators, index) for a tab.
local function tab_chrome_width(tab_info, has_alert)
    local index = tab_info.tab_index + 1
    local index_len = #tostring(index)
    return (has_alert and 7 or 5) + index_len
end

--- Get terminal window width in columns.
local function get_window_cols(tab_info)
    local max_col = 0
    if tab_info.panes then
        for _, p in ipairs(tab_info.panes) do
            local right = (p.left or 0) + (p.width or 0)
            if right > max_col then
                max_col = right
            end
        end
    end
    if max_col > 0 then
        return max_col
    end
    local pane = tab_info.active_pane
    if pane and pane.width and pane.width > 0 then
        return pane.width
    end
    return 120
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = get_tab_title(tab)
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

    local index = tab.tab_index + 1
    local is_dark = config.color_scheme and config.color_scheme:find("Dark") ~= nil

    if tab_has_alert(tab) then
        -- Red alert dot, normal inactive colors for number and title
        local dot_color = is_dark and "#f85149" or "#cf222e"
        local num_color = is_dark and "#484f58" or "#afb8c1"
        local title_color = is_dark and "#7d8590" or "#6e7781"
        return {
            { Foreground = { Color = dot_color } },
            { Text = "  ● " },
            { Foreground = { Color = num_color } },
            { Text = index .. " " },
            { Foreground = { Color = title_color } },
            { Text = title .. "  " },
        }
    end

    if is_active then
        -- Number in lighter/muted secondary color, no colon (saving a column), title in bold warm yellow
        local num_color = is_dark and "#8b949e" or "#8c959f"
        local title_color = is_dark and "#e3b341" or "#9a6700"
        return {
            { Foreground = { Color = num_color } },
            { Text = "  " .. index .. " " },
            { Attribute = { Intensity = "Bold" } },
            { Foreground = { Color = title_color } },
            { Text = title .. "  " },
        }
    else
        -- Inactive: number in subtle dimmed color, title in muted text color
        local num_color = is_dark and "#484f58" or "#afb8c1"
        local title_color = is_dark and "#7d8590" or "#6e7781"
        return {
            { Foreground = { Color = num_color } },
            { Text = "  " .. index .. " " },
            { Foreground = { Color = title_color } },
            { Text = title .. "  " },
        }
    end
end)

--- Return true if any pattern in `patterns` matches anywhere in `haystack`.
--- @param haystack string|string[] String, or list of strings, to search in.
--- @param patterns string[] Lua patterns to test against the haystack.
--- @return boolean
local function find_any(haystack, patterns)
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

-- Full-screen TUI apps that should run without window padding.
local tui_apps = { "nvim", "opencode" }

--- Detect whether the foreground process in `pane` is a full-screen TUI app.
--- Falls back to inspecting argv so apps wrapped by a runtime (e.g. opencode,
--- which is launched via a `node` script) are matched correctly.
--- @param pane table A wezterm pane object.
--- @return boolean
local function is_tui(pane)
    local process = pane:get_foreground_process_name()
    if find_any(process, tui_apps) then
        return true
    end
    local info = pane:get_foreground_process_info()
    if info and info.argv then
        return find_any(info.argv, tui_apps)
    end
    return false
end

-- Drop padding for full-screen TUIs; update color scheme dynamically
wezterm.on("update-right-status", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local scheme = get_effective_scheme(pane)
    overrides.color_scheme = scheme
    overrides.colors = {
        tab_bar = tab_bar_colors_for_scheme(scheme),
    }
    if is_tui(pane) then
        overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
    else
        overrides.window_padding = nil
    end
    window:set_config_overrides(overrides)

    window:set_right_status("")
end)

wezterm.on("user-var-changed", function(window, pane, name, _)
    if name == "THEME" then
        local overrides = window:get_config_overrides() or {}
        local scheme = get_effective_scheme(pane)
        overrides.color_scheme = scheme
        overrides.colors = {
            tab_bar = tab_bar_colors_for_scheme(scheme),
        }
        window:set_config_overrides(overrides)
    end
end)

return config
