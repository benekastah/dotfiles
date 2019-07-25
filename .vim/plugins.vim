" ========================================
" Vim plugin configuration
" ========================================

call plug#begin('~/.vim/plugged')

" ========================================
" Vim utilities that may be used by other plugins
" ========================================
Plug 'vim-scripts/vim-misc'

" ========================================
" Added functionality
" ========================================
Plug 'tpope/vim-fugitive'
" A plugin which makes swapping of text in Vim easier
Plug 'kurkale6ka/vim-swap'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'

" ========================================
" General text editing improvements...
" ========================================
if len(glob("~/.vim/dev/neomake"))
    Plug '~/.vim/dev/neomake'
else
    Plug 'neomake/neomake'
endif

Plug 'michaeljsmith/vim-indent-object'

" ========================================
" Trying before buying...
" ========================================
" Plug 'christoomey/vim-tmux-navigator'

" ========================================
" Shits and giggles
" ========================================
" Adventure game
Plug 'katono/rogue.vim'

" ========================================
" Language/syntax bundles
" ========================================
Plug 'jdonaldson/vaxe'
Plug 'wting/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
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
Plug 'vim-scripts/glsl.vim'
Plug 'dag/vim-fish'
Plug 'zah/nim.vim'


" ========================================
" Color schemes
" ========================================
Plug 'altercation/vim-colors-solarized'
Plug 'sickill/vim-monokai'

call plug#end()


silent! system('test -i /usr/local/opt/fzf')
if v:shell_error == 0
    set rtp+=/usr/local/opt/fzf
endif
