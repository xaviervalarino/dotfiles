if not vim.g.vscode then
    return
end

local vscode = require("vscode")

---Run VS Code editor commands through keymaps
---https://code.visualstudio.com/api/references/commands
---@param mode string|string[]
---@param lhs string
---@param rhs string
---@param opts vim.keymap.set.Opts?
local function vs_map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, function()
        vscode.action(rhs)
    end, opts)
end

-- Git
vs_map("n", "[h", "editor.action.dirtydiff.next")
vs_map("n", "]h", "editor.action.dirtydiff.previous")

vim.keymap.set("n", "gh", function()
    vscode.action("git.diff.stageHunk")
end)

-- TODO: unstageChange might need a range or unstageFile might need a filename
-- vs_map("n", "gH", "editor.action.unstageFile")

vim.keymap.set("n", "<leader>rn", function()
    vscode.action("editor.action.rename")
end)

vim.keymap.set("n", "<leader>ff", function()
    vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end)

vim.keymap.set("n", "<leader>ca", function()
    vscode.action("editor.action.quickFix")
end)

vim.keymap.set("n", "<leader>t", function()
    vscode.action("workbench.action.toggleSidebarVisibility")
end)

vim.keymap.set("n", "<leader>k", function()
    vscode.action("workbench.action.openPreviousEditor")
end)

vim.keymap.set("n", "<leader>c", function()
    vscode.action("workbench.action.closeActiveEditor")
end)

vim.keymap.set("n", "<leader>wo", function()
    vscode.call("workbench.action.closeOtherEditors")
end)

vim.keymap.set("n", "<leader>wz", function()
    vscode.call("workbench.action.toggleZenMode")
end)

vim.keymap.set("n", "<leader>wc", function()
    vscode.call("workbench.action.toggleCenteredLayout")
end)

vim.keymap.set("n", "<leader>af", function()
    vscode.call("editor.action.organizeImports")
    vscode.call("editor.action.formatDocument")
end)

vim.keymap.set({ "n", "v" }, "<leader>ap", function()
    vscode.call("editor.action.showContextMenu")
end)

vim.keymap.set({ "n", "v" }, "<leader>ar", function()
    vscode.call("editor.action.refactor")
end)

vim.keymap.set("n", "H", function()
    vscode.call("workbench.action.previousEditor")
end)

vim.keymap.set("n", "L", function()
    vscode.call("workbench.action.nextEditor")
end)

vim.keymap.set("n", "K", function()
    vscode.call("editor.action.showHover")
end)

vim.keymap.set("n", "]d", function()
    vscode.action("editor.action.marker.next")
end)

vim.keymap.set("n", "[d", function()
    vscode.action("editor.action.marker.prev")
end)

vim.keymap.set("v", "<leader>w", function()
    vscode.call("editor.action.smartSelect.grow")
end)

vim.keymap.set("v", "<leader>W", function()
    vscode.call("editor.action.smartSelect.shrink")
end)

vim.keymap.set("n", "gf", function()
    vscode.call("workbench.action.gotoSymbol")
end)

vim.keymap.set("n", "gi", function()
    vscode.call("editor.action.goToImplementation")
end)

vim.keymap.set("n", "gp", function()
    vscode.call("workbench.explorer.fileView.focus")
end)

vim.keymap.set("n", "gy", function()
    vscode.call("editor.action.goToTypeDefinition")
end)

vim.keymap.set("n", "ge", function()
    vscode.call("remote-wsl.revealInExplorer")
end)

-- "workbench.action.showAllEditorsByMostRecentlyUsed"
-- "outline.focus"

-- agent chat
-- workbench.action.toggleAuxiliaryBar
-- workbench.panel.chat
-- workbench.action.openQuickChat

-- folds
--  "zM" "editor.foldAll"
--  "zR" "editor.unfoldAll"
--  "zc" "editor.fold"
--  "zC" "editor.foldRecursively"
--  "zo" "editor.unfold"
--  "zO" "editor.unfoldRecursively"
--  "za" "editor.toggleFold"
