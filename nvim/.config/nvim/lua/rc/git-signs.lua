local buf_keymaps = require('rc.util').buf_create_keymaps('n', 'nv', 'ox')

require('gitsigns').setup {
  signs = {},
  numhl = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local nmap, nvmap, oxmap = buf_keymaps(bufnr)

    -- stylua: ignore start

    -- Navigation
    nmap(']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true }, { desc = 'Go to next hunk'})

    nmap('[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Go to previous hunk'})

    -- Actions
    nvmap('<leader>hs', ':Gitsigns stage_hunk<CR>')
    nvmap('<leader>hr', ':Gitsigns reset_hunk<CR>')
    nmap('<leader>hS', gs.stage_buffer)
    nmap('<leader>hu', gs.undo_stage_hunk)
    nmap('<leader>hR', gs.reset_buffer)
    nmap('<leader>hp', gs.preview_hunk)
    nmap('<leader>hb', function() gs.blame_line { full = true } end)
    nmap('<leader>tb', gs.toggle_current_line_blame)
    nmap('<leader>hd', gs.diffthis)
    nmap('<leader>hD', function() gs.diffthis '~' end)
    nmap('<leader>td', gs.toggle_deleted)

    -- Text object
    oxmap('ih', ':<C-U>Gitsigns select_hunk<CR>')

    -- stylua ignore end
  end,
}
