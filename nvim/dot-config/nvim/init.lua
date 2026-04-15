vim.o.showbreak = "↪"
vim.opt.listchars:append({
    space = "·",
    tab = "→ ",
    eol = "¬",
    nbsp = "␣",
    trail = "•",
    extends = "⟩",
    precedes = "⟨",
})

vim.o.autowriteall = true

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Visual -------------------------
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1" -- Add padding to wrapped lists
vim.o.relativenumber = true
vim.o.number = true
vim.o.cursorline = true
vim.o.wrap = false
vim.o.scrolloff = 10
vim.wo.signcolumn = "yes"

vim.opt.fillchars = { diff = "╱" }
-- set.fillchars = {
--   horiz = '━',
--   horizup = '┻',
--   horizdown = '┳',
--   vert = '┃',
--   vertleft = '┫',
--   vertright = '┣',
--   verthoriz = '╋',
-- }
vim.opt.shortmess:append("c") -- don't give `ins-completion-menu` messages
vim.opt.shortmess:append("s") -- don't give "search hit BOTTOM, continuing at TOP"
vim.opt.shortmess:append("C") -- don't give messages while scanning for ins-completion
vim.opt.shortmess:append("S") -- do not show search count message when searching

-- Search ------------------------------
vim.o.ignorecase = true
vim.o.smartcase = true

-- Save / Swap / Undo ------------------
-- Leave buffers open in the background
vim.o.hidden = true
-- Turn off swap and turn on undo history
vim.o.swapfile = false
vim.o.undofile = true

-- Tabs --------------------------------
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.expandtab = true

-- Window splits -----------------------
vim.o.splitbelow = true
vim.o.splitright = true

-- Completion --------------------------
vim.opt.completeopt = { "menu,menuone,noselect" }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim --------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

if not vim.g.vscode then
    vim.o.mouse = "a"
    vim.o.spell = true
    vim.o.linebreak = true
    vim.o.laststatus = 3
    vim.g.netrw_banner = 0
    vim.o.winborder = "solid"

    -- TODO: FT for UI elements does not work with treesitter
    -- require("vim._core.ui2").enable({ enable = true })
end
