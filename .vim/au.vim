let textFileTypes = ['text', 'html', 'markdown', 'ghmarkdown', 'mustache']

augroup paulh
    autocmd!

    " handlebars
    autocmd BufNewFile,BufRead,BufFilePost *.handlebars :set ft=mustache

    " Salt
    autocmd BufNewFile,BufRead,BufFilePost *.sls :set ft=yaml

    " Clean up smartindent behavior for non-c files
    let cFileTypes = ['c', 'c++', 'objc']
    autocmd BufNewFile,BufRead,BufFilePost * if index(cFileTypes, &ft) < 0 | setlocal cindent | endif

    if !has('nvim')
        autocmd BufNewFile,BufRead,BufFilePost * if index(textFileTypes, &ft) > 0 | setlocal spell spelllang=en_us | endif
    endif

    " autocmd BufNewFile,BufRead,BufFilePost * if index(textFileTypes, &ft) > 0 | setlocal wrap | endif

    autocmd BufNewFile,BufRead,BufFilePost *.json :set ft=json
    autocmd FileType json runtime! syntax/javascript.vim

    " Diet templates
    autocmd BufNewFile,BufRead,BufFilePost *.dt :set ft=jade

    autocmd BufNewFile,BufRead,BufFilePost *.h,*.cpp :let b:syntastic_cpp_cflags='@g++_opts'

    autocmd BufNewFile,BufRead,BufFilePost *.jison set ft=yacc

    autocmd Filetype go setlocal makeprg=go\ build

    autocmd Filetype rust setlocal makeprg=cargo\ build

    autocmd Filetype haskell setlocal makeprg=~/Library/Haskell/bin/cabal\ build

    autocmd Filetype python let b:indentNoEndDelimiter = 1
    " autocmd Filetype python call ChecksrvStart() | call ChecksrvSyntastic(&ft, 'pylint', '')
    " For vim-dispatch
    " autocmd Filetype python let &l:makeprg='pylint -f text --msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}" -r n' |
    "             \ setlocal errorformat=%f:%l:%c:%t:\ %m |
    "             \ setlocal errorformat+=%f:%l:\ %m |
    "             \ setlocal errorformat+=%f:(%l):\ %m

    autocmd BufWritePost,BufReadPost * Neomake

    autocmd Filetype python let b:CalculateCommand=function('CalculatePythonCommand')
    autocmd Filetype javascript let b:CalculateCommand=function('CalculateJavascriptCommand')
    autocmd Filetype javascript setlocal cinkeys=0{,0},0),:,!^F,o,O,e

    autocmd Filetype haskell set makeprg=~/Library/Haskell/bin/cabal\ build
    autocmd Filetype cabal set makeprg=~/Library/Haskell/bin/cabal\ build
    autocmd VimLeave * VimuxCloseRunner

    autocmd FileType vim setlocal keywordprg=:help
    " autocmd FileType help noremap <buffer> q :q<CR>

    au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl set ft=glsl
augroup END
