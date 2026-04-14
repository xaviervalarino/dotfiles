local ts = require("nvim-treesitter")
local parsers = {
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
    "jsx",
    "json",
    "json5",
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
    "tsx",
    "xml",
    "yaml",
}

vim.schedule(function()
    ts.install(parsers)
end)

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if vim.startswith(ev.file, "blink-cmp") then
            return
        end

        -- Start treesitter with highlighting
        local _, err = pcall(vim.treesitter.start, ev.buf)

        if err then
            return print(err)
        end

        -- Use treesitter indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
