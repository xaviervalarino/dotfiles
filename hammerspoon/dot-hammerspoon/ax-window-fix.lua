local M = {}

local AX_WINDOW_FIX_METHODS = {
  'maximize',
  'move',
  'moveToUnit',
  'setFrame',
  'toUnitRect',
}

---Temporarily disabled Apple's `AXEnhancedUserInterface` accessibility features
---which cause janky window movements and resizing
local function toggle_window_ax(window, fn, ...)
  local ax_app = hs.axuielement.applicationElement(window:application())
  local was_enhanced = ax_app.AXEnhancedUserInterface

  if was_enhanced then
    ax_app.AXEnhancedUserInterface = false
  end

  local result = fn(window, ...)

  if was_enhanced then
    ax_app.AXEnhancedUserInterface = true
  end

  return result
end

local metatable = {
  __index = function(self, key)
    local value = self.window[key]
    local is_patch_method = hs.fnutils.contains(AX_WINDOW_FIX_METHODS, key)

    if type(value) == 'function' then
      if is_patch_method then
        return function(_, ...)
          return toggle_window_ax(self.window, value, ...)
        end
      end

      return function(_, ...)
        return value(self.window, ...)
      end
    else
      return value
    end
  end,
}

---@param hs_window any A hammerspoon window instance
M._init = function(hs_window)
  local instance = {}
  instance.window = hs_window
  setmetatable(instance, metatable)
  return instance
end

setmetatable(M, {
  __call = function(self, ...)
    return self._init(...)
  end,
})

return M
