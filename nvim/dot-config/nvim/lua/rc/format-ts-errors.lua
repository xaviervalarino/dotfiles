-- Initialize ts-error-translator without auto_attach so it doesn't overwrite
-- raw inline diagnostics, allowing us to combine translation + pretty details in hover.
pcall(function()
    require("ts-error-translator").setup({
        auto_attach = false,
    })
end)

vim.diagnostic.config({
    severity_sort = true,
    float = {
        border = "rounded",
    },
    virtual_text = {
        hl_mode = "combine",
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
