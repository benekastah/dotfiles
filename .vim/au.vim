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

    autocmd BufNewFile,BufRead,BufFilePost *.json :set ft=json
    autocmd FileType json runtime! syntax/javascript.vim

    autocmd BufNewFile,BufRead,BufFilePost *.jison set ft=yacc

    autocmd Filetype go setlocal makeprg=go\ build

    autocmd Filetype rust setlocal makeprg=cargo\ build

    autocmd Filetype python let b:indentNoEndDelimiter = 1

    autocmd Filetype dart setlocal et tabstop=2 shiftwidth=2
    autocmd BufWritePost,BufReadPost *.dart :DartFmt

    " autocmd BufWritePost,BufReadPost * Neomake

    autocmd Filetype python let b:CalculateCommand=function('CalculatePythonCommand')
    autocmd Filetype javascript let b:CalculateCommand=function('CalculateJavascriptCommand')
    autocmd Filetype javascript setlocal cinkeys=0{,0},0),:,!^F,o,O,e

    autocmd FileType vim setlocal keywordprg=:help

    au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl set ft=glsl

    au ColorScheme *
        \ hi NeomakeWarningSign cterm=underline gui=undercurl |
        \ hi NeomakeWarning cterm=underline gui=undercurl

    autocmd Filetype scss setlocal commentstring=/*%s*/

    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline

    autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END
