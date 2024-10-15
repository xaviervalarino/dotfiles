local M = {}

--- Create custom alert window
--- aligned to bottom-center
--- @param  msg string message to display in the alert
--- @param persist boolean [optional] wether to persist the alert indefinitely
--- @return string alert_id identifier for the alert window, useful when persist is true
function M.alert(msg, persist)
    local style = {
        strokeWidth = 1,
        strokeColor = { white = 0.8 },
        fillColor = { white = 1 },
        textSize = 18,
        textFont = "Iosevka Light",
        textColor = { white = 0 },
        radius = 6,
        padding = 18,
        atScreenEdge = 2,
    }
    return hs.alert.show(msg, style, persist)
end

return M
