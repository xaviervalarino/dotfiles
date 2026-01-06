-- diagnostics
vim.keymap.set("n", "[d", function()
    if not vim.g.vscode then
        vim.diagnostic.jump({ count = 1, float = true })
    else
        return "<F8>"
    end
end, { desc = "Go to previous [D]iagnostic message" })

vim.keymap.set("n", "]d", function()
    if not vim.g.vscode then
        vim.diagnostic.jump({ count = -1, float = true })
    else
        return "S-<F8>"
    end
end, { desc = "Go to previous [D]iagnostic message" })

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

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
