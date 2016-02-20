" ========================================
" Vim plugin configuration
" ========================================

call plug#begin('~/.vim/plugged')

" ========================================
" Vim utilities that may be used by other plugins
" ========================================
Plug 'vim-misc'

" ========================================
" Added functionality
" ========================================
" Plug 'xolox/vim-session'
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" A plugin which makes swapping of text in Vim easier
Plug 'kurkale6ka/vim-swap'
Plug 'editorconfig/editorconfig-vim'

" ========================================
" General text editing improvements...
" ========================================
Plug 'tomtom/tcomment_vim'

if len(glob("~/.vim/dev/neomake"))
    " set rtp+=~/.vim/dev/neomake
    " helptags ~/.vim/dev/neomake/doc
    Plug '~/.vim/dev/neomake'
else
    Plug 'benekastah/neomake'
    " Plug 'scrooloose/syntastic'
endif

Plug 'skwp/vim-colors-solarized'
Plug 'vim-scripts/Sunset'

" Plug 'kien/ctrlp.vim'
Plug 'michaeljsmith/vim-indent-object'

" ========================================
" Language/syntax bundles
" ========================================
Plug 'jdonaldson/vaxe'
Plug 'wting/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Plug 'git://github.com/jsx/jsx.vim.git'
Plug 'kchmck/vim-coffee-script'
" Provides ghmarkdown (github-flavored markdown)
Plug 'jtratner/vim-flavored-markdown'
" Faster yaml syntax files
Plug 'stephpy/vim-yaml'
Plug 'mustache/vim-mustache-handlebars'
Plug 'lukerandall/haskellmode-vim'
Plug 'idris-hackers/idris-vim'
Plug 'derekwyatt/vim-scala'
" syntax, indent, and filetype plugin files for git, gitcommit, gitconfig,
" gitrebase, and gitsendemail.
Plug 'tpope/vim-git'
Plug 'tejr/vim-tmux'
Plug 'glsl.vim'
Plug 'dag/vim-fish'
Plug 'zah/nim.vim'

" ========================================
" Trying before buying...
" ========================================
Plug 'tpope/vim-dispatch'
Plug 'benmills/vimux'

" ========================================
" Shits and giggles
" ========================================
" Adventure game
Plug 'katono/rogue.vim'

call plug#end()
