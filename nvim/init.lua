local set = vim.opt
local window = vim.wo

set.showbreak = '↪'
set.listchars:append {
  space = '·',
  tab = '→ ',
  eol = '¬',
  nbsp = '␣',
  trail = '•',
  extends = '⟩',
  precedes = '⟨',
}

set.autowriteall = true

-- Visual -------------------------
set.breakindent = true
set.relativenumber = true
vim.opt.relativenumber = true
set.number = true
set.updatetime = 250
set.cursorline = true
set.wrap = false
window.signcolumn = 'yes'

vim.g.netrw_banner = 0
-- let g:netrw_browse_split = 4

set.fillchars = { diff = '╱' }

-- set.fillchars = {
--   horiz = '━',
--   horizup = '┻',
--   horizdown = '┳',
--   vert = '┃',
--   vertleft = '┫',
--   vertright = '┣',
--   verthoriz = '╋',
-- }

-- set.cmdheight = 0
set.shortmess:append 'c' -- don't give `ins-completion-menu` messages
set.shortmess:append 's' -- don't give "search hit BOTTOM, continuing at TOP"
set.shortmess:append 'C' -- don't give messages while scanning for ins-completion
set.shortmess:append 'S' -- do not show search count message when searching

-- Search ------------------------------
set.ignorecase = true
set.smartcase = true

-- Save / Swap / Undo ------------------
-- Leave buffers open in the background
set.hidden = true
-- Turn off swap and turn on undo history
set.swapfile = false
set.undofile = true

-- Tabs --------------------------------
set.shiftwidth = 2
set.softtabstop = 2
set.smartindent = true
set.expandtab = true

-- Window splits -----------------------
set.splitbelow = true
set.splitright = true

-- Completion --------------------------
set.completeopt = { 'menu,menuone,noselect' }

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- lazy.nvim --------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'plugins'

if vim.g.vscode then
  print 'VSCODE!!!!!!'
else
  set.mouse = 'a'
  set.spell = true
  set.linebreak = true
  set.laststatus = 0
  vim.cmd 'colorscheme rose-pine-moon'
  -- vim.cmd 'colorscheme rose-pine-dawn'
end
