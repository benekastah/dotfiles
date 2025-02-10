
-- Editor UI options
vim.o.number = true
vim.o.relativenumber = true
vim.o.colorcolumn = '80'
vim.o.ruler = true
vim.o.termguicolors = true
vim.o.background = "dark"

-- Misc options
vim.o.autoread = true

-- Set grep program
if vim.fn.executable('rg') then
    vim.o.grepprg = "rg --no-heading --vimgrep --hidden --case-sensitive --ignore-vcs --glob '!.git' --glob '!node_modules' --glob '!build'"
end

-- Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', "<leader>/", '<cmd>noh<cr>')
vim.keymap.set('t', "<C-w>", "<C-\\><C-o><C-w>")
vim.keymap.set('n', '<leader>ml', '<cmd>exe "/<<<<<<<\\\\|=======\\\\|>>>>>>>"<cr>')
vim.keymap.set('n', '<leader>mh', '<cmd>exe "?<<<<<<<\\\\|=======\\\\|>>>>>>>"<cr>')

require('config.lazy')
