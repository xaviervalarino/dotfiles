local kanso_themes = {
    mist = {
        foreground = "#C5C9C7",
        background = "#22262D",

        cursor_bg = "#C5C9C7",
        cursor_fg = "#22262D",
        cursor_border = "#C5C9C7",

        selection_fg = "#C5C9C7",
        selection_bg = "#43464E",

        scrollbar_thumb = "#43464E",
        split = "#43464E",

        ansi = {
            "#22262D",
            "#C4746E",
            "#8A9A7B",
            "#C4B28A",
            "#8BA4B0",
            "#A292A3",
            "#8EA4A2",
            "#a4a7a4",
        },
        brights = {
            "#5C6066",
            "#E46876",
            "#87A987",
            "#E6C384",
            "#7FB4CA",
            "#938AA9",
            "#7AA89F",
            "#C5C9C7",
        },
    },
    ink = {
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
    },
    zen = {
        foreground = "#C5C9C7",
        background = "#090E13",

        cursor_bg = "#090E13",
        cursor_fg = "#C5C9C7",
        cursor_border = "#C5C9C7",

        selection_fg = "#C5C9C7",
        selection_bg = "#22262D",

        scrollbar_thumb = "#22262D",
        split = "#22262D",

        ansi = {
            "#090E13",
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
    },
}

local function get_tab_bar_color(theme)
    return {
        background = theme.background,
        active_tab = {
            bg_color = theme.background,
            fg_color = theme.brights[7],
            intensity = "Bold",
        },
        inactive_tab = {
            bg_color = theme.background,
            fg_color = theme.ansi[8],
            intensity = "Half",
        },
    }
end

-- Build the callable & indexable table:
local theme = {}

setmetatable(theme, {
    __index = function(_, name)
        local t = kanso_themes[name]
        if not t then
            error(("Theme '%s' not found"):format(tostring(name)))
        end

        -- shallow copy
        local result = {}
        for k, v in pairs(t) do
            result[k] = v
        end

        result.tab_bar = get_tab_bar_color(t)

        return result
    end,
})

return theme
