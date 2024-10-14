vim.diagnostic.config {
  severity_sort = true,
  float = {
    border = 'rounded',
  },
  virtual_text = {
    hl_mode = 'combine',
  },
}

local curr_options = vim.diagnostic.config() or {}

local options = vim.tbl_deep_extend('force', curr_options, {
  float = {
    format = function(diagnostic)
      local is_not_typescript = diagnostic.source ~= 'tsserver' and diagnostic.source ~= 'ts'

      if is_not_typescript then
        return diagnostic.message
      end

      -- codes: https://github.com/microsoft/typescript/blob/main/src/compiler/diagnosticmessages.json
      local formatter = require('format-ts-errors')[diagnostic.code]
      local message = formatter and formatter(diagnostic.message) or diagnostic.message

      return message
    end,
  },
})

vim.diagnostic.config(options)
