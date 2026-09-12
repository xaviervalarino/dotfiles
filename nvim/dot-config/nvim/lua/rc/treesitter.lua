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

-- Fallback SDKROOT to Command Line Tools SDK to avoid Xcode TAPI arm64e
-- linker errors when nvim-treesitter compiles C parsers
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

-- Register aliases for common filetypes that share parsers
pcall(vim.treesitter.language.register, "bash", "env")
pcall(vim.treesitter.language.register, "bash", "zsh")

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if vim.startswith(ev.file, "blink-cmp") or vim.startswith(ev.file, "oil:") then
            return
        end

        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        local has_parser = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0

        if has_parser then
            pcall(vim.treesitter.start, ev.buf, lang)
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
