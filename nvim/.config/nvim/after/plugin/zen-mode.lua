require('zen-mode').setup {
  window = {
    backdrop = 1,
    width = 80,
  },
  plugins = {
    -- requires `allow_remote_control` and 'listen_on' to be set
    kitty = {
      enabled = true,
      font = '+1',
    },
  },
}
