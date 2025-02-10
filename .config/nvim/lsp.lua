
vim.cmd([[
    nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap grn <Cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap gra <Cmd>lua vim.lsp.buf.code_action()<CR>
    xnoremap gra <Cmd>lua vim.lsp.buf.range_code_action()<CR>
    nnoremap grr <Cmd>lua vim.lsp.buf.references()<CR>
    nnoremap gri <Cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap gO <Cmd>lua vim.lsp.buf.document_symbol()<CR>
    inoremap <C-S> <Cmd>lua vim.lsp.buf.signature_help()<CR>
]])



