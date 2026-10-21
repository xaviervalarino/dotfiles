-- Two-finger horizontal trackpad swipe + modifier steps ribbon focus left/right.
local M = {}

local RIBBON = "/Users/xavier/dev/ribbon/bin/ribbon"

M.modifier = "cmd" -- held modifier that turns a swipe into a focus step
M.threshold = 60 -- points of horizontal travel before one focus step

local props = hs.eventtap.event.properties
local SCROLL_PHASE_BEGAN = 1 -- kCGScrollPhaseBegan

-- Per-gesture state. `axis` locks on the first movement: "x" claims the gesture
-- for ribbon, "y" leaves it to the app, nil is not yet decided.
local travel, fired, axis = 0, false, nil

---@param event hs.eventtap.event
---@return boolean swallow true drops the scroll so the app underneath never sees it
local function on_scroll(event)
    -- Mouse wheels send line-based scrolls; only trackpads send continuous ones.
    if event:getProperty(props.scrollWheelEventIsContinuous) ~= 1 then
        return false
    end
    if event:getProperty(props.scrollWheelEventScrollPhase) == SCROLL_PHASE_BEGAN then
        travel, fired, axis = 0, false, nil
    end
    -- Inertia keeps arriving after the fingers lift; swallow it for a claimed swipe
    -- so it never scrolls the app underneath.
    if event:getProperty(props.scrollWheelEventMomentumPhase) ~= 0 then
        return axis == "x"
    end

    local dx = event:getProperty(props.scrollWheelEventPointDeltaAxis2)
    if axis == nil then
        if not event:getFlags()[M.modifier] then
            return false
        end
        local dy = event:getProperty(props.scrollWheelEventPointDeltaAxis1)
        if dx == 0 and dy == 0 then
            return false
        end
        axis = math.abs(dx) > math.abs(dy) and "x" or "y"
    end
    if axis ~= "x" then
        return false
    end

    travel = travel + dx
    if not fired and math.abs(travel) >= M.threshold then
        fired = true -- one step per swipe
        hs.task.new(RIBBON, nil, { "focus", travel < 0 and "right" or "left" }):start()
    end
    return true
end

-- Held on the module table: Hammerspoon stops a garbage-collected eventtap.
M.tap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, on_scroll)

function M.start()
    M.tap:start()
    return M
end

function M.stop()
    M.tap:stop()
    return M
end

return M
