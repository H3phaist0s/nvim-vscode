-- Setting bindings
vim.g.mapleader = " "
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

_G.live_grep = function()
    if in_vscode() then
        local ok, vscode = pcall(require, 'vscode')
        if ok then
            vscode.action("workbench.action.terminal.sendSequence", {
                args = {
                    text = "rg" --Command to run rg + fzf 
                }
            })
        else
            print("Error loading vscode module")
        end
    end
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
        vim.api.nvim_set_keymap('n', '<leader>fg', ':lua live_grep()<CR>', {
            noremap = true,
            silent = true
        })
    else
        print("Error loading vscode module")
    end
    -- Set keybinding to show leader options if possible
    -- Could use terminal.sendSequence to run certain cli cmds
else
    -- Ordinary Neovim
end