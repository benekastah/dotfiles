" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Clear filetype flags before changing runtimepath to force Vim to reload them.
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
set runtimepath+=$HOME/dev/git-related  " Remove once it is ready for vundle to install

" =============== Plugin Initialization ===============
if filereadable(expand("~/.vim/plugins.vim"))
    source ~/.vim/plugins.vim
endif

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
set complete-=i
set nrformats=octal,hex,alpha
if !has('nvim')
    set cryptmethod=blowfish
endif
set nocursorline
set tags=./tags;~,tags,~/tags
set scrolloff=1         "Start scrolling when we're 1 line away from margins

set exrc

" Search
set hlsearch
set incsearch

" I don't need no ag.vim!!
function! s:EscapeSearchString(str)
    return substitute(a:str, '|', '\\|', 'g')
endfunction

set grepprg=ag\ --nogroup\ --nocolor\ --column\ -s
set grepformat=%f:%l:%c:%m,%f:%l:%m
command! -nargs=+ -complete=file_in_path Ag exe 'silent grep! '.s:EscapeSearchString(<q-args>) | redraw! | cwindow
command! -nargs=+ -complete=file_in_path Lag exe 'silent lgrep! '.s:EscapeSearchString(<q-args>) | redraw! | lwindow
command! -nargs=+ -complete=file_in_path AG Ag <args>
command! -nargs=+ -complete=file_in_path LAG Lag <args>

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

" Set up autocommands before applying colorscheme
if filereadable(expand("~/.vim/au.vim"))
    source ~/.vim/au.vim
endif

" ================ Colors ========================
set t_Co=256
set background=dark
colorscheme monokai

if filereadable(expand("~/.vim/utils.vim"))
    source ~/.vim/utils.vim
endif

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
set wildignore+=*/venv/*,*/venv/**,venv/*,venv/**
set wildignore+=.hsenv,*.chs.h,*.chi,*.hi,*.cabal-sandbox,cabal.sandbox.config,cabal.config,*.dyn_hi,*.dyn_o,*.p_hi,*.p_o
set wildignore+=node_modules/*,node_modules/**,*/node_modules/*,**/node_modules/**


" ================ Neomake ========================
hi Warning ctermfg=3
let g:neomake_error_sign = {
            \ 'texthl': 'Error',
            \ }
let g:neomake_warning_sign = {
            \ 'text': '‼',
            \ 'texthl': 'Warning'
            \ }
call neomake#configure#automake('nrw')


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

    set statusline+=%{fugitive#statusline()}\      " git statusline
    set statusline+=%1.3n:%-f\     " Current file name
    set statusline+=%y                         " Label
    set statusline+=%*%h%m%r%w                           " File modification info

    set statusline+=%=                                   " Switch to right side
    set statusline+=%l,%c%V\ %P                " Line, column, percentage through buffer
    set statusline+=\ %{neomake#statusline#QflistStatus('qf:\ ')}
    set statusline+=\ %{neomake#statusline#LoclistStatus('ll:\ ')}
endfunction
call Statusline()


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

" Goes at end of file
set secure
