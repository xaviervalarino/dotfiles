local headless_config = {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "csv",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "markdown",
                    "markdown_inline",
                    "css",
                    "diff",
                    "editorconfig",
                    "git_config",
                    "git_rebase",
                    "go",
                    "graphql",
                    "html",
                    "javascript",
                    "jq",
                    "jsdoc",
                    "json",
                    "json5",
                    "jsonc",
                    "luadoc",
                    "luap",
                    "regex",
                    "ruby",
                    "rust",
                    "scss",
                    "sql",
                    "ssh_config",
                    "svelte",
                    "toml",
                    "typescript",
                    "xml",
                    "yaml",
                },
                sync_install = false,
                highlight = {
                    enable = true,
                },
                indent = { enable = true },
            })
        end,
    },
    {
        "tpope/vim-sleuth",
    },
    {
        "echasnovski/mini.ai",
        version = false,
        config = function()
            require("mini.ai").setup()
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        config = function()
            require("mini.pairs").setup({})
        end,
    },
    {

        "echasnovski/mini.surround",
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
        "echasnovski/mini.comment",
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
    return headless_config
end

return vim.tbl_extend("force", headless_config, {
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
        branch = "0.1.x",
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
            { "echasnovski/mini.icons" },
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
        "echasnovski/mini.diff",
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
        "echasnovski/mini-git",
        version = false,
        main = "mini.git",
        config = function()
            require("mini.git").setup()
        end,
    },
    {
        "echasnovski/mini.hipatterns",
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
        "echasnovski/mini.animate",
        version = false,
        config = function()
            require("rc.animate")
        end,
    },
    {
        "echasnovski/mini.indentscope",
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
        dependencies = { "echasnovski/mini.icons" },
        config = function()
            require("rc.oil")
        end,
    },
    {
        "echasnovski/mini.clue",
        version = false,
        config = function()
            require("rc.clue")
        end,
    },
    {
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
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
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("rc.copilot")
        end,
    },
})
