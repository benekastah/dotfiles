
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

vim.keymap.set({'n', 'v'}, '<leader>y', '<cmd>normal "+y<cr>')

vim.cmd([[
    nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
    "nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap gn <Cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap ga <Cmd>lua vim.lsp.buf.code_action()<CR>
    xnoremap ga <Cmd>lua vim.lsp.buf.range_code_action()<CR>
    "nnoremap grr <Cmd>lua vim.lsp.buf.references()<CR>
    "nnoremap gri <Cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap gO <Cmd>lua vim.lsp.buf.document_symbol()<CR>
    inoremap <C-S> <Cmd>lua vim.lsp.buf.signature_help()<CR>
]])

-- Backup and undo files
vim.cmd([[
    silent !mkdir ~/.vim/.backup > /dev/null 2>&1
    set backupdir=~/.vim/.backup//
    set backup

    " silent !mkdir ~/.vim/.swp > /dev/null 2>&1
    " set directory=~/.vim/.swp//
    " set swapfile
    set noswapfile

    silent !mkdir ~/.vim/.undo > /dev/null 2>&1
    set undodir=~/.vim/.undo//
    set undofile
]])

-- Filetype plugins and indent files
vim.cmd([[
    filetype plugin on
    filetype indent on
]])

require('config.lazy')
