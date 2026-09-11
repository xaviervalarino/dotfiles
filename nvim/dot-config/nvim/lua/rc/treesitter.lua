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

if vim.fn.isdirectory("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk") == 1 then
    vim.env.SDKROOT = vim.env.SDKROOT or "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
end

vim.schedule(function()
    local missing = vim.tbl_filter(function(lang)
        return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) == 0
    end, parsers)
    if #missing > 0 then
        ts.install(missing)
    end
end)

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if vim.startswith(ev.file, "blink-cmp") or vim.startswith(ev.file, "oil:") then
            return
        end

        -- Start treesitter with highlighting
        local _, err = pcall(vim.treesitter.start, ev.buf)

        if err then
            return print("[ERROR] TREESITTER", ev.file, err)
        end

        -- Use treesitter indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
