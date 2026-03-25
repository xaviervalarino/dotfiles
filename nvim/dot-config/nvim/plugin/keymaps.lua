-- Move up/down visual line blocks when text is wrapped
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")

-- diagnostics
vim.keymap.set("n", "[d", function()
    if not vim.g.vscode then
        vim.diagnostic.jump({ count = -1, float = true })
    else
        return "S-<F8>"
    end
end, { desc = "Go to previous [D]iagnostic message" })

vim.keymap.set("n", "]d", function()
    if not vim.g.vscode then
        vim.diagnostic.jump({ count = 1, float = true })
    else
        return "<F8>"
    end
end, { desc = "Go to next [D]iagnostic message" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

vim.keymap.set("n", "<leader>q", function()
    if not vim.g.vscode then
        vim.diagnostic.setloclist()
    else
        require("vscode").action("workbench.action.problems.focus")
    end
end, { desc = "Open diagnostic [Q]uickfix list" })

-- copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

-- clear search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", function()
    if not vim.g.vscode then
        return "<C-w><C-h>"
    else
        require("vscode").action("workbench.action.focusLeftGroup")
    end
end, { desc = "Move focus to the left window" })

vim.keymap.set("n", "<C-l>", function()
    if not vim.g.vscode then
        return "<C-w><C-l>"
    else
        require("vscode").action("workbench.action.focusRightGroup")
    end
end, { desc = "Move focus to the right window" })

vim.keymap.set("n", "<C-j>", function()
    if not vim.g.vscode then
        return "<C-w><C-j>"
    else
        require("vscode").action("workbench.action.focusBelowGroup")
    end
end, { desc = "Move focus to the lower window" })

vim.keymap.set("n", "<C-k>", function()
    if not vim.g.vscode then
        return "<C-w><C-k>"
    else
        require("vscode").action("workbench.action.focusAboveGroup")
    end
end, { desc = "Move focus to the upper window" })
