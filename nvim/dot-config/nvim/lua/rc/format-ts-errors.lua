-- Initialize ts-error-translator without auto_attach so it doesn't overwrite
-- raw inline diagnostics, allowing us to combine translation + pretty details in hover.
pcall(function()
    require("ts-error-translator").setup({
        auto_attach = false,
    })
end)

pcall(function()
    require("format-ts-errors").setup({
        add_markdown = true,
        start_indent_level = 0,
    })
end)

vim.diagnostic.config({
    severity_sort = true,
    float = {
        border = "rounded",
    },
    virtual_text = {
        hl_mode = "combine",
        prefix = function()
            return "●"
        end,
    },
})

local curr_options = vim.diagnostic.config() or {}

local options = vim.tbl_deep_extend("force", curr_options, {
    float = {
        format = function(diagnostic)
            local src = diagnostic.source or ""
            local is_ts = src == "vtsls" or src == "typescript" or src == "tsserver" or src == "ts"

            if not is_ts then
                return diagnostic.message
            end

            local original = diagnostic.message

            -- 1. Format the detailed TypeScript error
            local formatter = require("format-ts-errors")[diagnostic.code]
            local pretty = formatter and formatter(original) or original

            -- 2. Extract the plain-English translation
            local message_with_code = diagnostic.code and ("TS" .. tostring(diagnostic.code) .. ": " .. original)
                or original
            local ok, translator = pcall(require, "ts-error-translator.parser")
            if ok then
                local parsed = translator.parse_errors(message_with_code)
                if #parsed > 0 and parsed[1].improvedError and parsed[1].improvedError.body then
                    local translation = parsed[1].improvedError.body
                    -- Translation above, separator, pretty formatted details below
                    return "💡 " .. translation .. "\n" .. string.rep("─", 44) .. "\n" .. pretty
                end
            end

            return pretty
        end,
    },
})

vim.diagnostic.config(options)

-- Ensure floating diagnostic window renders markdown with syntax highlighting & concealed links
local orig_open_float = vim.diagnostic.open_float
vim.diagnostic.open_float = function(...)
    local float_bufnr, winnr = orig_open_float(...)

    if float_bufnr and vim.api.nvim_buf_is_valid(float_bufnr) then
        vim.api.nvim_buf_clear_namespace(float_bufnr, -1, 0, -1)
        vim.bo[float_bufnr].filetype = "markdown"

        pcall(vim.treesitter.start, float_bufnr, "markdown")

        if winnr and vim.api.nvim_win_is_valid(winnr) then
            vim.wo[winnr].conceallevel = 2
            vim.wo[winnr].concealcursor = "c"
        end
    end

    return float_bufnr, winnr
end
