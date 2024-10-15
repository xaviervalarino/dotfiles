if vim.g.vscode then
    return {}
end

return {
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
}
