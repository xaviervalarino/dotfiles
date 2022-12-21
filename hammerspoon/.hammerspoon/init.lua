hs.console.clearConsole()

-- Install SpoonInstall if it's not already instaled
if not pcall(hs.fs.dir, './Spoons') then
  hs.fs.mkdir './Spoons/'
end

if not hs.spoons.isInstalled 'SpoonInstall' then
  local url = 'https://raw.githubusercontent.com/Hammerspoon/Spoons/master/Source/SpoonInstall.spoon/'
  local path = './Spoons/SpoonInstall.spoon/'
  local function download_file(filename)
    os.execute(string.format('curl %s%s > %s%s', url, filename, path, filename))
  end
  hs.fs.mkdir(path)
  download_file 'init.lua'
  download_file 'docs.json'
end

hs.loadSpoon 'SpoonInstall'

-- Load Hammerspoon annotations for Sumneko LSP
spoon.SpoonInstall:andUse('EmmyLua')
URLDispather = require './url-dispatcher'

-- allow Hammerspoon to be used through CLI
-- `hs` to start REPL
-- `hs -c "{lua cmd}"` to run commands

-- TODO: would be nice to look up $HOMEBREW_PREFIX location
-- os.getenv'HOMEBREW_PREFIX' and hs.execute'echo $HOMEBREW_PREFIX' are note working
hs.ipc.cliInstall '/opt/homebrew/'

local switcher = require 'switcher'

local app_select = switcher.app_select
local goto_chrome_tab = switcher.goto_chrome_tab
local detach_chrome_tab = switcher.detach_chrome_tab

-- App launcher -----------------------------------------------------
Launch = {}
local work = nil -- hs.execute('uname -n'):find '<NAME>'

Launch.mail = work and goto_chrome_tab 'mail.google.com' or app_select 'Mail'
Launch.calendar = work and goto_chrome_tab 'calendar.google.com' or app_select 'Calendar'
Launch.meet = goto_chrome_tab 'meet.google.com'
Launch.nts = goto_chrome_tab 'nts.live'

-- Manage windows ---------------------------------------------------
WM = require 'window-manager'
WM.detach_chrome_tab = detach_chrome_tab

Indicator = require 'focused-window-indicator'

-- Handlers ---------------------------------------------------------
Thunderbolt = hs.usb.watcher.new(function(t)
  print('WATCHER ' .. t.eventType)
  if t.productName == 'USB 10/100/1000 LAN' then
    print('USB LAN ' .. t.eventType)
    hs.wifi.setPower(t.eventType == 'removed')

    -- pull all windows onto laptop monitor
    if t.eventType == 'removed' then
      (function()
        local ws = hs.window.allWindows()
        for _, w in ipairs(ws) do
          local screen = w:screen()
          w:move(w:frame():toUnitRect(screen:frame()), hs.screen.mainScreen(), true, 0)
        end
      end)()
    end
  end
end)
Thunderbolt:start()

-- Spaces -----------------------------------------------------------

---Get ordered list of space IDs
local function getSpaces()
  local t = {}
  for _, screen in ipairs(hs.screen.allScreens()) do
    for _, space in ipairs(hs.spaces.spacesForScreen(screen)) do
      table.insert(t, space)
    end
  end
  return t
end

local spaceIDs = getSpaces()
local lastActiveWindows = hs.window.filter.new():setCurrentSpace(true):getWindows()

---Go to space by it's Mission Control number
---Focuses the last focused (usually the topmost one) window for that space 
---@param number number The number as seen in Mission Control, i.e. 1-8
Spaces = function(number)
  local spaceID = spaceIDs[number]
  hs.spaces.gotoSpace(spaceID)

  -- set focus to last active window in the Space being selected
  if spaceID ~= hs.spaces.activeSpaceOnScreen() then
    for _, lastActive in ipairs(lastActiveWindows) do
      if hs.spaces.windowSpaces(lastActive)[1] == spaceID then
        return lastActive:focus()
      end
    end
  end
end

---------------------------------------------------------------------
require('util').alert '🔨 loaded'
