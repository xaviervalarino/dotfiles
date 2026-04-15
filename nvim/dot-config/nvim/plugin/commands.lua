vim.api.nvim_create_user_command("Root", function()
    local directory = vim.fs.root(0, ".git") or "."
    vim.cmd.cd(directory)
end, { desc = "Go to a Git project's root " })
