require("blink.cmp").setup({
    completion = {
        documentation = { auto_show = true },
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
