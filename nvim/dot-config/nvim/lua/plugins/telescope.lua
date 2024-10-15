return {
    "nvim-telescope/telescope.nvim",
    enabled = not vim.g.vscode,
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
}
