local lspconfig = require("lspconfig")
local get_capabilities = require("blink.cmp").get_lsp_capabilities
require("lspconfig.configs").vtsls = require("vtsls").lspconfig

local servers = {
    eslint = {
        settings = {
            format = false,
            workingDirectory = {
                mode = "auto",
            },
        },
        root_dir = lspconfig.util.find_git_ancestor,
    },
    graphql = {},
    html = {},
    jsonls = {},
    cssls = {},
    cssmodules_ls = {
        -- on_attach = function(client)
        --     client.server_capabilities.definitionProvider = false
        -- end,
    },
    -- lspconfig.css_variables =  {}
    somesass_ls = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                    disable = { "missing-fields" },
                },
            },
        },
    },
    vtsls = {
        settings = {
            typescript = {
                autoUseWorkspaceTsdk = true,
                inlayHints = {
                    parameterNames = { enabled = "literals" },
                    parameterTypes = { enabled = true },
                    variableTypes = { enabled = true },
                    propertyDeclarationTypes = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                    enumMemberValues = { enabled = true },
                },
            },
        },
        on_attach = function(client, bufnr)
            require("twoslash-queries").attach(client, bufnr)

            local cmd = require("vtsls").commands

            local function on_reject(msg_or_err)
                vim.notify(msg_or_err)
            end

            vim.keymap.set("n", "<leader>im", function()
                cmd.add_missing_imports(bufnr, function()
                    vim.notify("adding missing imports")
                    cmd.remove_unused_imports(bufnr, function()
                        vim.notify("removing unused imports")
                        cmd.sort_imports(bufnr, function()
                            vim.notify("sorting imports")
                        end, on_reject)
                    end, on_reject)
                end, on_reject)
            end, { desc = "TS: update [im]ports" })

            vim.keymap.set("n", "<leader>fa", function()
                cmd.fix_all(bufnr)
            end, { desc = "TS: [f]ix [a]ll" })

            vim.keymap.set("n", "<leader>rf", ":VtsRename % ", { desc = "TS: [r]ename [f]ile" })
        end,
    },
}

for server, config in pairs(servers) do
    config.capabilities = get_capabilities(config.capabilities)
    lspconfig[server].setup(config)
end
