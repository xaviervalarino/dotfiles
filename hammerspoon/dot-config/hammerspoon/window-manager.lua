local window_fix = require("ax-window-fix")

local M = {}

hs.window.animationDuration = 0
hs.application.enableSpotlightForNameSearches(true)

function M.left()
    local win = window_fix(hs.window.focusedWindow())
    win:moveToUnit({ 0, 0, 0.5, 1 })
end

function M.down()
    local win = window_fix(hs.window.focusedWindow())
    win:moveToUnit({ 0, 0.5, 1, 0.5 })
end

function M.up()
    local win = window_fix(hs.window.focusedWindow())
    win:moveToUnit({ 0, 0, 1, 0.5 })
end

function M.right()
    local win = window_fix(hs.window.focusedWindow())
    win:moveToUnit({ 0.5, 0, 0.5, 1 })
end

function M.center()
    local win = window_fix(hs.window.focusedWindow())
    win:moveToUnit({ 0.1, 0.1, 0.8, 0.8 })
end

function M.fill()
    local win = window_fix(hs.window.focusedWindow())
    win:maximize()
end

function M.toggle_show_desktop()
    hs.spaces.toggleShowDesktop()
end

function M.move_to_next_display()
    local win = window_fix(hs.window.focusedWindow())
    local screen = win:screen()
    print("move to next", hs.inspect(screen))
    win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end

local function mod_curr_win(callback)
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local max = win:screen():frame()
    win:setFrame(callback(frame, max), 0)
end

local function increment_mod_cur_win(callback)
    local timer
    return function(start)
        if start then
            timer = hs.timer.doEvery(0.05, function()
                mod_curr_win(callback)
            end)
        else
            timer:stop()
        end
    end
end

M.grow_right = increment_mod_cur_win(function(frame, max)
    if frame.x + frame.w == max.w then
        frame.w = frame.w - 20
        frame.x = frame.x + 20
    else
        frame.w = frame.w + 20
    end
    return frame
end)

M.grow_down = increment_mod_cur_win(function(frame, max)
    if frame.h >= max.h then
        frame.h = frame.h - 20
        frame.y = frame.y + 20
    else
        frame.h = frame.h + 20
    end
    return frame
end)

M.grow_up = increment_mod_cur_win(function(frame, max)
    if frame.y <= max.y then
        frame.h = frame.h - 20
    else
        frame.y = frame.y - 20
    end
    return frame
end)

M.grow_left = increment_mod_cur_win(function(frame, max)
    if frame.x == max.x then
        frame.w = frame.w - 20
    else
        frame.x = frame.x - 20
        frame.w = frame.w + 20
    end
    return frame
end)

return M
