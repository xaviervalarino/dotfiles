require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

local previewers = require("telescope.previewers")
local delta = previewers.new_termopen_previewer({
    get_command = function(entry)
        local path = entry.value or entry.path
        if not path or path == "" then
            return nil
        end
        if entry.status and entry.status:find("?") then
            return {
                "sh",
                "-c",
                "git diff --no-index -- /dev/null "
                    .. vim.fn.shellescape(path)
                    .. " 2>/dev/null | delta --paging=never",
            }
        end
        return { "sh", "-c", "git diff HEAD -- " .. vim.fn.shellescape(path) .. " 2>/dev/null | delta --paging=never" }
    end,
})

require("telescope").setup({
    defaults = {
        borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        layout_config = {
            prompt_position = "top",
            preview_cutoff = 0,
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            vertical = {
                prompt_position = "top",
                mirror = true,
                preview_height = 0.65,
            },
            flex = {
                flip_columns = 120,
            },
        },
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
    },
    pickers = {
        git_status = {
            previewer = delta,
            git_icons = {
                added = "A",
                changed = "M",
                copied = "C",
                deleted = "D",
                renamed = "R",
                unmerged = "U",
                untracked = "?",
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")

-- Custom git_status entry maker that adds +N -N line counts to file list
local function make_git_status_entry_maker()
    local stats = {}
    local function parse_lines(cmd)
        local lines = vim.fn.systemlist(cmd)
        for _, line in ipairs(lines) do
            local add, del, file = line:match("^(%d+)%s+(%d+)%s+(.+)$")
            if file then
                if stats[file] then
                    stats[file].add = stats[file].add + (tonumber(add) or 0)
                    stats[file].del = stats[file].del + (tonumber(del) or 0)
                else
                    stats[file] = { add = tonumber(add) or 0, del = tonumber(del) or 0 }
                end
            end
        end
    end
    parse_lines("git diff --numstat HEAD 2>/dev/null")
    parse_lines("git diff --cached --numstat 2>/dev/null")

    local make_entry = require("telescope.make_entry")
    local entry_display = require("telescope.pickers.entry_display")
    local utils = require("telescope.utils")

    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 2 },
            {
                width = function(_, cols)
                    return math.max(1, cols - 17)
                end,
            },
            { width = 6, right_justify = true },
            { width = 6, right_justify = true },
        },
    })

    local default_maker = make_entry.gen_from_git_status()

    return function(line)
        local entry = default_maker(line)
        if not entry then
            return nil
        end

        entry.display = function(e)
            local stat = stats[e.value]
            local add_str = (stat and stat.add > 0) and ("+" .. stat.add) or ""
            local del_str = (stat and stat.del > 0) and ("-" .. stat.del) or ""

            local x = string.sub(e.status, 1, 1)
            local y = string.sub(e.status, -1)
            local char = (x ~= " " and x) or (y ~= " " and y) or "?"
            local hl_map = {
                A = "TelescopeResultsDiffAdd",
                M = "TelescopeResultsDiffChange",
                D = "TelescopeResultsDiffDelete",
                ["?"] = "TelescopeResultsDiffUntracked",
            }
            local status_hl = hl_map[char] or "TelescopeResultsNormal"
            local display_path, path_style = utils.transform_path({}, e.value)

            return displayer({
                { e.status, status_hl },
                {
                    display_path,
                    function()
                        return path_style
                    end,
                },
                { add_str, "diffAdded" },
                { del_str, "diffRemoved" },
            })
        end

        return entry
    end
end

local orig_git_status = builtin.git_status
builtin.git_status = function(opts)
    opts = opts or {}
    opts.entry_maker = opts.entry_maker or make_git_status_entry_maker()
    return orig_git_status(opts)
end

vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[g]it [s]tatus" })
vim.keymap.set("n", "<leader>sr", builtin.lsp_references, { desc = "[s]earch [r]eferences" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "[s]earch [r]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] find existing buffers" })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    })
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- HACK fix 0.11 winborder issue: https://github.com/nvim-telescope/telescope.nvim/issues/3436
vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopeFindPre",
    callback = function()
        local default_winborder = vim.opt.winborder:get()

        vim.opt_local.winborder = "none"
        vim.api.nvim_create_autocmd("WinLeave", {
            once = true,
            callback = function()
                vim.opt_local.winborder = default_winborder
            end,
        })
    end,
})
