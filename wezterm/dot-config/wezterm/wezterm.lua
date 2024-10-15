local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "rose-pine"
-- config.font = wezterm.font 'Iosevka Term'
config.font_size = 15
-- config.use_ime = false

config.window_decorations = "RESIZE"
config.use_resize_increments = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
-- config.window_decorations = 'INTEGRATED_BUTTONS'
local wezterm = require("wezterm")

-- Apply the Rose Pine colors for the tabs
local tab_colors = {
    background = "#191724", -- Tab bar background color (matches Rose Pine background)

    active_tab = {
        bg_color = "#191724", -- Background for the active tab
        fg_color = "#e0def4", -- Foreground (text) for the active tab
    },

    inactive_tab = {
        bg_color = "#26233a", -- Background for inactive tabs
        fg_color = "#908caa", -- Foreground for inactive tabs
    },

    inactive_tab_hover = {
        bg_color = "#3e3859", -- Background when hovering over an inactive tab
        fg_color = "#e0def4", -- Foreground when hovering
    },

    new_tab = {
        bg_color = "#191724", -- Background for the 'new tab' button
        fg_color = "#eb6f92", -- Accent color for the 'new tab' button
    },

    new_tab_hover = {
        bg_color = "#3e3859", -- Background when hovering over the 'new tab' button
        fg_color = "#eb6f92", -- Accent color for the hover state
    },
}

-- Add highlight color when selecting text
-- TODO: set this up so that it switches with term theme
config.colors = {
    -- Set the Rose Pine theme selection colors
    selection_fg = "#e0def4", -- Use 'text' color for the selection foreground
    selection_bg = "#26233a", -- Use 'overlay' color for the selection background

    -- Set the cursor colors to fit the theme
    cursor_fg = "#191724", -- Use 'base' color for cursor foreground
    cursor_bg = "#e0def4", -- Use 'text' color for cursor background
    tab_bar = tab_colors,
}

local default_window_padding = {
    left = "2cell",
    right = "2cell",
    top = "2cell",
    bottom = "2cell",
}

local nvim_window_padding = {
    left = "0cell",
    right = "0cell",
    top = "0cell",
    bottom = "0cell",
}

config.window_padding = default_window_padding

local function set_padding(window, enter_event)
    local overrides = window:get_config_overrides() or {}

    if enter_event then
        overrides.window_padding = nvim_window_padding
    else
        overrides.window_padding = nil
    end

    window:set_config_overrides(overrides)
end

wezterm.on("user-var-changed", function(window, _, name, value)
    if name == "NVIM_EVENT" then
        local enter_event = value == "IN"
        set_padding(window, enter_event)
    end

    return false
end)

return config
