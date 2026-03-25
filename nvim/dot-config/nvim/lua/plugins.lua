local headless_plugins = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("rc.treesitter")
        end,
    },
    {
        "tpope/vim-sleuth",
    },
    {
        "nvim-mini/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup()
        end,
    },
    {
        "nvim-mini/mini.pairs",
        version = false,
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {

        "nvim-mini/mini.surround",
        version = false,
        config = function()
            require("mini.surround").setup({
                n_lines = 200,
            })
        end,
    },
    {
        "gbprod/yanky.nvim",
        config = function()
            require("rc.yanky")
        end,
    },
    {
        "nvim-mini/mini.comment",
        version = false,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("rc.comment")
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "html",
            "javascriptreact",
            "typescriptreact",
        },
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },
    {
        "cbochs/grapple.nvim",
        config = function()
            require("rc.grapple")
        end,
    },
}

if vim.g.vscode then
    return headless_plugins
end

local nvim_plugins = {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "yioneko/nvim-vtsls",
            "marilari88/twoslash-queries.nvim",
        },
        config = function()
            require("rc.lsp")
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-mini/mini.icons" },
        },
        config = function()
            require("rc.telescope")
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        config = function()
            require("rc.completion")
        end,
    },
    {
        "nvim-mini/mini.diff",
        version = false,
        config = function()
            local diff = require("mini.diff")
            diff.setup({
                view = { style = "sign" },
            })
            vim.keymap.set("n", "dh", diff.toggle_overlay, { desc = "Toggle [d]iff [h]unks" })
        end,
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        config = function()
            require("rc.gitblame")
        end,
    },
    {
        "nvim-mini/mini-git",
        version = false,
        main = "mini.git",
        config = function()
            require("mini.git").setup()
        end,
    },
    {
        "nvim-mini/mini.hipatterns",
        version = false,
        config = function()
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
    {
        "nvim-mini/mini.animate",
        version = false,
        config = function()
            require("rc.animate")
        end,
    },
    {
        "nvim-mini/mini.indentscope",
        version = false,
        config = function()
            require("mini.indentscope").setup({
                draw = {
                    delay = 0,
                    animation = function()
                        return 0
                    end,
                },
                symbol = "│",
            })
        end,
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        config = true,
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-mini/mini.icons" },
        config = function()
            require("rc.oil")
        end,
    },
    {
        "nvim-mini/mini.clue",
        version = false,
        config = function()
            require("rc.clue")
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre " },
        cmd = { "ConformInfo" },
        config = function()
            require("rc.conform")
        end,
    },
    {
        "davidosomething/format-ts-errors.nvim",
        event = {
            "LspNotify *.ts",
            "LspNotify *.tsx",
        },
        after = function()
            require("rc.format-ts-errors")
        end,
    },
    {
        "folke/zen-mode.nvim",
        dependencies = {
            "folke/twilight.nvim",
        },
        cmd = "ZenMode",
        keys = {
            { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
        },
        config = function()
            require("rc.zenmode")
        end,
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("rc.diffview")
        end,
    },
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("rc.aerial")
        end,
    },
    {

        "saecki/live-rename.nvim",
        config = function()
            require("rc.rename")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("rc.treesitter-context")
        end,
    },
    {
        "dmmulroy/tsc.nvim",
        config = function()
            require("tsc").setup()
        end,
    },
}

return vim.iter({ headless_plugins, nvim_plugins }):flatten():totable()
