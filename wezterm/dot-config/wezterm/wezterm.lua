local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrains Mono")
config.font_size = 15

config.window_decorations = "RESIZE"
config.window_content_alignment = {
    horizontal = "Center",
    vertical = "Bottom",
}

config.force_reverse_video_cursor = true

local kanso_ink_colors = {
    foreground = "#C5C9C7",
    background = "#14171d",

    cursor_bg = "#C5C9C7",
    cursor_fg = "#14171d",
    cursor_border = "#C5C9C7",

    selection_fg = "#C5C9C7",
    selection_bg = "#393B44",

    scrollbar_thumb = "#393B44",
    split = "#393B44",

    ansi = {
        "#14171d",
        "#C4746E",
        "#8A9A7B",
        "#C4B28A",
        "#8BA4B0",
        "#A292A3",
        "#8EA4A2",
        "#A4A7A4",
    },
    brights = {
        "#A4A7A4",
        "#E46876",
        "#87A987",
        "#E6C384",
        "#7FB4CA",
        "#938AA9",
        "#7AA89F",
        "#C5C9C7",
    },
    tab_bar = {
        background = "#14171d",
        active_tab = {
            bg_color = "#14171d",
            fg_color = "#7AA89F",
            intensity = "Bold",
        },

        inactive_tab = {
            bg_color = "#14171d",
            fg_color = "#A4A7A4",
            intensity = "Half",
        },
    },
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

local kanso_ink = {
    background = "#14171d",
    foreground = "#C5C9C7",
    muted = "#6E7370",
    highlight = "#393B44",
    faded = "#1A1C22",
}

-- TODO: set this up so that it switches with term theme
config.colors = kanso_ink_colors

local default_padding = {
    left = 36,
    right = 36,
    top = 32,
    bottom = 32,
}

-- Remove padding when editing inside nvim
wezterm.on("update-right-status", function(window, pane)
    local process = pane:get_foreground_process_name()

    if process:find("nvim") then
        window:set_config_overrides({
            window_padding = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0,
            },
        })
    else
        window:set_config_overrides({
            window_padding = default_padding,
        })
    end
end)

config.window_close_confirmation = "NeverPrompt"

return config
