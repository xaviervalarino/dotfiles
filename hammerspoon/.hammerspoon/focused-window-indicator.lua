local M = {}

M.canvas = (function()
  local max = hs.screen.mainScreen():fullFrame()
  local canvas = hs.canvas.new { x = max.x, y = max.y, h = max.h, w = max.w }
  canvas:appendElements {
    type = 'rectangle',
    action = 'fill',
    fillColor = { red = 0, green = 0, blue = 0, alpha = 0.6 },
    frame = { x = max.x, y = max.y, h = max.h, w = max.w },
  }
  canvas:level 'normal'
  return canvas
end)()

M.on = function()
  hs.window.focusedWindow():raise()
  M.canvas:show(0.4)
end

M.off = function()
  M.canvas:hide(0.4)
end

return M
