local window_fix = require("ax-window-fix")

local M = {}

-- Smooth Niri-style sliding animation
hs.window.animationDuration = 0.12
hs.application.enableSpotlightForNameSearches(true)

-- Load PaperWM Spoon
local paperwm = hs.loadSpoon("PaperWM")

if paperwm then
    -- Tiling & spacing config: 8px between windows
    paperwm.window_gap = 8
    paperwm.screen_margin = 1
    paperwm.default_width = 0.5
    paperwm.window_ratios = { 0.382, 0.5, 0.618, 0.8 }

    -- Remove outer screen edge padding (leaving only 2px for the border)
    paperwm.windows.getCanvas = function(screen)
        local screen_frame = screen:frame()
        local screen_full_frame = screen:fullFrame()
        local edge_margin = 2 -- just enough for the border stroke

        local external_bar = paperwm.external_bar
        local external_bar_top = external_bar and external_bar.top
        local external_bar_bottom = external_bar and external_bar.bottom
        local frame_top = external_bar_top and screen_full_frame.y + external_bar_top or screen_frame.y
        local frame_bottom = external_bar_bottom and screen_full_frame.y2 - external_bar_bottom or screen_frame.y2
        local frame_height = frame_bottom - frame_top

        return hs.geometry.rect(
            screen_frame.x + edge_margin,
            frame_top + edge_margin,
            screen_frame.w - (edge_margin * 2),
            frame_height - (edge_margin * 2)
        )
    end

    -- Default window widths by application
    paperwm.app_widths = {
        -- Browsers: 80% width
        ["Zen Browser"] = 0.8,
        ["Zen"] = 0.8,
        ["Firefox Developer Edition"] = 0.8,
        ["Safari"] = 0.8,
        ["Google Chrome"] = 0.8,
        ["Chromium"] = 0.8,
        ["Slack"] = 0.8,

        -- Full width (100%)
        ["Code"] = 1.0,
        ["Visual Studio Code"] = 1.0,
        ["com.microsoft.VSCode"] = 1.0,
        ["Mail"] = 1.0,
        ["Figma"] = 1.0,
    }

    -- Anti-jank: Filter out utility popups, overlays, and dialogs
    paperwm.window_filter = paperwm.window_filter
        :setAppFilter("Finder", false)
        :setAppFilter("System Settings", false)
        :setAppFilter("System Preferences", false)
        :setAppFilter("1Password", false)
        :setAppFilter("Raycast", false)
        :setAppFilter("Karabiner-Elements", false)
        :setAppFilter("Karabiner-EventViewer", false)
        :setAppFilter("Activity Monitor", false)
        :setAppFilter("Hammerspoon", false)
        :setAppFilter("borders", false)

    -- Start PaperWM tiling
    paperwm:start()
end

-- Manage JankyBorders lifecycle as a PaperWM dependency
local borders_bin = "/opt/homebrew/bin/borders"
local borders_task = nil

local function start_borders()
    if hs.fs.attributes(borders_bin) then
        if borders_task and borders_task:isRunning() then
            borders_task:terminate()
        end
        borders_task = hs.task.new(borders_bin, nil, {
            "active_color=0x99c678dd", -- ~60% opacity
            "inactive_color=0x00000000",
            "width=6.0",
            "style=round",
            "hidpi=on",
        })
        borders_task:start()
    end
end

local function stop_borders()
    if borders_task and borders_task:isRunning() then
        borders_task:terminate()
        borders_task = nil
    end
end

start_borders()

hs.shutdownCallback = function()
    stop_borders()
end

local actions = paperwm and paperwm.actions.actions() or {}

-- Focus navigation (scrolls horizontal ribbon)
function M.left()
    if actions.focus_left then actions.focus_left() end
end

function M.right()
    if actions.focus_right then actions.focus_right() end
end

function M.up()
    if actions.focus_up then actions.focus_up() end
end

function M.down()
    if actions.focus_down then actions.focus_down() end
end

-- Swap / Move window in ribbon
function M.swap_left()
    if actions.swap_left then actions.swap_left() end
end

function M.swap_right()
    if actions.swap_right then actions.swap_right() end
end

function M.swap_up()
    if actions.swap_up then actions.swap_up() end
end

function M.swap_down()
    if actions.swap_down then actions.swap_down() end
end

-- Sizing & Layout
function M.center()
    if actions.center_window then actions.center_window() end
end

function M.fill()
    if actions.full_width then actions.full_width() end
end

function M.cycle_width()
    if actions.cycle_width then actions.cycle_width() end
end

function M.toggle_floating()
    if actions.toggle_floating then actions.toggle_floating() end
end

function M.slurp()
    if actions.slurp_in then actions.slurp_in() end
end

function M.barf()
    if actions.barf_out then actions.barf_out() end
end

function M.toggle_show_desktop()
    hs.spaces.toggleShowDesktop()
end

function M.move_to_next_display()
    if actions.move_window_r then
        actions.move_window_r()
    else
        local win = window_fix(hs.window.focusedWindow())
        if win then
            local screen = win:screen()
            win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
        end
    end
end

-- Cheatsheet HUD
local last_alert_id = nil
function M.toggle_cheatsheet()
    if last_alert_id then
        hs.alert.closeSpecific(last_alert_id)
        last_alert_id = nil
        return
    end

    local text = table.concat({
        "  PaperWM (w_layer) Shortcuts  ",
        "─────────────────────────────────────────",
        "w + h / l         Focus Left / Right (ribbon)",
        "w + j / k         Focus Down / Up (column)",
        "w + Shift + h / l Swap Column Left / Right",
        "w + Shift + j / k Swap Window Down / Up",
        "w + f             Toggle Float",
        "w + r             Cycle Width (38% → 50% → 62% → 80%)",
        "w + i             Slurp (pull window into column)",
        "w + o             Barf (push window out of column)",
        "w + '             Toggle Full Width",
        "w + ;             Center Window",
        "w + n             Move to Next Display",
        "w + /             Toggle This Cheatsheet",
    }, "\n")

    local style = {
        strokeWidth = 2,
        strokeColor = { red = 0.78, green = 0.47, blue = 0.87, alpha = 0.8 },
        fillColor = { red = 0.08, green = 0.09, blue = 0.12, alpha = 0.95 },
        textColor = { white = 0.98, alpha = 1.0 },
        textFont = "Menlo",
        textSize = 14,
        radius = 12,
        fadeInDuration = 0.1,
        fadeOutDuration = 0.15,
    }

    last_alert_id = hs.alert.show(text, style, hs.screen.mainScreen(), 6)
    hs.timer.doAfter(6, function()
        last_alert_id = nil
    end)
end

-- Lightweight Session Management
local session_file = os.getenv("HOME") .. "/.config/hammerspoon/paperwm_session.json"

local function session_alert(icon, title, details)
    local lines = { icon .. "  " .. title }
    if details and #details > 0 then
        table.insert(lines, "─────────────────────────────────────────")
        table.insert(lines, details)
    end
    local text = table.concat(lines, "\n")

    local style = {
        strokeWidth = 2,
        strokeColor = { red = 0.78, green = 0.47, blue = 0.87, alpha = 0.9 },
        fillColor = { red = 0.08, green = 0.09, blue = 0.12, alpha = 0.95 },
        textColor = { white = 1.0, alpha = 1.0 },
        textFont = "Menlo",
        textSize = 14,
        radius = 12,
        fadeInDuration = 0.1,
        fadeOutDuration = 0.2,
    }

    hs.alert.show(text, style, hs.screen.mainScreen(), 2.5)
end

function M.save_session()
    local session = {}
    local app_set = {}
    local app_names = {}
    local all_windows = hs.window.filter.default:getWindows()

    for _, win in ipairs(all_windows) do
        local app = win:application()
        if app and win:isVisible() and not win:isFullScreen() then
            local space = hs.spaces.windowSpaces(win)[1]
            local name = app:name()
            table.insert(session, {
                app = name,
                bundleID = app:bundleID(),
                title = win:title(),
                space = space,
            })
            if not app_set[name] then
                app_set[name] = true
                table.insert(app_names, name)
            end
        end
    end

    local file = io.open(session_file, "w")
    if file then
        file:write(hs.json.encode(session, true))
        file:close()
        local details = table.concat(app_names, ", ") .. " (" .. #session .. " windows)"
        session_alert("💾", "Session Saved", details)
    else
        session_alert("❌", "Failed to Save", "Could not write session file")
    end
end

function M.restore_session()
    local file = io.open(session_file, "r")
    if not file then
        session_alert("⚠️", "No Saved Session", "Press Spacebar + Shift + s to save one")
        return
    end

    local content = file:read("*a")
    file:close()

    local session = hs.json.decode(content)
    if not session or #session == 0 then
        session_alert("⚠️", "Session Empty", "The saved session has no windows")
        return
    end

    local app_set = {}
    local app_names = {}
    for _, item in ipairs(session) do
        local name = item.app or item.bundleID
        if name and not app_set[name] then
            app_set[name] = true
            table.insert(app_names, name)
        end
        if item.bundleID then
            hs.application.launchOrFocusByBundleID(item.bundleID)
        elseif item.app then
            hs.application.launchOrFocus(item.app)
        end
    end

    hs.timer.doAfter(0.6, function()
        if paperwm and paperwm.windows then
            paperwm.windows.refreshWindows()
        end
        local details = table.concat(app_names, ", ") .. " (" .. #session .. " windows)"
        session_alert("📂", "Session Restored", details)
    end)
end

M.start_borders = start_borders
M.stop_borders = stop_borders

return M
