local alert = require('util').alert

local M = {}

---Create new modal object
---Used to create new modalities that can be 'chorded' mnemonically
---@param mod string modifier keys
---@param key string keycode
---@return table modal the new modal object
function M:new(mod, key)
  local this = self
  this.ready_mode = hs.hotkey.modal.new(mod, key)
  this.active_mode = nil
  this.alert_id = nil

  this.ready_mode:bind('', 'escape', function()
    this.ready_mode:exit()
  end)

  function this.ready_mode:entered()
    if this.active_mode then
      this.active_mode:exit()
    end
    this.alert_id = alert('   ready...  ', true)
    hs.timer.doAfter(2, function()
      this.ready_mode:exit()
    end)
  end

  function this.ready_mode:exited()
    if this.alert_id then
      hs.alert.closeSpecific(this.alert_id)
    end
  end

  return this
end

---Create new modality
---@param key string single key code to enter the mode
---@param name string the name of the mode, shown when entering the mode
---@return table hs.hotkey.modal object
function M:create(key, name)
  local mode = hs.hotkey.modal.new()
  local alert_id

  function mode:entered()
    alert_id = alert(name, true)
    hs.timer.doAfter(2, function()
      mode:exit()
    end)
  end

  function mode:exited()
    self.active_mode = nil
    hs.alert.closeSpecific(alert_id)
  end

  mode:bind('', 'escape', function()
    mode:exit()
  end)

  self.ready_mode:bind('', key, function()
    self.ready_mode:exit()
    mode:enter()
    self.active_mode = mode
  end)

  --Key binding wrapper that works with this mode
  --@param ... any arguments used on hs.hotkey bind, except `msg`
  --@return table hs.hotkey
  function mode:chord(...)
    local args = { ... }
    -- if no modifier keys
    if type(args[2]) == 'function' then
      table.insert(args, 1, '')
    end
    return self:bind(args[1], args[2], function()
      args[3]()
      mode:exit()
    end, args[4], args[5])
  end

  return mode
end

return M
