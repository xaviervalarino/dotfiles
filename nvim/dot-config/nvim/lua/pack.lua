-- Native package manager configuration (Neovim 0.12+)
-- Replaces lazy.nvim with built-in vim.pack

-- Ensure packpath includes site directory where vim.pack installs plugins
local site_dir = vim.fn.stdpath("data") .. "/site"
local current_packpath = vim.opt.packpath:get()
local found = false
for _, p in ipairs(current_packpath) do
    if p == site_dir then
        found = true
        break
    end
end
if not found then
    vim.opt.packpath:append(site_dir)
end

-- Build hooks for native plugins
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
            vim.system({ "make" }, { cwd = ev.data.path }):wait()
        end
    end,
})

-- Headless plugins (shared between TUI and VSCode)
local specs = {
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/tpope/vim-sleuth" },
    { src = "https://github.com/nvim-mini/mini.ai" },
    { src = "https://github.com/nvim-mini/mini.pairs" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    { src = "https://github.com/gbprod/yanky.nvim" },
    { src = "https://github.com/nvim-mini/mini.comment" },
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/cbochs/grapple.nvim" },
}

if not vim.g.vscode then
    local nvim_specs = {
        { src = "https://github.com/projekt0n/github-nvim-theme" },
        { src = "https://github.com/neovim/nvim-lspconfig" },
        { src = "https://github.com/yioneko/nvim-vtsls" },
        { src = "https://github.com/marilari88/twoslash-queries.nvim" },
        { src = "https://github.com/folke/lazydev.nvim" },
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/nvim-telescope/telescope.nvim" },
        { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
        { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
        { src = "https://github.com/nvim-mini/mini.icons" },
        { src = "https://github.com/rafamadriz/friendly-snippets" },
        { src = "https://github.com/saghen/blink.cmp", version = "v1.*" },
        { src = "https://github.com/nvim-mini/mini.diff" },
        { src = "https://github.com/f-person/git-blame.nvim" },
        { src = "https://github.com/nvim-mini/mini-git" },
        { src = "https://github.com/nvim-mini/mini.hipatterns" },
        { src = "https://github.com/nvim-mini/mini.animate" },
        { src = "https://github.com/nvim-mini/mini.indentscope" },
        { src = "https://github.com/stevearc/oil.nvim" },
        { src = "https://github.com/refractalize/oil-git-status.nvim" },
        { src = "https://github.com/nvim-mini/mini.clue" },
        { src = "https://github.com/stevearc/conform.nvim" },
        { src = "https://github.com/davidosomething/format-ts-errors.nvim" },
        { src = "https://github.com/folke/twilight.nvim" },
        { src = "https://github.com/folke/zen-mode.nvim" },
        { src = "https://github.com/sindrets/diffview.nvim" },
        { src = "https://github.com/stevearc/aerial.nvim" },
        { src = "https://github.com/saecki/live-rename.nvim" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
        { src = "https://github.com/dmmulroy/tsc.nvim" },
    }
    for _, s in ipairs(nvim_specs) do
        table.insert(specs, s)
    end
end

-- Add all plugins via native vim.pack
vim.pack.add(specs, { confirm = false })

-- Setup headless plugins
require("rc.treesitter")
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.surround").setup({ n_lines = 200 })
require("rc.yanky")
require("rc.comment")
require("nvim-ts-autotag").setup({})
require("rc.grapple")

if not vim.g.vscode then
    require("rc.theme").setup()
    require("rc.lsp")
    require("lazydev").setup({})
    require("rc.telescope")
    require("rc.completion")

    local diff = require("mini.diff")
    diff.setup({ view = { style = "sign" } })
    vim.keymap.set("n", "dh", diff.toggle_overlay, { desc = "Toggle [d]iff [h]unks" })

    require("rc.gitblame")
    require("mini.git").setup()

    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
        highlighters = {
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })

    require("rc.animate")
    require("mini.indentscope").setup({
        draw = {
            delay = 0,
            animation = function()
                return 0
            end,
        },
        symbol = "│",
    })

    require("rc.oil")
    require("oil-git-status")
    require("rc.clue")
    require("rc.conform")
    require("rc.format-ts-errors")
    require("rc.zenmode")
    require("rc.diffview")
    require("rc.aerial")
    require("rc.rename")
    require("rc.treesitter-context")
    require("tsc").setup()
end
