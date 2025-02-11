function! Input(prompt)
    call inputsave()
    let search = input(a:prompt)
    call inputrestore()
    return search
endfunction

" Window navigation
function! Wincmd(cmd)
    if exists('w:winmax')
        let l:prev_winmax = w:winmax
    else
        let l:prev_winmax = 0
    endif

    exe ":wincmd ".a:cmd

    if a:cmd ==# '_'
        let t:winmax = 1
        let w:wineq = 0
        let w:winmax = 0
        return
    elseif a:cmd ==# '='
        let t:winmax = 0
        let w:wineq = 0
        let w:winmax = 0
        return
    endif

    if &previewwindow || &buftype ==# 'quickfix'
        resize 10
        return
    endif

    if a:cmd ==# '-' || a:cmd ==# '+'
        let t:winmax = 0
        let w:winmax = 0
        return
    endif

    if exists('t:winmax') && t:winmax
        :wincmd _
    elseif l:prev_winmax
        :wincmd =
    endif
endfunction

" Override some of the C-w commands for additional features
noremap <C-w>_ :call Wincmd('_')<CR>
noremap <C-w><C-_> :call Wincmd('_')<CR>
noremap <C-w>= :call Wincmd('=')<CR>
noremap <C-w><C-=> :call Wincmd('=')<CR>
noremap <C-w>- :call Wincmd('-')<CR>
noremap <C-w><C--> :call Wincmd('-')<CR>
noremap <C-w>+ :call Wincmd('+')<CR>
noremap <C-w><C-+> :call Wincmd('+')<CR>
noremap <C-w>h :call Wincmd('h')<CR>
noremap <C-w><C-h> :call Wincmd('h')<CR>
noremap <C-w>j :call Wincmd('j')<CR>
noremap <C-w><C-j> :call Wincmd('j')<CR>
noremap <C-w>k :call Wincmd('k')<CR>
noremap <C-w><C-k> :call Wincmd('k')<CR>
noremap <C-w>l :call Wincmd('l')<CR>
noremap <C-w><C-l> :call Wincmd('l')<CR>

tnoremap <C-w>_ <C-\><C-o>:call Wincmd('_')<CR><ESC>
tnoremap <C-w><C-_> <C-\><C-o>:call Wincmd('_')<CR><ESC>
tnoremap <C-w>= <C-\><C-o>:call Wincmd('=')<CR><ESC>
tnoremap <C-w><C-=> <C-\><C-o>:call Wincmd('=')<CR><ESC>
tnoremap <C-w>- <C-\><C-o>:call Wincmd('-')<CR><ESC>
tnoremap <C-w><C--> <C-\><C-o>:call Wincmd('-')<CR><ESC>
tnoremap <C-w>+ <C-\><C-o>:call Wincmd('+')<CR><ESC>
tnoremap <C-w><C-+> <C-\><C-o>:call Wincmd('+')<CR><ESC>
tnoremap <C-w>h <C-\><C-o>:call Wincmd('h')<CR><ESC>
tnoremap <C-w><C-h> <C-\><C-o>:call Wincmd('h')<CR><ESC>
tnoremap <C-w>j <C-\><C-o>:call Wincmd('j')<CR><ESC>
tnoremap <C-w><C-j> <C-\><C-o>:call Wincmd('j')<CR><ESC>
tnoremap <C-w>k <C-\><C-o>:call Wincmd('k')<CR><ESC>
tnoremap <C-w><C-k> <C-\><C-o>:call Wincmd('k')<CR><ESC>
tnoremap <C-w>l <C-\><C-o>:call Wincmd('l')<CR><ESC>
tnoremap <C-w><C-l> <C-\><C-o>:call Wincmd('l')<CR><ESC>

" Buffer navigatior
nnoremap <localleader>bp :<C-U>exe 'bp '.v:count1<CR>
nnoremap <localleader>bn :<C-U>exe 'bn '.v:count1<CR>

" Merge helpers
" Find the next merge section
nnoremap <leader>ml :exe "/<<<<<<<\\\|=======\\\|>>>>>>>"<CR>
nnoremap <leader>mh :exe "?<<<<<<<\\\|=======\\\|>>>>>>>"<CR>
" In vimdiff I often want to write only the current buffer, and quit all
nnoremap <leader>wqa :w<CR>:qa<CR>
nnoremap <leader>wqa! :w!<CR>:qa!<CR>

vnoremap * :<C-u>exe '/'.GetVisualSelection()<CR>
vnoremap <leader>* :<C-u>exe 'Ag -Q '.shellescape(GetVisualSelection())<CR>
nnoremap <leader>* *N:exe "Ag '\\b".expand('<cword>')."\\b'"<CR>

" Clear search
nnoremap <leader>/ :noh<CR>

" Open and close list
nnoremap <leader>w :cwindow<CR>
nnoremap <leader>q :cclose<CR>
nnoremap <localleader>w :lwindow<CR>
nnoremap <localleader>q :lclose<CR>
" Next/prev error
nnoremap <leader>p :cprev<CR>
nnoremap <leader>n :cnext<CR>
nnoremap <localleader>p :lprev<CR>
nnoremap <localleader>n :lnext<CR>
" First/last error
nnoremap <leader><leader>p :cfirst<CR>
nnoremap <leader><leader>n :clast<CR>
nnoremap <localleader><localleader>p :lfirst<CR>
nnoremap <localleader><localleader>n :llast<CR>

" Sort
function! SortLines(type, ...)
    let visual_mode = a:0
    let cmd = ""
    if visual_mode
        let cmd .= "'<,'>"
    else
        let cmd .= "'[,']"
    endif
    let cmd .= "sort " . get(g:, 'sort_lines_default_args', '')
    exe cmd
endfunction

nnoremap <leader>s :set opfunc=SortLines<CR>g@
vnoremap <leader>s :<C-U>call SortLines(visualmode(), 1)<CR>


" Gen tags
if !exists('g:neomake_ctags_maker')
    let g:neomake_ctags_maker = {'args': ['-R']}
endif
nnoremap <leader>gt :Neomake! ctags<CR>


" Refactoring helpers
nnoremap <leader>" :%s/"\(.\{-}\)"/\="'".substitute(submatch(1), "'", '"', 'g')."'"/gc<CR>
nnoremap <leader>. :%s/\['\(\w\+\)\'\]/.\1/gc<CR>:%s/\["\(\w\+\)\"\]/.\1/gc<CR>
command! TODO :silent! exe '/\<\(TODO\|FIXME\|XXX\)\>' | Ag '\b(TODO\\|FIXME\\|XXX)\b'
command! TEST :silent! exe '/\<\(TOTEST\|TEST\)\>' | Ag '\b(TOTEST\\|TEST)\b'


" ======================= HTML/XML Tag operations =============================
" Change tagname
function! ChangeTagName()
    let tag = Input("New tagname: ")
    exe 'normal! vathciw' . tag
    exe 'normal! gvolciw' . tag . ''
endfunction
nnoremap <leader>ct :call ChangeTagName()<CR>

" Remove tag (leaving inner contents in place)
nnoremap <leader>rt ditvatp

function! WrapTag()
    let tag = Input("Tagname: ")
    let break = tag =~ ' $'
    if break
        let tag = substitute(tag, '\s\+$', '', '')
    endif
    let cmd = 'normal! cat<' . tag . '>'
    if break
        let cmd .= ''
    endif
    let cmd .= 'gpa'
    if break
        let cmd .= ''
    endif
    let cmd .= '</' . tag . '>'
    if break
        let cmd .= 'vat='
    endif
    exe cmd
endfunction
nnoremap <leader>wt :call WrapTag()<CR>


" ======================= Filter text with shell command =============================
function! TextFilter(type, Cmd, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @c

    if a:0 && a:1  " Invoked from Visual mode, use '< and '> marks.
        let visual_select = '`<' . a:type . '`>'
    elseif a:type == 'line'
        let visual_select = "'[V']"
    elseif a:type == 'block'
        let visual_select = '`[\<C-V>`]'
    else
        let visual_select = '`[v`]'
    endif

    exe 'normal! ' . visual_select . '"cy'
    let @c = substitute(a:Cmd(@c), '\_s\+$', '', 'g')
    exe 'normal! ' . visual_select . '"cp'

    let @c = reg_save
    let &selection = sel_save
endfunction

" ======================= Calculator Macro =============================
function! CalculateBcCommand(text)
    if !len(a:text)
        return '0'
    endif
    let scale = get(b:, 'calculate_scale', get(g:, 'calculate_scale'))
    if scale
        let cmd = "sed 's/.\\+/scale=" . scale . "; &/' | bc -l"
    else
        let cmd = 'bc -l'
    endif
    " For some reason passing text as second argument gives a syntax error
    " when used with bc.
    return system('echo ' . shellescape(a:text) . ' | ' . cmd)
endfunction

function! CalculatePythonCommand(text)
    if !len(a:text)
        return '0'
    endif
    let scale = get(b:, 'calculate_scale', get(g:, 'calculate_scale'))
    if scale
        let val = '"{:.' . scale . 'f}.format(&)'
    else
        let val = '&'
    endif
    let assgn = split(substitute(a:text, '\(\r\|\n\)\+$', '', ''), '\s*=\s*')
    let text = assgn[-1]
    if len(assgn) > 1
        let vars = join(assgn[:-2], ' = ') . ' = '
    else
        let vars = ''
    endif
    let text = 'print("{}{}".format("' . vars . '", ' . text . '))'
    return system('python', text)
endfunction

function! CalculateJavascriptCommand(text)
    if !len(a:text)
        return '0'
    endif
    let scale = get(b:, 'calculate_scale', get(g:, 'calculate_scale'))
    if scale
        let val = '(\1).toFixed(' . scale . ')'
    else
        let val = '\1'
    endif
    return system("sed " . shellescape('s/\([^;]\+\)\(;\?\)/console.log(' . val . ', "\2")/') . " | node", a:text)
endfunction

function! Calculate(type, ...)
    let Cmd = get(b:, 'CalculateCommand',
                \ get(g:, 'CalculateCommand', function('CalculateBcCommand')))
    if type(Cmd) == type(function('tr'))
        call TextFilter(a:type, Cmd, a:0 && a:1)
    else
        call CommandFilter(a:type, a:0, Cmd)
    endif
endfunction
nnoremap <leader>C :set opfunc=Calculate<CR>g@
vnoremap <leader>C :<C-U>call Calculate(visualmode(), 1)<CR>

exe 'nnoremap <leader>sc :let b:calculate_scale = '


" REPL replacement (kinda)

function! REPL_stop() abort
    call job_stop(b:repl_job)
    unlet b:repl_job
    unlet b:repl_buffer
endfunction

function! REPL_start(cmd, delete_existing) abort
    if has_key(b:, 'repl_job') && job_status(b:repl_job) ==# 'run'
        if a:delete_existing
            call REPL_stop()
        else
            echoerr 'Unable to start repl: buffer already has a repl'
            return
        endif
    endif
    let repl_bufname = substitute(join(a:cmd, '_'), '\W\+', '_', 'g')
    let b:repl_job = job_start(a:cmd, {
        \ 'out_io': 'buffer',
        \ 'out_name': repl_bufname,
        \ 'err_io': 'buffer',
        \ 'err_name': repl_bufname
    \ })
    exe 'split ' . repl_bufname
    let b:repl_buffer = bufnr('%')
endfunction

function! REPL_send(text) abort
    if !has_key(b:, 'repl_job')
        echoerr 'No repl found for this buffer'
        return
    endif
    let ch = job_getchannel(b:repl_job)
    call ch_sendraw(ch, a:text . "\n")
endfunction

command! -nargs=+ -bang REPL :call REPL_start([<f-args>], '<bang>' ==# '!')
command! REPLStop :call REPL_stop()
nnoremap <leader><ENTER> :call REPL_send(getline('.'))<CR>


" Delete hidden buffers
" Thanks to https://stackoverflow.com/a/30101152/777929
function! DeleteHiddenBuffers()
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        if getbufvar(buf, '&mod') == 0
            silent execute 'bwipeout' buf
            let closed += 1
        endif
    endfor
    echo "Closed ".closed." hidden buffers"
endfunction

nnoremap <leader>bd :call DeleteHiddenBuffers()<CR>

if has('nvim')
    " LSP stuff
    " Show hover
    nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
    " Jump to definition
    nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap grn <Cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap gra <Cmd>lua vim.lsp.buf.code_action()<CR>
    xnoremap gra <Cmd>lua vim.lsp.buf.range_code_action()<CR>
    nnoremap grr <Cmd>lua vim.lsp.buf.references()<CR>
    nnoremap gri <Cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap gO <Cmd>lua vim.lsp.buf.document_symbol()<CR>
    inoremap <C-S> <Cmd>lua vim.lsp.buf.signature_help()<CR>

    nnoremap <leader>db <Cmd>lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <leader>dc <Cmd>lua require'dap'.continue()<CR>
    nnoremap <leader>do <Cmd>lua require'dap'.step_over()<CR>
    nnoremap <leader>di <Cmd>lua require'dap'.step_into()<CR>
    nnoremap <leader>dr <Cmd>lua require'dap'.repl.open()<CR>

    nnoremap <leader>fl <Cmd>FlutterRun<CR>
    nnoremap <leader>flr <Cmd>FlutterReload<CR>
    nnoremap <leader>flR <Cmd>FlutterRestart<CR>
    nnoremap <leader>flq <Cmd>FlutterQuit<CR>
endif

if has('nvim')
    nnoremap <leader>ff <Cmd>Telescope find_files<cr>
    nnoremap <leader>fg <Cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <Cmd>Telescope buffers<cr>
    nnoremap <leader>fh <Cmd>Telescope help_tags<cr>
endif
