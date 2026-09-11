local sessions = require("mini.sessions")

sessions.setup({
    -- Whether to read default session if Neovim opened without file arguments
    autoread = false,
    -- Automatically update currently active session on quit
    autowrite = true,
    -- Store all sessions in stdpath('data')/session (keeps repos clean)
    file = "",
})

-- Keymaps for session management
vim.keymap.set("n", "<leader>S", function()
    sessions.select("read")
end, { desc = "Select [S]ession" })

vim.keymap.set("n", "<leader>Sw", function()
    local default_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local name = vim.fn.input("Session name: ", default_name)
    if name and name ~= "" then
        sessions.write(name)
        vim.notify("Session saved: " .. name)
    end
end, { desc = "[S]ession [w]rite" })

vim.keymap.set("n", "<leader>Sd", function()
    sessions.select("delete")
end, { desc = "[S]ession [d]elete" })
