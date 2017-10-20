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

    autocmd Filetype python let b:indentNoEndDelimiter = 1

    autocmd BufWritePost,BufReadPost * Neomake

    autocmd Filetype python let b:CalculateCommand=function('CalculatePythonCommand')
    autocmd Filetype javascript let b:CalculateCommand=function('CalculateJavascriptCommand')
    autocmd Filetype javascript setlocal cinkeys=0{,0},0),:,!^F,o,O,e

    autocmd FileType vim setlocal keywordprg=:help

    au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl set ft=glsl

    au ColorScheme *
        \ hi NeomakeWarningSign cterm=underline gui=undercurl |
        \ hi NeomakeWarning cterm=underline gui=undercurl

    autocmd Filetype tmux,python,sh,yaml let b:comment_prefix = '# ' | let b:comment_line_regex = '^\s*# '
    autocmd Filetype vim let b:comment_prefix = '" ' | let b:comment_line_regex = '^\s*" '
    autocmd Filetype c,css,scss let b:comment_prefix = '/* ' | let b:comment_postfix = ' */' | let b:comment_line_regex = '^\s*/\*.*\*/$'

    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
augroup END
