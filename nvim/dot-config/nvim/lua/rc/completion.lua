local icons = require("mini.icons")

require("blink.cmp").setup({
    completion = {
        documentation = { auto_show = true },
        menu = {
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local kind_icon, _, _ = icons.get("lsp", ctx.kind)
                            return kind_icon
                        end,
                        -- (optional) use highlights from mini.icons
                        highlight = function(ctx)
                            local _, hl, _ = icons.get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                    kind = {
                        -- (optional) use highlights from mini.icons
                        highlight = function(ctx)
                            local _, hl, _ = icons.get("lsp", ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
    },
    signature = { enabled = true },
    sources = {
        providers = {
            path = {
                opts = {
                    -- TODO: have this check tsconfig root dir if in a typescript project
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
        },
    },
})
