local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.setup {
  plugins = {
    spelling = {
      enabled = true,
    },
  },
  window = {
    border = require('rc.util').float_win_style.border,
  },
}
