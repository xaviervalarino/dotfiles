if not vim.g.vscode then
    return
end

vim.keymap.set("n", "<leader>rn", function()
    vim.fn.VSCodeNotify("editor.action.rename")
end, { desc = "Rename symbol in VSCode" })
