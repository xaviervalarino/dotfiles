-- Node version managers (fnm, nvm, volta) use ephemeral shell paths that
-- Neovim may not inherit. Resolve the real bin directory from the `node`
-- binary so npm-installed LSP servers are always found.
local node = vim.fn.exepath("node")
if node ~= "" then
    local real = vim.uv.fs_realpath(node)
    if real then
        local bin_dir = vim.fs.dirname(real)
        if not vim.env.PATH:find(bin_dir, 1, true) then
            vim.env.PATH = bin_dir .. ":" .. vim.env.PATH
        end
    end
end

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("eslint", {
    format = false,
    workingDirectory = {
        mode = "auto",
    },
})

vim.lsp.enable("eslint")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                command = "LspEslintFixAll",
            })
        end
    end,
})

vim.lsp.enable("graphql")

vim.lsp.enable("gopls")

vim.lsp.config("html", {
    capabilities = capabilities,
})
vim.lsp.enable("html")

vim.lsp.config("jsonls", {
    capabilities = capabilities,
})
vim.lsp.enable("jsonls")

vim.lsp.config("cssls", {
    capabilities = capabilities,
})
vim.lsp.enable("cssls")
vim.lsp.enable("cssmodules_ls")
-- TODO: test out this language server:
-- npm i -g css-variables-language-server
-- Need to fix permissions for installing global packages
vim.lsp.enable("css_variables")

vim.lsp.enable("somesass_ls")

vim.lsp.config("lua_ls", {
    --     settings = {
    --         Lua = {
    --             diagnostics = {
    --                 globals = { "vim" },
    --                 disable = { "missing-fields" },
    --             },
    --         },
    --     },
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library'
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --   vim.api.nvim_get_runtime_file('', true),
                -- }
            },
        })
    end,
    settings = {
        Lua = {
            diagnostics = {
                disable = { "missing-fields" },
            },
        },
    },
})
vim.lsp.enable("lua_ls")

require("lspconfig.configs").vtsls = require("vtsls").lspconfig
require("lspconfig").vtsls.setup({
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
})

vim.lsp.config("tailwindcss", {
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        -- Use the git root so the server can find hoisted node_modules in monorepos
        on_dir(vim.fs.root(fname, ".git"))
    end,
})
vim.lsp.enable("tailwindcss")
