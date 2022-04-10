local M = {}
local buffer_path = vim.fn.expand '%:p'

-- TODO: add a check if:
-- * Hammerspoon is installed?
-- * Hammerspoon IPC is active?
-- eg: if hs -c => 'can't access Hammerspoon message port Hammerspoon; is it running with the ipc module loaded?'
-- print(vim.fn.system 'hs -c package.path')

local hs_version = vim.fn.system('hs -c _VERSION'):gsub('[\n\r]', '')
local hs_path = vim.split(vim.fn.system('hs -c package.path'):gsub('[\n\r]', ''), ';')
table.insert(hs_path, 'lua/?.lua')
table.insert(hs_path, 'lua/?/init.lua')

local project_config = {
  ['.config/nvim'] = require('lua-dev').setup(),
  ['.hammerspoon'] = {
    settings = {
      Lua = {
        runtime = {
          version = hs_version,
          path = hs_path,
        },
        diagnostics = { globals = { 'hs' } },
        workspace = {
          library = {
            string.format('%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations', os.getenv 'HOME'),
          },
        },
      },
    },
  },
}

for dir, config in pairs(project_config) do
  if buffer_path:match(dir) then
    M = config
  end
end

return M
