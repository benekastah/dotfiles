" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Clear filetype flags before changing runtimepath to force Vim to reload them.
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
set runtimepath+=$HOME/dev/git-related  " Remove once it is ready for vundle to install

" ================ General Config ====================

set number                      "Line numbers are good
set relativenumber              "Relative line numbers are also good
set colorcolumn=80              "Show me column 80, plz
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set ruler
set path=.,**
set nrformats=octal,hex,alpha
if !has('nvim')
    set cryptmethod=blowfish
endif
set cursorline
set tags=./tags;~,tags,~/tags

" Search
set hlsearch
set incsearch

" I don't need no ag.vim!!
function! s:EscapeSearchString(str)
    return substitute(a:str, '|', '\\|', 'g')
endfunction

set grepprg=ag\ --nogroup\ --nocolor\ --column
set grepformat=%f:%l:%c:%m,%f:%l:%m
command! -nargs=+ -complete=file_in_path Ag exe 'silent grep! '.s:EscapeSearchString(<q-args>) | redraw! | cwindow
command! -nargs=+ -complete=file_in_path Lag exe 'silent lgrep! '.s:EscapeSearchString(<q-args>) | redraw! | lwindow
command! -nargs=+ -complete=file_in_path AG Ag <args>
command! -nargs=+ -complete=file_in_path LAG Lag <args>

" " Make gj and gk default
" nnoremap j gj
" nnoremap k gk
" nnoremap gj j
" nnoremap gk k

" More intuitive splitting
set splitbelow
set splitright

" This makes vim act like all other editors, buffers can exist in the
" background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on
set synmaxcol=1000

" Leaders
let mapleader="\<Space>"
let maplocalleader='\'

" =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundle.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/plugins.vim"))
    source ~/.vim/plugins.vim
endif

if filereadable(expand("~/.vim/utils.vim"))
    source ~/.vim/utils.vim
endif

" ================ Colors ========================
" function! s:SetBackground()
"     let [hour, minute] = split(system('date +%H:%M'), ':', 0)
"     let hour += 0
"     let minute += 0
"     if hour < 6 || hour > 16 || (hour == 6 && minute > 30) || (hour == 16 && minute > 30)
"         set background=dark
"     else
"         set background=light
"     endif
" endfunction
" call s:SetBackground()

" So that sunset can figure out if the theme should be light or dark
" San Francisco
let g:sunset_latitude = 37.77
let g:sunset_longitude = -122.42
" Tokyo
" let g:sunset_latitude = 35.69
" let g:sunset_longitude = 139.69

set t_Co=256
colorscheme solarized

" ================ Swap Files etc. ==============

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

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

if has('nvim')
    set wrap
    silent! set breakindent
else
    set nowrap       "Don't wrap lines
endif
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=manual
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.so,*.dylib,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.pyc,*.pyo,*.pyd,*.egg-info/**,*.egg,develop-eggs/**,__pycache__/**,.Python
set wildignore+=.hsenv,.virtualenv,*.chs.h,*.chi,*.hi,*.cabal-sandbox,cabal.sandbox.config,cabal.config,*.dyn_hi,*.dyn_o,*.p_hi,*.p_o

" ================ scrolling ========================
set scrolloff=1         "Start scrolling when we're 1 line away from margins

" ================ Syntastic ========================
" let g:syntastic_mode_map = {'mode': 'passive'}
let g:syntastic_python_checkers = ['pep8', 'pyflakes']
let g:syntastic_python_checkers_full = ['pep8', 'pyflakes', 'pylint']
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
let g:syntastic_c_checkers = ['make']
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = 'E>'

" ================ Neomake ========================
hi Warning ctermfg=3
let g:neomake_error_sign = {
            \ 'texthl': 'Error',
            \ }
let g:neomake_warning_sign = {
            \ 'text': '‼',
            \ 'texthl': 'Warning'
            \ }
let g:neomake_python_enabled_makers = ['python', 'pep8', 'pylint']

" Tortoise Typing
let g:tortoiseTypingKeyLog = $HOME.'/.typing_keys'
let g:tortoiseTypingResultLog = $HOME.'/.typing_tests'

" Vimux config
let g:vimuxHeight = "10"

" RunSqlQuery config
let g:sqlCommand = 'psql'


" Comment config
call tcomment#DefineType('tmux', '# %s')
" Jsx should match javascript style
call tcomment#DefineType('jsx', '// %s')
call tcomment#DefineType('jsx_block', g:tcommentBlockC)
call tcomment#DefineType('jsx_inline', g:tcommentInlineC)


" ================ Statusline ========================
function! StatuslineLocList()
    let errcount = 0
    let buf = bufnr('%')
    for err in getloclist(winnr())
        if err.bufnr ==# buf
            let errcount += 1
        endif
    endfor
    if errcount
        return 'Err: '.errcount
    else
        return ''
    endif
endfunction

function! Statusline()
    set noruler
    set laststatus=2

    set statusline=

    set statusline+=%#tag#%{fugitive#statusline()}\      " git statusline
    set statusline+=%#number#%1.3n:%#underlined#%-f\     " Current file name
    set statusline+=%#comment#%y                         " Label
    set statusline+=%*%h%m%r%w                           " File modification info

    set statusline+=%=                                   " Switch to right side
    set statusline+=%#comment#%l,%c%V                    " Line and column info
    set statusline+=\ %#ErrorMsg#%{neomake#statusline#QflistStatus('qf:\ ')}
    set statusline+=%#Normal#
    set statusline+=\ %#ErrorMsg#%{neomake#statusline#LoclistStatus('ll:\ ')}
endfunction
call Statusline()

" ================ Tern ========================
" let tern#command = ['tern', '--no-port-file']

" D
let g:syntastic_d_compiler = "$HOME/bin/dub-syntastic"
" let g:syntastic_d_dmd_exec = "dub"
" let g:syntastic_d_dmd_args = "build --quiet"

let g:haddock_browser = ""


" Allows writing to readonly files
command! -bang Write exe 'w !' . ('<bang>' ==# '!' ? 'sudo ' : '') . 'tee %'

" Preview markdown/html with w3m
function! W3m()
    if &ft ==# 'markdown' || &ft ==# 'ghmarkdown'
        let cmd = 'markdown % | w3m -T text/html'
    elseif &ft ==# 'html'
        let cmd = 'w3m -T text/html %'
    else
        let cmd = 'w3m %'
    endif
    if &mod
        let cmd = substitute(cmd, '%', '', 'g')
        call TmuxSplit(0, cmd, join(getline(1,'$'), "\n"))
    else
        let cmd = substitute(cmd, '%', shellescape(expand('%')), 'g')
        call TmuxSplit(0, cmd)
    endif
endfunction
command! W3m call W3m()


if filereadable(expand("~/.vim/keymaps.vim"))
    source ~/.vim/keymaps.vim
endif

if filereadable(expand("~/.vim/sessions.vim"))
    source ~/.vim/sessions.vim
endif

if filereadable(expand("~/.vim/au.vim"))
    source ~/.vim/au.vim
endif

let g:project_local_vimrc = findfile('.project.vim', '.;')
if filereadable(g:project_local_vimrc)
    execute 'source ' . g:project_local_vimrc
endif
