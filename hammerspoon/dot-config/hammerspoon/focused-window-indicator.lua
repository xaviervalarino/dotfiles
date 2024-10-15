local M = {}

local function create_canvases()
    local canvases = {}
    for _, screen in ipairs(hs.screen.allScreens()) do
        local max = screen:fullFrame()
        local canvas = hs.canvas.new({ x = max.x, y = max.y, h = max.h, w = max.w })
        local relative = screen:absoluteToLocal(max)
        canvas:appendElements({
            type = "rectangle",
            action = "fill",
            fillColor = { red = 0, green = 0, blue = 0, alpha = 0.6 },
            frame = { x = relative.x, y = relative.y, h = relative.h, w = relative.w },
        })
        canvas:level("normal")
        canvases[screen:name()] = canvas
    end
    return canvases
end
M.canvases = create_canvases()

Screen_watcher = hs.screen.watcher.new(function()
    M.canvases = create_canvases()
end)
Screen_watcher:start()

M.on = function()
    -- TODO: Hammerspoon console does not get recognized as focusedWindow
    hs.window.focusedWindow():raise()
    for _, canvas in pairs(M.canvases) do
        print(hs.inspect(canvas.hide))
        canvas:show(0.4)
    end
end

M.off = function()
    hs.window.focusedWindow():raise()
    for _, canvas in pairs(M.canvases) do
        canvas:hide(0.4)
    end
end

return M
