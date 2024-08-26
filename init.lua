-- Setting bindings
vim.g.mapleader = " "
vim.opt.clipboard:append("unnamedplus")
vim.api.nvim_set_keymap('n', '<Leader>w', ':write<CR>', {
    noremap = true,
    silent = true
})
vim.api.nvim_set_keymap('n', '<Tab>', ':tabnext<CR>', {
    noremap = true,
    silent = true
})
vim.api.nvim_set_keymap('n', '<S-Tab>', ':tabprevious<CR>', {
    noremap = true,
    silent = true
})
-- Function to check if we're in VSCode context:
local function in_vscode()
    return vim.g.vscode == 1
end

if in_vscode() then
    local ok, vscode_module = pcall(require, 'vscode')
    if ok then 
        _G.vscode = vscode_module
    else 
        print("Error loading vscode module")
    end
end

--TODO: Add function to search current active editor
--TODO: Add function to search by file name
_G.live_grep = function()
    local rg_prefix = "rg --column --line-number --no-heading --color=always --smart-case"
    local cmd = string.format(
        "fzf --tmux --ansi --disabled "..
        "--bind 'start:reload:%s {q}' "..
        "--bind 'change:reload-sync: %s {q} || true' "..
        "--delimiter : "..
        "--preview 'bat --color=always {1} --highlight-line {2}' "..
        "--preview-window 'up,60%%,border-bottom,+{2}+3/3,~3' ",
        rg_prefix,
        rg_prefix
    )
    cmd = cmd .. "--bind 'enter:execute(nohup code -r -g {1}:{2} &)'+abort;"..
                 "exit"
    _G.vscode.call("workbench.action.terminal.new")
    _G.vscode.call("workbench.action.terminal.sendSequence", {
        args = {
            text = cmd .. "\r"
        }
    })
    _G.vscode.call("workbench.action.terminal.focus") 
end

if in_vscode() then
    local ok, vscode = pcall(require, 'vscode')
    if ok then
        vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("vscode").action("workbench.action.terminal.toggleTerminal")<CR>', {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<Tab>', ':lua require("vscode").action("workbench.action.nextEditor")<CR>', {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<S-Tab>', ':lua require("vscode").action("workbench.action.previousEditor")<CR>', {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<C-n>', 'lua require("vscode").action("workbench.action.toggleSidebarVisibility")<CR>', {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<leader>fd', ":lua require('vscode').action('editor.action.formatDocument')<CR>", {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<leader>x', ":lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", {
            noremap = true,
            silent = true
        })
        vim.api.nvim_set_keymap('n', '<leader>fg', ':lua live_grep()<CR>', {
            noremap = true,
            silent = true
        })
    else
        print("Error loading vscode module")
    end
    -- Set keybinding to show leader options if possible
else
    -- Ordinary Neovim
end