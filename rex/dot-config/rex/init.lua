rex.bind("ctrl+cmd+[", "client.tab.move", { direction = "backward" })
rex.bind("ctrl+cmd+]", "client.tab.move", { direction = "forward" })
rex.bind("cmd+r", "client.config.reload")
rex.bind("shift+cmd+r", "client.tab.rename")
rex.bind("ctrl+cmd+r", "client.tab.rename")

-- Scratch shell in a floating layer
rex.bind("ctrl+cmd+enter", "pane.new_floating")

-- Diff of the focused pane's repo, in a split on the right.
-- One line-number column (new file only) fits a narrow split. Unified delta
-- leaves wrapping to the pager, which wraps into the number column, so
-- less -S cuts long lines instead (scroll with the arrow keys).
local review_diff_cmd = [[git status -sb && GIT_PAGER='delta]]
  .. [[ --features=${COLOR_PALETTE:-github}-${COLOR_MODE:-dark}]]
  .. [[ --line-numbers-left-format=""]]
  .. [[ --pager="less -RFMS --mouse"' git diff]] .. "\n"

rex.action{
  name     = "review_diff",
  title    = "Review Diff",
  keywords = "git diff delta changes",
  run      = function(ctx)
    local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
    local dir = proc and proc.foreground and proc.foreground.cwd
    local _, err = rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side      = "after",
      focus     = true,
      layout    = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = { cwd = dir, initial_input = review_diff_cmd },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}
-- ctrl+cmd+d is macOS Look Up and never reaches Rex
rex.bind("ctrl+cmd+g", "review_diff")
