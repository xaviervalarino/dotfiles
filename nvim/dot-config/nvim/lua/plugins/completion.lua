if vim.g.vscode then
    return {}
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "onsails/lspkind.nvim",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    },
    lazy = false,
    config = function()
        require("rc.completion")
    end,
}
