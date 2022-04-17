local M = {}

---Select app by name
---launch or focus app by its name
---@param name string the name of the app
---@return boolean did the application launch or focus
function M.app_select(name)
  return function()
    hs.application.launchOrFocus(name)
  end
end

return M
